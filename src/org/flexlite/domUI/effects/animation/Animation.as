package org.flexlite.domUI.effects.animation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.effects.easing.Sine;

	/**
	 * 数值缓动工具类
	 * @author DOM
	 */
	public class Animation
	{
		/**
		 * 构造函数
		 * @param updateFunction 动画更新时的回调函数,updateFunction(animation:Animation):void
		 */		
		public function Animation(updateFunction:Function)
		{
			this.updateFunction = updateFunction;
		}
		
		private static var defaultEaser:IEaser = new Sine(.5); 
		
		private var _easer:IEaser = defaultEaser;
		/**
		 * 此效果的缓动行为。设置为null意味着不使用缓动，默认值为Sine(.5)
		 */
		public function get easer():IEaser
		{
			return _easer;
		}

		public function set easer(value:IEaser):void
		{
			_easer = value;
		}

		
		private var _isPlaying:Boolean
		/**
		 * 是否正在播放动画，不包括延迟等待和暂停的阶段
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
		private var _duration:Number = 500;
		/**
		 * 动画持续时间,单位毫秒，默认值500
		 */
		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			_duration = value;
		}
		
		private var _startDelay:Number = 0;

		/**
		 * 动画开始播放前的延时时间,单位毫秒,默认0。
		 */		
		public function get startDelay():Number
		{
			return _startDelay;
		}

		public function set startDelay(value:Number):void
		{
			_startDelay = value;
		}
		
		private var _repeatBehavior:String = RepeatBehavior.LOOP;
		/**
		 * 设置重复动画的行为。
		 * RepeatBehavior.LOOP表示始终重复正向播放动画。
		 * RepeatBehavior.REVERSE表示正向和反向播放交替进行。
		 */
		public function get repeatBehavior():String
		{
			return _repeatBehavior;
		}

		public function set repeatBehavior(value:String):void
		{
			_repeatBehavior = value;
		}

		
		private var _repeatCount:int = 1;
		/**
		 * 动画重复的次数，0代表无限制重复。默认值为1。
		 */
		public function get repeatCount():int
		{
			return _repeatCount;
		}

		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		private var _repeatDelay:Number = 0;
		/**
		 * 每次重复播放之间的间隔。第二次及以后的播放开始之前的延迟毫秒数。若要设置第一次之前的延迟时间，请使用startDelay属性。
		 */
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}

		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}
		
		
		
		private var _motionPaths:Vector.<MotionPath>;
		/**
		 * 随着时间的推移Animation将设置动画的属性和值的列表。
		 */
		public function get motionPaths():Vector.<MotionPath>
		{
			if(_motionPaths==null)
				_motionPaths = new Vector.<MotionPath>();
			return _motionPaths;
		}

		public function set motionPaths(value:Vector.<MotionPath>):void
		{
			_motionPaths = value;
		}

		private var _currentValue:Object = {};

		/**
		 * 动画到当前时间对应的值。以MotionPath.property为键存储各个MotionPath的当前值。
		 */		
		public function get currentValue():Object
		{
			return _currentValue;
		}
		
		/**
		 * 动画开始播放时的回调函数,只会在首次延迟等待结束时触发一次,若有重复播放，之后将触发repeatFunction。startFunction(animation:Animation):void
		 */		
		public var startFunction:Function;
		/**
		 * 动画播放结束时的回调函数,可以是正常播放结束，也可以是被调用了end()方法导致结束。注意：stop()方法被调用不会触发这个函数。endFunction(animation:Animation):void
		 */
		public var endFunction:Function;

		/**
		 * 动画更新时的回调函数,updateFunction(animation:Animation):void
		 */		
		public var updateFunction:Function;
		
		/**
		 * 动画开始一次新的重复播放时的回调函数，repeatFunction(animation:Animation):void
		 */		
		public var repeatFunction:Function;
		
		/**
		 * 动画被停止的回调函数，即stop()方法被调用。stopFunction(animation:Animation):void
		 */		
		public var stopFunction:Function;
		
		/**
		 * 开始正向播放动画,无论何时调用都重新从零时刻开始，若设置了延迟会首先进行等待。
		 */		
		public function play():void
		{
			stopAnimation();
			_isReverse = false;
			start();
		}
		
		private var _isReverse:Boolean = false;
		/**
		 * 正在反向播放。
		 */
		public function get isReverse():Boolean
		{
			return _isReverse;
		}
		
		/**
		 * 仅当动画已经在播放中时有效，从当前位置开始沿motionPaths定义的路径反向播放。
		 */		
		public function reverse():void
		{
			if(_isReverse||!_isPlaying)
				return;
			_isReverse = true;
			var runningTime:Number = currentTime-startTime-_startDelay;
			runningTime = Math.min(runningTime,duration);
			seek(duration - runningTime);
		}
		
		/**
		 * 立即跳到指定百分比的动画位置
		 */		
		private function seek(runningTime:Number):void
		{
			runningTime = Math.min(runningTime,duration);
			var fraction:Number = runningTime/duration;
			caculateCurrentValue(fraction);
			startTime = getTimer() - runningTime - _startDelay;
			if(updateFunction!=null)
				updateFunction(this);
		}
		
		/**
		 * 开始播放动画
		 */		
		private function start():void
		{
			playedTimes = 0;
			_started = true;
			_isPlaying = false;
			_currentValue = {};
			caculateCurrentValue(0);
			startTime = getTimer();
			currentTime = getTimer();
			doInterval();
			addAnimation(this);
		}
		
		/**
		 * 直接跳到动画结尾
		 */		
		public function end():void
		{
			if(!_started)
			{
				caculateCurrentValue(0);
				if(startFunction!=null)
				{
					startFunction(this);
				}
				if(updateFunction!=null)
				{
					updateFunction(this);
				}
			}
			caculateCurrentValue(1);
			if(updateFunction!=null)
			{
				updateFunction(this);
			}
			stopAnimation();
			if(endFunction!=null)
			{
				endFunction(this);
			}
		}
		
		/**
		 * 停止播放动画
		 */		
		public function stop():void
		{
			stopAnimation();
			if(stopFunction!=null)
				stopFunction(this);
		}
		/**
		 * 仅停止播放动画，而不调用stopFunction。
		 */		
		private function stopAnimation():void
		{
			playedTimes = 0;
			_isPlaying = false;
			startTime = 0;
			_started = false;
			removeAnimation(this);
		}
		
		private var pauseTime:Number = 0;
		
		private var _isPaused:Boolean = false;
		/**
		 * 正在暂停中
		 */
		public function get isPaused():Boolean
		{
			return _isPaused;
		}
		
		
		
		/**
		 * 暂停播放
		 */		
		public function pause():void
		{
			if(!_started)
				return;
			_isPaused = true;
			pauseTime = getTimer();
			_isPlaying = false;
			removeAnimation(this);
		}
		/**
		 * 继续播放
		 */		
		public function resume():void
		{
			if(!_started||!_isPaused)
				return;
			_isPaused = false;
			startTime += getTimer()-pauseTime;
			pauseTime = -1;
			addAnimation(this);
		}
		
		/**
		 * 动画启动时刻
		 */		
		private var startTime:Number = 0;
		
		private var _started:Boolean = false;

		/**
		 * 动画已经开始的标志，包括延迟等待和暂停的阶段。
		 */
		public function get started():Boolean
		{
			return _started;
		}

		
		/**
		 * 已经播放的次数。
		 */		
		private var playedTimes:int = 0;
		/**
		 * 计算当前值并返回动画是否结束
		 */		
		private function doInterval():Boolean
		{
			var delay:Number = playedTimes>0?_repeatDelay:_startDelay;
			var runningTime:Number = currentTime-startTime-delay;
			if(runningTime<0)
			{
				return false;
			}
			if(!_isPlaying)
			{
				_isPlaying = true;
				if(playedTimes==0)
				{
					if(startFunction!=null)
						startFunction(this);
				}
				else
				{
					if(repeatFunction!=null)
						repeatFunction(this);
				}
			}
			var fraction:Number = _duration==0?1:Math.min(runningTime,_duration)/_duration;
			caculateCurrentValue(fraction);
			if(updateFunction!=null)
				updateFunction(this);
			var isEnded:Boolean = runningTime>=_duration;
			if(isEnded)
			{
				playedTimes++;
				_isPlaying = false;
				startTime =  currentTime;
				if(_repeatCount==0||playedTimes<_repeatCount)
				{
					if(_repeatBehavior=="reverse")
					{
						_isReverse = !_isReverse;
					}
					isEnded = false;
				}
				else
				{
					removeAnimation(this);
					_started = false;
					playedTimes = 0;
				}
			}
			if(isEnded&&endFunction!=null)
			{
				endFunction(this);
			}
			return isEnded;
		}
		/**
		 * 计算当前值
		 */		
		private function caculateCurrentValue(fraction:Number):void
		{
			if(_isReverse)
			{
				fraction = 1-fraction;
			}
			var finalFraction:Number = fraction;
			if(easer)
				finalFraction = easer.ease(fraction);
			for each(var motionPath:MotionPath in motionPaths)
			{
				currentValue[motionPath.property] = motionPath.valueFrom+(motionPath.valueTo-motionPath.valueFrom)*finalFraction;
			}
		}
		
		/**
		 * 总时间轴的当前时间
		 */		
		private static var currentTime:Number = 0;
		
		
		private static const TIMER_RESOLUTION:Number = 1000 / 60;	// 60 fps
		
		private static var timer:Timer;
		
		/**
		 * 正在活动的动画
		 */		
		private static var activeAnimations:Vector.<Animation> = new Vector.<Animation>();
		
		/**
		 * 添加动画到队列
		 */		
		private static function addAnimation(animation:Animation):void
		{
			if(activeAnimations.indexOf(animation)==-1)
			{
				activeAnimations.push(animation);
				if (timer==null)
				{
					timer = new Timer(TIMER_RESOLUTION);
					timer.addEventListener(TimerEvent.TIMER, timerHandler);
				}
				if(!timer.running)
					timer.start();
			}
		}
		
		/**
		 * 从队列移除动画,返回移除前的索引
		 */		
		private static function removeAnimation(animation:Animation):void
		{
			var index:int = activeAnimations.indexOf(animation);
			if(index!=-1)
			{
				activeAnimations.splice(index,1);
				if(index<=currentIntervalIndex)
					currentIntervalIndex--;
			}
			if(activeAnimations.length==0&&timer&&timer.running)
			{
				timer.stop();
			}
		}
		
		/**
		 * 当前正在执行动画的索引
		 */		
		private static var currentIntervalIndex:int = -1;
		
		/**
		 * 计时器触发函数
		 */		
		private static function timerHandler(event:TimerEvent):void
		{
			currentTime = getTimer();
			currentIntervalIndex = 0;
			while(currentIntervalIndex<activeAnimations.length)
			{
				var animation:Animation = activeAnimations[currentIntervalIndex];
				var isEnded:Boolean = animation.doInterval();
				currentIntervalIndex++;
			}
			currentIntervalIndex = -1;
			if(activeAnimations.length==0&&timer.running)
			{
				timer.stop();
			}
			if(DomGlobals.useUpdateAfterEvent)
				event.updateAfterEvent();
		}
		
	}
}