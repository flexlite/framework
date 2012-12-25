package org.flexlite.domUI.core
{

	/**
	 * 具有管理IVisualElement子显示对象的容器接口
	 * @author DOM
	 */	
	public interface IVisualElementContainer extends IVisualElement,IContainer
	{
		/**
		 * 从容器中删除所有可视元素。
		 */		
		function removeAllElements():void;
		/**
		 * 交换两个指定可视元素的索引。所有其他元素仍位于相同的索引位置。
		 * @param element1 第一个可视元素。
		 * @param element2 第二个可视元素。
		 */		
		function swapElements(element1:IVisualElement, element2:IVisualElement):void;
		/**
		 * 交换容器中位于两个指定索引位置的可视元素。所有其他可视元素仍位于相同的索引位置。
		 * @param index1 第一个元素的索引。
		 * @param index2 第二个元素的索引。
		 * @throws RangeError 如果在子列表中不存在该索引位置。
		 */		
		function swapElementsAt(index1:int, index2:int):void;
		/**
		 * 确定指定的 IVisualElement 是否为容器实例的子代或该实例本身。将进行深度搜索，即，如果此元素是该容器的子代、孙代、曾孙代等，它将返回 true。
		 * @param element 要测试的子对象
		 */		
		function containsElement(element:IVisualElement):Boolean;
	}
	
}
