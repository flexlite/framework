package org.flexlite.domUI.events
{
	import flash.events.Event;
	/**
	 * 窗口关闭事件
	 * @author DOM
	 */	
	public class CloseEvent extends Event
	{
		public static const CLOSE:String = "close";
		/**
		 * 构造函数
		 */		
		public function CloseEvent(type:String, bubbles:Boolean = false,
								   cancelable:Boolean = false, detail:Object = -1)
		{
			super(type, bubbles, cancelable);
			
			this.detail = detail;
		}
		/**
		 * 触发关闭事件的细节。某些窗口组件用此属性来区分窗口中被点击的按钮。
		 */		
		public var detail:Object;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CloseEvent(type, bubbles, cancelable, detail);
		}
	}
	
}
