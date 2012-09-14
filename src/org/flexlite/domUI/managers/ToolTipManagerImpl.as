package org.flexlite.domUI.managers
{
	
	import org.flexlite.domUI.components.ToolTip;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IToolTip;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.ToolTipEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * 工具提示管理器实现类
	 * @author DOM
	 */	
	public class ToolTipManagerImpl extends EventDispatcher
	{
		
		public function ToolTipManagerImpl()
		{
			super();
		}
		/**
		 * 初始化完成的标志
		 */		
		private var initialized:Boolean = false;
		/**
		 * 用于鼠标经过一个对象后计时一段时间开始显示ToolTip
		 */		
		private var showTimer:Timer;
		/**
		 * 用于ToolTip显示后计时一段时间自动隐藏。
		 */		
		private var hideTimer:Timer;
		/**
		 * 用于当已经显示了一个ToolTip，鼠标快速经过多个显示对象时立即切换显示ToolTip。
		 */		
		private var scrubTimer:Timer;
		/**
		 * 当前的toolTipData
		 */		
		private var currentTipData:Object;
		/**
		 * 上一个ToolTip显示对象
		 */		
		private var previousTarget:IToolTipManagerClient;
		
		private var _reuseToolTip:Boolean = true;
		
		/**
		 * 是否复用ToolTip实例,若为true,则每个ToolTipClass只创建一个实例缓存于管理器，
		 * 回收时需要手动调用destroyToolTip(toolTipClass)方法。
		 * 若为false，则每次都重新创建新的ToolTip实例。 默认为true。
		 */
		public function get reuseToolTip():Boolean
		{
			return _reuseToolTip;
		}

		public function set reuseToolTip(value:Boolean):void
		{
			_reuseToolTip = value;
		}
		
		private var toolTipCache:Dictionary = new Dictionary;
		/**
		 * 销毁指定类对应的ToolTip实例。
		 * @param toolTipClass 要移除的ToolTip类定义
		 * @return 是否移除成功,若不存在该实例，返回false。
		 */		
		public function destroyToolTip(toolTipClass:Class):Boolean
		{
			if(toolTipCache[toolTipClass]!==undefined)
			{
				delete toolTipCache[toolTipClass];
				return true;
			}
			return false;
		}
		
		private var _currentTarget:IToolTipManagerClient;
		/**
		 * 当前的IToolTipManagerClient组件
		 */		
		public function get currentTarget():IToolTipManagerClient
		{
			return _currentTarget;
		}
		
		public function set currentTarget(value:IToolTipManagerClient):void
		{
			_currentTarget = value;
		}
		
		private var _currentToolTip:DisplayObject;
		/**
		 * 当前的ToolTip显示对象；如果未显示ToolTip，则为 null。
		 */		
		public function get currentToolTip():IToolTip
		{
			return _currentToolTip as IToolTip;
		}
		
		public function set currentToolTip(value:IToolTip):void
		{
			_currentToolTip = value as DisplayObject;
		}
		
		private var _enabled:Boolean = true;
		/**
		 * 如果为 true，则当用户将鼠标指针移至组件上方时，ToolTipManager 会自动显示工具提示。
		 * 如果为 false，则不会显示任何工具提示。
		 */		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		private var _hideDelay:Number = 10000; 
		/**
		 * 自工具提示出现时起，ToolTipManager要隐藏此提示前所需等待的时间量（以毫秒为单位）。默认值：10000。
		 */		
		public function get hideDelay():Number 
		{
			return _hideDelay;
		}
		
		public function set hideDelay(value:Number):void
		{
			_hideDelay = value;
		}
		
		private var _scrubDelay:Number = 100; 
		/**
		 * 当第一个ToolTip显示完毕后，若在此时间间隔内快速移动到下一个组件上，就直接显示ToolTip而不延迟一段时间。默认值：100。
		 */		
		public function get scrubDelay():Number 
		{
			return _scrubDelay;
		}
		
		public function set scrubDelay(value:Number):void
		{
			_scrubDelay = value;
		}
		
		private var _toolTipClass:Class = ToolTip;
		/**
		 * 全局默认的创建工具提示要用到的类。
		 */		
		public function get toolTipClass():Class 
		{
			return _toolTipClass;
		}
		
		public function set toolTipClass(value:Class):void
		{
			_toolTipClass = value;
		}
		/**
		 * 初始化
		 */		
		private function initialize():void
		{
			if (!showTimer)
			{
				showTimer = new Timer(0, 1);
				showTimer.addEventListener(TimerEvent.TIMER,
					showTimer_timerHandler);
			}
			
			if (!hideTimer)
			{
				hideTimer = new Timer(0, 1);
				hideTimer.addEventListener(TimerEvent.TIMER,
					hideTimer_timerHandler);
			}
			
			if (!scrubTimer)
				scrubTimer = new Timer(0, 1);
			
			initialized = true;
		}
		/**
		 * 注册需要显示ToolTip的组件
		 * @param target 目标组件
		 * @param oldToolTip 之前的ToolTip数据
		 * @param newToolTip 现在的ToolTip数据
		 */		
		dx_internal function registerToolTip(target:DisplayObject,
										oldToolTip:Object,
										newToolTip:Object):void
		{
			if (!oldToolTip && newToolTip)
			{
				target.addEventListener(MouseEvent.MOUSE_OVER,
					toolTipMouseOverHandler);
				target.addEventListener(MouseEvent.MOUSE_OUT,
					toolTipMouseOutHandler);
				if (mouseIsOver(target))
					showImmediately(target);
			}
			else if (oldToolTip && !newToolTip)
			{
				target.removeEventListener(MouseEvent.MOUSE_OVER,
					toolTipMouseOverHandler);
				target.removeEventListener(MouseEvent.MOUSE_OUT,
					toolTipMouseOutHandler);
				if (mouseIsOver(target))
					hideImmediately(target);
			}
		}
		/**
		 * 检测鼠标是否处于目标对象上
		 */		
		private function mouseIsOver(target:DisplayObject):Boolean
		{
			if (!target || !target.stage)
				return false;
			if ((target.stage.mouseX == 0)	 && (target.stage.mouseY == 0))
				return false;
			
			if (target is ILayoutManagerClient && !ILayoutManagerClient(target).initialized)
				return false;
			
			return target.hitTestPoint(target.stage.mouseX,
				target.stage.mouseY, true);
		}
		/**
		 * 立即显示ToolTip标志
		 */		
		private var showImmediatelyFlag:Boolean = false;
		/**
		 * 立即显示目标组件的ToolTip
		 */		
		private function showImmediately(target:DisplayObject):void
		{
			showImmediatelyFlag = true;
			checkIfTargetChanged(target);
			showImmediatelyFlag = false;
		}
		/**
		 * 立即隐藏目标组件的ToolTip
		 */		
		private function hideImmediately(target:DisplayObject):void
		{
			checkIfTargetChanged(null);
		}
		/**
		 * 检查当前的鼠标下的IToolTipManagerClient组件是否发生改变
		 */		
		private function checkIfTargetChanged(displayObject:DisplayObject):void
		{
			if (!enabled)
				return;
			
			findTarget(displayObject);
			
			if (currentTarget != previousTarget)
			{
				targetChanged();
				previousTarget = currentTarget;
			}
		}
		/**
		 * 向上遍历查询，直到找到第一个当前鼠标下的IToolTipManagerClient组件。
		 */		
		private function findTarget(displayObject:DisplayObject):void
		{
			while (displayObject)
			{
				if (displayObject is IToolTipManagerClient)
				{
					currentTipData = IToolTipManagerClient(displayObject).toolTip;
					if (currentTipData != null)
					{
						currentTarget = displayObject as IToolTipManagerClient;
						return;
					}
				}
				
				displayObject = displayObject.parent;
			}
			
			currentTipData = null;
			currentTarget = null;
		}

		/**
		 * 当前的IToolTipManagerClient组件发生改变
		 */		
		private function targetChanged():void
		{
			
			if (!initialized)
				initialize()
			
			var event:ToolTipEvent;
			
			if (previousTarget && currentToolTip)
			{
				if (currentToolTip is IToolTip)
				{
					event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
					event.toolTip = currentToolTip;
					previousTarget.dispatchEvent(event);
				}
				else
				{
					if (hasEventListener(ToolTipEvent.TOOL_TIP_HIDE))
						dispatchEvent(new Event(ToolTipEvent.TOOL_TIP_HIDE));
				}
			}   
			
			reset();
			
			if (currentTarget)
			{
				
				if (currentTipData==null||currentTipData == "")
					return;
				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
				currentTarget.dispatchEvent(event);
				
				if (currentTarget.toolTipShowDelay==0||showImmediatelyFlag||scrubTimer.running)
				{
					
					createTip();
					initializeTip();
					positionTip();
					showTip();
				}
				else
				{
					showTimer.delay = currentTarget.toolTipShowDelay;
					showTimer.start();
				}
			}
		}
		/**
		 * 创建ToolTip显示对象
		 */		
		private function createTip():void
		{
			var tipClass:Class = currentTarget.toolTipClass;
			if(!tipClass)
			{
				tipClass = toolTipClass;
			}
			if(_reuseToolTip)
			{
				if(toolTipCache[tipClass])
				{
					currentToolTip = toolTipCache[tipClass];
				}
				else 
				{
					currentToolTip = new tipClass();
					toolTipCache[tipClass] = currentToolTip;
				}
			}
			else
			{
				currentToolTip = new tipClass();
			}
			
			currentToolTip.visible = false;
			
			DomGlobals.stage.addChild(currentToolTip as DisplayObject);
		}
		/**
		 * 初始化ToolTip显示对象
		 */		
		private function initializeTip():void
		{
			
			if (currentToolTip is IToolTip)
				IToolTip(currentToolTip).toolTipData = currentTipData;
			
			sizeTip(currentToolTip);
		}
		/**
		 * 设置ToolTip大小
		 */		
		private function sizeTip(toolTip:IToolTip):void
		{
			if (toolTip is IInvalidating)
				IInvalidating(toolTip).validateNow();
			toolTip.setActualSize(toolTip.preferredWidth,toolTip.preferredHeight);
		}
		/**
		 * 设置ToolTip位置
		 */		
		private function positionTip():void
		{
			var x:Number;
			var y:Number;
			
			var screenWidth:Number = DomGlobals.stage.stageWidth;
			var screenHeight:Number = DomGlobals.stage.stageHeight;
			
			var stage:Stage = DomGlobals.stage;
			x = stage.mouseX + 10; 
			y = stage.mouseY + 20;
			var toolTipWidth:Number = currentToolTip.width;
			if (x + toolTipWidth > screenWidth)
			{
				x = screenWidth - toolTipWidth;
			}
			var toolTipHeight:Number = currentToolTip.height;
			if (y + toolTipHeight > screenHeight)
				y = screenHeight - toolTipHeight;
			
			var pos:Point = new Point(x, y);
			pos = stage.localToGlobal(pos);

			currentToolTip.x = pos.x;
			currentToolTip.y = pos.y;
		}
		/**
		 * 显示ToolTip
		 */		
		private function showTip():void
		{
			var event:ToolTipEvent =
				new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
			event.toolTip = currentToolTip;
			currentTarget.dispatchEvent(event);
			
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN,
				stage_mouseDownHandler);
			currentToolTip.visible = true;
		}
		/**
		 * 隐藏ToolTip
		 */		
		private function hideTip():void
		{
			if (previousTarget)
			{
				var event:ToolTipEvent =
					new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
				event.toolTip = currentToolTip;
				previousTarget.dispatchEvent(event);
			}
			
			if (currentToolTip)
				currentToolTip.visible = false;
			if (previousTarget)
			{
				DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_DOWN,
					stage_mouseDownHandler);
			}
		}
		
		/**
		 * 移除当前的ToolTip对象并重置所有计时器。
		 */		
		private function reset():void
		{
			
			showTimer.reset();
			hideTimer.reset();
			if (currentToolTip)
			{
				DomGlobals.stage.removeChild(currentToolTip as DisplayObject);
				currentToolTip = null;
				
				scrubTimer.delay = scrubDelay;
				scrubTimer.reset();
				if (scrubDelay > 0)
				{
					scrubTimer.delay = scrubDelay;
					scrubTimer.start();
				}
			}
		}
		/**
		 * 使用指定的ToolTip数据,创建默认ToolTip类的实例，然后在舞台坐标中的指定位置显示此实例。 
		 * @param toolTipData ToolTip数据
		 * @param x 舞台坐标x
		 * @param y 舞台坐标y
		 */		
		public function createToolTip(toolTipData:String, x:Number, y:Number):IToolTip
		{
			var toolTip:IToolTip = new toolTipClass() as IToolTip;
			
			DomGlobals.stage.addChild(toolTip as DisplayObject);
			
			toolTip.toolTipData = toolTipData;
			
			sizeTip(toolTip);
			
			toolTip.x = x;
			toolTip.y = y;
			return toolTip;
		}
		
		/**
		 * 鼠标经过IToolTipManagerClient组件
		 */		
		private function toolTipMouseOverHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(DisplayObject(event.target));
		}
		/**
		 * 鼠标移出IToolTipManagerClient组件
		 */		
		private function toolTipMouseOutHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(event.relatedObject);
		}
		
		/**
		 * 显示ToolTip的计时器触发。
		 */		
		private function showTimer_timerHandler(event:TimerEvent):void
		{
			
			if (currentTarget)
			{
				createTip();
				initializeTip();
				positionTip();
				showTip();
			}
		}
		/**
		 * 隐藏ToolTip的计时器触发
		 */		
		private function hideTimer_timerHandler(event:TimerEvent):void
		{
			hideTip();
		}
		/**
		 * 舞台上按下鼠标
		 */		
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			reset();
		}
	}
	
}
