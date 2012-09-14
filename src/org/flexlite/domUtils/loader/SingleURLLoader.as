<<<<<<< HEAD
package org.flexlite.domUtils.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * 对单个URLLoader类加载过程的封装
	 * @author DOM
	 */	
	public class SingleURLLoader
	{
		private var loader:URLLoader;
		public function SingleURLLoader()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComp);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		}

		private var format:int;
		private static const FORMAT_BYTE_ARRAY:int = 0;
		private static const FORMAT_TEXT:int = 1;
		private static const FORMAT_XML:int= 2;
		/**
		 * 根据url获取指定文件的二进制字节流数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:ByteArray)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadByteArray(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BYTE_ARRAY;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			load(url,onComp,onProgress,onIoError);
		}
		
		/**
		 * 根据url获取指定文件的字符串数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:String)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadText(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_TEXT;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的XML对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:XML)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadXML(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_XML;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(url,onComp,onProgress,onIoError);
		}
		
		private function load(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			this.compFunc = onComp;
			this.progressFunc = onProgress;
			this.ioErrorFunc = onIoError;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 加载完成回调函数 
		 */		
		private var compFunc:Function;
		/**
		 * 加载完成
		 */		
		private function onComp(e:Event):void
		{
			if(compFunc!=null)
			{
				switch(format)
				{
					case FORMAT_BYTE_ARRAY:
						compFunc(loader.data as ByteArray);
						break;
					case FORMAT_TEXT:
						compFunc(loader.data as String);
						break;
					case FORMAT_XML:
						var data:String = loader.data as String;
						var xml:XML;
						if(data!=null)
						{
							try
							{
								xml = new XML(data);
							}
							catch(e:Error)
							{
								xml = null;
							}
						}
						compFunc(xml);
						break;
					default:;
				}
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
			if(ioErrorFunc!=null)
				ioErrorFunc(event);
		}
	}
=======
package org.flexlite.domUtils.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * 对单个URLLoader类加载过程的封装
	 * @author DOM
	 */	
	public class SingleURLLoader
	{
		private var loader:URLLoader;
		public function SingleURLLoader()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComp);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		}

		private var format:int;
		private static const FORMAT_BYTE_ARRAY:int = 0;
		private static const FORMAT_TEXT:int = 1;
		private static const FORMAT_XML:int= 2;
		/**
		 * 根据url获取指定文件的二进制字节流数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:ByteArray)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadByteArray(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BYTE_ARRAY;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			load(url,onComp,onProgress,onIoError);
		}
		
		/**
		 * 根据url获取指定文件的字符串数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:String)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadText(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_TEXT;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的XML对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:XML)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public function loadXML(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_XML;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(url,onComp,onProgress,onIoError);
		}
		
		private function load(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			this.compFunc = onComp;
			this.progressFunc = onProgress;
			this.ioErrorFunc = onIoError;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 加载完成回调函数 
		 */		
		private var compFunc:Function;
		/**
		 * 加载完成
		 */		
		private function onComp(e:Event):void
		{
			if(compFunc!=null)
			{
				switch(format)
				{
					case FORMAT_BYTE_ARRAY:
						compFunc(loader.data as ByteArray);
						break;
					case FORMAT_TEXT:
						compFunc(loader.data as String);
						break;
					case FORMAT_XML:
						var data:String = loader.data as String;
						var xml:XML;
						if(data!=null)
						{
							try
							{
								xml = new XML(data);
							}
							catch(e:Error)
							{
								xml = null;
							}
						}
						compFunc(xml);
						break;
					default:;
				}
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
			if(ioErrorFunc!=null)
				ioErrorFunc(event);
		}
	}
>>>>>>> master
}