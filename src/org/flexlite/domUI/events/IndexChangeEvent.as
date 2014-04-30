package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 索引改变事件
	 * @author DOM
	 */	
	public class IndexChangeEvent extends Event
	{
		/**
		 * 指示索引已更改 
		 */		
		public static const CHANGE:String = "change";
		
		/**
		 * 指示索引即将更改,可以通过调用preventDefault()方法阻止索引发生更改
		 */
		public static const CHANGING:String = "changing";
		
		public function IndexChangeEvent(type:String, bubbles:Boolean = false,
										 cancelable:Boolean = false,
										 oldIndex:int = -1,
										 newIndex:int = -1)
		{
			super(type, bubbles, cancelable);
			
			this.oldIndex = oldIndex;
			this.newIndex = newIndex;
		}
		
		/**
		 * 进行更改之后的从零开始的索引。
		 */
		public var newIndex:int;
		
		/**
		 * 进行更改之前的从零开始的索引。
		 */		
		public var oldIndex:int;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new IndexChangeEvent(type, bubbles, cancelable,
				oldIndex, newIndex);
		}
	}
}