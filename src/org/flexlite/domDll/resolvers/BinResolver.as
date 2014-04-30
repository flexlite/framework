package org.flexlite.domDll.resolvers
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
	import org.flexlite.domDll.core.IResolver;
	import org.flexlite.domUtils.Recycler;
	import org.flexlite.domUtils.SharedMap;
	/**
	 * 二进制文件解析器<br/>
	 * 直接返回文件二进制字节流。若文件是"zlib"方式压缩的，缓存时会先解压它。
	 * @author DOM
	 */
	public class BinResolver implements IResolver
	{
		/**
		 * 构造函数
		 */		
		public function BinResolver()
		{
			super();
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
		protected var dllItemDic:Dictionary = new Dictionary();
		/**
		 * @inheritDoc
		 */
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
		protected var recycler:Recycler = new Recycler();
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
		protected function onLoadFinish(event:Event):void
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
				loadBytes(loader.data,dllItem.name);
			}
			compFunc(dllItem);
		}
		/**
		 * @inheritDoc
		 */
		public function loadBytes(bytes:ByteArray,name:String):void
		{
			if(fileDic[name]||!bytes)
				return;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
			fileDic[name] = bytes;
		}
		/**
		 * @inheritDoc
		 */
		public function getRes(key:String):*
		{
			return fileDic[key];
		}
		/**
		 * @inheritDoc
		 */
		public function getResAsync(key:String,compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:* = getRes(key);
			compFunc(res);
		}
		/**
		 * @inheritDoc
		 */
		public function hasRes(name:String):Boolean
		{
			return fileDic[name]!=null;
		}
		/**
		 * @inheritDoc
		 */
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