package org.flexlite.domUI.layouts.supportClasses
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.utils.OnDemandEventDispatcher;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 容器布局基类
	 * @author DOM
	 */
	public class LayoutBase extends OnDemandEventDispatcher
	{
		public function LayoutBase()
		{
			super();
		}
		
		private var _target:GroupBase;
		/**
		 * 目标容器
		 */		
		public function get target():GroupBase
		{
			return _target;
		}
		
		public function set target(value:GroupBase):void
		{
			if (_target == value)
				return;
			_target = value;
			clearVirtualLayoutCache();
		}
		
		private var _horizontalScrollPosition:Number = 0;
		/**
		 * 可视区域水平方向起始点
		 */		
		public function get horizontalScrollPosition():Number 
		{
			return _horizontalScrollPosition;
		}
		
		public function set horizontalScrollPosition(value:Number):void 
		{
			if (value == _horizontalScrollPosition) 
				return;
			var oldValue:Number = _horizontalScrollPosition;
			_horizontalScrollPosition = value;
			scrollPositionChanged();
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(
				this, "horizontalScrollPosition", oldValue, value));
		}
		
		private var _verticalScrollPosition:Number = 0;
		/**
		 * 可视区域竖直方向起始点
		 */		
		public function get verticalScrollPosition():Number 
		{
			return _verticalScrollPosition;
		}
		
		public function set verticalScrollPosition(value:Number):void 
		{
			if (value == _verticalScrollPosition)
				return;
			var oldValue:Number = _verticalScrollPosition;
			_verticalScrollPosition = value;
			scrollPositionChanged();
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(
				this, "verticalScrollPosition", oldValue, value));
		}    
		
		private var _clipAndEnableScrolling:Boolean = false;
		/**
		 * 如果为 true，指定将子代剪切到视区的边界。如果为 false，则容器子代会从容器边界扩展过去，而不管组件的大小规范。
		 */	
		public function get clipAndEnableScrolling():Boolean 
		{
			return _clipAndEnableScrolling;
		}
		
		public function set clipAndEnableScrolling(value:Boolean):void 
		{
			if (value == _clipAndEnableScrolling) 
				return;
			
			_clipAndEnableScrolling = value;
			if (target!=null)
				updateScrollRect(target.width, target.height);
		}
		/**
		 * 返回对水平滚动位置的更改以处理不同的滚动选项。
		 * 下列选项是由 NavigationUnit 类定义的：END、HOME、LEFT、PAGE_LEFT、PAGE_RIGHT 和 RIGHT。 
		 * @param navigationUnit 采用以下值： 
		 *  <li> 
		 *  <code>END</code>
		 *  返回滚动 delta，它将使 scrollRect 与内容区域右对齐。 
		 *  </li> 
		 *  <li> 
		 *  <code>HOME</code>
		 *  返回滚动 delta，它将使 scrollRect 与内容区域左对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>LEFT</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的左边或在其左边左侧的第一个元素左对齐。 
		 *  </li>
		 *  <li>
		 *  <code>PAGE_LEFT</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的左边或在其左边左侧的第一个元素右对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>PAGE_RIGHT</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的右边或在其右边右侧的第一个元素左对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>RIGHT</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的右边或在其右边右侧的第一个元素右对齐。 
		 *  </li>
		 *  </ul>
		 */		
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			var g:GroupBase = target;
			if (!g)
				return 0;     
			
			var scrollRect:Rectangle = getScrollRect();
			if (!scrollRect)
				return 0;
			
			if ((scrollRect.x == 0) && (scrollRect.width >= g.contentWidth))
				return 0;  
			
			var maxDelta:Number = g.contentWidth - scrollRect.right;
			var minDelta:Number = -scrollRect.left;
			var getElementBounds:Rectangle;
			switch(navigationUnit)
			{
				case NavigationUnit.LEFT:
				case NavigationUnit.PAGE_LEFT:
					getElementBounds = getElementBoundsLeftOfScrollRect(scrollRect);
					break;
				
				case NavigationUnit.RIGHT:
				case NavigationUnit.PAGE_RIGHT:
					getElementBounds = getElementBoundsRightOfScrollRect(scrollRect);
					break;
				
				case NavigationUnit.HOME: 
					return minDelta;
					
				case NavigationUnit.END: 
					return maxDelta;
					
				default:
					return 0;
			}
			
			if (!getElementBounds)
				return 0;
			
			var delta:Number = 0;
			switch (navigationUnit)
			{
				case NavigationUnit.LEFT:
					delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);
					break;    
				case NavigationUnit.RIGHT:
					delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
					break;    
				case NavigationUnit.PAGE_LEFT:
				{
					delta = getElementBounds.right - scrollRect.right;
					
					if (delta >= 0)
						delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);  
				}
					break;
				case NavigationUnit.PAGE_RIGHT:
				{
					delta = getElementBounds.left - scrollRect.left;
					
					if (delta <= 0)
						delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
				}
					break;
			}
			
			return Math.min(maxDelta, Math.max(minDelta, delta));
		}
		/**
		 * 返回对垂直滚动位置的更改以处理不同的滚动选项。
		 * 下列选项是由 NavigationUnit 类定义的：DOWN、END、HOME、PAGE_DOWN、PAGE_UP 和 UP。
		 * @param navigationUnit 采用以下值： DOWN 
		 *  <ul>
		 *  <li> 
		 *  <code>DOWN</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的底边或在其底边之下的第一个元素底对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>END</code>
		 *  返回滚动 delta，它将使 scrollRect 与内容区域底对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>HOME</code>
		 *  返回滚动 delta，它将使 scrollRect 与内容区域顶对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>PAGE_DOWN</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的底边或在其底边之下的第一个元素顶对齐。
		 *  </li>
		 *  <code>PAGE_UP</code>
		 *  <li>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的顶边或在其顶边之上的第一个元素底对齐。 
		 *  </li>
		 *  <li> 
		 *  <code>UP</code>
		 *  返回滚动 delta，它将使 scrollRect 与跨越 scrollRect 的顶边或在其顶边之上的第一个元素顶对齐。 
		 *  </li>
		 *  </ul>
		 */		
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			var g:GroupBase = target;
			if (!g)
				return 0;     
			
			var scrollRect:Rectangle = getScrollRect();
			if (!scrollRect)
				return 0;
			
			if ((scrollRect.y == 0) && (scrollRect.height >= g.contentHeight))
				return 0;  
			
			var maxDelta:Number = g.contentHeight - scrollRect.bottom;
			var minDelta:Number = -scrollRect.top;
			var getElementBounds:Rectangle;
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
				case NavigationUnit.PAGE_UP:
					getElementBounds = getElementBoundsAboveScrollRect(scrollRect);
					break;
				
				case NavigationUnit.DOWN:
				case NavigationUnit.PAGE_DOWN:
					getElementBounds = getElementBoundsBelowScrollRect(scrollRect);
					break;
				
				case NavigationUnit.HOME: 
					return minDelta;
					
				case NavigationUnit.END: 
					return maxDelta;
					
				default:
					return 0;
			}
			
			if (!getElementBounds)
				return 0;
			
			var delta:Number = 0;
			switch (navigationUnit)
			{
				case NavigationUnit.UP:
					delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);
					break;    
				case NavigationUnit.DOWN:
					delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
					break;    
				case NavigationUnit.PAGE_UP:
				{
					delta = getElementBounds.bottom - scrollRect.bottom;
					
					if (delta >= 0)
						delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);  
				}
					break;
				case NavigationUnit.PAGE_DOWN:
				{
					delta = getElementBounds.top - scrollRect.top;
					
					if (delta <= 0)
						delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
				}
					break;
			}
			
			return Math.min(maxDelta, Math.max(minDelta, delta));
		}
		
		/**
		 * 返回布局坐标中目标的滚动矩形的界限。
		 */		
		protected function getScrollRect():Rectangle
		{
			var g:GroupBase = target;
			if (!g || !g.clipAndEnableScrolling)
				return null;     
			var vsp:Number = g.verticalScrollPosition;
			var hsp:Number = g.horizontalScrollPosition;
			return new Rectangle(hsp, vsp, g.width, g.height);
		}
		/**
		 * 返回跨越 scrollRect 的左边或在其左边左侧的第一个布局元素的界限。 
		 */		
		protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.left - 1;
			bounds.right = scrollRect.left; 
			return bounds;
		} 
		/**
		 * 返回跨越 scrollRect 的右边或在其右边右侧的第一个布局元素的界限。 
		 */		
		protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.right;
			bounds.right = scrollRect.right + 1;
			return bounds;
		} 
		/**
		 * 返回跨越 scrollRect 的顶边或在其顶边之上的第一个布局元素的界限。
		 */
		protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.top - 1;
			bounds.bottom = scrollRect.top;
			return bounds;
		} 
		/**
		 * 返回跨越 scrollRect 的底边或在其底边之下的第一个布局元素的界限。 
		 */		
		protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.bottom;
			bounds.bottom = scrollRect.bottom + 1;
			return bounds;
		}
		
		/**
		 * 滚动条位置改变
		 */		
		protected function scrollPositionChanged():void
		{
			if (target==null)
				return;
			updateScrollRect(target.width, target.height);
			target.invalidateDisplayListExceptLayout();
		}
		/**
		 * 更新可视区域
		 */		
		public function updateScrollRect(w:Number, h:Number):void
		{
			if (target==null)
				return;
			if (_clipAndEnableScrolling)
			{
				target.scrollRect = new Rectangle(_horizontalScrollPosition, _verticalScrollPosition, w, h);
			}
			else
			{
				target.scrollRect = null;
			}
		}
		
		
		private var _useVirtualLayout:Boolean = false;
		/**
		 * 若要配置容器使用虚拟布局，请为与容器关联的布局的 useVirtualLayout 属性设置为 true。
		 * 只有布局设置为 VerticalLayout、HorizontalLayout 
		 * 或 TileLayout 的 DataGroup 或 SkinnableDataContainer 
		 * 才支持虚拟布局。不支持虚拟化的布局子类必须禁止更改此属性。
		 */
		public function get useVirtualLayout():Boolean
		{
			return _useVirtualLayout;
		}
		
		public function set useVirtualLayout(value:Boolean):void
		{
			if (_useVirtualLayout == value)
				return;
			
			_useVirtualLayout = value;
			dispatchEvent(new Event("useVirtualLayoutChanged"));
			
			if (_useVirtualLayout && !value) 
				clearVirtualLayoutCache();
			if (target)
				target.invalidateDisplayList();
		}
		
		private var _typicalLayoutRect:Rectangle;
		
		/**
		 * 由虚拟布局所使用，以估计尚未滚动到视图中的布局元素的大小。 
		 */
		public function get typicalLayoutRect():Rectangle
		{
			return _typicalLayoutRect;
		}
		
		public function set typicalLayoutRect(value:Rectangle):void
		{
			if(_typicalLayoutRect==value)
				return;
			_typicalLayoutRect = value;
			if (target)
				target.invalidateSize();
		}
		
		
		
		/**
		 * 清理虚拟布局缓存的数据
		 */		
		public function clearVirtualLayoutCache():void
		{
		}
		/**
		 * 在已添加布局元素之后且在验证目标的大小和显示列表之前，由目标调用。
		 * 按元素状态缓存的布局（比如虚拟布局）可以覆盖此方法以更新其缓存。 
		 */		
		public function elementAdded(index:int):void
		{
		}
		/**
		 * 必须在已删除布局元素之后且在验证目标的大小和显示列表之前，由目标调用此方法。
		 * 按元素状态缓存的布局（比如虚拟布局）可以覆盖此方法以更新其缓存。 
		 */		
		public function elementRemoved(index:int):void
		{
		}
		
		/**
		 * 测量组件尺寸大小
		 */		
		public function measure():void
		{
		}
		/**
		 * 更新显示列表
		 */		
		public function updateDisplayList(width:Number, height:Number):void
		{
		} 
	}
}