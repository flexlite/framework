<<<<<<< HEAD
package org.flexlite.domDisplay.image
{
	import org.flexlite.domDisplay.codec.IBitmapEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.JPEGEncoderOptions;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	
	/**
	 * JPEG32位图编码器,需要Flash Player11.3及以上版本支持
	 * @author DOM
	 */
	public class Jpeg32Encoder implements IBitmapEncoder
	{
		/**
		 * 构造函数
		 * @param quality 编码质量 1～100,值越高画面质量越好
		 * @param alphaLv alpha通道分级 16或256
		 */
		public function Jpeg32Encoder(quality:int = 80)
		{
			encodeOptions = new JPEGEncoderOptions(quality);
		}
		
		public function get codecKey():String
		{
			return "jpeg32";
		}
		
		private var encodeOptions:JPEGEncoderOptions;

		public function encode(bitmapData:BitmapData):ByteArray
		{
			var aBlock:ByteArray = getAlphaDataBlock(bitmapData);
			var aBlockLength:uint = aBlock.length;			
			var bBlock:ByteArray = new ByteArray; //= encoder.encode(bitmapData);
			bitmapData.encode(bitmapData.rect,encodeOptions,bBlock);
			var fBlock:ByteArray = new ByteArray();
			
			fBlock.position = 0;
			fBlock.writeUnsignedInt(aBlockLength);//写入alpha数据块长度
			fBlock.writeBytes(aBlock,0,aBlock.length);//写入alpha数据块
			fBlock.writeBytes(bBlock,0,bBlock.length);//写入bitmap数据块
			return fBlock;
		}
		
		
		
		/**
		 * 提取图像alpha通道数据块
		 * @param source 源图像数据
		 */
		private static function getAlphaDataBlock(source:BitmapData):ByteArray
		{
			var alphaBitmapData:BitmapData = new BitmapData(source.width,source.height,true,0);
			alphaBitmapData.copyChannel(source,source.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			var bytes:ByteArray = new ByteArray();
			bytes.position = 0;
			bytes.writeUTF("alphaBlock");
			bytes.writeBytes(alphaBitmapData.getPixels(alphaBitmapData.rect));
			bytes.compress();
			return bytes;
		}
	}
=======
package org.flexlite.domDisplay.image
{
	import org.flexlite.domDisplay.codec.IBitmapEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.JPEGEncoderOptions;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	
	/**
	 * JPEG32位图编码器,需要Flash Player11.3及以上版本支持
	 * @author DOM
	 */
	public class Jpeg32Encoder implements IBitmapEncoder
	{
		/**
		 * 构造函数
		 * @param quality 编码质量 1～100,值越高画面质量越好
		 * @param alphaLv alpha通道分级 16或256
		 */
		public function Jpeg32Encoder(quality:int = 80)
		{
			encodeOptions = new JPEGEncoderOptions(quality);
		}
		
		public function get codecKey():String
		{
			return "jpeg32";
		}
		
		private var encodeOptions:JPEGEncoderOptions;

		public function encode(bitmapData:BitmapData):ByteArray
		{
			var aBlock:ByteArray = getAlphaDataBlock(bitmapData);
			var aBlockLength:uint = aBlock.length;			
			var bBlock:ByteArray = new ByteArray; //= encoder.encode(bitmapData);
			bitmapData.encode(bitmapData.rect,encodeOptions,bBlock);
			var fBlock:ByteArray = new ByteArray();
			
			fBlock.position = 0;
			fBlock.writeUnsignedInt(aBlockLength);//写入alpha数据块长度
			fBlock.writeBytes(aBlock,0,aBlock.length);//写入alpha数据块
			fBlock.writeBytes(bBlock,0,bBlock.length);//写入bitmap数据块
			return fBlock;
		}
		
		
		
		/**
		 * 提取图像alpha通道数据块
		 * @param source 源图像数据
		 */
		private static function getAlphaDataBlock(source:BitmapData):ByteArray
		{
			var alphaBitmapData:BitmapData = new BitmapData(source.width,source.height,true,0);
			alphaBitmapData.copyChannel(source,source.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			var bytes:ByteArray = new ByteArray();
			bytes.position = 0;
			bytes.writeUTF("alphaBlock");
			bytes.writeBytes(alphaBitmapData.getPixels(alphaBitmapData.rect));
			bytes.compress();
			return bytes;
		}
	}
>>>>>>> master
}