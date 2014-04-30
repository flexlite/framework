package org.flexlite.domUI.core
{
	/**
	 * 简单文本显示控件接口。
	 * @author DOM
	 */	
	public interface IDisplayText extends IUIComponent
	{
		/**
		 * 此文本组件所显示的文本。
		 */		
		function get text():String;
		function set text(value:String):void;
	}
}