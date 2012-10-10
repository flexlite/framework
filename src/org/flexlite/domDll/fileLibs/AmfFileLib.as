package org.flexlite.domDll.fileLibs
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.flexlite.domDll.core.IFileLib;
	
	
	/**
	 * 二进制序列化对象文件解析器
	 * @author DOM
	 */
	public class AmfFileLib implements IFileLib
	{
		public function AmfFileLib()
		{
		}
		
		/**
		 * 数据缓存字典
		 */		
		private var cacheDic:Dictionary = new Dictionary;
		
		public function addFileBytes(bytes:ByteArray, name:String, compFunc:Function):void
		{
			if(cacheDic[name]!=null)
			{
				compFunc(bytes);
				return;
			}
			cacheDic[name] = bytes;
			compFunc(bytes);
		}
		
		public function getData(key:String, subKey:String=""):*
		{
			var byte:ByteArray = cacheDic[key];
			if(byte)
			{
				try
				{
					byte.uncompress();
				}
				catch(e:Error){}
				try
				{
					return byte.readObject();
				}
				catch(e:Error){}
			}
			return null;
		}
		
		public function destoryData(key:String):void
		{
			if(cacheDic[key])
				delete cacheDic[key];
		}
	}
}