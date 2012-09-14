<<<<<<< HEAD
package org.flexlite.domUI.components.supportClasses
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.TrackBaseEvent;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	use namespace dx_internal;
	
	/**
	 * 滑块控件基类
	 * @author DOM
	 */
	public class SliderBase extends TrackBase
	{
		/**
		 * 构造函数
		 */	
		public function SliderBase():void
		{
			super();
			maximum = 10;
		}
		/**
		 * 动画实例
		 */	
		private var animator:Animation = null;
		
		private var slideToValue:Number;
		
		/**
		 * 鼠标在thumb上按下时的坐标
		 */	
		private var clickOffset:Point;  
		/**
		 * 记录最近一次鼠标移动事件相对于track的坐标。
		 */	
		private var mostRecentMousePoint:Point;
		/**
		 * 拖拽时用于强制刷新显示列表的计时器。
		 */	
		private var dragTimer:Timer = null;
		
		private var dragPending:Boolean = false;
		
		private static const MAX_DRAG_RATE:Number = 30;
		
		override public function get maximum():Number
		{
			return super.maximum;
		}
		
		private var _pendingValue:Number = 0;
		/**
		 * 释放鼠标按键时滑块将具有的值。无论liveDragging是否为true，在滑块拖动期间始终更新此属性。
		 * 而value属性在当liveDragging为false时，只在鼠标释放时更新一次。
		 */
		protected function get pendingValue():Number
		{
			return _pendingValue;
		}
		protected function set pendingValue(value:Number):void
		{
			if (value == _pendingValue)
				return;
			_pendingValue = value;
			invalidateDisplayList();
		}
		
		override protected function setValue(value:Number):void
		{
			_pendingValue = value;
			
			super.setValue(value);
		}
		/**
		 * 动画播放更新数值
		 */	
		private function animationUpdateHandler(animation:Animation):void
		{
			pendingValue = animation.currentValue["value"];
		}
		/**
		 * 动画播放完毕
		 */	
		private function animationEndHandler(animation:Animation):void
		{
			setValue(slideToValue);
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		/**
		 * 停止播放动画
		 */	
		private function stopAnimation():void
		{
			animator.stop();
			
			setValue(nearestValidValue(pendingValue, snapInterval));
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		
		override protected function thumb_mouseDownHandler(event:MouseEvent):void
		{
			
			if (animator && animator.isPlaying)
				stopAnimation();
			
			super.thumb_mouseDownHandler(event);
			clickOffset = thumb.globalToLocal(new Point(event.stageX, event.stageY));
		}
		
		private var _liveDragging:Boolean = true;
		/**
		 * 如果为 true，则将在沿着轨道拖动滑块时，而不是在释放滑块按钮时，提交此滑块的值。
		 */
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}
		
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}
		
		private function handleMousePoint(p:Point):void
		{
			var newValue:Number = pointToValue(p.x - clickOffset.x, p.y - clickOffset.y);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != pendingValue)
			{
				dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
				if (liveDragging == true)
				{
					setValue(newValue);
					dispatchEvent(new Event(Event.CHANGE));
				}
				else
				{
					pendingValue = newValue;
				}
			}
		}
		
		override protected function stage_mouseMoveHandler(event:MouseEvent):void
		{      
			if (!track)
				return;
			
			mostRecentMousePoint = track.globalToLocal(new Point(event.stageX, event.stageY));
			if (!dragTimer)
			{
				dragTimer = new Timer(1000/MAX_DRAG_RATE, 0);
				dragTimer.addEventListener(TimerEvent.TIMER, dragTimerHandler);
			}
			
			if (!dragTimer.running)
			{
				
				handleMousePoint(mostRecentMousePoint);
				event.updateAfterEvent();
				dragTimer.start();
				dragPending = false;
			}
			else
			{
				dragPending = true;
			}
		}
		/**
		 * 
		 */	
		private function dragTimerHandler(event:TimerEvent):void
		{
			if (dragPending)
			{
				
				handleMousePoint(mostRecentMousePoint);
				event.updateAfterEvent();
				dragPending = false;
			}
			else
			{
				dragTimer.stop();
			}
		}
		
		override protected function stage_mouseUpHandler(event:Event):void
		{
			if (dragTimer)
			{
				if (dragPending)
				{
					
					handleMousePoint(mostRecentMousePoint);
					if (event is MouseEvent)
						MouseEvent(event).updateAfterEvent();
				}
				
				dragTimer.stop();
				dragTimer.removeEventListener(TimerEvent.TIMER, dragTimerHandler);
				dragTimer = null;
			}
			
			if ((liveDragging == false) && (value != pendingValue))
			{
				setValue(pendingValue);
				dispatchEvent(new Event(Event.CHANGE));
			}
			super.stage_mouseUpHandler(event);
		}
		
		override protected function track_mouseDownHandler(event:MouseEvent):void
		{
			if (!enabled)
				return;
			var thumbW:Number = (thumb) ? thumb.width : 0;
			var thumbH:Number = (thumb) ? thumb.height : 0;
			var offsetX:Number = event.stageX - (thumbW / 2);
			var offsetY:Number = event.stageY - (thumbH / 2);
			var p:Point = track.globalToLocal(new Point(offsetX, offsetY));
			
			var newValue:Number = pointToValue(p.x, p.y);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != pendingValue)
			{
				if (slideDuration != 0)
				{
					if (!animator)
					{
						animator = new Animation(animationUpdateHandler);
						animator.endFunction = animationEndHandler;
						
						animator.easer = new Sine(0);
					}
					if (animator.isPlaying)
						stopAnimation();
					slideToValue = newValue;
					animator.duration = slideDuration * 
						(Math.abs(pendingValue - slideToValue) / (maximum - minimum));
					animator.motionPaths = new <MotionPath>[
						new MotionPath("value", pendingValue, slideToValue)];
					
					dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
					animator.play();
				}
				else
				{
					setValue(newValue);
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			
			event.updateAfterEvent();
		}
	}
	
}
=======
package org.flexlite.domUI.components.supportClasses
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.TrackBaseEvent;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	use namespace dx_internal;
	
	/**
	 * 滑块控件基类
	 * @author DOM
	 */
	public class SliderBase extends TrackBase
	{
		/**
		 * 构造函数
		 */	
		public function SliderBase():void
		{
			super();
			maximum = 10;
		}
		/**
		 * 动画实例
		 */	
		private var animator:Animation = null;
		
		private var slideToValue:Number;
		
		/**
		 * 鼠标在thumb上按下时的坐标
		 */	
		private var clickOffset:Point;  
		/**
		 * 记录最近一次鼠标移动事件相对于track的坐标。
		 */	
		private var mostRecentMousePoint:Point;
		/**
		 * 拖拽时用于强制刷新显示列表的计时器。
		 */	
		private var dragTimer:Timer = null;
		
		private var dragPending:Boolean = false;
		
		private static const MAX_DRAG_RATE:Number = 30;
		
		override public function get maximum():Number
		{
			return super.maximum;
		}
		
		private var _pendingValue:Number = 0;
		/**
		 * 释放鼠标按键时滑块将具有的值。无论liveDragging是否为true，在滑块拖动期间始终更新此属性。
		 * 而value属性在当liveDragging为false时，只在鼠标释放时更新一次。
		 */
		protected function get pendingValue():Number
		{
			return _pendingValue;
		}
		protected function set pendingValue(value:Number):void
		{
			if (value == _pendingValue)
				return;
			_pendingValue = value;
			invalidateDisplayList();
		}
		
		override protected function setValue(value:Number):void
		{
			_pendingValue = value;
			
			super.setValue(value);
		}
		/**
		 * 动画播放更新数值
		 */	
		private function animationUpdateHandler(animation:Animation):void
		{
			pendingValue = animation.currentValue["value"];
		}
		/**
		 * 动画播放完毕
		 */	
		private function animationEndHandler(animation:Animation):void
		{
			setValue(slideToValue);
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		/**
		 * 停止播放动画
		 */	
		private function stopAnimation():void
		{
			animator.stop();
			
			setValue(nearestValidValue(pendingValue, snapInterval));
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		
		override protected function thumb_mouseDownHandler(event:MouseEvent):void
		{
			
			if (animator && animator.isPlaying)
				stopAnimation();
			
			super.thumb_mouseDownHandler(event);
			clickOffset = thumb.globalToLocal(new Point(event.stageX, event.stageY));
		}
		
		private var _liveDragging:Boolean = true;
		/**
		 * 如果为 true，则将在沿着轨道拖动滑块时，而不是在释放滑块按钮时，提交此滑块的值。
		 */
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}
		
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}
		
		private function handleMousePoint(p:Point):void
		{
			var newValue:Number = pointToValue(p.x - clickOffset.x, p.y - clickOffset.y);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != pendingValue)
			{
				dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
				if (liveDragging == true)
				{
					setValue(newValue);
					dispatchEvent(new Event(Event.CHANGE));
				}
				else
				{
					pendingValue = newValue;
				}
			}
		}
		
		override protected function stage_mouseMoveHandler(event:MouseEvent):void
		{      
			if (!track)
				return;
			
			mostRecentMousePoint = track.globalToLocal(new Point(event.stageX, event.stageY));
			if (!dragTimer)
			{
				dragTimer = new Timer(1000/MAX_DRAG_RATE, 0);
				dragTimer.addEventListener(TimerEvent.TIMER, dragTimerHandler);
			}
			
			if (!dragTimer.running)
			{
				
				handleMousePoint(mostRecentMousePoint);
				event.updateAfterEvent();
				dragTimer.start();
				dragPending = false;
			}
			else
			{
				dragPending = true;
			}
		}
		/**
		 * 
		 */	
		private function dragTimerHandler(event:TimerEvent):void
		{
			if (dragPending)
			{
				
				handleMousePoint(mostRecentMousePoint);
				event.updateAfterEvent();
				dragPending = false;
			}
			else
			{
				dragTimer.stop();
			}
		}
		
		override protected function stage_mouseUpHandler(event:Event):void
		{
			if (dragTimer)
			{
				if (dragPending)
				{
					
					handleMousePoint(mostRecentMousePoint);
					if (event is MouseEvent)
						MouseEvent(event).updateAfterEvent();
				}
				
				dragTimer.stop();
				dragTimer.removeEventListener(TimerEvent.TIMER, dragTimerHandler);
				dragTimer = null;
			}
			
			if ((liveDragging == false) && (value != pendingValue))
			{
				setValue(pendingValue);
				dispatchEvent(new Event(Event.CHANGE));
			}
			super.stage_mouseUpHandler(event);
		}
		
		override protected function track_mouseDownHandler(event:MouseEvent):void
		{
			if (!enabled)
				return;
			var thumbW:Number = (thumb) ? thumb.width : 0;
			var thumbH:Number = (thumb) ? thumb.height : 0;
			var offsetX:Number = event.stageX - (thumbW / 2);
			var offsetY:Number = event.stageY - (thumbH / 2);
			var p:Point = track.globalToLocal(new Point(offsetX, offsetY));
			
			var newValue:Number = pointToValue(p.x, p.y);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != pendingValue)
			{
				if (slideDuration != 0)
				{
					if (!animator)
					{
						animator = new Animation(animationUpdateHandler);
						animator.endFunction = animationEndHandler;
						
						animator.easer = new Sine(0);
					}
					if (animator.isPlaying)
						stopAnimation();
					slideToValue = newValue;
					animator.duration = slideDuration * 
						(Math.abs(pendingValue - slideToValue) / (maximum - minimum));
					animator.motionPaths = new <MotionPath>[
						new MotionPath("value", pendingValue, slideToValue)];
					
					dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
					animator.play();
				}
				else
				{
					setValue(newValue);
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			
			event.updateAfterEvent();
		}
	}
	
}
>>>>>>> master
