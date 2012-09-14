package org.flexlite.domUtils.loader
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 文档类加载工具
	 * @author DOM
	 */
	public class RootLoader
	{
		/**
		 * 构造函数
		 */		
		public function RootLoader()
		{
		}
		
		private var loader:Loader;
		
		/**
		 * 根据url获取指定文件的文档类显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(root:DisplayObjectContainer,appDomain:ApplicationDomain)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadRoot(url:String,compFunc:Function,progressFunc:Function=null,ioErrorFunc:Function=null):void
		{
			if(loader == null)
			{
				loader = new Loader();
			}
			this.compFunc = compFunc;
			this.progressFunc = progressFunc;
			this.ioErrorFunc = ioErrorFunc;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComp);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 加载完成回调函数 
		 */		
		private var compFunc:Function;
		
		private var root:DisplayObjectContainer;
		/**
		 * 加载完成
		 */		
		private function onComp(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			root = loader.content as DisplayObjectContainer;
			if(root.hasOwnProperty("__rslPreloader"))
			{
				root.addEventListener(Event.ADDED,onAdded);
			}
			else
			{
				if(compFunc!=null)
				{
					compFunc(root,loader.contentLoaderInfo.applicationDomain);
				}
			}
			
		}
		
		/**
		 * 第二帧的Loader对象被实例化
		 */		
		private function onAdded(event:Event):void
		{
			if(event.target is Loader)
			{
				root.removeEventListener(Event.ADDED,onAdded);
				var loader:Loader = event.target as Loader;
				loader.contentLoaderInfo.addEventListener(Event.INIT,onLoaded);
			}
		}
		/**
		 * 文档类加载完成
		 */		
		private function onLoaded(event:Event):void
		{
			(event.target as LoaderInfo).removeEventListener(Event.INIT,onLoaded);
			root = (event.target as LoaderInfo).content as DisplayObjectContainer;
			if(compFunc!=null)
			{
				compFunc(root,loader.contentLoaderInfo.applicationDomain);
			}
		}		
		
		/**
		 * 进度条回调函数 
		 */		
		private var progressFunc:Function;
		/**
		 * 加载进度
		 */		
		private function onProgress(event:ProgressEvent):void
		{
			if(progressFunc!=null)
				progressFunc(event);
		}
		/**
		 * 加载失败回调函数 
		 */		
		private var ioErrorFunc:Function;
		/**
		 * 加载失败
		 */		
		private function ioError(event:IOErrorEvent):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComp);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			if(ioErrorFunc!=null)
			{
				ioErrorFunc(event);
			}
		}
	}
}