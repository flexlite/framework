package org.flexlite.domDisplay.image
{
	import flash.display.BitmapData;
	import flash.display.JPEGXREncoderOptions;
	import flash.utils.ByteArray;
	
	import org.flexlite.domDisplay.codec.IBitmapEncoder;
	
	/**
	 * JPEG-XR位图编码器，需要Flash Player11.3及以上版本支持
	 * @author DOM
	 */	
	public class JpegXREncoder implements IBitmapEncoder
	{
		/**
		 * 构造函数
		 * @param quantization 值越高压缩率越大，画质越差。                                                                                                                              
		 */		
		public function JpegXREncoder(quantization:uint=20, colorSpace:String="auto", trimFlexBits:uint=0)
		{
			super();
			encodeOptions = new JPEGXREncoderOptions(quantization,colorSpace,trimFlexBits);
		}
		/**
		 * @inheritDoc
		 */
		public function get codecKey():String
		{
			return "jpegxr";
		}
		
		private var encodeOptions:JPEGXREncoderOptions;
		
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