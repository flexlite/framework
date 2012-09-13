package org.flexlite.domDisplay.codec
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * 位图编解码器接口
	 * @author DOM
	 */	
	public interface IBitmapEncoder
	{
		/**
		 * 将位图数据编码为字节流数据
		 * @param bitmapData 要编码的位图数据
		 */		
		function encode(bitmapData:BitmapData):ByteArray;
		
		/**
		 * 编解码器标识符
		 */		
		function get codecKey():String;
	}
}