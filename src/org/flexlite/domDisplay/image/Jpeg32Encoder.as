package org.flexlite.domDisplay.image
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.JPEGEncoderOptions;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import org.flexlite.domDisplay.codec.IBitmapEncoder;
	
	
	/**
	 * JPEG32位图编码器,需要Flash Player11.3及以上版本支持
	 * @author DOM
	 */
	public class Jpeg32Encoder implements IBitmapEncoder
	{
		/**
		 * 构造函数
		 * @param quality 编码质量 1～100,值越高画面质量越好
		 */
		public function Jpeg32Encoder(quality:int = 80)
		{
			encodeOptions = new JPEGEncoderOptions(quality);
		}
		/**
		 * @inheritDoc
		 */
		public function get codecKey():String
		{
			return "jpeg32";
		}
		
		private var encodeOptions:JPEGEncoderOptions;
		/**
		 * @inheritDoc
		 */
		public function encode(bitmapData:BitmapData):ByteArray
		{
			var aBlock:ByteArray = getAlphaDataBlock(bitmapData);
			var aBlockLength:uint = aBlock.length;			
			var bBlock:ByteArray = new ByteArray;
			bitmapData.encode(bitmapData.rect,encodeOptions,bBlock);
			var fBlock:ByteArray = new ByteArray();
			
			fBlock.position = 0;
			fBlock.writeUnsignedInt(aBlockLength);
			fBlock.writeBytes(aBlock,0,aBlock.length);
			fBlock.writeBytes(bBlock,0,bBlock.length);
			return fBlock;
		}
		
		
		
		/**
		 * 提取图像alpha通道数据块
		 * @param source 源图像数据
		 */
		private static function getAlphaDataBlock(source:BitmapData):ByteArray
		{
			var alphaBitmapData:BitmapData = new BitmapData(source.width,source.height,true,0);
			alphaBitmapData.copyChannel(source,source.rect,new Point(),
				BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			var bytes:ByteArray = new ByteArray();
			bytes.position = 0;
			bytes.writeUTF("alphaBlock");
			bytes.writeBytes(alphaBitmapData.getPixels(alphaBitmapData.rect));
			bytes.compress();
			return bytes;
		}
	}
}