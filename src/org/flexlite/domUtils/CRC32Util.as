package org.flexlite.domUtils
{
	
	import flash.utils.ByteArray;
	
	/**
	 * CRC32工具类
	 * @author DOM
	 */
	public class CRC32Util
	{
		/**
		 * 计算时用到的CRC缓存数据表
		 */		
		private static var crcTable:Array = makeCrcTable();
		
		/**
		 * 获取CRC缓存数据表
		 */		
		private static function makeCrcTable():Array 
		{
			var crcTable:Array = new Array(256);
			for (var n:int = 0; n < 256; n++) 
			{
				var c:uint = n;
				for (var k:int = 8; --k >= 0; ) 
				{
					if((c & 1) != 0) 
					{
						c = 0xedb88320 ^ (c >>> 1);
					}
					else 
					{
						c = c >>> 1;
					}
				}
				crcTable[n] = c;
			}
			return crcTable;
		}
		
		/**
		 * 从字节流计算CRC32数据
		 * @param buf 要计算的字节流
		 */		
		public static function getCRC32(buf:ByteArray):uint 
		{
			var crc:uint = 0;
			var off:uint = 0;
			var len:uint = buf.length;
			var c:uint = ~crc;
			while(--len >= 0) 
			{
				c = crcTable[(c ^ buf[off++]) & 0xff] ^ (c >>> 8);
			}
			crc = ~c;
			return crc & 0xffffffff;
		}
		
	}
	
}
