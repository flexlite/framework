package org.flexlite.domDll.assetLibs
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.flexlite.domDll.core.IAssetLib;
	
	
	/**
	 * XML文件解析器
	 * @author DOM
	 */
	public class XmlAssetLib implements IAssetLib
	{
		/**
		 * 构造函数
		 */		
		public function XmlAssetLib()
		{
		}
		/**
		 * 数据缓存字典
		 */		
		private var cacheDic:Dictionary = new Dictionary;
		
		public function analyze(bytes:ByteArray,name:String,compFunc:Function):void
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
		
		public function destoryData(key:String):void
		{
			if(cacheDic[key])
				delete cacheDic[key];
		}
	}
}