package org.flexlite.domDll.loaders
{
	import flash.utils.ByteArray;
	
	/**
	 * XML文件加载器
	 * @author DOM
	 */
	public class XmlResLoader extends ResLoaderBase
	{
		/**
		 * 构造函数
		 */		
		public function XmlResLoader()
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
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
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