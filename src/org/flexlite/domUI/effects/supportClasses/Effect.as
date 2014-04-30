package org.flexlite.domUI.effects.supportClasses
{
	import flash.events.EventDispatcher;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IEffect;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.events.EffectEvent;
	
	use namespace dx_internal;
	
	/**
	 * 在动画完成播放时（既可以是正常完成播放时，也可以是通过调用end()或stop()方法提前结束播放时）分派。
	 */	
	[Event(name="effectEnd", type="org.flexlite.domUI.events.EffectEvent")]
	/**
	 * 在动画被停止播放时分派，即当该动画的stop()方法被调用时。还将分派 EFFECT_END事件以指示已结束该动画。将首先发送此EFFECT_STOP事件，作为对动画未正常播放完的指示。
	 */	
	[Event(name="effectStop", type="org.flexlite.domUI.events.EffectEvent")]
	/**
	 * 当动画开始播放时分派。
	 */	
	[Event(name="effectStart", type="org.flexlite.domUI.events.EffectEvent")]
	/**
	 * 对于任何重复次数超过一次的动画，当动画开始新的一次重复时分派。
	 */	
	[Event(name="effectRepeat", type="org.flexlite.domUI.events.EffectEvent")]
	
	
	/**
	 * 动画特效基类
	 * @author DOM
	 */
	public class Effect extends EventDispatcher implements IEffect
	{
		/**
		 * 构造函数
		 * @param target 要应用此动画特效的对象
		 */
		public function Effect(target:Object=null)
		{
			super();
			animator = new Animation(animationUpdateHandler);
			animator.startFunction = animationStartHandler
			animator.endFunction = animationEndHandler;
			animator.repeatFunction = animationRepeatHandler;
			animator.stopFunction = animationStopHandler;
			if(target)
			{
				this.target = target;
			}
		}
		
		/**
		 * 要应用此动画特效的对象。若要将特效同时应用到多个对象，请使用targets属性。
		 */		
		public function get target():Object
		{
			if (_targets.length > 0)
				return _targets[0]; 
			else
				return null;
		}
		/**
		 * @inheritDoc
		 */
		public function set target(value:Object):void
		{
			_targets.splice(0);
			
			if (value)
				_targets[0] = value;
		}
		
		dx_internal var _targets:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get targets():Array
		{
			return _targets;
		}
		
		public function set targets(value:Array):void
		{
			var n:int = value.length;
			for (var i:int = n - 1; i >= 0; i--)
			{
				if (value[i] == null)
					value.splice(i,1);
			}
			_targets = value;
		}
		
		/**
		 * 动画类实例
		 */		
		dx_internal var animator:Animation;
		/**
		 * 动画播放更新
		 */		
		protected function animationUpdateHandler(animation:Animation):void
		{
			
		}
		/**
		 * 动画播放开始,只会触发一次，若有重复，之后触发animationRepeatHandler()
		 */		
		protected function animationStartHandler(animation:Animation):void
		{
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_START);
			dispatchEvent(event);
		}
		/**
		 * 动画播放结束
		 */		
		protected function animationEndHandler(animation:Animation):void
		{
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_END);
			dispatchEvent(event);
		}
		/**
		 * 动画播放开始一次新的重复
		 */		
		protected function animationRepeatHandler(animation:Animation):void
		{
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_REPEAT);
			dispatchEvent(event);
		}
		/**
		 * 动画被停止
		 */		
		protected function animationStopHandler(animation:Animation):void
		{
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_STOP);
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get easer():IEaser
		{
			return animator.easer;
		}
		
		public function set easer(value:IEaser):void
		{
			animator.easer = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return animator.isPlaying;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get started():Boolean
		{
			return animator.started;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return animator.duration;
		}
		
		public function set duration(value:Number):void
		{
			animator.duration = value;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get startDelay():Number
		{
			return animator.startDelay;
		}
		
		public function set startDelay(value:Number):void
		{
			animator.startDelay = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get repeatBehavior():String
		{
			return animator.repeatBehavior;
		}
		
		public function set repeatBehavior(value:String):void
		{
			animator.repeatBehavior = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get repeatCount():int
		{
			return animator.repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			animator.repeatCount = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get repeatDelay():Number
		{
			return animator.repeatDelay;
		}
		
		public function set repeatDelay(value:Number):void
		{
			animator.repeatDelay = value;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function play(targets:Array=null):void
		{
			if(targets)
			{
				this.targets = targets;
			}
			if(!this.targets)
				return;
			animator.motionPaths = createMotionPath();
			animator.play();
		}
		
		/**
		 * 创建motionPath对象列表
		 */		
		protected function createMotionPath():Vector.<MotionPath>
		{
			return new <MotionPath>[];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isReverse():Boolean
		{
			return animator.isReverse;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function reverse():void
		{
			if(!this.targets)
				return;
			animator.reverse();
		}
		/**
		 * @inheritDoc
		 */		
		public function end():void
		{
			animator.end();
		}
		
		/**
		 * @inheritDoc
		 */	
		public function stop():void
		{
			animator.stop();
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_END);
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return animator.isPaused;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function pause():void
		{
			animator.pause();
		}
		/**
		 * @inheritDoc
		 */		
		public function resume():void
		{
			animator.resume();
		}
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			animator.stop();
			_targets = [];
		}
	}
}