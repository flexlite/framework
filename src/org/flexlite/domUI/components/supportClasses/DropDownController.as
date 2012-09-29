package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	
	use namespace dx_internal;
	
	/**
	 * 下拉框打开事件
	 */	
	[Event(name="open",type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 下来框关闭事件
	 */	
	[Event(name="close",type="org.flexlite.domUI.events.UIEvent")]
	
	[ExcludeClass]
	/**
	 * 用于处理因用户交互而打开和关闭下拉列表的操作的控制器
	 * @author DOM
	 */	
	public class DropDownController extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function DropDownController()
		{
			super();
		}
		/**
		 * 鼠标按下标志
		 */		
		private var mouseIsDown:Boolean;
			
		private var _openButton:ButtonBase;
		/**
		 * 下拉按钮实例
		 */	
		public function get openButton():ButtonBase
		{
			return _openButton;
		}
		public function set openButton(value:ButtonBase):void
		{
			if (_openButton === value)
				return;
			removeOpenTriggers();
			_openButton = value;
			addOpenTriggers();
			
		}
		/**
		 * 要考虑作为下拉列表的点击区域的一部分的显示对象列表。
		 * 在包含项列出的任何组件内进行鼠标单击不会自动关闭下拉列表。
		 */		
		public var hitAreaAdditions:Vector.<DisplayObject>;
		
		private var _dropDown:DisplayObject;
		/**
		 * 下拉区域显示对象
		 */		
		public function get dropDown():DisplayObject
		{
			return _dropDown;
		}
		public function set dropDown(value:DisplayObject):void
		{
			if (_dropDown === value)
				return;
			
			_dropDown = value;
		}   
		
		
		private var _isOpen:Boolean = false;
		/**
		 * 下拉列表已经打开的标志
		 */		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		private var _closeOnResize:Boolean = true;
		/**
		 * 如果为 true，则在调整舞台大小时会关闭下拉列表。
		 */		
		public function get closeOnResize():Boolean
		{
			return _closeOnResize;
		}
		
		public function set closeOnResize(value:Boolean):void
		{
			if (_closeOnResize == value)
				return;
			if (isOpen)
				removeCloseOnResizeTrigger();
			
			_closeOnResize = value;
			
			addCloseOnResizeTrigger();
		}
		
		private var _rollOverOpenDelay:Number = NaN;
		
		private var rollOverOpenDelayTimer:Timer;
		/**
		 * 指定滑过锚点按钮时打开下拉列表要等待的延迟（以毫秒为单位）。
		 * 如果设置为 NaN，则下拉列表会在单击时打开，而不是在滑过时打开。默认值NaN
		 */		
		public function get rollOverOpenDelay():Number
		{
			return _rollOverOpenDelay;
		}
		
		public function set rollOverOpenDelay(value:Number):void
		{
			if (_rollOverOpenDelay == value)
				return;
			
			removeOpenTriggers();
			
			_rollOverOpenDelay = value;
			
			addOpenTriggers();
		}
		/**
		 * 添加触发下拉列表打开的事件监听
		 */		
		private function addOpenTriggers():void
		{
			if (openButton)
			{
				if (isNaN(rollOverOpenDelay))
					openButton.addEventListener(UIEvent.BUTTON_DOWN, openButton_buttonDownHandler);
				else
					openButton.addEventListener(MouseEvent.ROLL_OVER, openButton_rollOverHandler);
			}
		}
		/**
		 * 移除触发下拉列表打开的事件监听
		 */	
		private function removeOpenTriggers():void
		{
			if (openButton)
			{
				if (isNaN(rollOverOpenDelay))
					openButton.removeEventListener(UIEvent.BUTTON_DOWN, openButton_buttonDownHandler);
				else
					openButton.removeEventListener(MouseEvent.ROLL_OVER, openButton_rollOverHandler);
			}
		}
		/**
		 * 添加触发下拉列表关闭的事件监听
		 */	
		private function addCloseTriggers():void
		{
			if (DomGlobals.stage)
			{
				if (isNaN(rollOverOpenDelay))
				{
					DomGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
					DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					DomGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
				}
				
				addCloseOnResizeTrigger();
				
				if (openButton && openButton.stage)
					DomGlobals.stage.addEventListener(MouseEvent.MOUSE_WHEEL, stage_mouseWheelHandler);
			}
		}
		
		/**
		 * 移除触发下拉列表关闭的事件监听
		 */	
		private function removeCloseTriggers():void
		{
			if (DomGlobals.stage)
			{
				if (isNaN(rollOverOpenDelay))
				{
					DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
					DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
					DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
					DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
				}
				
				removeCloseOnResizeTrigger();
				
				if (openButton && openButton.stage)
					DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stage_mouseWheelHandler);
			}
		} 
		/**
		 * 添加舞台尺寸改变的事件监听
		 */	
		private function addCloseOnResizeTrigger():void
		{
			if (closeOnResize)
				DomGlobals.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
		}
		/**
		 * 移除舞台尺寸改变的事件监听
		 */
		private function removeCloseOnResizeTrigger():void
		{
			if (closeOnResize)
				DomGlobals.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
		/**
		 * 检查鼠标是否在DropDown或者openButton区域内。
		 */		
		private function isTargetOverDropDownOrOpenButton(target:DisplayObject):Boolean
		{
			if (target)
			{
				
				if (openButton && openButton.contains(target))
					return true;
				if (hitAreaAdditions != null)
				{
					for (var i:int = 0;i<hitAreaAdditions.length;i++)
					{
						if (hitAreaAdditions[i] == target ||
							((hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(hitAreaAdditions[i]).contains(target as DisplayObject)))
							return true;
					}
				}
				if (dropDown is DisplayObjectContainer)
				{
					if (DisplayObjectContainer(dropDown).contains(target))
						return true;
				}
				else
				{
					if (target == dropDown)
						return true;
				}
			}
			
			return false;
		}
		/**
		 * 打开下拉列表
		 */		
		public function openDropDown():void
		{
			openDropDownHelper();
		}  
		/**
		 * 执行打开下拉列表
		 */		
		private function openDropDownHelper():void
		{
			if (!isOpen)
			{
				addCloseTriggers();
				
				_isOpen = true;
				
				if (openButton)
					openButton.keepDown(true); 
				
				dispatchEvent(new UIEvent(UIEvent.OPEN));
			}
		}
		/**
		 * 关闭下拉列表
		 */	
		public function closeDropDown(commit:Boolean):void
		{
			if (isOpen)
			{   
				_isOpen = false;
				if (openButton)
					openButton.keepDown(false);
				
				var dde:UIEvent = new UIEvent(UIEvent.CLOSE, false, true);
				
				if (!commit)
					dde.preventDefault();
				
				dispatchEvent(dde);
				
				removeCloseTriggers();
			}
		}   
		/**
		 * openButton上按下鼠标事件
		 */		
		dx_internal function openButton_buttonDownHandler(event:Event):void
		{
			if (isOpen)
				closeDropDown(true);
			else
			{
				mouseIsDown = true;
				openDropDownHelper();
			}
		}
		/**
		 * openButton上鼠标经过事件
		 */		
		dx_internal function openButton_rollOverHandler(event:MouseEvent):void
		{
			if (rollOverOpenDelay == 0)
				openDropDownHelper();
			else
			{
				openButton.addEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
				rollOverOpenDelayTimer = new Timer(rollOverOpenDelay, 1);
				rollOverOpenDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rollOverDelay_timerCompleteHandler);
				rollOverOpenDelayTimer.start();
			}
		}
		/**
		 * openButton上鼠标移出事件
		 */	
		private function openButton_rollOutHandler(event:MouseEvent):void
		{
			if (rollOverOpenDelayTimer && rollOverOpenDelayTimer.running)
			{
				rollOverOpenDelayTimer.stop();
				rollOverOpenDelayTimer = null;
			}
			
			openButton.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
		}
		/**
		 * 到达鼠标移入等待延迟打开的时间。
		 */		
		private function rollOverDelay_timerCompleteHandler(event:TimerEvent):void
		{
			openButton.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
			rollOverOpenDelayTimer = null;
			
			openDropDownHelper();
		}
		/**
		 * 舞台上鼠标按下事件
		 */		
		dx_internal function stage_mouseDownHandler(event:Event):void
		{
			
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
			
			if (!dropDown || 
				(dropDown && 
					(event.target == dropDown 
						|| (dropDown is DisplayObjectContainer && 
							!DisplayObjectContainer(dropDown).contains(DisplayObject(event.target))))))
			{
				
				var target:DisplayObject = event.target as DisplayObject;
				if (openButton && target && openButton.contains(target))
					return;
				
				if (hitAreaAdditions != null)
				{
					for (var i:int = 0;i<hitAreaAdditions.length;i++)
					{
						if (hitAreaAdditions[i] == event.target ||
							((hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(hitAreaAdditions[i]).contains(event.target as DisplayObject)))
							return;
					}
				}
				
				closeDropDown(true);
			} 
		}
		/**
		 * 舞台上鼠标移动事件
		 */		
		dx_internal function stage_mouseMoveHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			
			if (containedTarget)
				return;
			if (event is MouseEvent && MouseEvent(event).buttonDown)
			{
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
				DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler);
				return;
			}
			closeDropDown(true);
		}
		/**
		 * 舞台上鼠标弹起事件
		 */		
		dx_internal function stage_mouseUpHandler_noRollOverOpenDelay(event:Event):void
		{
			
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
		}
		/**
		 * 舞台上鼠标弹起事件
		 */	
		dx_internal function stage_mouseUpHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			if (containedTarget)
			{
				DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
				DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
				return;
			}
			
			closeDropDown(true);
		}
		/**
		 * 舞台尺寸改变事件
		 */		
		dx_internal function stage_resizeHandler(event:Event):void
		{
			closeDropDown(true);
		}    
		/**
		 * 舞台上鼠标滚轮事件
		 */		
		private function stage_mouseWheelHandler(event:MouseEvent):void
		{
			
			if (dropDown && !(DisplayObjectContainer(dropDown).contains(DisplayObject(event.target)) && event.isDefaultPrevented()))
				closeDropDown(false);
		}
	}
}
