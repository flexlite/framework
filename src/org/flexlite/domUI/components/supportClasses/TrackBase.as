package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.events.TrackBaseEvent;
	import org.flexlite.domUI.events.UIEvent;
	
	use namespace dx_internal;
	
	/**
	 * 当控件的值由于用户交互操作而发生更改时分派。 
	 */	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 改变结束
	 */	
	[Event(name="changeEnd", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 改变开始
	 */	
	[Event(name="changeStart", type="org.flexlite.domUI.events.UIEvent")]
	
	/**
	 * 按下滑块并使用鼠标移动滑块时分派。此事件始终发生在 thumbPress 事件之后。
	 */	
	[Event(name="thumbDrag", type="org.flexlite.domUI.events.TrackBaseEvent")]
	
	/**
	 * 按下滑块（即用户在滑块上按下鼠标按钮）时分派。
	 */	
	[Event(name="thumbPress", type="org.flexlite.domUI.events.TrackBaseEvent")]
	
	/**
	 * 放开滑块（即用户在滑块上弹起鼠标按钮）时分派。
	 */	
	[Event(name="thumbRelease", type="org.flexlite.domUI.events.TrackBaseEvent")]
	
	[DXML(show="false")]
	
	/**
	 * TrackBase类是具有一个轨道和一个或多个滑块按钮的组件的一个基类，如 Slider 和 ScrollBar。
	 * @author DOM
	 */	
	public class TrackBase extends Range
	{
		public function TrackBase():void
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private var _slideDuration:Number = 300;

		/**
		 * 在轨道上单击以移动滑块时，滑动动画持续的时间（以毫秒为单位）。<br/>
		 * 此属性用于 Slider 和 ScrollBar。对于 Slider，在轨道上的任何单击将导致生成使用此样式的一个动画，同时滑块将移到单击的位置。<br/>
		 * 对于 ScrollBar，仅当按住 Shift 键并单击轨道时才使用此样式，这会导致滑块移到单击的位置。<br/>
		 * 未按下 Shift 键时单击 ScrollBar 轨道将导致出现分页行为。<br/>
		 * 按住 Shift 键并单击时，必须也对 ScrollBar 设置 smoothScrolling 属性才可以实现动画行为。<br/>
		 * 此持续时间是整个滑过轨道的总时间，实际滚动会根据距离相应缩短。
		 */		
		public function get slideDuration():Number
		{
			return _slideDuration;
		}

		public function set slideDuration(value:Number):void
		{
			_slideDuration = value;
		}

		
		/**
		 * [SkinPart]实体滑块组件
		 */		
		public var thumb:Button;
		
		/**
		 * [SkinPart]实体轨道组件
		 */
		public var track:Button; 
		
		/**
		 * @inheritDoc
		 */
		override public function set maximum(value:Number):void
		{
			if (value == super.maximum)
				return;
			
			super.maximum = value;
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set minimum(value:Number):void
		{
			if (value == super.minimum)
				return;
			
			super.minimum = value;
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set value(newValue:Number):void
		{
			if (newValue == super.value)
				return;
			
			super.value = newValue;
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			invalidateDisplayList();
		}
		
		/**
		 * 将相对于轨道的 x,y 像素位置转换为介于最小值和最大值（包括两者）之间的一个值。 
		 * @param x 相对于轨道原点的位置的x坐标。
		 * @param y 相对于轨道原点的位置的y坐标。
		 */		
		protected function pointToValue(x:Number, y:Number):Number
		{
			return minimum;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			var prevValue:Number = this.value;
			
			super.changeValueByStep(increase);
			
			if (value != prevValue)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == thumb)
			{
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
				thumb.addEventListener(ResizeEvent.RESIZE, thumb_resizeHandler);
				thumb.addEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);
				thumb.stickyHighlighting = true;
			}
			else if (instance == track)
			{
				track.addEventListener(MouseEvent.MOUSE_DOWN, track_mouseDownHandler);
				track.addEventListener(ResizeEvent.RESIZE, track_resizeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == thumb)
			{
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
				thumb.removeEventListener(ResizeEvent.RESIZE, thumb_resizeHandler);            
				thumb.removeEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);            
			}
			else if (instance == track)
			{
				track.removeEventListener(MouseEvent.MOUSE_DOWN, track_mouseDownHandler);
				track.removeEventListener(ResizeEvent.RESIZE, track_resizeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			updateSkinDisplayList();
		}
		
		/**
		 * 记录鼠标在thumb上按下的位置
		 */		
		dx_internal var clickOffset:Point;
		
		/**
		 * 更新皮肤部件（通常为滑块）的大小和可见性。<br/>
		 * 子类覆盖此方法以基于 minimum、maximum 和 value 属性更新滑块的大小、位置和可见性。 
		 */		
		protected function updateSkinDisplayList():void 
		{
		}
		
		/**
		 * 添加到舞台时
		 */		
		private function addedToStageHandler(event:Event):void
		{
			updateSkinDisplayList();
		}
		
		/**
		 * 轨道尺寸改变事件
		 */		
		private function track_resizeHandler(event:Event):void
		{
			updateSkinDisplayList();
		}
		
		/**
		 * 滑块尺寸改变事件
		 */		
		private function thumb_resizeHandler(event:Event):void
		{
			updateSkinDisplayList();
		}
		
		/**
		 * 滑块三个阶段的延迟布局更新完毕事件
		 */		
		private function thumb_updateCompleteHandler(event:Event):void
		{
			updateSkinDisplayList();
			thumb.removeEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);
		}
		
		
		/**
		 * 滑块按下事件
		 */		
		protected function thumb_mouseDownHandler(event:MouseEvent):void
		{        
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, 
				stage_mouseMoveHandler, false,0,true);
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, 
				stage_mouseUpHandler, false,0,true);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,
				stage_mouseUpHandler, false,0,true);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			clickOffset = thumb.globalToLocal(new Point(event.stageX, event.stageY));
			
			dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_PRESS));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
		}
		
		/**
		 * 当鼠标拖动thumb时，需要更新value的标记。
		 */		
		private var needUpdateValue:Boolean = false;
		/**
		 * 拖动thumb过程中触发的EnterFrame事件
		 */		
		private function onEnterFrame(event:Event):void
		{
			if(!needUpdateValue||!track)
				return;
			updateWhenMouseMove();
			needUpdateValue = false;
		}
		
		/**
		 * 当thumb被拖动时更新值，此方法每帧只被调用一次，比直接在鼠标移动事件里更新性能更高。
		 */		
		protected function updateWhenMouseMove():void
		{
			if(!track)
				return;
			var p:Point = track.globalToLocal(new Point(DomGlobals.stage.mouseX, DomGlobals.stage.mouseY));
			var newValue:Number = pointToValue(p.x - clickOffset.x, p.y - clickOffset.y);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != value)
			{
				setValue(newValue); 
				validateDisplayList();
				dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 鼠标移动事件
		 */		
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if (needUpdateValue)
				return;
			needUpdateValue = true;
		}
		
		/**
		 * 鼠标弹起事件
		 */		
		protected function stage_mouseUpHandler(event:Event):void
		{
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, 
				stage_mouseMoveHandler);
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, 
				stage_mouseUpHandler);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,
				stage_mouseUpHandler);
			removeEventListener(Event.ENTER_FRAME,updateWhenMouseMove);
			if(needUpdateValue)
			{
				updateWhenMouseMove();
				needUpdateValue = false;
			}
			dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_RELEASE));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		
		/**
		 * 轨道被按下事件
		 */		
		protected function track_mouseDownHandler(event:MouseEvent):void 
		{ 
		}
		
		private var mouseDownTarget:DisplayObject;
		
		/**
		 * 当在组件上按下鼠标时记录被按下的子显示对象
		 */		
		private function mouseDownHandler(event:MouseEvent):void
		{
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, 
				system_mouseUpSomewhereHandler, false,0,true);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE, 
				system_mouseUpSomewhereHandler, false,0,true);
			
			mouseDownTarget = DisplayObject(event.target);      
		}
		
		/**
		 * 当鼠标弹起时，若不是在mouseDownTarget上弹起，而是另外的子显示对象上弹起时，额外抛出一个鼠标单击事件。
		 */		
		private function system_mouseUpSomewhereHandler(event:Event):void
		{
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, 
				system_mouseUpSomewhereHandler);
			DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE,
				system_mouseUpSomewhereHandler);
			if (mouseDownTarget != event.target && event is MouseEvent && contains(DisplayObject(event.target)))
			{ 
				var mEvent:MouseEvent = event as MouseEvent;
				
				var mousePoint:Point = new Point(mEvent.localX, mEvent.localY);
				mousePoint = globalToLocal(DisplayObject(event.target).localToGlobal(mousePoint));
				
				dispatchEvent(new MouseEvent(MouseEvent.CLICK, mEvent.bubbles, mEvent.cancelable, mousePoint.x,
					mousePoint.y, mEvent.relatedObject, mEvent.ctrlKey, mEvent.altKey,
					mEvent.shiftKey, mEvent.buttonDown, mEvent.delta));
			}
			
			mouseDownTarget = null;
		}
	}
	
}
