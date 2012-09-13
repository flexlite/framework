package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 视图状态改变事件
	 * @author DOM
	 */	
	public class StateChangeEvent extends Event
	{
		/**
		 * 当前视图状态已经改变 
		 */		
		public static const CURRENT_STATE_CHANGE:String = "currentStateChange";
		/**
		 * 当前视图状态即将改变
		 */		
		public static const CURRENT_STATE_CHANGING:String = "currentStateChanging";
		
		public function StateChangeEvent(type:String, bubbles:Boolean = false,
										 cancelable:Boolean = false,
										 oldState:String = null,
										 newState:String = null)
		{
			super(type, bubbles, cancelable);
			
			this.oldState = oldState;
			this.newState = newState;
		}
		/**
		 * 组件正在进入的视图状态的名称。
		 */		
		public var newState:String;
		
		/**
		 * 组件正在退出的视图状态的名称。
		 */		
		public var oldState:String;
		
		override public function clone():Event
		{
			return new StateChangeEvent(type, bubbles, cancelable,
				oldState, newState);
		}
	}
	
}
