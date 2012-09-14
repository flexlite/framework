<<<<<<< HEAD
package org.flexlite.domDisplay.utils
{
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domDisplay.DxrFile;
	
	/**
	 * 批量解码DxrFile列表中所有dxrData的工具类
	 * @author DOM
	 */
	public class DxrMultiDecoder
	{
		/**
		 * 构造函数
		 */		
		public function DxrMultiDecoder()
		{
		}
		
		private var dxrDataList:Array;
		/**
		 * 全部解码完成回调函数
		 */		
		private var allCompFunc:Function;
		/**
		 * 单个dxrData解码完成回调函数
		 */		
		private var oneCompFunc:Function;
		
		/**
		 * 待解码的dxr文件列表
		 */		
		private var dxrFileList:Vector.<DxrFile>;
		/**
		 * 当前解码的文件索引
		 */		
		private var currentFileIndex:int;
		/**
		 * 当前解码的文件包含的导出键名列表
		 */		
		private var currentKeyList:Vector.<String>;
		/**
		 * 当前解码的导出键名
		 */		
		private var currentKeyIndex:int;
		/**
		 * 批量解码DxrFile列表中所有dxrData
		 * @param dxrFileList DxrFile对象列表
		 * @param onAllComp 全部解码完成回调函数,示例：compFunc(dxrDataList:Array);
		 * @param onOneComp 单个解码完成回调函数,示例：compFunc(dxrData:DxrData);
		 */		
		public function decode(dxrFileList:Vector.<DxrFile>,onAllComp:Function=null,onOneComp:Function=null):void
		{
			if(dxrFileList==null||dxrFileList.length==0)
				return;
			this.dxrFileList = dxrFileList;
			this.allCompFunc = onAllComp;
			this.oneCompFunc = onOneComp;
			currentFileIndex = 0;
			currentKeyList = (dxrFileList[currentFileIndex] as DxrFile).getKeyList();
			currentKeyIndex = 0;
			if(onAllComp!=null)
				dxrDataList = [];
			else
				dxrDataList = null;
			next();
		}
		/**
		 * 解码一个dxrData
		 */		
		private function decodeOne():void
		{
			var currentKey:String = currentKeyList[currentKeyIndex];
			(dxrFileList[currentFileIndex] as DxrFile).getDxrData(currentKey,onOneComp);
		}
		/**
		 * 一个dxrData解码完成
		 */		
		private function onOneComp(data:DxrData):void
		{
			currentKeyIndex ++;
			if(dxrDataList)
				dxrDataList.push(data);
			if(oneCompFunc!=null)
				oneCompFunc(data);
			next();
		}
		/**
		 * 解码下一个dxrData
		 */		
		private function next():void
		{
			if(currentKeyIndex<currentKeyList.length)
			{
				decodeOne();
			}
			else
			{
				currentKeyIndex = 0;
				currentFileIndex++;
				if(currentFileIndex<dxrFileList.length)
				{
					currentKeyList = (dxrFileList[currentFileIndex] as DxrFile).getKeyList();
					next();
				}
				else
				{
					onAllComp();
				}
			}
		}
		/**
		 * 全部解码完成
		 */		
		private function onAllComp():void
		{
			if(allCompFunc!=null)
			{
				allCompFunc(dxrDataList);
				allCompFunc = null;
			}
			dxrDataList = null;
			currentKeyList = null;
		}
	}
=======
package org.flexlite.domDisplay.utils
{
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domDisplay.DxrFile;
	
	/**
	 * 批量解码DxrFile列表中所有dxrData的工具类
	 * @author DOM
	 */
	public class DxrMultiDecoder
	{
		/**
		 * 构造函数
		 */		
		public function DxrMultiDecoder()
		{
		}
		
		private var dxrDataList:Array;
		/**
		 * 全部解码完成回调函数
		 */		
		private var allCompFunc:Function;
		/**
		 * 单个dxrData解码完成回调函数
		 */		
		private var oneCompFunc:Function;
		
		/**
		 * 待解码的dxr文件列表
		 */		
		private var dxrFileList:Vector.<DxrFile>;
		/**
		 * 当前解码的文件索引
		 */		
		private var currentFileIndex:int;
		/**
		 * 当前解码的文件包含的导出键名列表
		 */		
		private var currentKeyList:Vector.<String>;
		/**
		 * 当前解码的导出键名
		 */		
		private var currentKeyIndex:int;
		/**
		 * 批量解码DxrFile列表中所有dxrData
		 * @param dxrFileList DxrFile对象列表
		 * @param onAllComp 全部解码完成回调函数,示例：compFunc(dxrDataList:Array);
		 * @param onOneComp 单个解码完成回调函数,示例：compFunc(dxrData:DxrData);
		 */		
		public function decode(dxrFileList:Vector.<DxrFile>,onAllComp:Function=null,onOneComp:Function=null):void
		{
			if(dxrFileList==null||dxrFileList.length==0)
				return;
			this.dxrFileList = dxrFileList;
			this.allCompFunc = onAllComp;
			this.oneCompFunc = onOneComp;
			currentFileIndex = 0;
			currentKeyList = (dxrFileList[currentFileIndex] as DxrFile).getKeyList();
			currentKeyIndex = 0;
			if(onAllComp!=null)
				dxrDataList = [];
			else
				dxrDataList = null;
			next();
		}
		/**
		 * 解码一个dxrData
		 */		
		private function decodeOne():void
		{
			var currentKey:String = currentKeyList[currentKeyIndex];
			(dxrFileList[currentFileIndex] as DxrFile).getDxrData(currentKey,onOneComp);
		}
		/**
		 * 一个dxrData解码完成
		 */		
		private function onOneComp(data:DxrData):void
		{
			currentKeyIndex ++;
			if(dxrDataList)
				dxrDataList.push(data);
			if(oneCompFunc!=null)
				oneCompFunc(data);
			next();
		}
		/**
		 * 解码下一个dxrData
		 */		
		private function next():void
		{
			if(currentKeyIndex<currentKeyList.length)
			{
				decodeOne();
			}
			else
			{
				currentKeyIndex = 0;
				currentFileIndex++;
				if(currentFileIndex<dxrFileList.length)
				{
					currentKeyList = (dxrFileList[currentFileIndex] as DxrFile).getKeyList();
					next();
				}
				else
				{
					onAllComp();
				}
			}
		}
		/**
		 * 全部解码完成
		 */		
		private function onAllComp():void
		{
			if(allCompFunc!=null)
			{
				allCompFunc(dxrDataList);
				allCompFunc = null;
			}
			dxrDataList = null;
			currentKeyList = null;
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}