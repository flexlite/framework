package org.flexlite.domDisplay.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	
	
	/***
	 * JPEG-XR位图解码器，需要Flash Player11.3及以上版本支持
	 * @author DOM
	 */	
	public class JpegXRDecoder implements IBitmapDecoder
	{
		/**
		 * 构造函数
		 */		
		public function JpegXRDecoder()
		{
		}
		/**
		 * @inheritDoc
		 */
		public function get codecKey():String
		{
			return "jpegxr";
		}
		
		private var onCompDic:Dictionary;
		/**
		 * @inheritDoc
		 */
		public function decode(byteArray:ByteArray,onComp:Function):void
		{
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy=ImageDecodingPolicy.ON_LOAD;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComp);
			if(onCompDic==null)
				onCompDic = new Dictionary;
			onCompDic[loader] = onComp;
			loader.loadBytes(byteArray,loaderContext);
		}
		/**
		 * 解码完成
		 */		
		private function onLoadComp(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComp);
			var bitmapData:BitmapData = (loader.content as Bitmap).bitmapData;
			if(onCompDic[loader]!=null)
			{
				onCompDic[loader](bitmapData);
			}
			delete onCompDic[loader];
		}
	}
}