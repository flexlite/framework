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
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IResolver;
	import org.flexlite.domUtils.SharedMap;
	
	/**
	 * SWF素材文件解析器<br/>
	 * 在IOS下将swf加载到当前程序域。其他平台默认加载到子程序域。
	 * 若是共享的代码库，只能加载到当前域的，请使用RslResolver。
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
				loadInCurrentDomain = true;
		}
		
		/**
		 * Loader对象缓存字典
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
		protected var loadInCurrentDomain:Boolean = false;
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
			loadingCount++;
			if(loadInCurrentDomain)
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
			delete dllItemDic[loader];
			var dllItem:DllItem = data.item;
			var compFunc:Function = data.func;
			dllItem.loaded = (event.type==Event.COMPLETE);
			if(dllItem.loaded)
			{
				if(!swfDic[dllItem.name])
				{
					swfDic[dllItem.name] = loader;
					if(!loadInCurrentDomain)
						appDomainList.push(loader.contentLoaderInfo.applicationDomain);
				}
			}
			checkAsyncList();
			compFunc(dllItem);
		}
		/**
		 * 正在加载的文件个数
		 */		
		private var loadingCount:int = 0;
		
		private var nameDic:Dictionary = new Dictionary();
		/**
		 * @inheritDoc
		 */
		public function loadBytes(bytes:ByteArray,name:String):void
		{
			if(swfDic[name]||!bytes)
				return;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
			var loader:Loader=new Loader();    
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bytesComplete); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,checkAsyncList); 
			nameDic[loader] = name;
			loadingCount++;
			var loaderContext:LoaderContext;
			if(loadInCurrentDomain)
			{
				loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
				
			}
			else
			{
				loaderContext = new LoaderContext();
			}
			if(loaderContext.hasOwnProperty("allowCodeImport"))
				loaderContext["allowCodeImport"] = true;
			loader.loadBytes(bytes,loaderContext);
		}
		
		/**
		 * 解析完成
		 */		
		private function bytesComplete(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			var name:String = nameDic[loader];
			delete nameDic[loader];
			swfDic[name] = loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bytesComplete); 
			if(!loadInCurrentDomain)
				appDomainList.push(loader.contentLoaderInfo.applicationDomain);
			checkAsyncList();
		}
		/**
		 * 加载结束
		 */		
		private function checkAsyncList(event:IOErrorEvent=null):void
		{
			loadingCount--;
			if(loadingCount==0)
			{
				for each(var item:Object in asyncList)
				{
					getResAsync(item.key,item.compFunc);
				}
				asyncList = [];
			}
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
		 * 待加载队列
		 */		
		private var asyncList:Array = [];
		/**
		 * @inheritDoc
		 */
		public function getResAsync(key:String,compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:* = getRes(key);
			if(!res&&loadingCount>0)
			{
				asyncList.push({key:key,compFunc:compFunc});
			}
			else
			{
				compFunc(res);
			}
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
				if(!loadInCurrentDomain)
				{
					var domain:ApplicationDomain = (swfDic[name] as Loader).contentLoaderInfo.applicationDomain;
					for(var i:int=0;i<appDomainList.length>0;i++)
					{
						if(appDomainList[i]==domain)
						{
							appDomainList.splice(i,1);
							break;
						}
					}
				}
				delete swfDic[name];
				return true;
			}
			return false;
		}
	}
}