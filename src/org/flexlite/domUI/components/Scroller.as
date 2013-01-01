package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.supportClasses.ScrollerLayout;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	
	[DXML(show="true")]
	
	[DefaultProperty(name="viewport",array="false")]
	
	/**
	 * 滚动条组件
	 * @author DOM
	 */	
	public class Scroller extends SkinnableComponent implements IVisualElementContainer
	{
		/**
		 * 构造函数
		 */		
		public function Scroller()
		{
			super();
			focusEnabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Scroller;
		}
		
		private var _verticalScrollPolicy:String = "auto";

		/**
		 * 垂直滚动条显示策略，参见ScrollPolicy类定义的常量。
		 */		
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}

		public function set verticalScrollPolicy(value:String):void
		{
			if(_verticalScrollPolicy  == value)
				return;
			_verticalScrollPolicy = value;
			invalidateSkin();
		}

		private var _horizontalScrollPolicy:String = "auto";

		/**
		 * 水平滚动条显示策略，参见ScrollPolicy类定义的常量。
		 */		
		public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}

		public function set horizontalScrollPolicy(value:String):void
		{
			if(_horizontalScrollPolicy == value)
				return;
			_horizontalScrollPolicy = value;
			invalidateSkin();
		}

		/**
		 * 标记皮肤需要更新尺寸和布局
		 */		
		private function invalidateSkin():void
		{
			if (skin is IInvalidating)
			{
				(skin as IInvalidating).invalidateSize();
				(skin as IInvalidating).invalidateDisplayList();
			}
		}    
		
		/**
		 * [SkinPart]水平滚动条
		 */		
		public var horizontalScrollBar:HScrollBar;

		/**
		 * [SkinPart]垂直滚动条
		 */		
		public var verticalScrollBar:VScrollBar;
		
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
			if (skin && viewport)
			{
				viewport.clipAndEnableScrolling = true;
				(skin as ISkin).addElementAt(viewport, 0);
				viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
			}
			if (verticalScrollBar)
				verticalScrollBar.viewport = viewport;
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = viewport;
		}
		
		/**
		 * 卸载视域组件
		 */		
		private function uninstallViewport():void
		{
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = null;
			if (verticalScrollBar)
				verticalScrollBar.viewport = null;        
			if (skin && viewport)
			{
				viewport.clipAndEnableScrolling = false;
				(skin as ISkin).removeElement(viewport);
				viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
			}
		}
		
		
		private var _minViewportInset:Number = 0;
		
		/**
		 * Scroller四个边与视域组件的最小间隔距离。
		 * 如果滚动条都不可见，则四个边的间隔为此属性的值。
		 * 如果滚动条可见，则取滚动条的宽度和此属性的值的较大值。
		 */		
		public function get minViewportInset():Number
		{
			return _minViewportInset;
		}
		
		public function set minViewportInset(value:Number):void
		{
			if (value == _minViewportInset)
				return;
			
			_minViewportInset = value;
			invalidateSkin();
		}
		
		private var _measuredSizeIncludesScrollBars:Boolean = true;
		/**
		 * 如果为 true，Scroller的测量大小会加上滚动条所占的空间，否则 Scroller的测量大小仅取决于其视域组件的尺寸。
		 */		
		public function get measuredSizeIncludesScrollBars():Boolean
		{
			return _measuredSizeIncludesScrollBars;
		}
		
		public function set measuredSizeIncludesScrollBars(value:Boolean):void
		{
			if (value == _measuredSizeIncludesScrollBars)
				return;
			
			_measuredSizeIncludesScrollBars = value;
			invalidateSkin();
		}   
		
		/**
		 * 视域组件的属性改变
		 */		
		private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch(event.property) 
			{
				case "contentWidth": 
				case "contentHeight": 
					invalidateSkin();
					break;
			}
		}
		
		public function get numElements():int
		{
			return viewport ? 1 : 0;
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
			if (viewport && index == 0)
				return viewport;
			else
				throwRangeError(index);
			return null;
		}
		
		
		public function getElementIndex(element:IVisualElement):int
		{
			if (element != null && element == viewport)
				return 0;
			else
				return -1;
		}
		
		public function containsElement(element:IVisualElement):Boolean
		{
			if (element != null && element == viewport)
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

		/**
		 * @inheritDoc
		 */
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			(skin as ISkin).layout = new ScrollerLayout();
			installViewport();
			(skin as ISkin).addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function detachSkin(skin:Object):void
		{    
			uninstallViewport();
			(skin as ISkin).layout = null;
			(skin as ISkin).removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
			super.detachSkin(skin);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == verticalScrollBar)
				verticalScrollBar.viewport = viewport;
				
			else if (instance == horizontalScrollBar)
				horizontalScrollBar.viewport = viewport;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == verticalScrollBar)
				verticalScrollBar.viewport = null;
				
			else if (instance == horizontalScrollBar)
				horizontalScrollBar.viewport = null;
		}
		
		
		/**
		 * 皮肤上鼠标滚轮事件
		 */		
		private function skin_mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible)
				return;
			
			var nSteps:uint = Math.abs(event.delta);
			var navigationUnit:uint;
			if (verticalScrollBar && verticalScrollBar.visible)
			{
				navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
				for (var vStep:int = 0; vStep < nSteps; vStep++)
				{
					var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
					if (!isNaN(vspDelta))
					{
						vp.verticalScrollPosition += vspDelta;
						if (vp is IInvalidating)
							IInvalidating(vp).validateNow();
					}
				}
				event.preventDefault();
			}
			else if (horizontalScrollBar && horizontalScrollBar.visible)
			{
				navigationUnit = (event.delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
				for (var hStep:int = 0; hStep < nSteps; hStep++)
				{
					var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
					if (!isNaN(hspDelta))
					{
						vp.horizontalScrollPosition += hspDelta;
						if (vp is IInvalidating)
							IInvalidating(vp).validateNow();
					}
				}
				event.preventDefault();
			}            
		}
		
	}
	
}
