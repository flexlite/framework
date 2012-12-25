package org.flexlite.domUI.managers
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IVisualElement;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * SystemManager的虚拟子容器
	 * @author DOM
	 */
	public class SystemContainer implements IContainer
	{
		/**
		 * 构造函数
		 */		
		public function SystemContainer(owner:SystemManager,
										lowerBoundReference:QName,
										upperBoundReference:QName)
		{
			this.owner = owner;
			this.lowerBoundReference = lowerBoundReference;
			this.upperBoundReference = upperBoundReference;
		}
		/**
		 * 实体容器
		 */		
		private var owner:SystemManager;
		
		/**
		 * 容器下边界属性
		 */		
		private var lowerBoundReference:QName;
		
		/**
		 * 容器上边界属性
		 */		
		private var upperBoundReference:QName;
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return owner[upperBoundReference] - owner[lowerBoundReference];
		}
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IVisualElement
		{
			var retval:IVisualElement =
				owner.raw_getElementAt(
					owner[lowerBoundReference] + index);
			return retval;
		}
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			var index:int = owner[upperBoundReference];
			if(element.parent==owner)
				index--;
			owner[upperBoundReference]++;
			owner.raw_addElementAt(element,index);
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			owner[upperBoundReference]++;
			owner.raw_addElementAt(
				element, owner[lowerBoundReference] + index);
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			var index:int = owner.raw_getElementIndex(element);
			if (owner[lowerBoundReference] <= index &&
				index < owner[upperBoundReference])
			{
				owner.raw_removeElement(element);
				owner[upperBoundReference]--;
			}
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			index += owner[lowerBoundReference];
			var element:IVisualElement;
			if (owner[lowerBoundReference] <= index &&
				index < owner[upperBoundReference])
			{
				element = owner.raw_removeElementAt(index);
				owner[upperBoundReference]--;
			}
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IVisualElement):int
		{
			var retval:int = owner.raw_getElementIndex(element);
			retval -= owner[lowerBoundReference];
			return retval;
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			owner.raw_setElementIndex(
				element, owner[lowerBoundReference] + index);
		}
	}
}