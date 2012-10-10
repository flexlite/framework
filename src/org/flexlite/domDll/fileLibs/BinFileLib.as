package org.flexlite.domDll.fileLibs
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.flexlite.domDll.core.IFileLib;
	
	
	/**
	 * 二进制文件解析器
	 * @author DOM
	 */
	public class BinFileLib implements IFileLib
	{
		/**
		 * 构造函数
		 */		
		public function BinFileLib()
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
			return cacheDic[key];
		}
		
		public function destoryData(key:String):void
		{
			if(cacheDic[key])
				delete cacheDic[key];
		}
	}
}