package org.flexlite.domDll.fileLib
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IFileLib;
	import org.flexlite.domUtils.Recycler;
	import org.flexlite.domUtils.SharedMap;
	
	/**
	 * SWF文件解析缓存库
	 * @author DOM
	 */
	public class SwfFileLib implements IFileLib
	{
		/**
		 * 构造函数
		 */		
		public function SwfFileLib()
		{
			super();
		}
		
		/**
		 * 字节流数据缓存字典
		 */		
		protected var swfDic:Dictionary = new Dictionary;
		/**
		 * 解码后对象的共享缓存表
		 */		
		protected var sharedMap:SharedMap = new SharedMap();
		/**
		 * 加载项字典
		 */		
		protected var dllItemDic:Dictionary = new Dictionary();
		
		/**
		 * 程序域加载参数
		 */		
		private var loaderContext:LoaderContext = 
			new LoaderContext(false,ApplicationDomain.currentDomain,null);
		
		public function loadFile(dllItem:DllItem,compFunc:Function,progressFunc:Function):void
		{
			if(swfDic[dllItem.name])
			{
				compFunc(dllItem);
				return;
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadFinish);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadFinish);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			dllItemDic[loader] = {item:dllItem,func:compFunc,progress:progressFunc};
			loader.load(new URLRequest(dllItem.url),loaderContext);
		}
		/**
		 * 加载进度事件
		 */		
		private function onProgress(event:ProgressEvent):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			var data:Object = dllItemDic[loader];
			var dllItem:DllItem = data.item;
			var progressFunc:Function = data.progress;
			progressFunc(event.bytesLoaded,dllItem);
		}
		/**
		 * 一项加载结束
		 */		
		private function onLoadFinish(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			var data:Object = dllItemDic[loader];
			delete dllItemDic[data];
			var dllItem:DllItem = data.item;
			var compFunc:Function = data.func;
			dllItem.loaded = (event.type==Event.COMPLETE);
			if(dllItem.loaded)
			{
				if(!swfDic[dllItem.name])
				{
					swfDic[dllItem.name] = loader;
				}
			}
			compFunc(dllItem);
		}
		
		/**
		 * 程序域
		 */		
		private var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		
		public function getRes(key:String):*
		{
			var res:*  = swfDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			if(appDomain.hasDefinition(key))
			{
				var clazz:Class = appDomain.getDefinition(key) as Class;
				sharedMap.set(key,clazz);
				return clazz;
			}
			return null;
		}
		
		public function getResAsync(key:String,compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:* = getRes(key);
			compFunc(res);
		}
		
		public function hasRes(name:String):Boolean
		{
			return swfDic[name]!=null;
		}
		
		public function destroyRes(name:String):Boolean
		{
			if(swfDic[name])
			{
				delete swfDic[name];
				return true;
			}
			return false;
		}
	}
}