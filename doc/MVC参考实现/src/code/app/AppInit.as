package code.app
{
	import code.app.mvc.Actor;
	import code.app.mvc.Context;
	
	import flash.display.Stage;
	
	/**
	 * 程序初始化启动类
	 * @author dom
	 */
	public class AppInit extends Actor
	{
		/**
		 * 构造函数
		 */		
		public function AppInit(stage:Stage)
		{
			Context.getInstance().setStage(stage);
		}
		
		/**
		 * 控制器列表
		 */		
		private var controllerList:ControllerList = new ControllerList();
		/**
		 * 初始化程序
		 */		
		public function start():void
		{
			//==============================
			//  这里做一些启动控制器前的初始化操作
			//==============================
			
			controllerList.start();
		}
	}
}