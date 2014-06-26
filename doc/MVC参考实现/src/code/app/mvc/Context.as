package code.app.mvc
{
	import code.app.CommonData;
	import code.app.CommonView;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	
	/**
	 * 命令总线上下文
	 * @author dom
	 */
	public class Context extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function Context()
		{
			super();
			if(_instance!=null)
			{
				throw new Error("实例化单例Context出错！");
			}
		}
		
		private static var _instance:Context;
		/**
		 * 获取单例
		 */		
		public static function getInstance():Context
		{
			if(_instance==null)
			{
				_instance = new Context;
			}
			return _instance;
		}
		
		private var _stage:Stage;
		
		/**
		 * 舞台引用
		 */
		public function get stage():Stage
		{
			return _stage;
		}
		/**
		 * 在项目启动时注入舞台实例
		 */
		public function setStage(value:Stage):void
		{
			if(!value)
				return;
			_stage = value;
		}
		
		private var _commonView:CommonView = new CommonView();
		/**
		 * 公共视图
		 */
		public function get commonView():CommonView
		{
			return _commonView;
		}
		
		private var _commonData:CommonData = new CommonData();
		/**
		 * 公共数据
		 */
		public function get commonData():CommonData
		{
			return _commonData;
		}
	}
}