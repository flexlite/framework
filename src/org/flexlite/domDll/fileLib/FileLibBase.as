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
		protected var fileDic:Dictionary = new Dictionary;
		/**
		 * 解码后对象的共享缓存表
		 */		
		protected var sharedMap:SharedMap = new SharedMap();
		
		public function addFile(bytes:*,name:String):void
		{
			if(fileDic[name])
				return;
			fileDic[name] = bytes;
		}
		
		public function getRes(key:String):*
		{
			return null;
		}
		
		public function getResAsync(key:String,compFunc:Function):void
		{
			var res:* = getRes(key);
			if(compFunc!=null)
				compFunc(res);
		}
		
		public function hasRes(name:String):Boolean
		{
			return fileDic[name]!=null;
		}
		
		public function destoryRes(name:String):void
		{
			delete fileDic[name];
			sharedMap.remove(name);
		}
	}
}