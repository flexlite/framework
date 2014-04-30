package org.flexlite.domUI.components
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexlite.domUI.components.supportClasses.ScrollBarBase;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 水平滚动条组件
	 * @author DOM
	 */	
	public class HScrollBar extends ScrollBarBase
	{
		/**
		 * 构造函数
		 */		
		public function HScrollBar()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return HScrollBar;
		}
		
		/**
		 * 更新最大值和分页大小
		 */		
		private function updateMaximumAndPageSize():void
		{
			var hsp:Number = viewport.horizontalScrollPosition;
			var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
			var cWidth:Number = viewport.contentWidth;
			maximum = (cWidth == 0) ? hsp : cWidth - viewportWidth;
			pageSize = viewportWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set viewport(newViewport:IViewport):void
		{
			
			const oldViewport:IViewport = super.viewport;
			if (oldViewport == newViewport)
				return;
			
			if (oldViewport)
			{
				oldViewport.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				removeEventListener(MouseEvent.MOUSE_WHEEL, hsb_mouseWheelHandler, true);
			}
			
			super.viewport = newViewport;
			
			if (newViewport)
			{
				updateMaximumAndPageSize()
				value = newViewport.horizontalScrollPosition;
				newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, -50);
				addEventListener(MouseEvent.MOUSE_WHEEL, hsb_mouseWheelHandler, true); 
			}
		}    
		
		/**
		 * @inheritDoc
		 */
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if (!thumb || !track)
				return 0;
			
			var r:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			return minimum + ((r != 0) ? (x / r) * (maximum - minimum) : 0); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateSkinDisplayList():void
		{
			if (!thumb || !track)
				return;
			
			var trackSize:Number = track.layoutBoundsWidth;
			var range:Number = maximum - minimum;
			
			var thumbPos:Point;
			var thumbPosTrackX:Number = 0;
			var thumbPosParentX:Number = 0;
			var thumbSize:Number = trackSize;
			if (range > 0)
			{
				if (fixedThumbSize === false)
				{
					thumbSize = Math.min((pageSize / (range + pageSize)) * trackSize, trackSize)
					thumbSize = Math.max(thumb.minWidth, thumbSize);
				}
				else
				{
					thumbSize = thumb ? thumb.width : 0;
				}
				thumbPosTrackX = (value - minimum) * ((trackSize - thumbSize) / range);
			}
			
			if (fixedThumbSize === false)
				thumb.width = Math.ceil(thumbSize);
			if (autoThumbVisibility === true)
				thumb.visible = thumbSize < trackSize;
			thumbPos = track.localToGlobal(new Point(thumbPosTrackX, 0));
			thumbPosParentX = thumb.parent.globalToLocal(thumbPos).x;
			
			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.layoutBoundsY);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			if (viewport)
				viewport.horizontalScrollPosition = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByPage(increase:Boolean = true):void
		{
			var oldPageSize:Number;
			if (viewport)
			{
				oldPageSize = pageSize;
				pageSize = Math.abs(viewport.getHorizontalScrollPositionDelta(
					(increase) ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
			}
			super.changeValueByPage(increase);
			if (viewport)
				pageSize = oldPageSize;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function animatePaging(newValue:Number, pageSize:Number):void
		{
			if (viewport)
			{
				var vpPageSize:Number = Math.abs(viewport.getHorizontalScrollPositionDelta(
					(newValue > value) ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
				super.animatePaging(newValue, vpPageSize);
				return;
			}        
			super.animatePaging(newValue, pageSize);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			var oldStepSize:Number;
			if (viewport)
			{
				oldStepSize = stepSize;
				stepSize = Math.abs(viewport.getHorizontalScrollPositionDelta(
					(increase) ? NavigationUnit.RIGHT : NavigationUnit.LEFT));
			}
			super.changeValueByStep(increase);
			if (viewport)
				stepSize = oldStepSize;
		}   
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == thumb)
			{
				thumb.left = undefined;
				thumb.right = undefined;
				thumb.horizontalCenter = undefined;
			}      
			
			super.partAdded(partName, instance);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function viewportHorizontalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
			if (viewport)
				value = viewport.horizontalScrollPosition;
		} 
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function viewportResizeHandler(event:ResizeEvent):void
		{
			if (viewport)
				updateMaximumAndPageSize();
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function viewportContentWidthChangeHandler(event:PropertyChangeEvent):void
		{
			if (viewport)
			{
				var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;        
				maximum = viewport.contentWidth - viewportWidth;
			}
		}
		
		/**
		 * 根据event.delta滚动指定步数的距离。这个事件处理函数优先级比垂直滚动条的低。
		 */		
		dx_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible||!visible)
				return;
			
			var nSteps:uint = useMouseWheelDelta?Math.abs(event.delta):1;
			var navigationUnit:uint;
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
		
		private function hsb_mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible)
				return;
			
			event.stopImmediatePropagation();            
			vp.dispatchEvent(event);        
		}
	}
}
