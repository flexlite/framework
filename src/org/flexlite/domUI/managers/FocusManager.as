package org.flexlite.domUI.managers
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.flexlite.domUI.core.IUIComponent;
	
	/**
	 * 焦点管理器，设置了stage属性后，开始管理全局的焦点。
	 * @author DOM
	 */
	public class FocusManager implements IFocusManager
	{
		/**
		 * 构造函数
		 */		
		public function FocusManager()
		{
		}
		
		private var _stage:Stage;
		/**
		 * 舞台引用
		 */
		public function get stage():Stage
		{
			return _stage;
		}
		public function set stage(value:Stage):void
		{
			if(_stage==value)
				return;
			var s:Stage = _stage?stage:value;
			if(value)
			{
				s.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				s.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,mouseFocusChangeHandler);
				s.addEventListener(Event.ACTIVATE, activateHandler);
				s.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
			}
			else
			{
				s.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				s.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,mouseFocusChangeHandler);
				s.removeEventListener(Event.ACTIVATE, activateHandler);
				s.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
			}
			_stage = value;
		}

		/**
		 * 屏蔽FP原始的焦点处理过程
		 */		
		private function mouseFocusChangeHandler(event:FocusEvent):void
		{
			if (event.isDefaultPrevented())
				return;
			
			if (event.relatedObject is TextField)
			{
				var tf:TextField = event.relatedObject as TextField;
				if (tf.type == "input" || tf.selectable||
					(tf.htmlText&&tf.htmlText.indexOf("</A>")!=-1))
				{
					return;
				}
			}
			event.preventDefault();
		}
		
		/**
		 * 当前的焦点对象。
		 */		
		private var currentFocus:IUIComponent;
		/**
		 * 鼠标按下事件
		 */		
		private function onMouseDown(event:MouseEvent):void
		{
			var focus:IUIComponent = getTopLevelFocusTarget(InteractiveObject(event.target));
			if (!focus)
				return;
			
			if (focus != currentFocus && !(focus is TextField))
			{
				focus.setFocus();
			}
		}
		/**
		 * 焦点改变时更新currentFocus
		 */		
		private function focusInHandler(event:FocusEvent):void
		{
			currentFocus = getTopLevelFocusTarget(InteractiveObject(event.target));
		}
		/**
		 * 获取鼠标按下点的焦点对象
		 */		
		private function getTopLevelFocusTarget(target:InteractiveObject):IUIComponent
		{
			while(target)
			{
				if (target is IUIComponent&&
					IUIComponent(target).focusEnabled&&
					IUIComponent(target).enabled)
				{
					return target as IUIComponent;
				}
				target = target.parent;
			}
			return null;
		}
		
		/**
		 * 窗口激活时重新设置焦点
		 */		
		private function activateHandler(event:Event):void
		{
			if(currentFocus)
				currentFocus.setFocus();
		}
	}
}