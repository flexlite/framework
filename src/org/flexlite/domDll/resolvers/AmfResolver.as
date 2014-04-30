package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	/**
	 * 二进制序列化对象解析器<br/>
	 * 将调用ByteArray.writeObject()方法序列化的二进制文件，解析为Object对象。
	 * @author DOM
	 */
	public class AmfResolver extends BinResolver
	{
		/**
		 * 构造函数
		 */		
		public function AmfResolver()
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
			var data:Object = null;
			try
			{
				bytes.position = 0;
				data = bytes.readObject();
			}
			catch(e:Error){}
			sharedMap.set(key,data);
			return data;
		}
	}
}