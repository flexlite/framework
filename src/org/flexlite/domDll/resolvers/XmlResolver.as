package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	
	/**
	 * XML文件解析器
	 * @author DOM
	 */
	public class XmlResolver extends ResolverBase
	{
		/**
		 * 构造函数
		 */		
		public function XmlResolver()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
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