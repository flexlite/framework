package org.flexlite.domDll.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDll.events.DllEvent;
	
	use namespace dx_internal;
	/**
	 * 队列加载进度事件
	 */	
	[Event(name="progress",type="flash.events.ProgressEvent")]
	/**
	 * 队列加载完成事件
	 */	
	[Event(name="complete",type="flash.events.Event")]
	/**
	 * 一个加载项加载结束事件，可能是加载成功也可能是加载失败。
	 */	
	[Event(name="itemLoadFinished",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 多文件队列加载器
	 * @author DOM
	 */
	public class DllLoader extends EventDispatcher
	{
		/**
		 * 构造函数
		 * @param thread 最大同时加载数
		 */		
		public function DllLoader(thread:int=2)
		{
			super();
			this.thread = thread;
		}
		
		private var _inGroupLoading:Boolean;
		/**
		 * 正在进行组加载的标志
		 */
		public function get inGroupLoading():Boolean
		{
			return _inGroupLoading;
		}

		/**
		 * 最大并发加载数 
		 */		
		private var thread:int = 2;
		
		/**
		 * 当前正在加载的队列
		 */		
		private var currentLoadList:Vector.<DllItem> = lazyLoadList;
		/**
		 * 当前队列总文件大小
		 */		
		private var totalSize:int;
		/**
		 * 已经加载的字节数
		 */		
		private var loadedSize:int;
		/**
		 * 当前组加载的项个数
		 */		
		private var groupTotal:int = 0;
		/**
		 * 已经加载的项个数
		 */		
		private var loadedIndex:int = 0;
		/**
		 * 开始加载一组文件
		 * @param list
		 */		
		public function loadGroup(list:Vector.<DllItem>):void
		{
			if(!list||list.length==0)
			{
				var event:Event = new Event(Event.COMPLETE);
				dispatchEvent(event);
				return;
			}
			totalSize = 0;
			loadedSize = 0;
			_inGroupLoading = true;
			for each(var dllItem:DllItem in list)
			{
				dllItem.inGroupLoading = true;
				dllItem.bytesLoaded = 0;
				totalSize += dllItem.size;
			}
			currentLoadList = list;
			groupTotal = list.length;
			loadedIndex = 0;
			next();
		}
		/**
		 * 延迟加载队列
		 */		
		private var lazyLoadList:Vector.<DllItem> = new Vector.<DllItem>();
		/**
		 * 加载一个文件
		 * @param dllItem 要加载的项
		 */		
		public function loadItem(dllItem:DllItem):void
		{
			lazyLoadList.push(dllItem);
			dllItem.inGroupLoading = false;
			next();
		}
		/**
		 * 资源解析库字典类
		 */		
		private var resLoaderDic:Dictionary = new Dictionary;
		/**
		 * 正在加载的线程计数
		 */		
		private var loadingCount:int = 0;
		/**
		 * 加载下一项
		 */		
		private function next():void
		{
			if(currentLoadList!=lazyLoadList&&currentLoadList.length==0)
			{
				currentLoadList = lazyLoadList;
			}
			if(currentLoadList.length==0)
				return;
			while(currentLoadList.length>0)
			{
				if(loadingCount>=thread)
					break;
				loadingCount++;
				var dllItem:DllItem = currentLoadList.shift();
				dllItem.startTime = getTimer();
				if(dllItem.loaded)
				{
					onItemProgress(dllItem.size,dllItem);
					onItemComplete(dllItem);
				}
				else
				{
					var resLoader:IResLoader = resLoaderDic[dllItem.type];
					if(!resLoader)
					{
						resLoader = resLoaderDic[dllItem.type] = Injector.getInstance(IResLoader,dllItem.type);
					}
					resLoader.loadFile(dllItem,onItemComplete,onItemProgress);
				}
			}
		}
		/**
		 * 加载进度更新
		 */		
		private function onItemProgress(bytesLoaded:int,dllItem:DllItem):void
		{
			loadedSize += bytesLoaded - dllItem.bytesLoaded;
			dllItem.bytesLoaded = bytesLoaded;
			var progressEvent:ProgressEvent = 
				new ProgressEvent(ProgressEvent.PROGRESS,false,false,loadedSize,totalSize);
			dispatchEvent(progressEvent);
		}
		/**
		 * 加载结束
		 */		
		private function onItemComplete(dllItem:DllItem):void
		{
			loadingCount--;
			dllItem._loadTime = getTimer()-dllItem.startTime;
			var itemLoadEvent:DllEvent = new DllEvent(DllEvent.ITEM_LOAD_FINISHED);
			itemLoadEvent.dllItem = dllItem;
			dispatchEvent(itemLoadEvent);
			if(dllItem.compFunc!=null)
				dllItem.compFunc(dllItem);
			if(dllItem.inGroupLoading)
			{
				loadedIndex++;
				if(!dllItem.loaded)
					loadedSize += dllItem.size;
				var progressEvent:ProgressEvent = 
					new ProgressEvent(ProgressEvent.PROGRESS,false,false,loadedSize,totalSize);
				dispatchEvent(progressEvent);
				if(loadedIndex==groupTotal)
				{
					_inGroupLoading = false;
					var event:Event = new Event(Event.COMPLETE);
					dispatchEvent(event);
				}
			}
			next();
		}
	}
}