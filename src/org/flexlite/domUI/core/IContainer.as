package org.flexlite.domUI.core
{
	
	/**
	 * 容器接口
	 * @author DOM
	 */
	public interface IContainer
	{
		/**
		 * 此容器中的可视元素的数量。
		 * 可视元素包括实现 IVisualElement 接口的类，
		 */		
		function get numElements():int;
		/**
		 * 返回指定索引处的可视元素。
		 * @param index 要检索的元素的索引。
		 * @throws RangeError 如果在子列表中不存在该索引位置。
		 */		
		function getElementAt(index:int):IVisualElement
		/**
		 * 将可视元素添加到此容器中。
		 * 如果添加的可视元素已有一个不同的容器作为父项，则该元素将会从其他容器中删除。
		 * @param element 要添加为此容器的子项的可视元素。
		 */		
		function addElement(element:IVisualElement):IVisualElement;
		/**
		 * 将可视元素添加到此容器中。该元素将被添加到指定的索引位置。索引 0 代表显示列表中的第一个元素。 
		 * 如果添加的可视元素已有一个不同的容器作为父项，则该元素将会从其他容器中删除。
		 * @param element 要添加为此可视容器的子项的元素。
		 * @param index 将该元素添加到的索引位置。如果指定当前占用的索引位置，则该位置以及所有更高位置上的子对象会在子级列表中上移一个位置。
		 * @throws RangeError 如果在子列表中不存在该索引位置。
		 */		
		function addElementAt(element:IVisualElement, index:int):IVisualElement;
		/**
		 * 从此容器的子列表中删除指定的可视元素。
		 * 在该可视容器中，位于该元素之上的所有元素的索引位置都减少 1。
		 * @param element 要从容器中删除的元素。
		 */		
		function removeElement(element:IVisualElement):IVisualElement;
		/**
		 * 从容器中的指定索引位置删除可视元素。
		 * 在该可视容器中，位于该元素之上的所有元素的索引位置都减少 1。
		 * @param index 要删除的元素的索引。
		 * @throws RangeError 如果在子列表中不存在该索引位置。
		 */		
		function removeElementAt(index:int):IVisualElement;
		/**
		 * 返回可视元素的索引位置。若不存在，则返回-1。
		 * @param element 可视元素。
		 */		
		function getElementIndex(element:IVisualElement):int;
		/**
		 * 在可视容器中更改现有可视元素的位置。
		 * @param element 要为其更改索引编号的元素。
		 * @param index 元素的最终索引编号。
		 * @throws RangeError 如果在子列表中不存在该索引位置。
		 */		
		function setElementIndex(element:IVisualElement, index:int):void;
		
	}
}