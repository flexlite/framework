<<<<<<< HEAD
package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * IMoveClip播放事件
	 * @author DOM
	 */
	public class MoveClipPlayEvent extends Event
	{
		/**
		 * IMoveClip一次播放完成。
		 */		
		public static const PLAY_COMPLETE:String = "playComplete"
			
		public function MoveClipPlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
=======
package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * IMoveClip播放事件
	 * @author DOM
	 */
	public class MoveClipPlayEvent extends Event
	{
		/**
		 * IMoveClip一次播放完成。
		 */		
		public static const PLAY_COMPLETE:String = "playComplete"
			
		public function MoveClipPlayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
>>>>>>> master
}