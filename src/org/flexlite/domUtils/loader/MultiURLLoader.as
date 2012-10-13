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
	 * 对多个URLLoader类队列加载过程的封装
	 * @author DOM
	 */	
	public class MultiURLLoader
	{
		private var loader:URLLoader;
		public function MultiURLLoader()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onCurrnetComp);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
		}
		
		
		private var format:int;
		private static const FORMAT_BYTE_ARRAY:int = 0;
		private static const FORMAT_TEXT:int = 1;
		private static const FORMAT_XML:int= 2;
		
		
		
		private var urlArray:Array;
		private var currentIndex:int = 0;
		
		/**
		 * 根据多个url获取多个二进制字节流对象，若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:ByteArray,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiByteArrays(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
										 onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BYTE_ARRAY;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个文件内的字符串,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:String,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiTexts(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
										 onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_TEXT;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个XML数据对象,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:XML,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiXMLs(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
											 onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_XML;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 加载成功返回数据队列 
		 */		
		private var returnArray:Array = [];
		private function load(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
							  onProgress:Function=null,onIoError:Function=null):void
		{
			if(urlArray==null||urlArray.length==0)
				return;			
			this.urlArray = urlArray;
			this.allCompFunc = onAllComp;
			this.currentCompFunc = onCurrentComp;
			this.progressFunc = onProgress;
			this.ioErrorFunc = onIoError;
			
			currentIndex = 0;
			returnArray = [];
			loadItem();
		}
		/**
		 * 开始加载一项
		 */		
		private function loadItem():void
		{
			var url:String = urlArray[currentIndex];
			loader.load(new URLRequest(url));
		}
		/**
		 * 加载下一项，如果已经没有下一项，则全部加载完成
		 */		
		private function next():void
		{
			currentIndex++;
			if(currentIndex >= urlArray.length)
				onAllComp();
			else
				loadItem();
		}
		
		/**
		 * 当前加载项完成回调函数 
		 */		
		private var currentCompFunc:Function;
		/**
		 * 当前项加载完成
		 */		
		private function onCurrnetComp(e:Event):void
		{
			switch(format)
			{
				case FORMAT_BYTE_ARRAY:
					
					returnArray.push(loader.data as ByteArray);
					if(currentCompFunc!=null)
					{
						currentCompFunc(loader.data as ByteArray,currentIndex);
					}
					break;
				case FORMAT_TEXT:
					returnArray.push(loader.data as String);
					if(currentCompFunc!=null)
					{
						currentCompFunc(loader.data as String,currentIndex);
					}
					break;
				case FORMAT_XML:
					var data:String = loader.data as String;
					var xml:XML;
					try
					{
						xml = new XML(data);
					}
					catch(e:Error)
					{
						xml = null;
					}
					returnArray.push(xml);
					if(currentCompFunc!=null)
					{
						currentCompFunc(xml,currentIndex);
					}
					break;
				default:;
			}			
			next();
		}
		
		/**
		 * 当前项加载进度回调函数 
		 */		
		private var progressFunc:Function;
		/**
		 * 当前项加载进度
		 */		
		private function onProgress(event:ProgressEvent):void
		{
			if(progressFunc!=null)
				progressFunc(event,currentIndex);
		}
		
		/**
		 * 当前项加载失败回调函数 
		 */		
		private var ioErrorFunc:Function;
		/**
		 * 当前项加载失败
		 */		
		private function onIoError(event:IOErrorEvent):void
		{
			returnArray.push(null);
			if(ioErrorFunc!=null)
				ioErrorFunc(event,currentIndex);
			next();
		}
		
		/**
		 * 全部加载完成回调函数 
		 */		
		private var allCompFunc:Function;
		/**
		 * 全部加载完成
		 */		
		private function onAllComp():void
		{
			if(allCompFunc!=null)
				allCompFunc(returnArray);
		}
	}
}