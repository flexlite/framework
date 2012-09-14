package org.flexlite.domDisplay.utils
{
	import org.flexlite.domDisplay.DxrFile;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	/**
	 * Dxr素材库解析工具
	 * @author DOM
	 */
	public class DxrMatLib extends EventDispatcher
	{
		public function DxrMatLib()
		{
		}
		
		private var _dxrFileList:Vector.<DxrFile> = new Vector.<DxrFile>;
		/**
		 * DxrFile列表
		 */
		public function get dxrFileList():Vector.<DxrFile>
		{
			return _dxrFileList;
		}

		/**
		 * 添加DxrFile到库
		 */		
		public function addDxrFile(file:DxrFile):void
		{
			var index:int = 0;
			for each(var dxrFile:DxrFile in dxrFileList)
			{
				if(dxrFile==file)
					return;
				if(dxrFile.path!=""&&dxrFile.path==file.path)
				{
					for(var key:String in returnDxrDic)
					{
						if(dxrFile==returnDxrDic[key])
							delete returnDxrDic[key];
					}
					dxrFileList.splice(index,1);
					break;
				}
				index++;
			}
			
			dxrFileList.push(file);
		}
		
		private var returnDxrDic:Dictionary = new Dictionary;
		/**
		 * 根据导出键名获取DxrData对象
		 * @param key 导出键名
		 * @param onComp 回调函数，示例：onComp(data:DxrData):void;
		 */		
		public function getDxrDataByKey(key:String,onComp:Function):void
		{
			var file:DxrFile = returnDxrDic[key] as DxrFile;
			if(!file)
			{
				for each(file in dxrFileList)
				{
					if(file.hasKey(key))
					{
						returnDxrDic[key] = file;
						break;
					}
				}
			}
			if(file)
			{
				file.getDxrData(key,onComp);
			}
			
		}
	}
}