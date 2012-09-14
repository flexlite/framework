package org.flexlite.domUI.core
{
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;

	/**
	 * 皮肤对象接口。是独立的布局容器，且含有样式绑定功能。
	 * @author DOM
	 */
	public interface ISkin extends IVisualElementContainer,IInvalidating
	{
		/**
		 * 主机组件引用,仅当皮肤被应用后才会对此属性赋值 
		 */		
		function get hostComponent():IHostComponent;
		function set hostComponent(value:IHostComponent):void;

		/**
		 * 此容器的布局对象
		 */		
		function get layout():LayoutBase;
		function set layout(value:LayoutBase):void;
		
		/**
		 * 标记某个样式属性已经改变
		 */	
		function invalidateStyle(styleName:String):void;
	}
}