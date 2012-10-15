package org.flexlite.domDll.events
{
	import flash.events.Event;
	
	import org.flexlite.domDll.core.DllItem;
	
	
	/**
	 * 资源管理器事件
	 * @author DOM
	 */
	public class DllEvent extends Event
	{
		/**
		 * 一个加载项加载结束事件，可能是加载成功也可能是加载失败。
		 */		
		public static const ITEM_LOAD_FINISHED:String = "itemLoadFinished";
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
		/**
		 * 一次加载项加载结束的项信息对象
		 */		
		public var dllItem:DllItem;
		
		override public function clone():Event
		{
			var event:DllEvent = new DllEvent(type,bubbles,cancelable);
			event.bytesLoaded = bytesLoaded;
			event.bytesTotal = bytesTotal;
			event.dllItem = dllItem;
			return event;
		}
	}
}