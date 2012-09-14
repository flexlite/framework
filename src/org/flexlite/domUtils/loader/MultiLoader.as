<<<<<<< HEAD
package org.flexlite.domUtils.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * 对多个Loader类队列加载过程的封装
	 * @author DOM
	 */	
	public class MultiLoader
	{
		private var loader:Loader;
		public function MultiLoader()
		{
		}
		
		/**
		 * 增加一个新的Loader
		 */		
		private function addNewLoader(createNew:Boolean = true):void
		{
			if(createNew)
				loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCurrnetComp);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
		}
		/**
		 * 移除事件
		 */		
		private function removeEventListener():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCurrnetComp);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
		}
		
		private var format:int;
		private static const FORMAT_LOADER:int = 0;
		private static const FORMAT_BITMAP:int = 1;
		private static const FORMAT_BITMAP_DATA:int= 2;
		
		
		
		private var urlArray:Array;
		private var currentIndex:int = 0;
		
		/**
		 * 根据多个url获取多个Loader显示对象，若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:Loader,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiLoaders(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_LOADER;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个Bitmap显示对象,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:Bitmap,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiBitmaps(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BITMAP;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个BitmapData数据对象,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:BitmapData,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiBitmapDatas(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BITMAP_DATA;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 加载成功返回数据队列 
		 */		
		private var returnArray:Array = null;
		private function load(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
							  onProgress:Function=null,onIoError:Function=null):void
		{
			if(urlArray==null||urlArray.length==0||onAllComp==null)
				return;	
			if(loader==null)
			{
				addNewLoader();
			}
			else
			{
				addNewLoader(false);
			}
			this.urlArray = urlArray;
			this.allCompFunc = onAllComp;
			this.currentCompFunc = onCurrentComp;
			this.progressFunc = onProgress;
			this.ioErrorFunc = onIoError;
			returnArray = [];
			currentIndex = 0;
			loadItem();
		}
		/**
		 * 开始加载一项
		 */		
		private function loadItem():void
		{
			var path:String = urlArray[currentIndex];
			loader.load(new URLRequest(path));
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
				case FORMAT_LOADER:
					removeEventListener();
					returnArray.push(loader);
					if(currentCompFunc!=null)
					{
						currentCompFunc(loader,currentIndex);
					}
					addNewLoader();
					break;
				case FORMAT_BITMAP:
					var bm:Bitmap = loader.contentLoaderInfo.content as Bitmap;
					returnArray.push(bm);
					if(currentCompFunc!=null)
					{
						currentCompFunc(bm,currentIndex);
					}
					break;
				case FORMAT_BITMAP_DATA:
					var bm2:Bitmap = loader.contentLoaderInfo.content as Bitmap;
					var bd:BitmapData;
					if(bm2!=null)
					{
						bd = bm2.bitmapData;
					}
					returnArray.push(bd);
					if(currentCompFunc!=null)
					{
						currentCompFunc(bd,currentIndex);
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
			removeEventListener();
			allCompFunc(returnArray);
			returnArray = null;
		}
		
	}
=======
package org.flexlite.domUtils.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * 对多个Loader类队列加载过程的封装
	 * @author DOM
	 */	
	public class MultiLoader
	{
		private var loader:Loader;
		public function MultiLoader()
		{
		}
		
		/**
		 * 增加一个新的Loader
		 */		
		private function addNewLoader(createNew:Boolean = true):void
		{
			if(createNew)
				loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCurrnetComp);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
		}
		/**
		 * 移除事件
		 */		
		private function removeEventListener():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCurrnetComp);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
		}
		
		private var format:int;
		private static const FORMAT_LOADER:int = 0;
		private static const FORMAT_BITMAP:int = 1;
		private static const FORMAT_BITMAP_DATA:int= 2;
		
		
		
		private var urlArray:Array;
		private var currentIndex:int = 0;
		
		/**
		 * 根据多个url获取多个Loader显示对象，若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:Loader,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiLoaders(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_LOADER;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个Bitmap显示对象,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:Bitmap,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiBitmaps(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BITMAP;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个BitmapData数据对象,若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:BitmapData,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public function loadMultiBitmapDatas(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			format = FORMAT_BITMAP_DATA;
			load(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 加载成功返回数据队列 
		 */		
		private var returnArray:Array = null;
		private function load(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
							  onProgress:Function=null,onIoError:Function=null):void
		{
			if(urlArray==null||urlArray.length==0||onAllComp==null)
				return;	
			if(loader==null)
			{
				addNewLoader();
			}
			else
			{
				addNewLoader(false);
			}
			this.urlArray = urlArray;
			this.allCompFunc = onAllComp;
			this.currentCompFunc = onCurrentComp;
			this.progressFunc = onProgress;
			this.ioErrorFunc = onIoError;
			returnArray = [];
			currentIndex = 0;
			loadItem();
		}
		/**
		 * 开始加载一项
		 */		
		private function loadItem():void
		{
			var path:String = urlArray[currentIndex];
			loader.load(new URLRequest(path));
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
				case FORMAT_LOADER:
					removeEventListener();
					returnArray.push(loader);
					if(currentCompFunc!=null)
					{
						currentCompFunc(loader,currentIndex);
					}
					addNewLoader();
					break;
				case FORMAT_BITMAP:
					var bm:Bitmap = loader.contentLoaderInfo.content as Bitmap;
					returnArray.push(bm);
					if(currentCompFunc!=null)
					{
						currentCompFunc(bm,currentIndex);
					}
					break;
				case FORMAT_BITMAP_DATA:
					var bm2:Bitmap = loader.contentLoaderInfo.content as Bitmap;
					var bd:BitmapData;
					if(bm2!=null)
					{
						bd = bm2.bitmapData;
					}
					returnArray.push(bd);
					if(currentCompFunc!=null)
					{
						currentCompFunc(bd,currentIndex);
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
			removeEventListener();
			allCompFunc(returnArray);
			returnArray = null;
		}
		
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}