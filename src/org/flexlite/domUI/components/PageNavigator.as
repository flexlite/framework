package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Orientation3D;
	
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.layouts.TileOrientation;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	[DefaultProperty(name="viewport",array="false")]
	
	/**
	 * 翻页组件
	 * @author DOM
	 */
	public class PageNavigator extends SkinnableComponent implements IVisualElementContainer
	{
		public function PageNavigator()
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return PageNavigator;
		}
		/**
		 * [SkinPart]上一页按钮
		 */	
		public var prevPage:Button;
		/**
		 * [SkinPart]下一页按钮
		 */	
		public var nextPage:Button;
		
		/**
		 * [SkinPart]第一页按钮
		 */	
		public var firstPage:Button;
		/**
		 * [SkinPart]最后一页按钮
		 */	
		public var lastPage:Button;
		/**
		 * [SkinPart]页码文本显示对象
		 */		
		public var labelDisplay:IDisplayText;
		/**
		 * [SkinPart]装载目标viewport的容器
		 */		
		public var contentGroup:Group;
		
		/**
		 * 页码文本格式化回调函数，示例：labelFunction(pageIndex:int,totalPages:int):String;
		 */		
		public var labelFunction:Function;
		/**
		 * 格式化当前页码为显示的文本
		 * @param pageIndex
		 */		
		protected function pageToLabel(pageIndex:int,totalPages:int):String
		{
			if(labelFunction!=null)
				return labelFunction(pageIndex,totalPages);
			return "第"+(pageIndex+1)+"/"+totalPages+"页";
		}
		
		private var _currentPage:int = -1;
		/**
		 * 当前页码索引，从0开始。
		 */
		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			gotoPage(value);
		}

		private var _totalPages:int = 0;
		/**
		 * 总页数。
		 */
		public function get totalPages():int
		{
			return _totalPages;
		}
		
		private var _viewport:IViewport;
		
		/**
		 * 要滚动的视域组件。 
		 */		
		public function get viewport():IViewport
		{       
			return _viewport;
		}
		
		public function set viewport(value:IViewport):void
		{
			if (value == _viewport)
				return;
			
			uninstallViewport();
			_viewport = value;
			installViewport();
			dispatchEvent(new Event("viewportChanged"));
		}
		
		/**
		 * 安装并初始化视域组件
		 */		
		private function installViewport():void
		{
			if (contentGroup&&_viewport)
			{
				_viewport.clipAndEnableScrolling = true;
				_viewport.percentHeight = _viewport.percentWidth = 100;
				contentGroup.addElementAt(_viewport, 0);
				_viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
				_viewport.addEventListener(ResizeEvent.RESIZE,onViewPortResized);
				pageDirectionIsVertical = updateDirection();
				if(_viewport is GroupBase)
				{
					_viewport.addEventListener("layoutChanged",onLayoutChanged);
					var layout:LayoutBase = (_viewport as GroupBase).layout;
					if(layout)
					{
						layout.addEventListener("orientationChanged",onLayoutChanged,false,0,true);
					}
				}
				updateaTotalPages();
			}
		}
		/**
		 * viewPort尺寸改变
		 */		
		private function onViewPortResized(event:ResizeEvent):void
		{
			totalPagesChanged = true;
			invalidateProperties();
		}
		
		/**
		 * 卸载视域组件
		 */		
		private function uninstallViewport():void
		{
			if (skin && _viewport)
			{
				_viewport.clipAndEnableScrolling = false;
				_viewport.percentHeight = _viewport.percentWidth = NaN;
				contentGroup.removeElement(_viewport);
				_viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);	
				_viewport.removeEventListener(ResizeEvent.RESIZE,onViewPortResized);
				if(_viewport is GroupBase)
				{
					_viewport.removeEventListener("layoutChanged",onLayoutChanged);
					var layout:LayoutBase = (_viewport as GroupBase).layout;
					if(layout)
					{
						layout.removeEventListener("orientationChanged",onLayoutChanged);
					}
				}
			}
		}
		/**
		 * viewport的layout属性改变,更新翻页方向.
		 */		
		private function onLayoutChanged(event:Event=null):void
		{
			pageDirectionIsVertical = updateDirection();
			if(event.type=="layoutChanged"&&_viewport is GroupBase)
			{
				var layout:LayoutBase = (_viewport as GroupBase).layout;
				if(layout&&!layout.hasEventListener("gapChanged"))
				{
					layout.addEventListener("orientationChanged",onLayoutChanged,false,0,true);
				}
			}
		}
		
		/**
		 * 翻页朝向，true代表垂直翻页，false代表水平翻页。
		 */		
		private var pageDirectionIsVertical:Boolean = true;
		/**
		 * 安装viewport时调用此方法，返回当前的翻页方向，true代表垂直翻页，反之水平翻页。
		 */		
		dx_internal function updateDirection():Boolean
		{
			if(!(_viewport is GroupBase))
				return true;
			var layout:LayoutBase = (_viewport as GroupBase).layout;
			var direction:Boolean = true;
			if(layout is HorizontalAlign)
			{
				direction = false;
			}
			else if(layout is TileLayout&&
				(layout as TileLayout).orientation==TileOrientation.COLUMNS)
			{
				direction = false;
			}
			else
			{
				direction = true;
			}
			return direction;
		}
		/**
		 * 总页数改变
		 */		
		private var totalPagesChanged:Boolean = false;
		/**
		 * 视域组件的属性改变
		 */		
		private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch(event.property) 
			{
				case "contentWidth": 
				case "contentHeight": 
					totalPagesChanged = true;
					invalidateProperties();
					break;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(totalPagesChanged)
			{
				updateaTotalPages();
			}
		}
		
		private var _autoButtonEnabled:Boolean = true;
		/**
		 * 当已经到达页尾或页首时，自动启用或禁用翻页按钮。默认值为true。
		 */
		public function get autoButtoEnabled():Boolean
		{
			return _autoButtonEnabled;
		}
		public function set autoButtoEnabled(value:Boolean):void
		{
			if(_autoButtonEnabled==value)
				return;
			_autoButtonEnabled = value;
			if(value)
			{
				checkButtonEnabled();
			}
		}
		/**
		 * 更新总页码
		 */		
		private function updateaTotalPages():void
		{
			totalPagesChanged = false;
			if(!_viewport)
				return;
			if(pageDirectionIsVertical)
			{
				_totalPages = Math.ceil(_viewport.contentHeight/_viewport.height);
				if(isNaN(_totalPages)||_totalPages<0)
					_totalPages = 0;
				_currentPage = Math.ceil(_viewport.verticalScrollPosition/_viewport.height);
				if(isNaN(_currentPage))
					_currentPage = -1;
			}
			else
			{
				_totalPages = Math.ceil(_viewport.contentWidth/_viewport.width);
				if(isNaN(_totalPages)||_totalPages<0)
					_totalPages = 0;
				_currentPage = Math.ceil(_viewport.horizontalScrollPosition/_viewport.width);
				if(isNaN(_currentPage))
					_currentPage = -1;
			}
			if(_autoButtonEnabled)
			{
				checkButtonEnabled();
			}
			if(labelDisplay)
				labelDisplay.text = pageToLabel(_currentPage,_totalPages);
		}
		
		/**
		 * 跳转到指定索引的页面
		 */			
		private function gotoPage(index:int):void
		{
			if(!_viewport)
				return;
			if(index<0)
				index = 0;
			if(index>_totalPages-1)
				index = _totalPages-1;
			if(_currentPage==index)
				return;
			var length:int = Math.abs(_currentPage-index);
			var i:int;
			var navigatorUint:uint;
			if(pageDirectionIsVertical)
			{
				if(index==0)
				{
					_viewport.verticalScrollPosition += 
						_viewport.getVerticalScrollPositionDelta(NavigationUnit.HOME);
				}
				else if(index==_totalPages-1)
				{
					_viewport.verticalScrollPosition += 
						_viewport.getVerticalScrollPositionDelta(NavigationUnit.END);
				}
				else
				{
					navigatorUint = index<_currentPage?NavigationUnit.PAGE_UP:NavigationUnit.PAGE_DOWN;
					for(i=0;i<length;i++)
					{
						_viewport.verticalScrollPosition += 
							_viewport.getVerticalScrollPositionDelta(navigatorUint);
					}
				}
			}
			else
			{
				if(index==0)
				{
					_viewport.horizontalScrollPosition += 
						_viewport.getHorizontalScrollPositionDelta(NavigationUnit.HOME);
				}
				else if(index==_totalPages-1)
				{
					_viewport.horizontalScrollPosition += 
						_viewport.getHorizontalScrollPositionDelta(NavigationUnit.END);
				}
				else
				{
					navigatorUint = index<_currentPage?NavigationUnit.PAGE_LEFT:NavigationUnit.PAGE_RIGHT;
					for(i=0;i<length;i++)
					{
						_viewport.horizontalScrollPosition += 
							_viewport.getHorizontalScrollPositionDelta(navigatorUint);
					}
				}
			}
			_currentPage = index;
			if(_autoButtonEnabled)
			{
				checkButtonEnabled();
			}
			if(labelDisplay)
				labelDisplay.text = pageToLabel(_currentPage,_totalPages);
		}
		/**
		 * 检查页码并设置按钮禁用状态
		 */		
		private function checkButtonEnabled():void
		{
			var prev:Boolean = false;
			var next:Boolean = false;
			var first:Boolean = false;
			var last:Boolean = false;
			if(_totalPages>1)
			{
				if(_currentPage<_totalPages-1)
				{
					last = next = true;
				}
				if(_currentPage>0)
				{
					first = prev = true;
				}
			}
			if(prevPage)
				prevPage.enabled = prev;
			if(nextPage)
				nextPage.enabled = next;
			if(firstPage)
				firstPage.enabled = first;
			if(lastPage)
				lastPage.enabled = last;
		}
		
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			installViewport();
		}
		
		override protected function detachSkin(skin:Object):void
		{    
			uninstallViewport();
			super.detachSkin(skin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance==prevPage)
			{
				prevPage.addEventListener(MouseEvent.CLICK,onPrevPageClick);
			}
			else if(instance==nextPage)
			{
				nextPage.addEventListener(MouseEvent.CLICK,onNextPageClick);
			}
			else if(instance==firstPage)
			{
				firstPage.addEventListener(MouseEvent.CLICK,onFirstPageClick);
			}
			else if(instance==lastPage)
			{
				lastPage.addEventListener(MouseEvent.CLICK,onLastPageClick);
			}
			else if(instance==labelDisplay)
			{
				labelDisplay.text = pageToLabel(_currentPage,_totalPages);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance==prevPage)
			{
				prevPage.removeEventListener(MouseEvent.CLICK,onPrevPageClick);
			}
			else if(instance==nextPage)
			{
				nextPage.removeEventListener(MouseEvent.CLICK,onNextPageClick);
			}
			else if(instance==firstPage)
			{
				firstPage.removeEventListener(MouseEvent.CLICK,onFirstPageClick);
			}
			else if(instance==lastPage)
			{
				lastPage.removeEventListener(MouseEvent.CLICK,onLastPageClick);
			}
		}
		/**
		 * "最后一页"按钮被点击
		 */		
		protected function onLastPageClick(event:MouseEvent):void
		{
			if(!_viewport)
				return;
			gotoPage(_totalPages-1);
		}
		/**
		 * "第一页"按钮被点击
		 */		
		protected function onFirstPageClick(event:MouseEvent):void
		{
			if(!_viewport)
				return;
			gotoPage(0);
		}
		/**
		 * "下一页"按钮被点击
		 */		
		protected function onNextPageClick(event:MouseEvent):void
		{
			if(!_viewport)
				return;
			gotoPage(_currentPage+1);
		}
		/**
		 * "上一页"按钮被点击
		 */		
		protected function onPrevPageClick(event:MouseEvent):void
		{
			if(!_viewport)
				return;
			gotoPage(_currentPage-1);
		}
		
		
		/**
		 * 皮肤上鼠标滚轮事件
		 */		
		private function skin_mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = _viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible)
				return;
			if(event.delta>0)
				gotoPage(_currentPage+1);
			else
				gotoPage(_currentPage-1);
			event.preventDefault();
			
		}
		
		public function get numElements():int
		{
			return _viewport ? 1 : 0;
		}
		
		/**
		 * 抛出索引越界异常
		 */		
		private function throwRangeError(index:int):void
		{
			throw new RangeError("索引:\""+index+"\"超出可视元素索引范围");
		}
		
		public function getElementAt(index:int):IVisualElement
		{
			if (_viewport && index == 0)
				return _viewport;
			else
				throwRangeError(index);
			return null;
		}
		
		
		public function getElementIndex(element:IVisualElement):int
		{
			if (element != null && element == _viewport)
				return 0;
			else
				return -1;
		}
		
		public function containsElement(element:IVisualElement):Boolean
		{
			if (element != null && element == _viewport)
				return true;
			return false;
		}
		
		private function throwNotSupportedError():void
		{
			throw new Error("此方法在Scroller组件内不可用!");
		}
		
		public function addElement(element:IVisualElement):IVisualElement
		{
			throwNotSupportedError();
			return null;
		}
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			throwNotSupportedError();
			return null;
		}
		public function removeElement(element:IVisualElement):IVisualElement
		{
			throwNotSupportedError();
			return null;
		}
		public function removeElementAt(index:int):IVisualElement
		{
			throwNotSupportedError();
			return null;
		}
		public function removeAllElements():void
		{
			throwNotSupportedError();
		}
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			throwNotSupportedError();
		}
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			throwNotSupportedError();
		}
		public function swapElementsAt(index1:int, index2:int):void
		{
			throwNotSupportedError();
		}
	}
}