package org.flexlite.domUI.components.supportClasses
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.TrackBaseEvent;
	import org.flexlite.domUI.events.UIEvent;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
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
		
		override protected function updateWhenMouseMove():void
		{      
			if(!track)
				return;
			
			var pos:Point = track.globalToLocal(new Point(DomGlobals.stage.mouseX, DomGlobals.stage.mouseY));
			var newValue:Number = pointToValue(pos.x - clickOffset.x,pos.y - clickOffset.y);
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
		
		override protected function stage_mouseUpHandler(event:Event):void
		{
			super.stage_mouseUpHandler(event);
			if ((liveDragging == false) && (value != pendingValue))
			{
				setValue(pendingValue);
				dispatchEvent(new Event(Event.CHANGE));
			}
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
			
		}
	}
	
}
