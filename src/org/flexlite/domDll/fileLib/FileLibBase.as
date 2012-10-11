package org.flexlite.domDll.fileLib
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.IFileLib;
	import org.flexlite.domUtils.SharedMap;
	
	
	/**
	 * 文件解析缓存库基类
	 * @author DOM
	 */
	public class FileLibBase implements IFileLib
	{
		/**
		 * 构造函数
		 */		
		public function FileLibBase()
		{
		}
		/**
		 * 字节流数据缓存字典
		 */		
		protected var bytesDic:Dictionary = new Dictionary;
		/**
		 * 解码后对象的共享缓存表
		 */		
		protected var sharedMap:SharedMap = new SharedMap();
		
		public function addFileBytes(bytes:ByteArray,name:String):void
		{
			if(bytesDic[name])
				return;
			bytesDic[name] = bytes;
		}
		
		public function getRes(key:String,subKey:String=""):*
		{
			return null;
		}
		
		public function getResAsync(key:String,compFunc:Function,subKey:String=""):void
		{
			var res:* = getRes(key,subKey);
			if(compFunc!=null)
				compFunc(res);
		}
		
		public function destoryRes(key:String):void
		{
			delete bytesDic[key];
			sharedMap.remove(key);
		}
	}
}