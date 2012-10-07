package org.flexlite.domDll
{
	import flash.events.EventDispatcher;
	
	
	/**
	 * 资源管理器
	 * @author DOM
	 */
	public class Dll extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function Dll()
		{
			super();
			if(_instance)
			{
				throw new Error("实例化单例:Dll出错！");
			}
		}
		
		private static var _instance:Dll;
		/**
		 * 获取单例
		 */		
		private static function getInstance():Dll
		{
			if(!_instance)
			{
				_instance = new Dll();
			}
			return _instance;
		}
		
		/**
		 * 加载初始化配置文件并解析，解析完成后开始加载loading界面素材(若有配置)。
		 * @param path 配置文件路径
		 * @param type 配置文件类型
		 */		
		public function loadConfig(path:String,type:String="xml"):void
		{
		}
		/**
		 * 开始加载配置为"预加载"的资源队列。
		 */		
		public function loadPreload():void
		{
			
		}
	}
}