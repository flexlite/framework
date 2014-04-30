package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	
	/**
	 * 文本文件解析器
	 * @author DOM
	 */
	public class TxtResolver extends BinResolver
	{
		public function TxtResolver()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			var bytes:ByteArray = fileDic[key];
			if(!bytes)
				return "";
			bytes.position = 0;
			return bytes.readUTFBytes(bytes.length);
		}
	}
}