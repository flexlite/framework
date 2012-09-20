package org.flexlite.domUI.components.supportClasses
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.layouts.BasicLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 自动布局容器基类
	 * @author DOM
	 */
	public class GroupBase extends UIComponent implements IViewport
	{
		public function GroupBase()
		{
			super();
		}
		
		private var _contentWidth:Number = 0;
		
		/**
		 * 视域的内容的宽度。
		 * 如果 clipAndEnabledScrolling 为 true，
		 * 则视域的 contentWidth 为水平滚动定义限制，
		 * 且视域的实际宽度定义可见的内容量。
		 * 要在内容中水平滚动，请在 0 和 contentWidth - width 
		 * 之间更改 horizontalScrollPosition。 
		 */
		public function get contentWidth():Number 
		{
			return _contentWidth;
		}

		private function setContentWidth(value:Number):void 
		{
			if (value == _contentWidth)
				return;
			var oldValue:Number = _contentWidth;
			_contentWidth = value;
			dispatchPropertyChangeEvent("contentWidth", oldValue, value);  
		}
		
		private var _contentHeight:Number = 0;
		
		/**
		 * 视域的内容的高度。
		 * 如果 clipAndEnabledScrolling 为 true，
		 * 则视域的 contentHeight 为垂直滚动定义限制，
		 * 且视域的实际高度定义可见的内容量。
		 * 要在内容中垂直滚动， 请在 0 和 contentHeight - height 
		 * 之间更改 verticalScrollPosition
		 */
		public function get contentHeight():Number 
		{
			return _contentHeight;
		}
		
		private function setContentHeight(value:Number):void 
		{            
			if (value == _contentHeight)
				return;
			var oldValue:Number = _contentHeight;
			_contentHeight = value;
			dispatchPropertyChangeEvent("contentHeight", oldValue, value);        
		}    
		/**
		 * @private
		 * 设置 contentWidth 和 contentHeight 属性，此方法由Layout类调用
		 */		
		public function setContentSize(width:Number, height:Number):void
		{
			if ((width == _contentWidth) && (height == _contentHeight))
				return;
			setContentWidth(width);
			setContentHeight(height);
		}
		
		/**
		 * 布局发生改变时传递的参数
		 */		
		private var _layoutProperties:Object;
		
		private var _layout:LayoutBase;
		/**
		 * 此容器的布局对象
		 */
		public function get layout():LayoutBase
		{
			return _layout;
		}

		public function set layout(value:LayoutBase):void
		{
			
			if (_layout == value)
				return;
			if (_layout)
			{
				_layout.target = null;
				_layout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);
				_layoutProperties = {"clipAndEnableScrolling": _layout.clipAndEnableScrolling};
			}
			
			_layout = value; 
			
			if (_layout)
			{
				_layout.target = this;
				_layout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);
				if (_layoutProperties)
				{
					if (_layoutProperties.clipAndEnableScrolling !== undefined)
						value.clipAndEnableScrolling = _layoutProperties.clipAndEnableScrolling;
					
					if (_layoutProperties.verticalScrollPosition !== undefined)
						value.verticalScrollPosition = _layoutProperties.verticalScrollPosition;
					
					if (_layoutProperties.horizontalScrollPosition !== undefined)
						value.horizontalScrollPosition = _layoutProperties.horizontalScrollPosition;
					
					_layoutProperties = null;
				}
			}
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("layoutChanged"));
		}
		
		/**
		 * 抛出滚动条位置改变事件
		 */		
		private function redispatchLayoutEvent(event:Event):void
		{
			var pce:PropertyChangeEvent = event as PropertyChangeEvent;
			if (pce)
				switch (pce.property)
				{
					case "verticalScrollPosition":
					case "horizontalScrollPosition":
						dispatchEvent(event);
						break;
				}
		}  
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(_layout==null)
			{
				layout = new BasicLayout;
			}
		}
		
		/**
		 * 如果为 true，指定将子代剪切到视区的边界。如果为 false，则容器子代会从容器边界扩展过去，而不管组件的大小规范。默认false
		 */
		public function get clipAndEnableScrolling():Boolean
		{
			if (_layout)
			{
				return _layout.clipAndEnableScrolling;
			}
			else if (_layoutProperties && 
				_layoutProperties.clipAndEnableScrolling !== undefined)
			{
				return _layoutProperties.clipAndEnableScrolling;
			}
			else
			{
				return false;
			}
		}
		
		public function set clipAndEnableScrolling(value:Boolean):void
		{
			if (_layout)
			{
				_layout.clipAndEnableScrolling = value;
			}
			else if (_layoutProperties)
			{
				_layoutProperties.clipAndEnableScrolling = value;
			}
			else
			{
				_layoutProperties = {clipAndEnableScrolling: value};
			}
			
			invalidateSize();
		}
		
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			return (layout) ? layout.getHorizontalScrollPositionDelta(navigationUnit) : 0;     
		}
		
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			return (layout) ? layout.getVerticalScrollPositionDelta(navigationUnit) : 0;     
		}
		
		/**
		 * 可视区域水平方向起始点
		 */
		public function get horizontalScrollPosition():Number
		{
			if (_layout)
			{
				return _layout.horizontalScrollPosition;
			}
			else if (_layoutProperties && 
				_layoutProperties.horizontalScrollPosition !== undefined)
			{
				return _layoutProperties.horizontalScrollPosition;
			}
			else
			{
				return 0;
			}
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if (_layout)
			{
				_layout.horizontalScrollPosition = value;
			}
			else if (_layoutProperties)
			{
				_layoutProperties.horizontalScrollPosition = value;
			}
			else
			{
				_layoutProperties = {horizontalScrollPosition: value};
			}
		}
		
		/**
		 * 可视区域竖直方向起始点
		 */
		public function get verticalScrollPosition():Number
		{
			if (_layout)
			{
				return _layout.verticalScrollPosition;
			}
			else if (_layoutProperties && 
				_layoutProperties.verticalScrollPosition !== undefined)
			{
				return _layoutProperties.verticalScrollPosition;
			}
			else
			{
				return 0;
			}
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if (_layout)
			{
				_layout.verticalScrollPosition = value;
			}
			else if (_layoutProperties)
			{
				_layoutProperties.verticalScrollPosition = value;
			}
			else
			{
				_layoutProperties = {verticalScrollPosition: value};
			}
		}

		override protected function measure():void
		{
			if(_layout==null||!layoutInvalidateSizeFlag)
				return;
			var oldMeasuredWidth:Number = measuredWidth;
			var oldMeasuredHeight:Number = measuredHeight;
			
			super.measure();
			
			_layout.measure();
			if ((measuredWidth != oldMeasuredWidth || measuredHeight != oldMeasuredHeight))
				invalidateDisplayList();
		}
		
		/**
		 * 在更新显示列表时是否需要更新布局标志 
		 */
		dx_internal var layoutInvalidateDisplayListFlag:Boolean = false;

		/**
		 * 标记需要更新显示列表但不需要更新布局
		 */		
		dx_internal function invalidateDisplayListExceptLayout():void
		{
			super.invalidateDisplayList();
		}
		
		override public function invalidateDisplayList():void
		{
			super.invalidateDisplayList();
			layoutInvalidateDisplayListFlag = true;
		}
		
		override dx_internal function childXYChanged():void
		{
			invalidateSize();
			invalidateDisplayList();
		}

		/**
		 * 在测量尺寸时是否需要测量布局的标志
		 */
		dx_internal var layoutInvalidateSizeFlag:Boolean = false;
			
		/**
		 * 标记需要更新显示列表但不需要更新布局
		 */
		dx_internal function invalidateSizeExceptLayout():void
		{
			super.invalidateSize();
		}
		
		override public function invalidateSize():void
		{
			super.invalidateSize();
			layoutInvalidateSizeFlag = true;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (layoutInvalidateDisplayListFlag&&_layout!=null)
			{
				layoutInvalidateDisplayListFlag = false;
				_layout.updateDisplayList(unscaledWidth, unscaledHeight);
				_layout.updateScrollRect(unscaledWidth, unscaledHeight);
			}
		}
		/**
		 *  @copy org.flexlite.domUI.core.IVisualElementContainer#numElements()
		 */
		public function get numElements():int
		{
			return -1;
		}
		
		/**
		 *  @copy org.flexlite.domUI.core.IVisualElementContainer#getElementAt()
		 */
		public function getElementAt(index:int):IVisualElement
		{
			return null;
		}
		/**
		 * 支持 useVirtualLayout 属性的布局类在 updateDisplayList() 中使用此方法来获取“处于视图中”的布局元素 
		 * @param index 要检索的元素的索引。
		 */		
		public function getVirtualElementAt(index:int):IVisualElement
		{
			return getElementAt(index);            
		}
		/**
		 *  @copy org.flexlite.domUI.core.IVisualElementContainer#getElementIndex()
		 */
		public function getElementIndex(element:IVisualElement):int
		{
			return -1;
		}
		/**
		 *  @copy org.flexlite.domUI.core.IVisualElementContainer#containsElement()
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
		 * 返回在容器可视区域内的布局元素索引列表,此方法忽略不是布局元素的普通的显示对象
		 */		
		public function getElementIndicesInView():Vector.<int>
		{
			var visibleIndices:Vector.<int> = new Vector.<int>();
			var index:int
			if(scrollRect==null)
			{
				for(index = 0;index < numChildren;index++)
				{
					visibleIndices.push(index);
				}
			}
			else
			{
				for(index = 0;index < numChildren;index++)
				{
					var layoutElement:ILayoutElement = getChildAt(index) as ILayoutElement;
					if (layoutElement==null)
						continue;
					var eltR:Rectangle = new Rectangle();
					eltR.x = layoutElement.layoutBoundsX;
					eltR.y = layoutElement.layoutBoundsY;
					eltR.width = layoutElement.layoutBoundsWidth;
					eltR.height = layoutElement.layoutBoundsHeight;
					if(scrollRect.intersects(eltR))
						visibleIndices.push(index);
				}
			}
			return visibleIndices;
		}
	}
}