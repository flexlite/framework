<<<<<<< HEAD
package org.flexlite.domUI.components.supportClasses
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.events.Event;
	
	use namespace dx_internal;
	
	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 切换按钮组件基类
	 * @author DOM
	 */	
	public class ToggleButtonBase extends ButtonBase
	{
		public function ToggleButtonBase()
		{
			super();
		}
		
		private var _selected:Boolean;
		/**
		 * 按钮处于按下状态时为 true，而按钮处于弹起状态时为 false。
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value == _selected)
				return;
			
			_selected = value;            
			dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			if (!selected)
				return super.getCurrentSkinState();
			else
				return super.getCurrentSkinState() + "AndSelected";
		}
		
		override protected function buttonReleased():void
		{
			super.buttonReleased();
			
			selected = !selected;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
}
=======
package org.flexlite.domUI.components.supportClasses
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.events.Event;
	
	use namespace dx_internal;
	
	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 切换按钮组件基类
	 * @author DOM
	 */	
	public class ToggleButtonBase extends ButtonBase
	{
		public function ToggleButtonBase()
		{
			super();
		}
		
		private var _selected:Boolean;
		/**
		 * 按钮处于按下状态时为 true，而按钮处于弹起状态时为 false。
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value == _selected)
				return;
			
			_selected = value;            
			dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			if (!selected)
				return super.getCurrentSkinState();
			else
				return super.getCurrentSkinState() + "AndSelected";
		}
		
		override protected function buttonReleased():void
		{
			super.buttonReleased();
			
			selected = !selected;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
