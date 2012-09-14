package org.flexlite.domUI.components
{
	import org.flexlite.domUI.core.ISkinPartHost;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.dx_internal;
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
		private var _placeHolderGroup:Group;
		
		/**
		 * 获取当前的实体容器
		 */		
		private function get currentContentGroup():Group
		{          
			if (contentGroup==null)
			{
				if (_placeHolderGroup==null)
				{
					_placeHolderGroup = new Group();
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
		 * @copy org.flexlite.domUI.components.Group#elementsContent
		 */		
		public function set elementsContent(value:Array):void
		{
			currentContentGroup.elementsContent = value;
		}
		
		public function get numElements():int
		{
			return currentContentGroup.numElements;
		}
		
		public function getElementAt(index:int):IVisualElement
		{
			return currentContentGroup.getElementAt(index);
		}
		
		public function addElement(element:IVisualElement):IVisualElement
		{
			return currentContentGroup.addElement(element);
		}
		
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			return currentContentGroup.addElementAt(element,index);
		}
		
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return currentContentGroup.removeElement(element);
		}
		
		public function removeElementAt(index:int):IVisualElement
		{
			return currentContentGroup.removeElementAt(index);
		}
		
		public function removeAllElements():void
		{
			currentContentGroup.removeAllElements();
		}
		
		public function getElementIndex(element:IVisualElement):int
		{
			return currentContentGroup.getElementIndex(element);
		}
		
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			currentContentGroup.setElementIndex(element,index);
		}
		
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			currentContentGroup.swapElements(element1,element2);
		}
		
		public function swapElementsAt(index1:int, index2:int):void
		{
			currentContentGroup.swapElementsAt(index1,index2);
		}
		
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
				if(_placeHolderGroup!=null)
				{
					_placeHolderGroup.removeEventListener(
						ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
					_placeHolderGroup.removeEventListener(
						ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
					var sourceContent:Array = _placeHolderGroup.getElementsContent();
					contentGroup.elementsContent = sourceContent ? sourceContent.slice() : null;
					for (var i:int = _placeHolderGroup.numElements; i > 0; i--)
					{
						_placeHolderGroup.removeElementAt(0);  
					}
					_placeHolderGroup = null;
					
				}
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
			}
		}
		
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
		private function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
		{
			event.element.owner = this
			
			dispatchEvent(event);
		}
		/**
		 * 容器移除元素事件
		 */		
		private function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
		{
			event.element.owner = null;
			
			dispatchEvent(event);
		}
		
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			if(!(skin is ISkinPartHost))
			{
				createContentGroup();
			}
		}
		
		override protected function detachSkin(skin:Object):void
		{
			if(!(skin is ISkinPartHost))
			{
				removeContentGroup();
			}
			super.detachSkin(skin);
		}
		
		/**
		 * 当皮肤不是ISkinPartHost时，创建DataGroup
		 */		
		private function createContentGroup():void
		{
			if(contentGroup)
				return;
			contentGroup = new Group();
			contentGroup.percentWidth = 100;
			contentGroup.percentHeight = 100;
			addToDisplyList(contentGroup);
			partAdded("contentGroup",contentGroup);
		}
		
		/**
		 * 销毁当皮肤不是ISkinPartHost时创建的DataGroup
		 */		
		private function removeContentGroup():void
		{
			if(!contentGroup)
				return;
			partRemoved("contentGroup",contentGroup);
			removeFromDisplayList(contentGroup);
			contentGroup = null;
		}
		
	}
}