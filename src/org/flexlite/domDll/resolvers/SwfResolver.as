package org.flexlite.domDll.resolvers
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IResolver;
	import org.flexlite.domUtils.Recycler;
	import org.flexlite.domUtils.SharedMap;
	
	/**
	 * SWF文件解析器
	 * @author DOM
	 */
	public class SwfResolver implements IResolver
	{
		/**
		 * 构造函数
		 */		
		public function SwfResolver()
		{
			super();
			if(Capabilities.os.substr(0,9)=="iPhone OS")
				inIOS = true;
		}
		
		/**
		 * 字节流数据缓存字典
		 */		
		private var swfDic:Dictionary = new Dictionary;
		/**
		 * 程序域列表
		 */		
		private var appDomainList:Vector.<ApplicationDomain> 
			= new <ApplicationDomain>[ApplicationDomain.currentDomain];
		/**
		 * 解码后对象的共享缓存表
		 */		
		private var sharedMap:SharedMap = new SharedMap();
		/**
		 * 加载项字典
		 */		
		private var dllItemDic:Dictionary = new Dictionary();
		/**
		 * 在IOS系统中运行的标志
		 */		
		private var inIOS:Boolean = false;
		/**
		 * @inheritDoc
		 */
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
			if(inIOS)
			{
				var loaderContext:LoaderContext = 
					new LoaderContext(false,ApplicationDomain.currentDomain);
				loader.load(new URLRequest(dllItem.url),loaderContext);
			}
			else
			{
				loader.load(new URLRequest(dllItem.url));
			}
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
					if(!inIOS)
						appDomainList.push(loader.contentLoaderInfo.applicationDomain);
				}
			}
			compFunc(dllItem);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRes(key:String):*
		{
			var res:*  = swfDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			for each(var domain:ApplicationDomain in appDomainList)
			{
				if(domain.hasDefinition(key))
				{
					var clazz:Class = domain.getDefinition(key) as Class;
					sharedMap.set(key,clazz);
					return clazz;
				}
			}
			
			return null;
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
			return swfDic[name]!=null;
		}
		/**
		 * @inheritDoc
		 */
		public function destroyRes(name:String):Boolean
		{
			if(swfDic[name])
			{
				var domain:ApplicationDomain = (swfDic[name] as Loader).contentLoaderInfo.applicationDomain;
				if(domain==ApplicationDomain.currentDomain)
					
				for(var i:int=0;i<appDomainList.length>0;i++)
				{
					if(appDomainList[i]==domain)
					{
						appDomainList.splice(i,1);
						break;
					}
				}
				delete swfDic[name];
				return true;
			}
			return false;
		}
	}
}