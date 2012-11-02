package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	[DefaultProperty(name="elementsContent",array="true")]
	
	/**
	 * 层级堆叠容器,一次只显示一个子对象。此容器的布局方式与BasicLayout相同。
	 * 可以接受任何IVisualElement作为子项。
	 * @author DOM
	 */
	public class ViewStack extends UIComponent implements IVisualElementContainer
	{
		/**
		 * 构造函数
		 */		
		public function ViewStack()
		{
			super();
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
			if(proposedSelectedIndex!=-1)
			{
				var index:int = proposedSelectedIndex;
				proposedSelectedIndex = -1;
				setSelectedIndex(index);
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
			
			if (_elementsContent != value)
			{
				for (i = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
			}
			
			_elementsContent = value.concat();
			
			var n:int = _elementsContent.length;
			for (i = 0; i < n; i++)
			{   
				var elt:IVisualElement = _elementsContent[i];
				
				if (elt.parent!=null && (elt.parent is IVisualElementContainer))
					IVisualElementContainer(elt.parent).removeElement(elt);
				
				elementAdded(elt, i);
			}
		}
		
		private var _selectedChild:IVisualElement;
		/**
		 * 当前可见的子容器。
		 */		
		public function get selectedChild():IVisualElement
		{
			return _selectedChild;
		}
		public function set selectedChild(value:IVisualElement):void
		{
			if(_selectedChild==value)
				return;
			var index:int = getElementIndex(value);
			setSelectedIndex(index);
		}
		
		private var proposedSelectedIndex:int = -1;
		
		dx_internal var _selectedIndex:int = -1;
		/**
		 * 当前可见子容器的索引。索引从0开始。
		 */		
		public function get selectedIndex():int
		{
			return proposedSelectedIndex!=-1?proposedSelectedIndex:_selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if(createChildrenCalled)
			{
				setSelectedIndex(value);
			}
			else
			{
				proposedSelectedIndex = value;
			}
		}
		/**
		 * 设置选中项索引
		 */		
		dx_internal function setSelectedIndex(value:int):void
		{
			if(_selectedIndex==value)
				return;
			if(value>=0&&value<numElements)
			{
				_selectedIndex = value;
				if(_selectedChild)
					_selectedChild.visible = false;
				_selectedChild = getElementAt(_selectedIndex);
			}
			else
			{
				_selectedChild = null;
				_selectedIndex = -1;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return _elementsContent.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			return _elementsContent[index];
		}
		/**
		 * 检查索引是否越界
		 */
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
		public function getElementIndex(element:IVisualElement):int
		{
			return _elementsContent.indexOf(element);
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			checkForRangeError(index);
			
			if (getElementIndex(element) == index)
				return;
			
			removeElement(element);
			addElementAt(element, index);
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
				elementRemoved(element1, index1);
				elementRemoved(element2, index2);
			}
			
			_elementsContent.splice(index2, 1);
			_elementsContent.splice(index1, 1);
			
			_elementsContent.splice(index1, 0, element2);
			_elementsContent.splice(index2, 0, element1);
			
			if (!elementsContentChanged)
			{
				elementAdded(element2,index1);
				elementAdded(element1,index2);
			}
		}
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IVisualElement):Boolean
		{
			while (element)
			{
				if (element == this)
					return true;
				
				if (element.parent is IVisualElement)
					element = IVisualElement(element.parent);
				else
					return false;
			}
			
			return false;
		}
		/**
		 * 添加一个显示元素到容器
		 */		
		dx_internal function elementAdded(element:IVisualElement, index:int):void
		{
			if(element is DisplayObject)
				super.addChildAt(DisplayObject(element), index);
			element.visible = false;
			if(_selectedIndex==-1)
				setSelectedIndex(0);
		}
		/**
		 * 从容器移除一个显示元素
		 */		
		dx_internal function elementRemoved(element:IVisualElement, index:int):void
		{
			var childDO:DisplayObject = element as DisplayObject; 
			if (childDO && childDO.parent == this)
			{
				super.removeChild(childDO);
			}
			element.visible = true;
			if(index==_selectedIndex)
				setSelectedIndex(0);
		}
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(!_selectedChild)
				return;
			
			var hCenter:Number   = _selectedChild.horizontalCenter;
			var vCenter:Number   = _selectedChild.verticalCenter;
			var left:Number      = _selectedChild.left;
			var right:Number     = _selectedChild.right;
			var top:Number       = _selectedChild.top;
			var bottom:Number    = _selectedChild.bottom;
			
			var extX:Number;
			var extY:Number;
			
			if (!isNaN(left) && !isNaN(right))
			{
				extX = left + right;                
			}
			else if (!isNaN(hCenter))
			{
				extX = Math.abs(hCenter) * 2;
			}
			else if (!isNaN(left) || !isNaN(right))
			{
				extX = isNaN(left) ? 0 : left;
				extX += isNaN(right) ? 0 : right;
			}
			else
			{
				extX = _selectedChild.preferredX;
			}
			
			if (!isNaN(top) && !isNaN(bottom))
			{
				extY = top + bottom;                
			}
			else if (!isNaN(vCenter))
			{
				extY = Math.abs(vCenter) * 2;
			}
			else if (!isNaN(top) || !isNaN(bottom))
			{
				extY = isNaN(top) ? 0 : top;
				extY += isNaN(bottom) ? 0 : bottom;
			}
			else
			{
				extY = _selectedChild.preferredY;
			}
			
			var preferredWidth:Number = _selectedChild.preferredWidth;
			var preferredHeight:Number = _selectedChild.preferredHeight;
			
			measuredWidth = Math.ceil(extX + preferredWidth);
			measuredHeight = Math.ceil(extY + preferredHeight);
		}
		/**
		 * 距离顶部距离
		 */		
		dx_internal var paddingTop:Number = 0;
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(!_selectedChild)
				return;
			_selectedChild.visible = true;
			
			var hCenter:Number          = _selectedChild.horizontalCenter;
			var vCenter:Number          = _selectedChild.verticalCenter;
			var left:Number             = _selectedChild.left;
			var right:Number            = _selectedChild.right;
			var top:Number              = _selectedChild.top;
			var bottom:Number           = _selectedChild.bottom;
			var percentWidth:Number     = _selectedChild.percentWidth;
			var percentHeight:Number    = _selectedChild.percentHeight;
			
			var childWidth:Number = NaN;
			var childHeight:Number = NaN;
			
			if(!isNaN(left) && !isNaN(right))
			{
				childWidth = unscaledWidth - right - left;
			}
			else if (!isNaN(percentWidth))
			{
				childWidth = Math.round(unscaledWidth * Math.min(percentWidth * 0.01, 1));
			}
			
			if (!isNaN(top) && !isNaN(bottom))
			{
				childHeight = unscaledHeight - bottom - top;
			}
			else if (!isNaN(percentHeight))
			{
				childHeight = Math.round(unscaledHeight * Math.min(percentHeight * 0.01, 1));
			}
			
			_selectedChild.setLayoutBoundsSize(childWidth, childHeight);
			
			var elementWidth:Number = _selectedChild.layoutBoundsWidth;
			var elementHeight:Number = _selectedChild.layoutBoundsHeight;
			
			
			var childX:Number = NaN;
			var childY:Number = NaN;
			
			if (!isNaN(hCenter))
				childX = Math.round((unscaledWidth - elementWidth) * 0.5 + hCenter);
			else if (!isNaN(left))
				childX = left;
			else if (!isNaN(right))
				childX = unscaledWidth - elementWidth - right;
			else
				childX = _selectedChild.layoutBoundsX;
			
			if (!isNaN(vCenter))
				childY = Math.round((unscaledHeight - elementHeight) * 0.5 + vCenter);
			else if (!isNaN(top))
				childY = top;
			else if (!isNaN(bottom))
				childY = unscaledHeight - elementHeight - bottom;
			else
				childY = _selectedChild.layoutBoundsY;
			
			_selectedChild.setLayoutBoundsPosition(childX, childY);
		}
		
		
		/**
		 * 添加对象到显示列表指定的索引
		 */		
		final dx_internal function addToDisplyListAt(child:DisplayObject,index:int):DisplayObject
		{
			return super.addChildAt(child,index);
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