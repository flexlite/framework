package org.flexlite.domDll.core
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
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
		}
		/**
		 * 最大并发加载数 
		 */		
		private var thread:int = 2;
		/**
		 * 正在加载的loader个数
		 */		
		private var runningLoaders:int = 0;
		/**
		 * 空闲的URLLoader实例列表
		 */		
		private var urlLoaderList:Vector.<URLLoader> = new Vector.<URLLoader>();
		/**
		 * 空闲的loader实例列表
		 */		
		private var loaderList:Vector.<Loader> = new Vector.<Loader>();
		/**
		 * 获取一个loader
		 */		
		private function getLoader(type:String):Object
		{
			if(runningLoaders>=thread)
				return null;
			runningLoaders++;
			if(type==DllItem.TYPE_SWF)
			{
				if(loaderList.length>0)
				{
					return loaderList.shift();
				}
				else
				{
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
					return loader;
				}
			}
			else
			{
				if(urlLoaderList.length>0)
				{
					return urlLoaderList.shift();
				}
				else
				{
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					urlLoader.addEventListener(Event.COMPLETE,onComplete);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
					urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
					return urlLoader;
				}
			}
		}
		/**
		 * 释放一个loader
		 */		
		private function freeLoader(loader:Object):void
		{
			if(loader is URLLoader)
				urlLoaderList.push(loader);
			else 
				loaderList.push(loader);
			runningLoaders--;
		}
		
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
		 * 程序域加载参数
		 */		
		private var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
		/**
		 * 加载项字典
		 */		
		private var dllItemDic:Dictionary = new Dictionary;
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
				var loader:Object = getLoader(currentLoadList[0].type);
				if(!loader)
					break;
				var dllItem:DllItem = currentLoadList.shift();
				dllItemDic[loader] = dllItem;
				if(loader is URLLoader)
				{
					loader.load(new URLRequest(dllItem.url));
				}
				else
				{
					loader.load(new URLRequest(dllItem.url),loaderContext);
				}
			}
		}
		/**
		 * 解析器字典类
		 */		
		private var fileLibDic:Dictionary = new Dictionary;
		/**
		 * 一项加载完成
		 */		
		private function onComplete(event:Event):void
		{
			var loader:Object = event.target;
			var isUrlLoader:Boolean = true;
			if(loader is LoaderInfo)
			{
				isUrlLoader = false;
				loader = (loader as LoaderInfo).loader;
			}
			freeLoader(loader);
			var dllItem:DllItem = dllItemDic[loader];
			delete dllItemDic[loader];
			var data:Object;
			if(isUrlLoader)
				data = loader.data;
			else
				data = loader.content;
			var fileLib:IFileLib = fileLibDic[dllItem.type];
			if(!fileLib)
			{
				fileLib = fileLibDic[dllItem.type] = Injector.getInstance(IFileLib,dllItem.type);
			}
			fileLib.addFile(data,dllItem.name);
			onItemComplete(dllItem);
		}
		/**
		 * 加载失败
		 */		
		private function onError(event:Event):void
		{
			var loader:Object = event.target;
			if(loader is LoaderInfo)
			{
				loader = (loader as LoaderInfo).loader;
			}
			freeLoader(loader);
			var dllItem:DllItem = dllItemDic[loader];
			delete dllItemDic[loader];
			trace("资源加载失败::::::",dllItem);
			onItemComplete(dllItem);
		}
		
		/**
		 * 检查当前的加载队列是否全部完成了。
		 */		
		private function onItemComplete(dllItem:DllItem):void
		{
			if(dllItem.compFunc!=null)
				dllItem.compFunc(dllItem);
			if(dllItem.inGroupLoading)
			{
				loadedIndex++;
				loadedSize += dllItem.size;
				var progressEvent:ProgressEvent = 
					new ProgressEvent(ProgressEvent.PROGRESS,false,false,loadedSize,totalSize);
				dispatchEvent(progressEvent);
				if(loadedIndex>=groupTotal)
				{
					var event:Event = new Event(Event.COMPLETE);
					dispatchEvent(event);
				}
			}
			next();
		}
	}
}