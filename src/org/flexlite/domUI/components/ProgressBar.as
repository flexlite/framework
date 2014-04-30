package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.flexlite.domUI.components.supportClasses.Range;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.MoveEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	
	[DXML(show="true")]
	
	/**
	 * 进度条控件。
	 * @author chenglong
	 */
	public class ProgressBar extends Range
	{
		public function ProgressBar()
		{
			super();
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
			if(_slideDuration==value)
				return;
			_slideDuration = value;
			if(animator&&animator.isPlaying)
			{
				animator.stop();
				super.value = slideToValue;
			}
		}
		
		private var _direction:String = ProgressBarDirection.LEFT_TO_RIGHT;
		/**
		 * 进度条增长方向。请使用ProgressBarDirection定义的常量。默认值：ProgressBarDirection.LEFT_TO_RIGHT。
		 */
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			if(_direction==value)
				return;
			_direction = value;
			invalidateDisplayList();
		}

		/**
		 * 动画实例
		 */	
		private var animator:Animation = null;
		/**
		 * 动画播放结束时要到达的value。
		 */		
		private var slideToValue:Number;
		
		/**
		 * 进度条的当前值。
		 * 注意：当组件添加到显示列表后，若slideDuration不为0。设置此属性，并不会立即应用。而是作为目标值，开启缓动动画缓慢接近。
		 * 若需要立即重置属性，请先设置slideDuration为0，或者把组件从显示列表移除。
		 */
		override public function get value():Number
		{
			return super.value;
		}
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
				validateProperties();//最大值最小值发生改变时要立即应用，防止当前起始值不正确。
				slideToValue = nearestValidValue(newValue, snapInterval);
				if(slideToValue==super.value)
					return;
				if (!animator)
				{
					animator = new Animation(animationUpdateHandler);
					animator.easer = null;
				}
				if (animator.isPlaying)
				{
					setValue(nearestValidValue(animator.motionPaths[0].valueTo, snapInterval));
					animator.stop();
				}
				var duration:Number = _slideDuration * 
					(Math.abs(super.value - slideToValue) / (maximum - minimum));
				animator.duration = duration===Infinity?0:duration;
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
					track.addEventListener(ResizeEvent.RESIZE,onTrackResizeOrMove);
					track.addEventListener(MoveEvent.MOVE,onTrackResizeOrMove);
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
					track.removeEventListener(ResizeEvent.RESIZE,onTrackResizeOrMove);
					track.removeEventListener(MoveEvent.MOVE,onTrackResizeOrMove);
				}
			}
		}
		
		private var trackResizedOrMoved:Boolean = false;
		/**
		 * track的位置或尺寸发生改变
		 */		
		private function onTrackResizeOrMove(event:Event):void
		{
			trackResizedOrMoved = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(trackResizedOrMoved)
			{
				trackResizedOrMoved = false;
				updateSkinDisplayList();
			}
		}
		/**
		 * 更新皮肤部件大小和可见性。
		 */		
		protected function updateSkinDisplayList():void
		{
			trackResizedOrMoved = false;
			var currentValue:Number = isNaN(value)?0:value;
			var maxValue:Number = isNaN(maximum)?0:maximum;
			if(thumb&&track)
			{
				var trackWidth:Number = isNaN(track.width)?0:track.width;
				trackWidth *= track.scaleX;
				var trackHeight:Number = isNaN(track.height)?0:track.height;
				trackHeight *= track.scaleY;
				var thumbWidth:Number = Math.round((currentValue/maxValue)*trackWidth);
				if(isNaN(thumbWidth)||thumbWidth<0||thumbWidth===Infinity)
					thumbWidth = 0;
				var thumbHeight:Number = Math.round((currentValue/maxValue)*trackHeight);
				if(isNaN(thumbHeight)||thumbHeight<0||thumbHeight===Infinity)
					thumbHeight = 0;
				var thumbPos:Point = globalToLocal(track.localToGlobal(new Point));
				switch(_direction)
				{
					case ProgressBarDirection.LEFT_TO_RIGHT:
						thumb.width = thumbWidth;
						thumb.x = thumbPos.x;
						break;
					case ProgressBarDirection.RIGHT_TO_LEFT:
						thumb.width = thumbWidth;
						thumb.x = thumbPos.x+trackWidth-thumbWidth;
						break;
					case ProgressBarDirection.TOP_TO_BOTTOM:
						thumb.height = thumbHeight;
						thumb.y = thumbPos.y;
						break;
					case ProgressBarDirection.BOTTOM_TO_TOP:
						thumb.height = thumbHeight;
						thumb.y = thumbPos.y+trackHeight-thumbHeight;
						break;
				}
				
			}
			if(labelDisplay)
			{
				labelDisplay.text = valueToLabel(currentValue,maxValue);
			}
		}
	}
}