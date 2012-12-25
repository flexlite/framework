package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domDisplay.DxrFile;
	
	/**
	 * DXR文件解析器
	 * @author DOM
	 */
	public class DxrResolver extends BinResolver
	{
		public function DxrResolver()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function loadBytes(bytes:ByteArray,name:String):void
		{
			if(fileDic[name]||!bytes)
				return;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
			fileDic[name] = new DxrFile(bytes,name);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			var res:* = fileDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getResAsync(key:String, compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:* = getRes(key);
			if(res)
			{
				compFunc(res);
			}
			else 
			{
				var file:DxrFile;
				var found:Boolean = false;
				for each(file in fileDic)
				{
					if(file.hasKey(key))
					{
						found = true;
						break;
					}
				}
				if(found)
				{
					file.getDxrData(key,function(data:DxrData):void{
						sharedMap.set(key,data);
						compFunc(data);
					});
				}
				else
				{
					compFunc(null);
				}
			}
		}
	}
}