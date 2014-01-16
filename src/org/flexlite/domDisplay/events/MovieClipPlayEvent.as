package org.flexlite.domDisplay.events
{
	import flash.events.Event;
	
	/**
	 * IMoveClip播放事件
	 * @author DOM
	 */
	public class MovieClipPlayEvent extends Event
	{
		/**
		 * IMoveClip一次播放完成。
		 */		
		public static const PLAY_COMPLETE:String = "playComplete"
			
		public function MovieClipPlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}