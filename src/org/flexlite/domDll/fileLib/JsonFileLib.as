package org.flexlite.domDll.fileLib
{
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.ByteArray;
	
	/**
	 * JSON文件解析缓存库
	 * @author DOM
	 */
	public class JsonFileLib extends FileLibBase
	{
		public function JsonFileLib()
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
			var data:Object;
			try
			{
				data = com.adobe.serialization.json.JSON.decode(resultStr);
			}
			catch(e:Error){}
			sharedMap.set(key,data);
			return data;
		}
	}
}