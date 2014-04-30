package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 移动事件
	 * @author DOM
	 */
	public class MoveEvent extends Event
	{
		public static const MOVE:String = "move";
		
		public function MoveEvent(type:String, oldX:Number = NaN, oldY:Number = NaN, 
								  bubbles:Boolean = false,
								  cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.oldX = oldX;
			this.oldY = oldY;
		}
		
		/**
		 * 旧的组件X
		 */
		public var oldX:Number;
		
		/**
		 * 旧的组件Y
		 */
		public var oldY:Number;

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new MoveEvent(type, oldX, oldY, bubbles, cancelable);
		}
	}
}