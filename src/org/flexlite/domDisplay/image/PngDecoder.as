package org.flexlite.domDisplay.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	
	
	/**
	 * PNG位图解码器,此解码器同样适用于其他所有普通位图解码。比如jpegxr。
	 * @author DOM
	 */
	public class PngDecoder implements IBitmapDecoder
	{
		/**
		 * 构造函数
		 */
		public function PngDecoder()
		{
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get codecKey():String
		{
			return "png";
		}
		
		private var onCompDic:Dictionary;
		/**
		 * @inheritDoc
		 */
		public function decode(byteArray:ByteArray,onComp:Function):void
		{
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			if(loaderContext.hasOwnProperty("imageDecodingPolicy"))//如果是FP11以上版本，开启异步位图解码
				loaderContext["imageDecodingPolicy"] = "onLoad";
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