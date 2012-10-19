package org.flexlite.domDll.loaders
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.IResLoader;
	import org.flexlite.domUtils.SharedMap;
	
	
	/**
	 * 二进制序列化对象加载器
	 * @author DOM
	 */
	public class AmfResLoader extends ResLoaderBase
	{
		/**
		 * 构造函数
		 */		
		public function AmfResLoader()
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