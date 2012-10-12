package org.flexlite.domDll.fileLib
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.IFileLib;
	import org.flexlite.domUtils.SharedMap;
	
	
	/**
	 * 二进制序列化对象文件解析缓存库
	 * @author DOM
	 */
	public class AmfFileLib extends FileLibBase
	{
		/**
		 * 构造函数
		 */		
		public function AmfFileLib()
		{
			super();
		}
		
		override public function getRes(key:String):*
		{
			var bytes:ByteArray = fileDic[key];
			if(!bytes)
				return null;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
			var data:Object = null;
			try
			{
				data = bytes.readObject();
			}
			catch(e:Error){}
			sharedMap.set(key,data);
			return data;
		}
	}
}