package org.flexlite.domUI.core
{
	import flash.display.Stage;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.managers.ISystemManager;
	import org.flexlite.domUI.managers.LayoutManager;

	use namespace dx_internal;
	
	/**
	 * 全局静态量
	 * @author DOM
	 */
	public class DomGlobals
	{
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
			layoutManager = new LayoutManager;
			initlized = true;
		}
		/**
		 * 延迟渲染布局管理器 
		 */		
		dx_internal static var layoutManager:LayoutManager;
		
		dx_internal static var _systemManager:ISystemManager;
		/**
		 * 顶级应用容器
		 */
		public static function get systemManager():ISystemManager
		{
			return _systemManager;
		}
	}
}