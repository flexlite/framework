package org.flexlite.domDisplay.codec
{
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author DOM
	 */
	public interface IBitmapDecoder
	{
		/**
		 * 将字节流数据解码为位图数组
		 * @param byteArray 要解码的字节流数据
		 * @param onComp 解码完成回调函数，示例：onComp(data:BitmapData);
		 */		
		function decode(byteArray:ByteArray,onComp:Function):void;
		
		/**
		 * 编解码器标识符
		 */		
		function get codecKey():String;
	}
}