package org.flexlite.domUI.core
{
	
	/**
	 * 层级堆叠容器接口
	 * @author DOM
	 */
	public interface IViewStack
	{
		/**
		 * 当前可见子元素的索引。索引从0开始。
		 */			
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
		
		/**
		 * 当前可见的子元素。
		 */
		function get selectedChild():IVisualElement;
		function set selectedChild(value:IVisualElement):void;
	}
}