package org.flexlite.domUI.core
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.managers.FocusManager;
	import org.flexlite.domUI.managers.IFocusManager;
	import org.flexlite.domUI.managers.ISystemManager;
	import org.flexlite.domUI.managers.LayoutManager;

	use namespace dx_internal;
	
	/**
	 * 全局静态量
	 * @author DOM
	 */
	public class DomGlobals
	{
		/**
		 * 一个全局标志，控制在某些鼠标操作或动画特效播放时，是否开启updateAfterEvent()，开启时能增加平滑的体验感,但是会提高屏幕渲染(Render事件)的频率。默认为true。
		 */		
		public static var useUpdateAfterEvent:Boolean = true;
		
		private static var _stage:Stage;
		/**
		 * 舞台引用，当第一个UIComponent添加到舞台时此属性被自动赋值
		 */		
		public static function get stage():Stage
		{
			return _stage;
		}
		/**
		 * 已经初始化完成标志
		 */		
		private static var initlized:Boolean = false;
		/**
		 * 初始化管理器
		 */		
		dx_internal static function initlize(stage:Stage):void
		{
			if(initlized)
				return;
			_stage = stage;
			layoutManager = new LayoutManager();
			try
			{
				focusManager = Injector.getInstance(IFocusManager);
			}
			catch(e:Error)
			{
				focusManager = new FocusManager();
			}
			focusManager.stage = stage;
			//屏蔽callLaterError
			stage.addEventListener("callLaterError",function(event:Event):void{});
			initlized = true;
		}
		/**
		 * 延迟渲染布局管理器 
		 */		
		dx_internal static var layoutManager:LayoutManager;
		/**
		 * 焦点管理器
		 */		
		dx_internal static var focusManager:IFocusManager;
		/**
		 * 系统管理器列表
		 */		
		dx_internal static var _systemManagers:Vector.<ISystemManager> = new Vector.<ISystemManager>();
		/**
		 * 顶级应用容器
		 */
		public static function get systemManager():ISystemManager
		{
			for(var i:int=_systemManagers.length-1;i>=0;i--)
			{
				if(_systemManagers[i].stage)
					return _systemManagers[i];
			}
			return null;
		}
		/**
		 * 是否屏蔽失效验证阶段和callLater方法延迟调用的所有报错。
		 * 建议在发行版中启用，避免因为一处报错引起全局的延迟调用失效。
		 */		
		public static var catchCallLaterExceptions:Boolean = false;
	}
}