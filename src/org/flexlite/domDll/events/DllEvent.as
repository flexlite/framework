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
		 * loading组资源加载进度事件。
		 */		
		public static const LOADING_PROGRESS:String = "loadingProgress";
		/**
		 * loading组资源加载完成事件
		 */		
		public static const LOADING_COMPLETE:String = "loadingComplete";
		/**
		 * preload组资源加载进度事件
		 */		
		public static const PRELOAD_PROGRESS:String = "preloadProgress";
		/**
		 * preload组资源加载完成事件
		 */		
		public static const PRELOAD_COMPLETE:String = "preloadComplete";
		/**
		 * 构造函数
		 */		
		public function DllEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * 已经加载的字节数
		 */		
		public var bytesLoaded:Number=0;
		/**
		 * 要加载的总字节数
		 */		
		public var bytesTotal:Number=0;
	}
}