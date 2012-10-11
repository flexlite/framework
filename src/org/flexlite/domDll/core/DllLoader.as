package org.flexlite.domDll.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	
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
			initLoaders();
		}
		/**
		 * 最大并发加载数 
		 */		
		private var thread:int = 2;
		/**
		 * 空闲的URLLoader实例 
		 */		
		private var freeLoaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		/**
		 * 初始化URLLoader
		 */		
		private function initLoaders():void
		{
			for (var i:int = 0; i < thread; i++) 
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.addEventListener(Event.COMPLETE,onComplete);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
				freeLoaders.push(urlLoader);
			}
			
		}
		/**
		 * 当前正在加载的队列
		 */		
		private var currentLoadList:Vector.<DllItem>;
		/**
		 * 当前队列加载项的个数
		 */		
		private var groupTotal:int;
		/**
		 * 已经加载完成的项个数
		 */		
		private var loadedIndex:int;
		/**
		 * 当前队列总文件大小
		 */		
		private var totalSize:int;
		
		private var loadedSize:int;
		/**
		 * 开始加载一组文件
		 * @param list
		 */		
		public function loadGroup(list:Vector.<DllItem>):void
		{
			if(!list||list.length==0)
				return;
			totalSize = 0;
			loadedSize = 0;
			for each(var dllItem:DllItem in list)
			{
				dllItem.inGroupLoading = true;
				totalSize += dllItem.size;
			}
			currentLoadList = list;
			groupTotal = list.length;
			loadedIndex = 0;
			next();
		}
		/**
		 * 当前的项加载队列
		 */		
		private var itemLoadList:Vector.<DllItem> = new Vector.<DllItem>();
		/**
		 * 加载一个文件
		 * @param dllItem 要加载的项
		 */		
		public function loadItem(dllItem:DllItem):void
		{
			itemLoadList.push(dllItem);
			next();
		}
		/**
		 * 加载项字典
		 */		
		private var dllItemDic:Dictionary = new Dictionary;
		/**
		 * 加载下一项
		 */		
		private function next():void
		{
			if(!currentLoadList||currentLoadList.length==0)
				currentLoadList = itemLoadList;
			if(currentLoadList.length==0)
				return;
			while(freeLoaders.length>0)
			{
				if(currentLoadList.length==0)
					break;
				var loader:URLLoader = freeLoaders.shift();
				var dllItem:DllItem = currentLoadList.shift();
				dllItemDic[loader] = dllItem;
				loader.load(new URLRequest(dllItem.url));
			}
		}
		/**
		 * 解析器字典类
		 */		
		private var analyzeDic:Dictionary = new Dictionary;
		/**
		 * 一项加载完成
		 */		
		private function onComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			freeLoaders.push(loader);
			var dllItem:DllItem = dllItemDic[loader];
			delete dllItemDic[loader];
			var data:ByteArray = loader.data as ByteArray;
			var analyze:IFileLib = analyzeDic[dllItem.type];
			if(!analyze)
			{
				analyze = analyzeDic[dllItem.type] = Injector.getInstance(IFileLib,dllItem.type);
			}
			analyze.addFileBytes(data,dllItem.name);
			next();
		}
		/**
		 * 加载失败
		 */		
		private function onError(event:Event):void
		{
			trace("素材加载失败::::::",event);
			var loader:URLLoader = event.target as URLLoader;
			freeLoaders.push(loader);
			var dllItem:DllItem = dllItemDic[loader];
			delete dllItemDic[loader];
			if(dllItem.compFunc!=null)
				dllItem.compFunc(dllItem);
			if(dllItem.inGroupLoading)
			{
				loadedIndex++;
				loadedSize += dllItem.size;
				checkAllComp();
			}
			next();
		}
		
		/**
		 * 文件字节流解析完成
		 */		
		private function onAnalyzeComp(data:ByteArray):void
		{
			var dllItem:DllItem = dllItemDic[data];
			delete dllItemDic[data];
			if(dllItem.compFunc!=null)
				dllItem.compFunc(dllItem);
			if(dllItem.inGroupLoading)
			{
				loadedIndex++;
				loadedSize += dllItem.size;
				checkAllComp();
			}
		}
		/**
		 * 检查当前的加载队列是否全部完成了。
		 */		
		private function checkAllComp():void
		{
			var progressEvent:ProgressEvent = 
				new ProgressEvent(ProgressEvent.PROGRESS,false,false,loadedSize,totalSize);
			dispatchEvent(progressEvent);
			if(loadedIndex>=groupTotal)
			{
				loadedIndex = 0;
				groupTotal = 0;
				var event:Event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
		}
	}
}