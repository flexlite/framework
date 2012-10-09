package org.flexlite.domDll.analyze
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * 二进制序列化对象文件解析器
	 * @author DOM
	 */
	public class AmfAnalyze implements IAnalyze
	{
		public function AmfAnalyze()
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
			var byte:ByteArray = cacheDic[key];
			if(byte)
			{
				try
				{
					byte.uncompress();
				}
				catch(e:Error){}
				return byte.readObject();
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