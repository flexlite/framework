package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.IResolver;
	import org.flexlite.domUtils.SharedMap;
	
	
	/**
	 * 二进制序列化对象解析器
	 * @author DOM
	 */
	public class AmfResolver extends ResolverBase
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
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
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