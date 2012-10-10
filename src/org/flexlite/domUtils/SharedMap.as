package org.flexlite.domUtils
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * 具有动态内存管理功能的哈希表。<br/>
	 * 此类通常用于动态共享高内存占用的数据对象，比如BitmapData。
	 * 它类似Dictionary，使用key(String|int)-value(Object)形式来存储数据。
	 * 但当外部对value的所有引用都断开时，value会被GC强制回收，并从哈希表移除。
	 * @author DOM
	 */
	public class SharedMap extends Proxy
	{
		public function SharedMap()
		{
			var cache:Dictionary = new Dictionary();
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			
		}
		/**
		 * 转换属性名为索引
		 */		
		private function convertToIndex(name:*):int
		{
			if (name is QName)
				name = name.localName;
			
			var index:int = -1;
			try
			{
				var n:Number = parseInt(String(name));
				if (!isNaN(n))
					index = int(n);
			}
			catch(e:Error)
			{
			}
			return index;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			return true;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var index:int = convertToIndex(name);
			if (index == -1)
				return false;
			return index >= 0 && index < length;
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < length ? index + 1 : 0;
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return (index - 1).toString();
		}
		
		override flash_proxy function nextValue(index:int):*
		{
		}    
		
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			return null;
		}
	}
}