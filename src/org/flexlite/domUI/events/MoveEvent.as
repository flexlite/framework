<<<<<<< HEAD
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

		override public function clone():Event
		{
			return new MoveEvent(type, oldX, oldY, bubbles, cancelable);
		}
	}
=======
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

		override public function clone():Event
		{
			return new MoveEvent(type, oldX, oldY, bubbles, cancelable);
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}