package org.flexlite.domDll.fileLib
{
	import flash.utils.ByteArray;
	
	/**
	 * XML文件解析缓存库
	 * @author DOM
	 */
	public class XmlFileLib extends FileLibBase
	{
		/**
		 * 构造函数
		 */		
		public function XmlFileLib()
		{
			super();
		}
		
		override public function getRes(key:String):*
		{
			if(sharedMap.has(key))
				return sharedMap.get(key);
			var bytes:ByteArray = fileDic[key];
			if(!bytes)
				return null;
			bytes.position = 0;
			var resultStr:String = bytes.readUTFBytes(bytes.length);
			var xml:XML
			try
			{
				xml = XML(resultStr);
			}
			catch(e:Error){}
			sharedMap.set(key,xml);
			return xml;
		}
	}
}