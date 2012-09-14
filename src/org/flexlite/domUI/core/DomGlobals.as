package org.flexlite.domUI.core
{
	import flash.display.Stage;
	
	import org.flexlite.domUI.managers.ILanguageManager;
	import org.flexlite.domUI.managers.LayoutManager;
	import org.flexlite.domUI.managers.SystemManager;

	use namespace dx_internal;
	
	/**
	 * 全局静态量
	 * @author DOM
	 */
	public class DomGlobals
	{
		dx_internal static var _stage:Stage;
		/**
		 * 舞台引用，当第一个UIComponent添加到舞台时此属性被自动赋值
		 */		
		public static function get stage():Stage
		{
			return _stage;
		}
		/**
		 * 延迟渲染布局管理器 
		 */		
		dx_internal static var layoutManager:LayoutManager;
		
		/**
		 * 多语言管理器 
		 */
		dx_internal static var languageManager:ILanguageManager;

		/**
		 * 设置多语言管理器
		 */
		public static function setLanguageManager(value:ILanguageManager):void
		{
			languageManager = value;
		}
		
		/**
		 * 顶级应用容器
		 */		
		public static var systemManager:SystemManager;

		
	}
}