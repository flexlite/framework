package org.flexlite.domUI.core
{
	
	/**
	 * 层级堆叠容器接口
	 * @author DOM
	 */
	public interface IViewStack
	{
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
		
		function get selectedChild():IVisualElement;
		function set selectedChild(value:IVisualElement):void;
	}
}