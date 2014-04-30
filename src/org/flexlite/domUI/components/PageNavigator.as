package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.layouts.TileOrientation;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	import org.flexlite.domUI.utils.callLater;
	
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
			focusEnabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return PageNavigator;
		}
		/**
		 * [SkinPart]上一页按钮
		 */	
		public var prevPageButton:Button;
		/**
		 * [SkinPart]下一页按钮
		 */	
		public var nextPageButton:Button;
		
		/**
		 * [SkinPart]第一页按钮
		 */	
		public var firstPageButton:Button;
		/**
		 * [SkinPart]最后一页按钮
		 */	
		public var lastPageButton:Button;
		/**
		 * [SkinPart]页码文本显示对象
		 */		
		public var labelDisplay:IDisplayText;
		/**
		 * [SkinPart]装载目标viewport的容器
		 */		
		public var contentGroup:Group;
		
		private var _pageDuration:Number = 500;
		
		/**
		 * 翻页缓动动画时间，单位毫秒。设置为0则不执行缓动。默认值500。
		 */		
		public function get pageDuration():Number
		{
			return _pageDuration;
		}
		
		public function set pageDuration(value:Number):void
		{
			_pageDuration = value;
		}
		
		private static var sineEaser:IEaser = new Sine(0);
		private var _animator:Animation = null;
		/**
		 * 动画类实例
		 */		
		private function get animator():Animation
		{
			if (_animator)
				return _animator;
			_animator = new Animation(animationUpdateHandler);
			_animator.endFunction = animationEndHandler;
			animator.easer = sineEaser;
			return _animator;
		}
		
		/**
		 * 动画播放过程中触发的更新数值函数
		 */		
		private function animationUpdateHandler(animation:Animation):void
		{
			if(!_viewport)
				return;
			var value:Number = animation.currentValue["scrollPosition"];
			if(pageDirectionIsVertical)
				_viewport.verticalScrollPosition = value;
			else
				_viewport.horizontalScrollPosition = value;
		}
		/**
		 * 动画播放结束时到达的滚动位置
		 */		
		private var destScrollPostion:Number;
		/**
		 * 动画播放完成触发的函数
		 */		
		private function animationEndHandler(animation:Animation):void
		{
			if(!_viewport)
				return;
			if(pageDirectionIsVertical)
			{
				if(destScrollPostion>_viewport.contentHeight-_viewport.height)
				{
					destScrollPostion = _viewport.contentHeight-_viewport.height;
				}
				_viewport.verticalScrollPosition = destScrollPostion;
			}
			else
			{
				if(destScrollPostion>_viewport.contentWidth-_viewport.width)
				{
					destScrollPostion = _viewport.contentWidth-_viewport.width;
				}
				_viewport.horizontalScrollPosition = destScrollPostion;
			}
		}
		/**
		 * 立即开始动画的播放
		 */		
		private function startAnimation(valueFrom:Number,valueTo:Number):void
		{
			if(animator.isPlaying)
			{
				animationEndHandler(animator);
				animator.stop();
			}
			var pageSize:Number = Math.max(1,_viewport.width);
			var duration:Number = Math.abs(valueTo-valueFrom)/pageSize*_pageDuration;
			animator.duration = int(Math.min(_pageDuration,duration));
			animator.motionPaths = new <MotionPath>[
				new MotionPath("scrollPosition", valueFrom, valueTo)];
			animator.play();
		}
		
		
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
			return (pageIndex+1)+"/"+totalPages;
		}
		
		/**
		 * 未设置缓存选中项的值
		 */
		private static const NO_PROPOSED_PAGE:int = -2;
		/**
		 * 在属性提交前缓存外部显式设置的页码值
		 */
		dx_internal var proposedCurrentPage:int = NO_PROPOSED_PAGE;
		
		private var _currentPage:int = 0;
		/**
		 * 当前页码索引，从0开始。
		 */
		public function get currentPage():int
		{
			return proposedCurrentPage == NO_PROPOSED_PAGE ?
				_currentPage : proposedCurrentPage;
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
			if(value == _viewport)
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
				_viewport.left = _viewport.right = _viewport.top = _viewport.bottom = 0;
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
			if (skinObject && _viewport)
			{
				_viewport.clipAndEnableScrolling = false;
				_viewport.left = _viewport.right = _viewport.top = _viewport.bottom = NaN;
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
			var oldDirection:Boolean = pageDirectionIsVertical;
			pageDirectionIsVertical = updateDirection();
			if(pageDirectionIsVertical!=oldDirection)
				updateaTotalPages();
			if(event.type=="layoutChanged"&&_viewport is GroupBase)
			{
				var layout:LayoutBase = (_viewport as GroupBase).layout;
				if(layout&&!layout.hasEventListener("orientationChanged"))
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
			if(layout is HorizontalLayout)
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
		 * 内部正在调整滚动位置的标志
		 */		
		private var adjustingScrollPostion:Boolean = false;
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
				case "horizontalScrollPosition":
				case "verticalScrollPosition":
					if(adjustingScrollPostion||(_animator&&_animator.isPlaying))
						break;
					totalPagesChanged = true;
					invalidateProperties();
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(totalPagesChanged)
			{
				updateaTotalPages();
			}
		}
		
		private var _autoButtonVisibility:Boolean = false;
		/**
		 * 当已经到达页尾或页首时，是否自动隐藏或显示翻页按钮。默认值为false。
		 */
		public function get autoButtonVisibility():Boolean
		{
			return _autoButtonVisibility;
		}

		public function set autoButtonVisibility(value:Boolean):void
		{
			if(_autoButtonVisibility==value)
				return;
			_autoButtonVisibility = value;
			checkButtonEnabled();
		}

		private var scrollPostionMap:Array = [0];
		/**
		 * 更新总页码
		 */		
		private function updateaTotalPages():void
		{
			totalPagesChanged = false;
			if(!_viewport)
				return;
			adjustingScrollPostion = true;
			scrollPostionMap = [0];
			_totalPages = 1;
			var oldScrollPostion:Number;
			var maxScrollPostion:Number;
			var currentPageFoud:Boolean = false;
			if(pageDirectionIsVertical)
			{
				oldScrollPostion = _viewport.verticalScrollPosition;
				_viewport.verticalScrollPosition = 0;
				maxScrollPostion = _viewport.contentHeight-Math.max(0,_viewport.height);
				maxScrollPostion = Math.min(_viewport.contentHeight,maxScrollPostion);
				while(_viewport.verticalScrollPosition<maxScrollPostion)
				{
					_viewport.verticalScrollPosition += 
						_viewport.getVerticalScrollPositionDelta(NavigationUnit.PAGE_DOWN);
					if(!currentPageFoud&&_viewport.verticalScrollPosition>oldScrollPostion)
					{
						currentPageFoud = true;
					}
					scrollPostionMap[_totalPages] = _viewport.verticalScrollPosition;
					_totalPages++;
				}
				var h:Number = isNaN(_viewport.height)?0:_viewport.height;
				_viewport.verticalScrollPosition 
					= Math.max(0,Math.min(oldScrollPostion,_viewport.contentHeight-h));
			}
			else
			{
				oldScrollPostion = _viewport.horizontalScrollPosition;
				_viewport.horizontalScrollPosition = 0;
				maxScrollPostion = _viewport.contentWidth-Math.max(0,_viewport.width);
				maxScrollPostion = Math.min(_viewport.contentWidth,maxScrollPostion);
				while(_viewport.horizontalScrollPosition<maxScrollPostion)
				{
					_viewport.horizontalScrollPosition += 
						_viewport.getHorizontalScrollPositionDelta(NavigationUnit.PAGE_RIGHT);
					if(!currentPageFoud&&_viewport.horizontalScrollPosition>oldScrollPostion)
					{
						currentPageFoud = true;
					}
					scrollPostionMap[_totalPages] = _viewport.horizontalScrollPosition;
					_totalPages++;
				}
				var w:Number = isNaN(_viewport.width)?0:_viewport.width;
				_viewport.horizontalScrollPosition 
					= Math.max(0,Math.min(oldScrollPostion,_viewport.contentWidth-w));
				
			}
			if(_animator&&_animator.isPlaying)
			{
				proposedCurrentPage = _currentPage;
				doChangePage();
			}
			else
			{
				if(_currentPage>_totalPages-1)
					_currentPage = _totalPages-1;
				checkButtonEnabled();
				if(labelDisplay)
					labelDisplay.text = pageToLabel(_currentPage,_totalPages);
				if(pageDirectionIsVertical)
				{
					_viewport.verticalScrollPosition = scrollPostionMap[_currentPage];
				}
				else
				{
					_viewport.horizontalScrollPosition = scrollPostionMap[_currentPage];
				}
			}
			adjustingScrollPostion = false;
		}
		
		private var pageIndexChanged:Boolean = false;
		/**
		 * 跳转到指定索引的页面
		 */			
		private function gotoPage(index:int):void
		{
			if(index<0)
				index = 0;
			proposedCurrentPage = index;
			if(pageIndexChanged)
				return;
			pageIndexChanged = true;
			callLater(doChangePage);
		}
		
		/**
		 * 执行翻页操作
		 */		
		private function doChangePage():void
		{
			pageIndexChanged = false;
			if(!_viewport)
				return;
			_currentPage = proposedCurrentPage;
			if(_currentPage>_totalPages-1)
				_currentPage = _totalPages-1;
			checkButtonEnabled();
			if(labelDisplay)
				labelDisplay.text = pageToLabel(_currentPage,_totalPages);
			
			destScrollPostion = scrollPostionMap[_currentPage];
			if(_pageDuration>0&&stage)
			{
				var oldScrollPostion:Number;
				if(pageDirectionIsVertical)
				{
					oldScrollPostion = _viewport.verticalScrollPosition;
				}
				else
				{
					oldScrollPostion = _viewport.horizontalScrollPosition;
				}
				startAnimation(oldScrollPostion,destScrollPostion);
			}
			else
			{
				if(pageDirectionIsVertical)
				{
					_viewport.verticalScrollPosition = destScrollPostion;
				}
				else
				{
					_viewport.horizontalScrollPosition = destScrollPostion;
				}
			}
			proposedCurrentPage = NO_PROPOSED_PAGE;
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
				if(currentPage<_totalPages-1)
				{
					last = next = true;
				}
				if(currentPage>0)
				{
					first = prev = true;
				}
			}
			if(prevPageButton)
			{
				prevPageButton.enabled = prev;
				prevPageButton.visible = !_autoButtonVisibility||prev;
				prevPageButton.includeInLayout = !_autoButtonVisibility||prev;
			}
			if(nextPageButton)
			{
				nextPageButton.enabled = next;
				nextPageButton.visible = !_autoButtonVisibility||next;
				nextPageButton.includeInLayout = !_autoButtonVisibility||next;
			}
			if(firstPageButton)
			{
				firstPageButton.enabled = first;
				firstPageButton.visible = !_autoButtonVisibility||first;
				firstPageButton.includeInLayout = !_autoButtonVisibility||first;
			}
			if(lastPageButton)
			{
				lastPageButton.enabled = last;
				lastPageButton.visible = !_autoButtonVisibility||last;
				lastPageButton.includeInLayout = !_autoButtonVisibility||last;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			installViewport();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function detachSkin(skin:Object):void
		{    
			uninstallViewport();
			super.detachSkin(skin);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance==prevPageButton)
			{
				prevPageButton.addEventListener(MouseEvent.CLICK,onPrevPageClick);
			}
			else if(instance==nextPageButton)
			{
				nextPageButton.addEventListener(MouseEvent.CLICK,onNextPageClick);
			}
			else if(instance==firstPageButton)
			{
				firstPageButton.addEventListener(MouseEvent.CLICK,onFirstPageClick);
			}
			else if(instance==lastPageButton)
			{
				lastPageButton.addEventListener(MouseEvent.CLICK,onLastPageClick);
			}
			else if(instance==labelDisplay)
			{
				labelDisplay.text = pageToLabel(currentPage,_totalPages);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance==prevPageButton)
			{
				prevPageButton.removeEventListener(MouseEvent.CLICK,onPrevPageClick);
			}
			else if(instance==nextPageButton)
			{
				nextPageButton.removeEventListener(MouseEvent.CLICK,onNextPageClick);
			}
			else if(instance==firstPageButton)
			{
				firstPageButton.removeEventListener(MouseEvent.CLICK,onFirstPageClick);
			}
			else if(instance==lastPageButton)
			{
				lastPageButton.removeEventListener(MouseEvent.CLICK,onLastPageClick);
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
			gotoPage(Math.min(_totalPages-1,currentPage+1));
		}
		/**
		 * "上一页"按钮被点击
		 */		
		protected function onPrevPageClick(event:MouseEvent):void
		{
			if(!_viewport)
				return;
			gotoPage(currentPage-1);
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
				gotoPage(currentPage-1);
			else
				gotoPage(Math.min(_totalPages-1,currentPage+1));
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
			throw new Error("此方法在PageNavigator组件内不可用!");
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