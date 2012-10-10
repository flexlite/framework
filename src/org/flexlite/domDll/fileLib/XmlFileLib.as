package org.flexlite.domDll.fileLib
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.flexlite.domDll.core.IFileLib;
	
	
	/**
	 * XML文件解析器
	 * @author DOM
	 */
	public class XmlFileLib implements IFileLib
	{
		/**
		 * 构造函数
		 */		
		public function XmlFileLib()
		{
		}
		/**
		 * 数据缓存字典
		 */		
		private var cacheDic:Dictionary = new Dictionary;
		
		public function addFileBytes(bytes:ByteArray,name:String,compFunc:Function):void
		{
			if(cacheDic[name])
			{
				compFunc(bytes);
				return;
			}
			cacheDic[name] = bytes;
			compFunc(bytes);
		}
		
		public function getData(key:String,subKey:String=""):*
		{
			var bytes:ByteArray = cacheDic[key];
			if(!bytes)
				return null;
			bytes.position = 0;
			var resultStr:String = bytes.readUTFBytes(bytes.length);
			var xml:XML
			try
			{
				xml = XML(resultStr);
			}
			catch(e:Error)
			{
			}
			return xml;
		}
		
		public function destoryCache(key:String):void
		{
			if(cacheDic[key])
				delete cacheDic[key];
		}
	}
}