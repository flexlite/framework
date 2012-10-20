package org.flexlite.domDisplay.image
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.utils.ByteArray;
	
	import org.flexlite.domDisplay.codec.IBitmapEncoder;
	
	
	/**
	 * PNG位图编码器
	 * @author DOM
	 */
	public class PngEncoder implements IBitmapEncoder
	{
		/**
		 * 构造函数
		 * @param fastCompression 是否启用快速压缩，为true文件将会比较大。
		 */		
		public function PngEncoder(fastCompression:Boolean = false)
		{
			encodeOptions = new PNGEncoderOptions(fastCompression);
		}
		/**
		 * @inheritDoc
		 */
		public function get codecKey():String
		{
			return "png";
		}
		
		private var encodeOptions:PNGEncoderOptions;
		/**
		 * @inheritDoc
		 */
		public function encode(bitmapData:BitmapData):ByteArray
		{
			var byteArray:ByteArray = new ByteArray;
			bitmapData.encode(bitmapData.rect,encodeOptions,byteArray);
			return byteArray;
		}
	}
}