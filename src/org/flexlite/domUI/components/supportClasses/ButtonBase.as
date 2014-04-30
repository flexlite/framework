package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IDisplayText;

	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	use namespace dx_internal;
	
	/**
	 * 当用户按下ButtonBase控件时分派。如果 autoRepeat属性为 true，则只要按钮处于按下状态，就将重复分派此事件。 
	 */	
	[Event(name="buttonDown", type="org.flexlite.domUI.events.UIEvent")]
	
	
	[DXML(show="false")]
	
	[DefaultProperty(name="label",array="false")]
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	/**
	 * 按钮组件基类
	 * @author DOM
	 */	
	public class ButtonBase extends SkinnableComponent
	{
		/**
		 * 构造函数
		 */		
		public function ButtonBase()
		{
			super();
			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
			focusEnabled = true;
			autoMouseEnabled = false;
			addHandlers();
		}
		
		/**
		 * 已经开始过不断抛出buttonDown事件的标志
		 */		
		private var _downEventFired:Boolean = false;
		
		/**
		 * 重发buttonDown事件计时器 
		 */		
		private var autoRepeatTimer:Timer;
		
		/**
		 * [SkinPart]按钮上的文本标签
		 */
		public var labelDisplay:IDisplayText;

		
		private var _autoRepeat:Boolean = false;
		/**
		 * 指定在用户按住鼠标按键时是否重复分派 buttonDown 事件。
		 */		
		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}
		
		public function set autoRepeat(value:Boolean):void
		{
			if (value == _autoRepeat)
				return;
			
			_autoRepeat = value;
			checkAutoRepeatTimerConditions(isDown());
		}
		
		private var _repeatDelay:Number = 35;
		/**
		 * 在第一个 buttonDown 事件之后，以及相隔每个 repeatInterval 重复一次 buttonDown 事件之前，需要等待的毫秒数。
		 */
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}

		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}
		
		private var _repeatInterval:Number = 35;

		/**
		 * 用户在按钮上按住鼠标时，buttonDown 事件之间相隔的毫秒数。
		 */		
		public function get repeatInterval():Number
		{
			return _repeatInterval;
		}

		public function set repeatInterval(value:Number):void
		{
			_repeatInterval = value;
		}

		
		private var _hovered:Boolean = false;    
		/**
		 * 指示鼠标指针是否位于按钮上。
		 */		
		protected function get hovered():Boolean
		{
			return _hovered;
		}
		
		protected function set hovered(value:Boolean):void
		{
			if (value == _hovered)
				return;
			_hovered = value;
			invalidateSkinState();
			checkButtonDownConditions();
		}
		
		private var _keepDown:Boolean = false;
		
		/**
		 * 强制让按钮停在鼠标按下状态,此方法不会导致重复抛出buttonDown事件,仅影响皮肤State。
		 * @param down 是否按下
		 */				
		dx_internal function keepDown(down:Boolean):void
		{
			if (_keepDown == down)
				return;
			_keepDown = down;
			invalidateSkinState();
		}
		
		
		private var _label:String = "";
		/**
		 * 要在按钮上显示的文本
		 */		
		public function set label(value:String):void
		{
			_label = value;
			if(labelDisplay)
			{
				labelDisplay.text = value;
			}
		}
		
		public function get label():String          
		{
			if(labelDisplay)
			{
				return labelDisplay.text;
			}
			else
			{
				return _label;
			}
		}
		
		private var _mouseCaptured:Boolean = false; 
		/**
		 * 指示第一次分派 MouseEvent.MOUSE_DOWN 时，是否按下鼠标以及鼠标指针是否在按钮上。
		 */		
		protected function get mouseCaptured():Boolean
		{
			return _mouseCaptured;
		}
		
		protected function set mouseCaptured(value:Boolean):void
		{
			if (value == _mouseCaptured)
				return;
			
			_mouseCaptured = value;        
			invalidateSkinState();
			if (!value)
				removeStageMouseHandlers();
			checkButtonDownConditions();
		}
		
		private var _stickyHighlighting:Boolean = false;
		/**
		 * 如果为 false，则按钮会在用户按下它时显示其鼠标按下时的外观，但在用户将鼠标拖离它时将改为显示鼠标经过的外观。
		 * 如果为 true，则按钮会在用户按下它时显示其鼠标按下时的外观，并在用户将鼠标拖离时继续显示此外观。
		 */		
		public function get stickyHighlighting():Boolean
		{
			return _stickyHighlighting
		}
		
		public function set stickyHighlighting(value:Boolean):void
		{
			if (value == _stickyHighlighting)
				return;
			
			_stickyHighlighting = value;
			invalidateSkinState();
			checkButtonDownConditions();
		}
		
		
		/**
		 * 开始抛出buttonDown事件
		 */		
		private function checkButtonDownConditions():void
		{
			var isCurrentlyDown:Boolean = isDown();
			if (_downEventFired != isCurrentlyDown)
			{
				if (isCurrentlyDown)
				{
					dispatchEvent(new UIEvent(UIEvent.BUTTON_DOWN));
				}
				
				_downEventFired = isCurrentlyDown;
				checkAutoRepeatTimerConditions(isCurrentlyDown);
			}
		}
		
		/**
		 * 添加鼠标事件监听
		 */		
		protected function addHandlers():void
		{
			addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			addEventListener(MouseEvent.CLICK, mouseEventHandler);
		}
		
		/**
		 * 添加舞台鼠标弹起事件监听
		 */		
		private function addStageMouseHandlers():void
		{
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler,false,0,true);
			
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler,false,0,true);
		}
		
		/**
		 * 移除舞台鼠标弹起事件监听
		 */	
		private function removeStageMouseHandlers():void
		{
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			
			DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler);
		}
		
		/**
		 * 按钮是否是按下的状态
		 */		
		private function isDown():Boolean
		{
			if (!enabled)
				return false;
			
			if (mouseCaptured && (hovered || stickyHighlighting))
				return true;
			return false;
		}
		
		
		/**
		 * 检查需要启用还是关闭重发计时器
		 */		
		private function checkAutoRepeatTimerConditions(buttonDown:Boolean):void
		{
			var needsTimer:Boolean = autoRepeat && buttonDown;
			var hasTimer:Boolean = autoRepeatTimer != null;
			
			if (needsTimer == hasTimer)
				return;
			
			if (needsTimer)
				startTimer();
			else
				stopTimer();
		}
		
		/**
		 * 启动重发计时器
		 */		
		private function startTimer():void
		{
			autoRepeatTimer = new Timer(1);
			autoRepeatTimer.delay = _repeatDelay;
			autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeat_timerDelayHandler);
			autoRepeatTimer.start();
		}
		
		/**
		 * 停止重发计时器
		 */		
		private function stopTimer():void
		{
			autoRepeatTimer.stop();
			autoRepeatTimer = null;
		}
		
		
		/**
		 * 鼠标事件处理
		 */	
		protected function mouseEventHandler(event:Event):void
		{
			var mouseEvent:MouseEvent = event as MouseEvent;
			switch (event.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					if (mouseEvent.buttonDown && !mouseCaptured)
						return;
					hovered = true;
					break;
				}
					
				case MouseEvent.ROLL_OUT:
				{
					hovered = false;
					break;
				}
					
				case MouseEvent.MOUSE_DOWN:
				{
					addStageMouseHandlers();
					mouseCaptured = true;
					break;
				}
					
				case MouseEvent.MOUSE_UP:
				{
					if (event.target == this)
					{
						hovered = true;
						
						if (mouseCaptured)
						{
							buttonReleased();
							mouseCaptured = false;
						}
					}
					break;
				}
				case MouseEvent.CLICK:
				{
					if (!enabled)
						event.stopImmediatePropagation();
					else
						clickHandler(MouseEvent(event));
					return;
				}
			}
		}
		
		/**
		 * 按钮弹起事件
		 */		
		protected function buttonReleased():void
		{
		}
		
		/**
		 * 按钮点击事件
		 */		
		protected function clickHandler(event:MouseEvent):void
		{
		}
		
		/**
		 * 舞台上鼠标弹起事件
		 */		
		private function stage_mouseUpHandler(event:Event):void
		{
			if (event.target == this)
				return;
			
			mouseCaptured = false;
		}
		
		/**
		 * 自动重发计时器首次延迟结束事件
		 */		
		private function autoRepeat_timerDelayHandler(event:TimerEvent):void
		{
			autoRepeatTimer.reset();
			autoRepeatTimer.removeEventListener( TimerEvent.TIMER, autoRepeat_timerDelayHandler);
			
			autoRepeatTimer.delay = _repeatInterval;
			autoRepeatTimer.addEventListener( TimerEvent.TIMER, autoRepeat_timerHandler);
			autoRepeatTimer.start();
		}
		
		/**
		 * 自动重发buttonDown事件
		 */		
		private function autoRepeat_timerHandler(event:TimerEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.BUTTON_DOWN));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if (!enabled)
				return super.getCurrentSkinState();
			
			if (isDown()||_keepDown)
				return "down";
			
			if (hovered || mouseCaptured)
				return "over";
			
			return "up";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == labelDisplay)
			{
				labelDisplay.text = _label;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(createLabelIfNeedChanged)
			{
				createLabelIfNeedChanged = false;
				if(createLabelIfNeed)
				{
					createSkinParts();
					invalidateSize();
					invalidateDisplayList();
				}
				else
				{
					removeSkinParts();
				}
			}
		}
		
		private var _createLabelIfNeed:Boolean = true;
		
		private var createLabelIfNeedChanged:Boolean = false;
		/**
		 * 如果皮肤不提供labelDisplay子项，自己是否创建一个，默认为true。
		 */
		public function get createLabelIfNeed():Boolean
		{
			return _createLabelIfNeed;
		}

		public function set createLabelIfNeed(value:Boolean):void
		{
			if(value==_createLabelIfNeed)
				return;
			_createLabelIfNeed = value;
			createLabelIfNeedChanged = true;
			invalidateProperties();
		}
		/**
		 * 创建过label的标志
		 */
		private var hasCreatedLabel:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			if(hasCreatedLabel||!_createLabelIfNeed)
				return;
			hasCreatedLabel = true;
			var text:Label = new Label();
			text.textAlign = TextFormatAlign.CENTER;
			text.verticalAlign = VerticalAlign.MIDDLE;
			text.maxDisplayedLines = 1;
			text.left = 10;
			text.right = 10;
			text.top = 2;
			text.bottom = 2;
			addToDisplayList(text);
			labelDisplay = text;
			partAdded("labelDisplay",labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void
		{
			if(!hasCreatedLabel)
				return;
			hasCreatedLabel = false;
			if(!labelDisplay)
				return;
			_label = labelDisplay.text;
			partRemoved("labelDisplay",labelDisplay);
			removeFromDisplayList(labelDisplay as DisplayObject);
			labelDisplay = null;
		}
		
	}
	
}
