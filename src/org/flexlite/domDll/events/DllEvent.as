package org.flexlite.domDll.events
{
	import flash.events.Event;
	
	
	/**
	 * 资源管理器事件
	 * @author DOM
	 */
	public class DllEvent extends Event
	{
		/**
		 * 构造函数
		 */		
		public function DllEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}