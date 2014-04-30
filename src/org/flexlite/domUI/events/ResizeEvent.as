package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 尺寸改变事件
	 * @author DOM
	 */
	public class ResizeEvent extends Event
	{
		public static const RESIZE:String = "resize";
		
		public function ResizeEvent(type:String,oldWidth:Number = NaN, oldHeight:Number = NaN,
									bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.oldWidth = oldWidth;
			this.oldHeight = oldHeight;
		}
		
		/**
		 * 旧的高度 
		 */
		public var oldHeight:Number;
		
		/**
		 * 旧的宽度 
		 */
		public var oldWidth:Number;

		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ResizeEvent(type, oldWidth, oldHeight, bubbles, cancelable);
		}
	}
}