package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.events.DragEvent;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	
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
	 * 自动布局容器
	 * @author DOM
	 */
	public class Group extends GroupBase implements IVisualElementContainer
	{
		public function Group()
		{
			super();
		}
		
		private var _hasMouseListeners:Boolean = false;
		
		/**
		 * 是否添加过鼠标事件监听
		 */  
		private function set hasMouseListeners(value:Boolean):void
		{
			if (_mouseEnabledWhereTransparent)
			{
				invalidateDisplayListExceptLayout();
			}
			_hasMouseListeners = value;
		}
		
		/**
		 * 鼠标事件的监听个数 
		 */	
		private var mouseEventReferenceCount:int;
		
		private var _mouseEnabledWhereTransparent:Boolean = true;
		
		/**
		 *  是否允许透明区域也响应鼠标事件,默认true
		 */
		public function get mouseEnabledWhereTransparent():Boolean
		{
			return _mouseEnabledWhereTransparent;
		}
		
		public function set mouseEnabledWhereTransparent(value:Boolean):void
		{
			if (value == _mouseEnabledWhereTransparent)
				return;
			
			_mouseEnabledWhereTransparent = value;
			
			if (_hasMouseListeners)
				invalidateDisplayListExceptLayout();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function,
												  useCapture:Boolean = false, priority:int = 0,
												  useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, 
				useWeakReference);
			switch (type)
			{
				
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.ROLL_OUT:
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_WHEEL:
				case DragEvent.DRAG_ENTER:
				case DragEvent.DRAG_OVER:
				case DragEvent.DRAG_DROP:
				case DragEvent.DRAG_EXIT:
					if (++mouseEventReferenceCount > 0)
						hasMouseListeners = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener( type:String, listener:Function,
													  useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			switch (type)
			{
				
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.ROLL_OUT:
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_WHEEL:
					if (--mouseEventReferenceCount == 0)
						hasMouseListeners = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			drawBackground();
		}
		/**
		 * 绘制鼠标点击区域
		 */		
		private function drawBackground():void
		{
			if (!_mouseEnabledWhereTransparent || !_hasMouseListeners)
				return;
			graphics.clear();
			if (width==0 || height==0)
				return;
			graphics.beginFill(0xFFFFFF, 0);
			if (layout && layout.clipAndEnableScrolling)
				graphics.drawRect(layout.horizontalScrollPosition, layout.verticalScrollPosition, width, height);
			else
			{
				const tileSize:int = 4096;
				for (var x:int = 0; x < width; x += tileSize)
					for (var y:int = 0; y < height; y += tileSize)
					{
						var tileWidth:int = Math.min(width - x, tileSize);
						var tileHeight:int = Math.min(height - y, tileSize);
						graphics.drawRect(x, y, tileWidth, tileHeight); 
					}
			}
			
			graphics.endFill();
		}	
		

		/**
		 * createChildren()方法已经执行过的标志
		 */		
		private var createChildrenCalled:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			createChildrenCalled = true;
			if(elementsContentChanged)
			{
				elementsContentChanged = false;
				setElementsContent(_elementsContent);
			}
		}
		
		/**
		 * elementsContent改变标志 
		 */		
		private  var elementsContentChanged:Boolean = false;
		
		private var _elementsContent:Array = [];
		/**
		 * 返回子元素列表
		 */		
		dx_internal function getElementsContent():Array
		{
			return _elementsContent;
		}

		/**
		 * 设置容器子对象数组 。数组包含要添加到容器的子项列表，之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器。
		 * 设置该属性时会对您输入的数组进行一次浅复制操作，所以您之后对该数组的操作不会影响到添加到容器的子项列表数量。
		 */		
		public function set elementsContent(value:Array):void
		{
			if(value==null)
				value = [];
			if(value==_elementsContent)
				return;
			if (createChildrenCalled)
			{
				setElementsContent(value);
			}
			else
			{
				elementsContentChanged = true;
				for (var i:int = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
				_elementsContent = value;
			}
		}
		
		/**
		 * 设置容器子对象列表
		 */		
		private function setElementsContent(value:Array):void
		{
			var i:int;
			
			for (i = _elementsContent.length - 1; i >= 0; i--)
			{
				elementRemoved(_elementsContent[i], i);
			}
			
			_elementsContent = value.concat();
			
			var n:int = _elementsContent.length;
			for (i = 0; i < n; i++)
			{   
				var elt:IVisualElement = _elementsContent[i];
				
				if(elt.parent is IVisualElementContainer)
					IVisualElementContainer(elt.parent).removeElement(elt);
				else if(elt.owner is IContainer)
					IContainer(elt.owner).removeElement(elt);
				
				elementAdded(elt, i);
			}
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		override public function get numElements():int
		{
			return _elementsContent.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			return _elementsContent[index];
		}
		
		private function checkForRangeError(index:int, addingElement:Boolean = false):void
		{
			var maxIndex:int = _elementsContent.length - 1;
			
			if (addingElement)
				maxIndex++;
			
			if (index < 0 || index > maxIndex)
				throw new RangeError("索引:\""+index+"\"超出可视元素索引范围");
		}
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			var index:int = numElements;
			
			if (element.parent == this)
				index = numElements-1;
			
			return addElementAt(element, index);
		}
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			if (element == this)
				return element;
			
			checkForRangeError(index, true);
			
			var host:DisplayObject = element.parent; 
			if (host == this)
			{
				setElementIndex(element, index);
				return element;
			}
			else if (host is IVisualElementContainer)
			{
				IVisualElementContainer(host).removeElement(element);
			}
			else if(element.owner is IContainer)
			{
				IContainer(element.owner).removeElement(element);
			}
			
			_elementsContent.splice(index, 0, element);
			
			if (!elementsContentChanged)
				elementAdded(element, index);
			
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return removeElementAt(getElementIndex(element));
		}
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			
			var element:IVisualElement = _elementsContent[index];
			
			if (!elementsContentChanged)
				elementRemoved(element, index);
			
			_elementsContent.splice(index, 1);
			
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			for (var i:int = numElements - 1; i >= 0; i--)
			{
				removeElementAt(i);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndex(element:IVisualElement):int
		{
			return _elementsContent.indexOf(element);
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			checkForRangeError(index);
			
			var oldIndex:int = getElementIndex(element);
			if (oldIndex==-1||oldIndex == index)
				return;
			
			if (!elementsContentChanged)
				elementRemoved(element, oldIndex, false);
			
			_elementsContent.splice(oldIndex, 1);
			_elementsContent.splice(index, 0, element);
			
			if (!elementsContentChanged)
				elementAdded(element, index, false);
		}
		/**
		 * @inheritDoc
		 */
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			swapElementsAt(getElementIndex(element1), getElementIndex(element2));
		}
		/**
		 * @inheritDoc
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			checkForRangeError(index1);
			checkForRangeError(index2);
			
			if (index1 > index2)
			{
				var temp:int = index2;
				index2 = index1;
				index1 = temp; 
			}
			else if (index1 == index2)
				return;
			
			var element1:IVisualElement = _elementsContent[index1];
			var element2:IVisualElement = _elementsContent[index2];
			if (!elementsContentChanged)
			{
				elementRemoved(element1, index1, false);
				elementRemoved(element2, index2, false);
			}
			
			_elementsContent.splice(index2, 1);
			_elementsContent.splice(index1, 1);
			
			_elementsContent.splice(index1, 0, element2);
			_elementsContent.splice(index2, 0, element1);
			
			if (!elementsContentChanged)
			{
				elementAdded(element2, index1, false);
				elementAdded(element1, index2, false);
			}
		}
		/**
		 * 添加一个显示元素到容器
		 */		
		dx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			if(element is DisplayObject)
				addToDisplayList(DisplayObject(element), index);
			
			if (notifyListeners)
			{
				if (hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_ADD, false, false, element, index));
			}
			
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * 从容器移除一个显示元素
		 */		
		dx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			if (notifyListeners)
			{        
				if (hasEventListener(ElementExistenceEvent.ELEMENT_REMOVE))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_REMOVE, false, false, element, index));
			}
			
			var childDO:DisplayObject = element as DisplayObject; 
			if (childDO && childDO.parent == this)
			{
				super.removeChild(childDO);
			}
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 添加对象到显示列表
		 */		
		final dx_internal function addToDisplayList(child:DisplayObject, index:int = -1):void
		{
			if (child.parent == this)
				super.setChildIndex(child, index != -1 ? index : super.numChildren - 1);
			else
				super.addChildAt(child, index != -1 ? index : super.numChildren);
		}
		
		private static const errorStr:String = "在此组件中不可用，若此组件为容器类，请使用";
		[Deprecated] 
		/**
		 * addChild()在此组件中不可用，若此组件为容器类，请使用addElement()代替
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("addChild()"+errorStr+"addElement()代替"));
		}
		[Deprecated] 
		/**
		 * addChildAt()在此组件中不可用，若此组件为容器类，请使用addElementAt()代替
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw(new Error("addChildAt()"+errorStr+"addElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * removeChild()在此组件中不可用，若此组件为容器类，请使用removeElement()代替
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("removeChild()"+errorStr+"removeElement()代替"));
		}
		[Deprecated] 
		/**
		 * removeChildAt()在此组件中不可用，若此组件为容器类，请使用removeElementAt()代替
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw(new Error("removeChildAt()"+errorStr+"removeElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * setChildIndex()在此组件中不可用，若此组件为容器类，请使用setElementIndex()代替
		 */		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw(new Error("setChildIndex()"+errorStr+"setElementIndex()代替"));
		}
		[Deprecated] 
		/**
		 * swapChildren()在此组件中不可用，若此组件为容器类，请使用swapElements()代替
		 */		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw(new Error("swapChildren()"+errorStr+"swapElements()代替"));
		}
		[Deprecated] 
		/**
		 * swapChildrenAt()在此组件中不可用，若此组件为容器类，请使用swapElementsAt()代替
		 */		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw(new Error("swapChildrenAt()"+errorStr+"swapElementsAt()代替"));
		}
	}
}