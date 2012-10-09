package org.flexlite.domDll.analyze
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * 二进制文件解析器
	 * @author DOM
	 */
	public class BinAnalyze implements IAnalyze
	{
		/**
		 * 构造函数
		 */		
		public function BinAnalyze()
		{
		}
		/**
		 * 数据缓存字典
		 */		
		private var cacheDic:Dictionary = new Dictionary;
		
		public function analyze(bytes:ByteArray, name:String, compFunc:Function):void
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