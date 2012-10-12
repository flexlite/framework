package org.flexlite.domDll.fileLib
{
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domDisplay.DxrFile;
	
	/**
	 * DXR文件解析缓存库
	 * @author DOM
	 */
	public class DxrFileLib extends FileLibBase
	{
		public function DxrFileLib()
		{
			super();
		}
		
		override public function addFile(bytes:*,name:String):void
		{
			if(fileDic[name])
				return;
			fileDic[name] = new DxrFile(bytes,name);
		}
		
		override public function getRes(key:String):*
		{
			var res:* = fileDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			return null;
		}
		
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