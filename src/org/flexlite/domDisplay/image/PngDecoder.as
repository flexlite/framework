<<<<<<< HEAD
package org.flexlite.domDisplay.image
{
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * PNG位图解码器
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
				
		public function get codecKey():String
		{
			return "png";
		}
		
		private var onCompDic:Dictionary;
		
		public function decode(byteArray:ByteArray,onComp:Function):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComp);
			if(onCompDic==null)
				onCompDic = new Dictionary;
			onCompDic[loader] = onComp;
			loader.loadBytes(byteArray);
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
=======
package org.flexlite.domDisplay.image
{
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * PNG位图解码器
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
				
		public function get codecKey():String
		{
			return "png";
		}
		
		private var onCompDic:Dictionary;
		
		public function decode(byteArray:ByteArray,onComp:Function):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComp);
			if(onCompDic==null)
				onCompDic = new Dictionary;
			onCompDic[loader] = onComp;
			loader.loadBytes(byteArray);
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
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}