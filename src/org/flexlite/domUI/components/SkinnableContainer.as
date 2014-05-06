package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	
	/**
	 * 元素添加事件
	 */	
	[Event(name="elementAdd", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	
	/**
	 * 元素移除事件 
	 */	
	[Event(name="elementRemove", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	

	[DXML(show="true")]
	
	[DefaultProperty(name="elementsContent",array="true")]
	
	/**
	 * 可设置外观的容器的基类
	 * @author DOM
	 */
	public class SkinnableContainer extends SkinnableComponent implements IVisualElementContainer
	{
		public function SkinnableContainer()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return SkinnableContainer;
		}
		
		/**
		 * [SkinPart]实体容器
		 */
		public var contentGroup:Group;
		
		/**
		 * 实体容器实例化之前缓存子对象的容器 
		 */		
		dx_internal var _placeHolderGroup:Group;
		
		/**
		 * 获取当前的实体容器
		 */		
		dx_internal function get currentContentGroup():Group
		{          
			if (contentGroup==null)
			{
				if (_placeHolderGroup==null)
				{
					_placeHolderGroup = new Group();
					_placeHolderGroup.visible = false;
					addToDisplayList(_placeHolderGroup);
				}
				_placeHolderGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				_placeHolderGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				return _placeHolderGroup;
			}
			else
			{
				return contentGroup;    
			}
		}
		
		/**
		 * 设置容器子对象数组 。数组包含要添加到容器的子项列表，之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器。 
		 * 设置该属性时会对您输入的数组进行一次浅复制操作，所以您之后对该数组的操作不会影响到添加到容器的子项列表数量。
		 */		
		public function set elementsContent(value:Array):void
		{
			currentContentGroup.elementsContent = value;
		}
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return currentContentGroup.numElements;
		}
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IVisualElement
		{
			return currentContentGroup.getElementAt(index);
		}
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			return currentContentGroup.addElement(element);
		}
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			return currentContentGroup.addElementAt(element,index);
		}
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return currentContentGroup.removeElement(element);
		}
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			return currentContentGroup.removeElementAt(index);
		}
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			currentContentGroup.removeAllElements();
		}
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IVisualElement):int
		{
			return currentContentGroup.getElementIndex(element);
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			currentContentGroup.setElementIndex(element,index);
		}
		/**
		 * @inheritDoc
		 */
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			currentContentGroup.swapElements(element1,element2);
		}
		/**
		 * @inheritDoc
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			currentContentGroup.swapElementsAt(index1,index2);
		}
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IVisualElement):Boolean
		{
			return currentContentGroup.containsElement(element);
		}
		
		
		/**
		 * contentGroup发生改变时传递的参数
		 */		
		private var contentGroupProperties:Object = {};
		
		/**
		 * 此容器的布局对象
		 */
		public function get layout():LayoutBase
		{
			return contentGroup!=null?
				contentGroup.layout:contentGroupProperties.layout;	
		}
		
		public function set layout(value:LayoutBase):void
		{
			if (contentGroup!=null)
			{
				contentGroup.layout = value;
			}
			else
			{
				contentGroupProperties.layout = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == contentGroup)
			{
				if(contentGroupProperties.layout !== undefined)
				{
					contentGroup.layout = contentGroupProperties.layout;
					contentGroupProperties = {};
				}
				if(_placeHolderGroup)
				{
					_placeHolderGroup.removeEventListener(
						ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
					_placeHolderGroup.removeEventListener(
						ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
					var sourceContent:Array = _placeHolderGroup.getElementsContent().concat();
					for (var i:int = _placeHolderGroup.numElements; i > 0; i--)
					{
						var element:IVisualElement = _placeHolderGroup.removeElementAt(0);  
						element.ownerChanged(null);
					}
					removeFromDisplayList(_placeHolderGroup);
					contentGroup.elementsContent = sourceContent;
					for (i = sourceContent.length-1; i >=0; i--)
					{
						element = sourceContent[i];  
						element.ownerChanged(this);
					}
					_placeHolderGroup = null;
				}
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == contentGroup)
			{
				contentGroup.removeEventListener(
					ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				contentGroup.removeEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				contentGroupProperties.layout = contentGroup.layout;
				contentGroup.layout = null;
				if(contentGroup.numElements>0)
				{
					_placeHolderGroup = new Group;
					
					while(contentGroup.numElements>0)
					{
						_placeHolderGroup.addElement(contentGroup.getElementAt(0));
					}
					_placeHolderGroup.addEventListener(
						ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
					_placeHolderGroup.addEventListener(
						ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				}
			}
		}
		
		/**
		 * 容器添加元素事件
		 */		
		dx_internal function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
		{
			event.element.ownerChanged(this);
			dispatchEvent(event);
		}
		/**
		 * 容器移除元素事件
		 */		
		dx_internal function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
		{
			event.element.ownerChanged(null);
			dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			contentGroup = new Group();
			contentGroup.percentWidth = 100;
			contentGroup.percentHeight = 100;
			addToDisplayList(contentGroup);
			partAdded("contentGroup",contentGroup);
		}
				
		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void
		{
			partRemoved("contentGroup",contentGroup);
			removeFromDisplayList(contentGroup);
			contentGroup = null;
		}
	}
}