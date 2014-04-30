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
	 * 垂直滚动条组件
	 * @author DOM
	 */	
	public class VScrollBar extends ScrollBarBase
	{
		/**
		 * 构造函数
		 */		
		public function VScrollBar()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return VScrollBar;
		}
		
		/**
		 * 更新最大值和分页大小
		 */
		private function updateMaximumAndPageSize():void
		{
			var vsp:Number = viewport.verticalScrollPosition;
			var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
			var cHeight:Number = viewport.contentHeight;
			maximum = (cHeight == 0) ? vsp : cHeight - viewportHeight;
			pageSize = viewportHeight;
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
				removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
			
			super.viewport = newViewport;
			
			if (newViewport)
			{
				updateMaximumAndPageSize()
				value = newViewport.verticalScrollPosition;;
				newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);  
			}
		}   
		
		/**
		 * @inheritDoc
		 */
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if (!thumb || !track)
				return 0;
			
			var r:Number = track.layoutBoundsHeight - thumb.layoutBoundsHeight;
			return minimum + ((r != 0) ? (y / r) * (maximum - minimum) : 0); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateSkinDisplayList():void
		{
			if (!thumb || !track)
				return;
			
			var trackSize:Number = track.layoutBoundsHeight;
			var range:Number = maximum - minimum;
			
			var thumbPos:Point;
			var thumbPosTrackY:Number = 0;
			var thumbPosParentY:Number = 0;
			var thumbSize:Number = trackSize;
			if (range > 0)
			{
				if (fixedThumbSize === false)
				{
					thumbSize = Math.min((pageSize / (range + pageSize)) * trackSize, trackSize)
					thumbSize = Math.max(thumb.minHeight, thumbSize);
				}
				else
				{
					thumbSize = thumb ? thumb.height : 0;
				}
				thumbPosTrackY = (value - minimum) * ((trackSize - thumbSize) / range);
			}
			
			if (fixedThumbSize === false)
				thumb.height = Math.ceil(thumbSize);
			if (autoThumbVisibility === true)
				thumb.visible = thumbSize < trackSize;
			thumbPos = track.localToGlobal(new Point(0, thumbPosTrackY));
			thumbPosParentY = thumb.parent.globalToLocal(thumbPos).y;
			
			thumb.setLayoutBoundsPosition(thumb.layoutBoundsX, Math.round(thumbPosParentY));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			if (viewport)
				viewport.verticalScrollPosition = value;
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
				pageSize = Math.abs(viewport.getVerticalScrollPositionDelta(
					(increase) ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
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
				var vpPageSize:Number = Math.abs(viewport.getVerticalScrollPositionDelta(
					(newValue > value) ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
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
				stepSize = Math.abs(viewport.getVerticalScrollPositionDelta(
					(increase) ? NavigationUnit.DOWN : NavigationUnit.UP));
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
				thumb.top = undefined;
				thumb.bottom = undefined;
				thumb.verticalCenter = undefined;
			}      
			super.partAdded(partName, instance);
		}     
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function viewportVerticalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
			if (viewport)
				value = viewport.verticalScrollPosition;
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
		override dx_internal function viewportContentHeightChangeHandler(event:PropertyChangeEvent):void
		{
			if (viewport)
			{
				var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
				maximum = viewport.contentHeight - viewport.height;
			}
		}
		
		/**
		 * 根据event.delta滚动指定步数的距离。
		 */	
		dx_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible||!visible)
				return;
			
			var nSteps:uint = useMouseWheelDelta?Math.abs(event.delta):1;
			var navigationUnit:uint;
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
		
	}
}
