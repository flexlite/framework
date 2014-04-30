package org.flexlite.domDisplay.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	
	
	/**
	 * Jpeg32位图解码器
	 * @author DOM
	 */
	public class Jpeg32Decoder implements IBitmapDecoder
	{
		/**
		 * 构造函数
		 */		
		public function Jpeg32Decoder()
		{
		}
		/**
		 * @inheritDoc
		 */
		public function get codecKey():String
		{
			return "jpeg32";
		}
		
		/**
		 * 回调函数字典
		 */		
		private var onCompDic:Dictionary = new Dictionary;
		/**
		 * 透明通道字典类
		 */		
		private var alphaBlockDic:Dictionary = new Dictionary;
		/**
		 * @inheritDoc
		 */
		public function decode(bytes:ByteArray,onComp:Function):void
		{
			var fBlock:ByteArray = bytes;
			fBlock.position = 0;
			var aLength:uint  = fBlock.readUnsignedInt();
			var aBlock:ByteArray = new ByteArray();
			var bBlock:ByteArray = new ByteArray();
			fBlock.readBytes(aBlock,0,aLength);
			fBlock.readBytes(bBlock,0);
			
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			if(loaderContext.hasOwnProperty("imageDecodingPolicy"))//如果是FP11以上版本，开启异步位图解码
				loaderContext["imageDecodingPolicy"] = "onLoad";
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComp);
			if(onCompDic==null)
				onCompDic = new Dictionary;
			onCompDic[loader] = onComp;
			alphaBlockDic[loader] = aBlock;
			loader.loadBytes(bBlock,loaderContext);
		}
		
		/**
		 * 解码字节流完成
		 */		
		private function onLoadComp(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComp);
			var bitmapData:BitmapData = (loader.content as Bitmap).bitmapData;
			var aBlock:ByteArray = alphaBlockDic[loader];
			bitmapData = writeAlphaToBitmapData(aBlock,bitmapData);//合并alpha通道
			
			if(onCompDic[loader]!=null)
			{
				onCompDic[loader](bitmapData);
			}
			delete onCompDic[loader];
			delete alphaBlockDic[loader];
		}
		
		/**
		 * 将alpha数据块写入bitmapData 
		 * @param alphaDataBlock alpha通道数据块
		 * @param bitmapData 位图数据
		 */
		private static function writeAlphaToBitmapData(alphaDataBlock:ByteArray,bitmapData:BitmapData):BitmapData
		{
			var retBitmapData:BitmapData;
			alphaDataBlock.uncompress();
			alphaDataBlock.position = 0;
			if(alphaDataBlock.readUTF() == "alphaBlock")
			{
				var alphaBitmapData:BitmapData =  new BitmapData(bitmapData.width,bitmapData.height,true,0);
				retBitmapData = new BitmapData(bitmapData.width,bitmapData.height,true,0);
				alphaBitmapData.setPixels(retBitmapData.rect,alphaDataBlock);
				retBitmapData.copyPixels(bitmapData,bitmapData.rect,new Point(),alphaBitmapData,new Point(),true);
			}
			return retBitmapData;
		}
	}
}