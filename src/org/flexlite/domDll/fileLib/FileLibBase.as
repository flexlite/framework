package org.flexlite.domDll.fileLib
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IFileLib;
	import org.flexlite.domUtils.Recycler;
	import org.flexlite.domUtils.SharedMap;
	
	
	/**
	 * 文件解析缓存库基类
	 * @author DOM
	 */
	public class FileLibBase implements IFileLib
	{
		/**
		 * 构造函数
		 */		
		public function FileLibBase()
		{
		}
		/**
		 * 字节流数据缓存字典
		 */		
		protected var fileDic:Dictionary = new Dictionary;
		/**
		 * 解码后对象的共享缓存表
		 */		
		protected var sharedMap:SharedMap = new SharedMap();
		/**
		 * 加载项字典
		 */		
		private var dllItemDic:Dictionary = new Dictionary();
		
		public function loadFile(dllItem:DllItem,compFunc:Function,onProgress:Function):void
		{
			if(fileDic[dllItem.name])
			{
				compFunc(dllItem);
				return;
			}
			var loader:URLLoader = getLoader();
			dllItemDic[loader] = {item:dllItem,func:compFunc,progress:onProgress};
			loader.load(new URLRequest(dllItem.url));
		}
		/**
		 * URLLoader对象池
		 */		
		private var recycler:Recycler = new Recycler();
		/**
		 * 获取一个URLLoader对象
		 */		
		private function getLoader():URLLoader
		{
			var loader:URLLoader = recycler.get();
			if(!loader)
			{
				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE,onLoadFinish);
				loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadFinish);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadFinish);
			}
			return loader;
		}
		/**
		 * 加载进度
		 */		
		private function onProgress(event:ProgressEvent):void
		{
			var loader:URLLoader = event.target as URLLoader;
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
			var loader:URLLoader = event.target as URLLoader;
			var data:Object = dllItemDic[loader];
			delete dllItemDic[loader];
			recycler.push(loader);
			var dllItem:DllItem = data.item;
			var compFunc:Function = data.func;
			dllItem.loaded = (event.type==Event.COMPLETE);
			if(dllItem.loaded)
			{
				if(!fileDic[dllItem.name])
				{
					cacheFileBytes(loader.data,dllItem.name);
				}
			}
			compFunc(dllItem);
		}
		/**
		 * 缓存加载到的文件字节流
		 */		
		protected function cacheFileBytes(bytes:ByteArray,name:String):void
		{
			fileDic[name] = bytes;
		}
		
		public function getRes(key:String):*
		{
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
			return fileDic[name]!=null;
		}
		
		public function destroyRes(name:String):Boolean
		{
			if(fileDic[name])
			{
				delete fileDic[name];
				return true;
			}
			return false;
		}
	}
}