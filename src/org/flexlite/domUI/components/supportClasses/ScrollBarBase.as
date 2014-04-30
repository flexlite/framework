package org.flexlite.domUI.components.supportClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.easing.IEaser;
	import org.flexlite.domUI.effects.easing.Linear;
	import org.flexlite.domUI.effects.easing.Sine;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.events.UIEvent;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	[DefaultProperty(name="viewport",array="false")]
	/**
	 * 滚动条基类
	 * @author DOM
	 */	
	public class ScrollBarBase extends TrackBase
	{
		/**
		 * 构造函数
		 */		
		public function ScrollBarBase():void
		{
			super();
		}
		
		/**
		 * [SkinPart]减小滚动条值的按钮
		 */		
		public var decrementButton:Button;
		
		/**
		 * [SkinPart]增大滚动条值的按钮
		 */	
		public var incrementButton:Button;
		
		
		private var _animator:Animation = null;
		/**
		 * 动画类实例
		 */		
		private function get animator():Animation
		{
			if (_animator)
				return _animator;
			_animator = new Animation(animationUpdateHandler);
			_animator.endFunction = animationEndHandler;
			return _animator;
		}
		
		/**
		 * 用户在操作系统中可以设置将鼠标滚轮每滚动一个单位应滚动多少行。
		 * 当使用鼠标滚轮滚动此组件的目标容器时，true表示根据用户系统设置的值滚动对应的行数。
		 * false则忽略系统设置，始终只滚动一行。默认值为true。
		 */
		dx_internal var useMouseWheelDelta:Boolean

		/**
		 * 正在步进增大值的标志
		 */		
		private var steppingDown:Boolean;
		/**
		 * 正在步进减小值的标志
		 */		
		private var steppingUp:Boolean;
		
		/**
		 * 正在步进改变值的标志
		 */		
		private var isStepping:Boolean;
		
		private var animatingOnce:Boolean;
		
		/**
		 * 滚动动画用到的缓动类
		 */		
		private static var linearEaser:IEaser = new Linear();
		private static var easyInLinearEaser:IEaser = new Linear(.1);
		private static var deceleratingSineEaser:IEaser = new Sine(0);
		
		/**
		 * 记录当前滚动方向的标志
		 */		
		private var trackScrollDown:Boolean;
		
		/**
		 * 当鼠标按住轨道时用于循环滚动的计时器
		 */		
		private var trackScrollTimer:Timer;
		
		/**
		 * 在鼠标按住轨道的滚动过程中记录滚动的位置
		 */		
		private var trackPosition:Point = new Point();
		
		/**
		 * 正在进行鼠标按住轨道滚动过程的标志
		 */		
		private var trackScrolling:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function set minimum(value:Number):void
		{
			if (value == super.minimum)
				return;
			
			super.minimum = value;
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set maximum(value:Number):void
		{
			if (value == super.maximum)
				return;
			
			super.maximum = value;
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set snapInterval(value:Number):void
		{
			super.snapInterval = value;
			pageSizeChanged = true;
		}
		
		private var _pageSize:Number = 20;
		
		/**
		 * 翻页大小改变标志
		 */		
		private var pageSizeChanged:Boolean = false;
		
		/**
		 * 翻页大小,调用 changeValueByPage() 方法时 value 属性值的改变量。
		 */	
		public function get pageSize():Number
		{
			return _pageSize;
		}
		
		public function set pageSize(value:Number):void
		{
			if (value == _pageSize)
				return;
			
			_pageSize = value;
			pageSizeChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		
		private var _smoothScrolling:Boolean = true;

		/**
		 * 翻页和步进时滚动条是否播放平滑的动画。
		 */		
		public function get smoothScrolling():Boolean
		{
			return _smoothScrolling;
		}

		public function set smoothScrolling(value:Boolean):void
		{
			_smoothScrolling = value;
		}

		
		private var _repeatInterval:Number = 35;

		/**
		 * 用户在轨道上按住鼠标时，page 事件之间相隔的毫秒数。
		 */		
		public function get repeatInterval():Number
		{
			return _repeatInterval;
		}

		public function set repeatInterval(value:Number):void
		{
			_repeatInterval = value;
		}

		
		private var _fixedThumbSize:Boolean = false;

		/**
		 * 如果为 true，则沿着滚动条的滑块的大小将不随滚动条最大值改变。
		 */		
		public function get fixedThumbSize():Boolean
		{
			return _fixedThumbSize;
		}

		public function set fixedThumbSize(value:Boolean):void
		{
			if(_fixedThumbSize == value)
				return;
			_fixedThumbSize = value;
			invalidateDisplayList();
		}

		
		private var _repeatDelay:Number = 500;

		/**
		 * 在第一个 page 事件之后直到后续的 page 事件发生之间相隔的毫秒数。
		 */		
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}

		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}

		
		private var _autoThumbVisibility:Boolean = true;

		/**
		 * 如果为 true（默认值），则无论何时更新滑块的大小，都将重置滑块的可见性。
		 */		
		public function get autoThumbVisibility():Boolean
		{
			return _autoThumbVisibility;
		}

		public function set autoThumbVisibility(value:Boolean):void
		{
			if(_autoThumbVisibility == value)
				return;
			_autoThumbVisibility = value;
			invalidateDisplayList();
		}

		
		private var _viewport:IViewport;
		
		/**
		 * 由此滚动条控制的可滚动组件。
		 */
		public function get viewport():IViewport
		{
			return _viewport;
		}
		public function set viewport(value:IViewport):void
		{
			if (value == _viewport)
				return;
			
			if (_viewport)  
			{
				_viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.removeEventListener(ResizeEvent.RESIZE, viewportResizeHandler);
				_viewport.clipAndEnableScrolling = false;
			}
			
			_viewport = value;
			
			if (_viewport)  
			{
				_viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.addEventListener(ResizeEvent.RESIZE, viewportResizeHandler);
				_viewport.clipAndEnableScrolling = true;
			}
		}
		
		/**
		 * 开始播放动画
		 */		
		dx_internal function startAnimation(duration:Number, valueTo:Number, 
										easer:IEaser, startDelay:Number = 0):void
		{
			animator.stop();
			animator.duration = duration;
			animator.easer = easer;
			animator.motionPaths = new <MotionPath>[
				new MotionPath("value", value, valueTo)];
			animator.startDelay = startDelay;
			animator.play();
		}
		
		/**
		 * 根据指定数值返回最接近snapInterval的整数倍的数值
		 */		
		private function nearestValidSize(size:Number):Number
		{
			var interval:Number = snapInterval;
			if (interval == 0)
				return size;
			
			var validSize:Number = Math.round(size / interval) * interval
			return (Math.abs(validSize) < interval) ? interval : validSize;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (pageSizeChanged)
			{
				_pageSize = nearestValidSize(_pageSize);
				pageSizeChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == decrementButton)
			{
				decrementButton.addEventListener(UIEvent.BUTTON_DOWN,
					button_buttonDownHandler);
				decrementButton.addEventListener(MouseEvent.ROLL_OVER,
					button_rollOverHandler);
				decrementButton.addEventListener(MouseEvent.ROLL_OUT,
					button_rollOutHandler);
				decrementButton.autoRepeat = true;
			}
			else if (instance == incrementButton)
			{
				incrementButton.addEventListener(UIEvent.BUTTON_DOWN,
					button_buttonDownHandler);
				incrementButton.addEventListener(MouseEvent.ROLL_OVER,
					button_rollOverHandler);
				incrementButton.addEventListener(MouseEvent.ROLL_OUT,
					button_rollOutHandler);
				incrementButton.autoRepeat = true;
			}
			else if (instance == track)
			{
				track.addEventListener(MouseEvent.ROLL_OVER,
					track_rollOverHandler);
				track.addEventListener(MouseEvent.ROLL_OUT,
					track_rollOutHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == decrementButton)
			{
				decrementButton.removeEventListener(UIEvent.BUTTON_DOWN,
					button_buttonDownHandler);
				decrementButton.removeEventListener(MouseEvent.ROLL_OVER,
					button_rollOverHandler);
				decrementButton.removeEventListener(MouseEvent.ROLL_OUT,
					button_rollOutHandler);
			}
			else if (instance == incrementButton)
			{
				incrementButton.removeEventListener(UIEvent.BUTTON_DOWN,
					button_buttonDownHandler);
				incrementButton.removeEventListener(MouseEvent.ROLL_OVER,
					button_rollOverHandler);
				incrementButton.removeEventListener(MouseEvent.ROLL_OUT,
					button_rollOutHandler);
			}
			else if (instance == track)
			{
				track.removeEventListener(MouseEvent.ROLL_OVER,
					track_rollOverHandler);
				track.removeEventListener(MouseEvent.ROLL_OUT, 
					track_rollOutHandler);
			}
		}
		
		/**
		 * 从 value 增加或减去 pageSize。每次增加后，新的 value 是大于当前 value 的 pageSize 的最接近倍数。<br/>
		 * 每次减去后，新的 value 是小于当前 value 的 pageSize 的最接近倍数。value 的最小值是 pageSize。
		 * @param increase 翻页操作是增加 (true) 还是减少 (false) value。
		 */		
		public function changeValueByPage(increase:Boolean = true):void
		{
			var val:Number;
			if (increase)
				val = Math.min(value + pageSize, maximum);
			else
				val = Math.max(value - pageSize, minimum);
			if (_smoothScrolling)
			{
				startAnimation(_repeatInterval, val, linearEaser);
			}
			else
			{
				setValue(val);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 目标视域组件属性发生改变
		 */		
		private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch(event.property) 
			{
				case "contentWidth": 
					viewportContentWidthChangeHandler(event);
					break;
				
				case "contentHeight": 
					viewportContentHeightChangeHandler(event);
					break;
				
				case "horizontalScrollPosition":
					viewportHorizontalScrollPositionChangeHandler(event);
					break;
				
				case "verticalScrollPosition":
					viewportVerticalScrollPositionChangeHandler(event);
					break;
			}
		}
		
		/**
		 * 目标视域组件尺寸发生改变
		 */		
		dx_internal function viewportResizeHandler(event:ResizeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的内容宽度发生改变。
		 */		
		dx_internal function viewportContentWidthChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的内容高度发生改变。
		 */		
		dx_internal function viewportContentHeightChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的水平方向滚动条位置发生改变
		 */		
		dx_internal function viewportHorizontalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
		}  
		
		/**
		 * 目标视域组件的垂直方向滚动条位置发生改变
		 */		
		dx_internal function viewportVerticalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
		} 
		
		/**
		 * 鼠标在滑块按下事件
		 */		
		override protected function thumb_mouseDownHandler(event:MouseEvent) : void
		{
			
			stopAnimation();
			
			super.thumb_mouseDownHandler(event);
		}
		
		/**
		 * 鼠标在两端按钮上按住不放的事件
		 */		
		protected function button_buttonDownHandler(event:Event):void
		{
			if (!isStepping)
				stopAnimation();
			var increment:Boolean = (event.target == incrementButton);
			if (!isStepping && 
				((increment && value < maximum) ||
					(!increment && value > minimum)))
			{
				dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
				isStepping = true;
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, 
					button_buttonUpHandler, false,0,true);
				DomGlobals.stage.addEventListener(
					Event.MOUSE_LEAVE, button_buttonUpHandler,false,0,true);
			}
			if (!steppingDown && !steppingUp)
			{
				changeValueByStep(increment);
				if (_smoothScrolling &&
					((increment && value < maximum) ||
						(!increment && value > minimum)))
				{
					animateStepping(increment ? maximum : minimum, 
						Math.max(pageSize/10, stepSize));
				}
				return;
			}
		}
		
		/**
		 * 鼠标在两端按钮上弹起的事件
		 */		
		protected function button_buttonUpHandler(event:Event):void
		{
			if (steppingDown || steppingUp)
			{
				
				stopAnimation();
				
				dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
				
				steppingUp = steppingDown = false;
				isStepping = false;
			}
			else if (isStepping)
			{
				
				dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
				isStepping = false;
			}
			
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, 
				button_buttonUpHandler);
			DomGlobals.stage.removeEventListener(
				Event.MOUSE_LEAVE, button_buttonUpHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function track_mouseDownHandler(event:MouseEvent):void
		{
			if (!enabled)
				return;
			stopAnimation();
			trackPosition = track.globalToLocal(new Point(event.stageX, event.stageY));
			if (event.shiftKey)
			{
				var thumbW:Number = (thumb) ? thumb.layoutBoundsWidth : 0;
				var thumbH:Number = (thumb) ? thumb.layoutBoundsHeight : 0;
				trackPosition.x -= (thumbW / 2);
				trackPosition.y -= (thumbH / 2);        
			}
			
			var newScrollValue:Number = pointToValue(trackPosition.x, trackPosition.y);
			trackScrollDown = (newScrollValue > value);
			
			if (event.shiftKey)
			{
				var adjustedValue:Number = nearestValidValue(newScrollValue, snapInterval);
				if (_smoothScrolling && 
					slideDuration != 0 && 
					(maximum - minimum) != 0)
				{
					dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
					
					startAnimation(slideDuration * 
						(Math.abs(value - newScrollValue) / (maximum - minimum)),
						adjustedValue, deceleratingSineEaser);
					animatingOnce = true;
				}
				else
				{
					setValue(adjustedValue);
					dispatchEvent(new Event(Event.CHANGE));
				}
				return;
			}
			
			dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
			
			animatingOnce = false;
			
			changeValueByPage(trackScrollDown);
			
			trackScrolling = true;
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, 
				track_mouseMoveHandler, false,0,true);      
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, 
				track_mouseUpHandler, false,0,true);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE, 
				track_mouseUpHandler,false,0,true);
			if (!trackScrollTimer)
			{
				trackScrollTimer = new Timer(_repeatDelay, 1);
				trackScrollTimer.addEventListener(TimerEvent.TIMER, 
					trackScrollTimerHandler);
			} 
			else
			{
				trackScrollTimer.delay = _repeatDelay;
				trackScrollTimer.repeatCount = 1;
			}
			trackScrollTimer.start();
		}
		
		/**
		 * 计算并播放翻页动画
		 */		
		protected function animatePaging(newValue:Number, pageSize:Number):void
		{
			animatingOnce = false;
			
			startAnimation(
				_repeatInterval * (Math.abs(newValue - value) / pageSize),
				newValue, linearEaser);
		}
		
		/**
		 * 播放步进动画
		 */		
		protected function animateStepping(newValue:Number, stepSize:Number):void
		{
			steppingDown = (newValue > value);
			steppingUp = !steppingDown;
			var denominator:Number = (stepSize != 0) ? stepSize : 1; 
			var duration:Number = _repeatInterval * 
				(Math.abs(newValue - value) / denominator);
			
			var easer:IEaser;
			if (duration > 5000)
				easer = new Linear(500/duration);
			else
				easer = easyInLinearEaser;
			startAnimation(duration, newValue, easer, _repeatDelay);
		}
		
		/**
		 * 动画播放过程中触发的更新数值函数
		 */		
		private function animationUpdateHandler(animation:Animation):void
		{
			setValue(animation.currentValue["value"]);
		}
		
		/**
		 * 动画播放完成触发的函数
		 */		
		private function animationEndHandler(animation:Animation):void
		{
			if (trackScrolling)
				trackScrolling = false;
			if (steppingDown || steppingUp)
			{
				changeValueByStep(steppingDown);
				
				animator.startDelay = 0;
				return;
			}
			setValue(nearestValidValue(this.value, snapInterval));
			dispatchEvent(new Event(Event.CHANGE));
			if (animatingOnce)
			{
				dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
				animatingOnce = false;
			}
		}
		
		/**
		 * 立即停止动画的播放
		 */		
		dx_internal function stopAnimation():void
		{
			if (animator.isPlaying)
				animationEndHandler(animator);
			animator.stop();
		}
		
		/**
		 * 在轨道上按住shift并按下鼠标后，滑块滑动到按下点的计时器触发函数
		 */		
		private function trackScrollTimerHandler(event:Event):void
		{
			var newScrollValue:Number = pointToValue(trackPosition.x, trackPosition.y);
			if(newScrollValue==value)
				return;
			var fixedThumbSize:Boolean = _fixedThumbSize !== false;
			if (trackScrollDown)
			{
				var range:Number = maximum - minimum;
				if (range == 0)
					return;
				
				if ((value + pageSize) > newScrollValue &&
					(!fixedThumbSize || nearestValidValue(newScrollValue, pageSize) != maximum))
					return;
			}
			else if (newScrollValue > value)
			{
				return;
			}
			
			if (_smoothScrolling)
			{
				var valueDelta:Number = Math.abs(value - newScrollValue);
				var pages:int;
				var pageToVal:Number;
				if (newScrollValue > value)
				{
					pages = pageSize != 0 ? 
						int(valueDelta / pageSize) :
						valueDelta;
					if (fixedThumbSize && nearestValidValue(newScrollValue, pageSize) == maximum)
						pageToVal = maximum;
					else
						pageToVal = value + (pages * pageSize);
				}
				else
				{
					pages = pageSize != 0 ? 
						int(Math.ceil(valueDelta / pageSize)) :
						valueDelta;
					pageToVal = Math.max(minimum, value - (pages * pageSize));
				}
				animatePaging(pageToVal, pageSize);
				return;
			}
			
			var oldValue:Number = value;
			
			changeValueByPage(trackScrollDown);
			
			if (trackScrollTimer && trackScrollTimer.repeatCount == 1)
			{
				trackScrollTimer.delay = _repeatInterval;
				trackScrollTimer.repeatCount = 0;
			}
		}
		
		/**
		 * 轨道上鼠标移动事件
		 */		
		private function track_mouseMoveHandler(event:MouseEvent):void
		{
			if (trackScrolling)
			{
				var pt:Point = new Point(event.stageX, event.stageY);
				
				trackPosition = track.globalToLocal(pt);
			}
		}
		
		/**
		 * 轨道上鼠标弹起事件
		 */		
		private function track_mouseUpHandler(event:Event):void
		{
			trackScrolling = false;
			
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, 
				track_mouseMoveHandler);      
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, 
				track_mouseUpHandler);
			DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, 
				track_mouseUpHandler);
			if (_smoothScrolling)
			{
				if (!animatingOnce)
				{
					if (trackScrollTimer && trackScrollTimer.running)
					{
						if (animator.isPlaying)
							animatingOnce = true;
						else
							dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
					}
					else
					{
						stopAnimation();
						dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
					}
				}
			}
			else
			{
				dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
			}
			
			if (trackScrollTimer)
				trackScrollTimer.reset();
		}
		
		/**
		 * 鼠标经过轨道触发函数
		 */		
		private function track_rollOverHandler(event:MouseEvent):void
		{
			if (trackScrolling && trackScrollTimer)
				trackScrollTimer.start();
		}
		
		/**
		 * 鼠标移出轨道时触发的函数
		 */		
		private function track_rollOutHandler(event:MouseEvent):void
		{
			if (trackScrolling && trackScrollTimer)
				trackScrollTimer.stop();
		}
		
		/**
		 * 鼠标经过两端按钮时触发函数
		 */		
		private function button_rollOverHandler(event:MouseEvent):void
		{
			if (steppingUp || steppingDown)
				animator.resume();
		}
		
		/**
		 * 鼠标移出两端按钮是触发函数
		 */		
		private function button_rollOutHandler(event:MouseEvent):void
		{
			if (steppingUp || steppingDown)
				animator.pause();
		}
	}
	
}