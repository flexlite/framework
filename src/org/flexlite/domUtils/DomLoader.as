package org.flexlite.domUtils
{
	import org.flexlite.domUtils.loader.MultiLoader;
	import org.flexlite.domUtils.loader.MultiURLLoader;
	import org.flexlite.domUtils.loader.RootLoader;
	import org.flexlite.domUtils.loader.SingleLoader;
	import org.flexlite.domUtils.loader.SingleURLLoader;
	
	import flash.system.ApplicationDomain;


	/**
	 * 调用各种数据请求功能的入口类
	 * @author DOM
	 */	
	public class DomLoader
	{
		
		//==========单个加载项========start========
		/**
		 * 根据url获取指定文件的二进制字节流数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:ByteArray)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadByteArray(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var baLoader:SingleURLLoader = new SingleURLLoader;
			baLoader.loadByteArray(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的字符串数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:String)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadText(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var textLoader:SingleURLLoader = new SingleURLLoader;
			textLoader.loadText(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的XML对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:XML)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadXML(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var xmlLoader:SingleURLLoader = new SingleURLLoader;
			xmlLoader.loadXML(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的Loader显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:Loader)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 * @param appDomain 加载使用的程序域
		 */		
		public static function loadLoader(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null,appDomain:ApplicationDomain=null):void
		{
			var ldLoader:SingleLoader = new SingleLoader;
			ldLoader.loadLoader(url,onComp,onProgress,onIoError,appDomain);
		}
		/**
		 * 根据url获取指定文件的Bitmap显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:Bitmap)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadBitmap(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var bmLoader:SingleLoader = new SingleLoader;
			bmLoader.loadBitmap(url,onComp,onProgress,onIoError);
		}
		/**
		 * 根据url获取指定文件的BitmapData数据
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(data:BitmapData)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadBitmapData(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var bdLoader:SingleLoader = new SingleLoader;
			bdLoader.loadBitmapData(url,onComp,onProgress,onIoError);
		}
		
		/**
		 * 根据url获取指定文件的Class类定义数据
		 * @param url 文件的url路径
		 * @param className 要获取的类名
		 * @param onComp 返回结果时的回调函数 onComp(data:Class)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent
		 * @param appDomain 加载使用的程序域
		 */	
		public static function loadExternalClass(url:String,className:String,onComp:Function,onProgress:Function=null,onIoError:Function=null,appDomain:ApplicationDomain=null):void
		{
			var classLoader:SingleLoader = new SingleLoader;
			classLoader.loadExternalClass(url,className,onComp,onProgress,onIoError,appDomain);
		}
		
		/**
		 * 根据url获取指定文件的文档类显示对象
		 * @param url 文件的url路径
		 * @param onComp 返回结果时的回调函数 onComp(root:DisplayObjectContainer,appDomain:ApplicationDomain)
		 * @param onProgress 加载进度回调函数 onProgress(event:ProgressEvent)
		 * @param onIoError 加载失败回调函数 onIoError(event:IOErrorEvent)
		 */		
		public static function loadRoot(url:String,onComp:Function,onProgress:Function=null,onIoError:Function=null):void
		{
			var rootLoader:RootLoader = new RootLoader;
			rootLoader.loadRoot(url,onComp,onProgress,onIoError);
		}
		
		//==========单个加载项=========end=========
		
		//==========多个加载项========start========
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
		public static function loadMultiLoaders(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			var ldLoader:MultiLoader = new MultiLoader();
			ldLoader.loadMultiLoaders(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个Bitmap显示对象，若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:Bitmap,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public static function loadMultiBitmaps(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									onProgress:Function=null,onIoError:Function=null):void
		{
			var bmLoader:MultiLoader = new MultiLoader();
			bmLoader.loadMultiBitmaps(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		/**
		 * 根据多个url获取多个BitmapData数据对象，若其中一项加载失败，该项结果返回null值
		 * @param urlArray 文件的url数组队列
		 * @param onAllComp 全部项加载完成的回调函数 onAllComp(data:Array)
		 * @param onCurrentComp 当前项加载完成回调函数 onAllComp(data:BitmapData,currentIndex:int)<br/>
		 * data:当前项加载完成返回的结果，currentIndex:当前加载项在url队列中的索引
		 * @param onProgress 当前项加载进度回调函数 onProgress(event:ProgressEvent,currentIndex:int)<br/>
		 * event:当前加载项的进度事件，currentIndex:当前加载项在url队列中的索引
		 * @param onIoError 当前项加载失败回调函数 onIoError(event:IOErrorEvent,currentIndex:int)
		 */		
		public static function loadMultiBitmapDatas(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
										onProgress:Function=null,onIoError:Function=null):void
		{
			var bdLoader:MultiLoader = new MultiLoader();
			bdLoader.loadMultiBitmapDatas(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		
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
		public static function loadMultiByteArrays(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
											onProgress:Function=null,onIoError:Function=null):void
		{
			var baLoader:MultiURLLoader = new MultiURLLoader();
			baLoader.loadMultiByteArrays(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
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
		public static function loadMultiTexts(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
									   onProgress:Function=null,onIoError:Function=null):void
		{
			var textLoader:MultiURLLoader = new MultiURLLoader();
			textLoader.loadMultiTexts(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
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
		public static function loadMultiXMLs(urlArray:Array,onAllComp:Function,onCurrentComp:Function=null,
											 onProgress:Function=null,onIoError:Function=null):void
		{
			var xmlLoader:MultiURLLoader = new MultiURLLoader();
			xmlLoader.loadMultiXMLs(urlArray,onAllComp,onCurrentComp,onProgress,onIoError);
		}
		//==========多个加载项=========end=========
		
	}
}