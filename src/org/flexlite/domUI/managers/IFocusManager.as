package org.flexlite.domUI.managers
{
	import flash.display.Stage;
	
	/**
	 * 焦点管理器接口
	 * @author DOM
	 */
	public interface IFocusManager
	{
		/**
		 * 舞台引用
		 */
		function get stage():Stage;
		function set stage(value:Stage):void;
	}
}