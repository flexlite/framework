package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.flexlite.domUI.components.supportClasses.Range;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.ResizeEvent;
	
	[DXML(show="true")]
	
	/**
	 * 进度条控件。注意：此控件默认禁用鼠标事件。
	 * @author chenglong
	 */
	public class ProgressBar extends Range
	{
		public function ProgressBar()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ProgressBar;
		}
		
		/**
		 * [SkinPart]进度高亮显示对象。
		 */		
		public var thumb:DisplayObject;
		/**
		 * [SkinPart]轨道显示对象，用于确定thumb要覆盖的区域。
		 */		
		public var track:DisplayObject;
		/**
		 * [SkinPart]进度条文本
		 */
		public var labelDisplay:Label;
		
		private var _labelFunction:Function;
		/**
		 * 进度条文本格式化回调函数。示例：labelFunction(value:Number,maximum:Number):String;
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		public function set labelFunction(value:Function):void
		{
			if(_labelFunction == value)
				return;
			_labelFunction = value;
			invalidateDisplayList();
		}

		/**
		 * 将当前value转换成文本
		 */		
		protected function valueToLabel(value:Number,maximum:Number):String
		{
			if(labelFunction!=null)
			{
				return labelFunction(value,maximum);
			}
			return value+" / "+maximum;
		}
		
		private var _slideDuration:Number = 500;
		
		/**
		 * value改变时调整thumb长度的缓动动画时间，单位毫秒。设置为0则不执行缓动。默认值500。
		 */		
		public function get slideDuration():Number
		{
			return _slideDuration;
		}
		
		public function set slideDuration(value:Number):void
		{
			_slideDuration = value;
		}
		
		private static var sineEaser:IEaser = new Sine(0);
		/**
		 * 动画实例
		 */	
		private var animator:Animation = null;
		/**
		 * 动画播放结束时要到达的value。
		 */		
		private var slideToValue:Number;
		/**
		 * @param org.flexlite.domUI.components.supportClasses.Range#value
		 */		
		override public function set value(newValue:Number):void
		{
			if(super.value == newValue)
				return;
			if (_slideDuration == 0||!stage)
			{
				super.value = newValue;
			}
			else
			{
				if (!animator)
				{
					animator = new Animation(animationUpdateHandler);
					animator.endFunction = animationEndHandler;
					
					animator.easer = sineEaser;
				}
				if (animator.isPlaying)
					animator.stop();
				slideToValue = nearestValidValue(newValue, snapInterval);
				animator.duration = _slideDuration * 
					(Math.abs(super.value - slideToValue) / (maximum - minimum));
				animator.motionPaths = new <MotionPath>[
					new MotionPath("value", super.value, slideToValue)];
				animator.play();
			}
		}
		
		/**
		 * 动画播放更新数值
		 */	
		private function animationUpdateHandler(animation:Animation):void
		{
			setValue(nearestValidValue(animation.currentValue["value"], snapInterval));
		}
		
		/**
		 * 动画播放完毕
		 */	
		private function animationEndHandler(animation:Animation):void
		{
			setValue(slideToValue);
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
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			updateSkinDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance==track)
			{
				if(track is UIComponent)
				{
					track.addEventListener(ResizeEvent.RESIZE,onTrackResize);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance==track)
			{
				if(track is UIComponent)
				{
					track.removeEventListener(ResizeEvent.RESIZE,onTrackResize);
				}
			}
		}
		
		private function onTrackResize(event:ResizeEvent):void
		{
			updateSkinDisplayList();
		}
		/**
		 * 更新皮肤部件大小和可见性。
		 */		
		protected function updateSkinDisplayList():void
		{
			var currentValue:Number = isNaN(value)?0:value;
			var maxValue:Number = isNaN(maximum)?0:maximum;
			if(thumb&&track)
			{
				var w:Number = isNaN(track.width)?0:track.width;
				
				var thumbWidth:Number = (value/maximum)*w;
				if(thumbWidth<0)
					thumbWidth = 0;
				thumb.width = Math.round(isNaN(thumbWidth)?0:thumbWidth);
				thumb.x = globalToLocal(track.localToGlobal(new Point)).x;
			}
			if(labelDisplay)
			{
				labelDisplay.text = valueToLabel(currentValue,maxValue);
			}
		}
	}
}