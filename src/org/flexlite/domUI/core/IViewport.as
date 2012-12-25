package org.flexlite.domUI.core
{
	/**
	 * 支持视区的组件接口
	 * @author DOM
	 */	
	public interface IViewport extends IVisualElement
	{
		/**
		 * 视域的内容的宽度。
		 * 如果 clipAndEnabledScrolling 为 true， 则视域的 contentWidth 为水平滚动定义限制，
		 * 且视域的实际宽度定义可见的内容量。要在内容中水平滚动， 请在 0 和 contentWidth - width 
		 * 之间更改 horizontalScrollPosition。 
		 */		
		function get contentWidth():Number;
		
		/**
		 * 视域的内容的高度。
		 * 如果 clipAndEnabledScrolling 为 true，则视域的 contentHeight 为垂直滚动定义限制，
		 * 且视域的实际高度定义可见的内容量。要在内容中垂直滚动，请在 0 和 contentHeight - height 
		 * 之间更改 verticalScrollPosition。
		 */		
		function get contentHeight():Number;
		
		/**
		 * 可视区域水平方向起始点
		 */		
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		/**
		 * 可视区域竖直方向起始点
		 */		
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		/**
		 * 返回要添加到视域的当前 horizontalScrollPosition 的数量，以按请求的滚动单位进行滚动。
		 * @param navigationUnit 要滚动的数量。该值必须是NavigationUnit 常量之一
		 */		
		function getHorizontalScrollPositionDelta(navigationUnit:uint):Number;
		
		/**
		 * 回要添加到视域的当前 verticalScrollPosition 的数量，以按请求的滚动单位进行滚动。
		 * @param navigationUnit 要滚动的数量。该值必须是NavigationUnit 常量之一
		 */		
		function getVerticalScrollPositionDelta(navigationUnit:uint):Number;
		
		/**
		 * 如果为 true，指定将子代剪切到视区的边界。如果为 false，则容器子代会从容器边界扩展过去，而不管组件的大小规范。默认false
		 */		
		function get clipAndEnableScrolling():Boolean;
		function set clipAndEnableScrolling(value:Boolean):void;
	}
	
}
