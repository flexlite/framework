package org.flexlite.domDll.assetLibs
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.flexlite.domDll.core.IAssetLib;
	
	
	/**
	 * 二进制序列化对象文件解析器
	 * @author DOM
	 */
	public class AmfAssetLib implements IAssetLib
	{
		public function AmfAssetLib()
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