<<<<<<< HEAD
package org.flexlite.domDisplay
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDisplay.codec.DxrDecoder;
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.managers.InjectorManager;

	use namespace dx_internal;
	/**
	 * DXR动画文件解析类
	 * @author DOM
	 */	
	public class DxrFile
	{
		/**
		 * 构造函数
		 * @param data DXR文件字节流数据
		 */		
		public function DxrFile(data:ByteArray,path:String="")
		{
			keyObject = DxrDecoder.readObject(data);
			this._path = path;
		}
		
		private var _path:String;

		/**
		 * 文件路径
		 */
		public function get path():String
		{
			return _path;
		}

		/**
		 * 位图解码器实例
		 */		
		private var bitmapDecoder:IBitmapDecoder;
		
		/**
		 * 获取动画导出键名列表
		 */
		public function getKeyList():Vector.<String>
		{
			var keyList:Vector.<String> = new Vector.<String>;
			for(var key:String in keyObject.keyList)
			{
				keyList.push(key);
			}
			return keyList;
		}
		
		dx_internal var keyObject:Object;
		
		/**
		 * 是否包含指定导出键名的动画
		 * @param key 
		 */
		public function hasKey(key:String):Boolean
		{
			return keyObject.keyList[key]!=null;
		}
		
		/**
		 * DxrData缓存字典
		 */		
		private var dxrDataDic:Dictionary;
		
		private var compFuncDic:Dictionary;
		
		/**
		 * 通过动画导出键名获取指定的DxrData动画数据
		 * @param key 动画导出键名
		 * @param onComp 结果回调函数，示例：onComp(data:DxrData);
		 */		
		public function getDxrData(key:String,onComp:Function):void
		{
			if(dxrDataDic==null)
			{
				dxrDataDic = new Dictionary;
			}
			else
			{
				for(var dxr:* in dxrDataDic)
				{
					if(dxrDataDic[dxr]===key)
					{
						if(onComp!=null)
							onComp(dxr);
						return;
					}
				}
			}
			
			var data:Object = keyObject.keyList[key];
			if(data==null)
			{
				if(onComp!=null)
					onComp(null);
				return;
			}
			if(compFuncDic==null)
			{
				compFuncDic = new Dictionary;
			}
			if(compFuncDic[key]==null)
			{
				compFuncDic[key] = new <Function>[onComp];
				
				var decoder:DxrDecoder = new DxrDecoder();
				decoder.decode(data,key,onGetDxrData);
			}
			else
			{
				(compFuncDic[key] as Vector.<Function>).push(onComp);
			}
			
		}
		
		private function onGetDxrData(dxrData:DxrData):void
		{
			dxrDataDic[dxrData] = dxrData.key;
			var funcVec:Vector.<Function> = compFuncDic[dxrData.key];
			delete compFuncDic[dxrData.key];
			for each(var compFunc:Function in funcVec)
				compFunc(dxrData);
		}
		
	}
=======
package org.flexlite.domDisplay
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDisplay.codec.DxrDecoder;
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.managers.InjectorManager;

	use namespace dx_internal;
	/**
	 * DXR动画文件解析类
	 * @author DOM
	 */	
	public class DxrFile
	{
		/**
		 * 构造函数
		 * @param data DXR文件字节流数据
		 */		
		public function DxrFile(data:ByteArray,path:String="")
		{
			keyObject = DxrDecoder.readObject(data);
			this._path = path;
		}
		
		private var _path:String;

		/**
		 * 文件路径
		 */
		public function get path():String
		{
			return _path;
		}

		/**
		 * 位图解码器实例
		 */		
		private var bitmapDecoder:IBitmapDecoder;
		
		/**
		 * 获取动画导出键名列表
		 */
		public function getKeyList():Vector.<String>
		{
			var keyList:Vector.<String> = new Vector.<String>;
			for(var key:String in keyObject.keyList)
			{
				keyList.push(key);
			}
			return keyList;
		}
		
		dx_internal var keyObject:Object;
		
		/**
		 * 是否包含指定导出键名的动画
		 * @param key 
		 */
		public function hasKey(key:String):Boolean
		{
			return keyObject.keyList[key]!=null;
		}
		
		/**
		 * DxrData缓存字典
		 */		
		private var dxrDataDic:Dictionary;
		
		private var compFuncDic:Dictionary;
		
		/**
		 * 通过动画导出键名获取指定的DxrData动画数据
		 * @param key 动画导出键名
		 * @param onComp 结果回调函数，示例：onComp(data:DxrData);
		 */		
		public function getDxrData(key:String,onComp:Function):void
		{
			if(dxrDataDic==null)
			{
				dxrDataDic = new Dictionary;
			}
			else
			{
				for(var dxr:* in dxrDataDic)
				{
					if(dxrDataDic[dxr]===key)
					{
						if(onComp!=null)
							onComp(dxr);
						return;
					}
				}
			}
			
			var data:Object = keyObject.keyList[key];
			if(data==null)
			{
				if(onComp!=null)
					onComp(null);
				return;
			}
			if(compFuncDic==null)
			{
				compFuncDic = new Dictionary;
			}
			if(compFuncDic[key]==null)
			{
				compFuncDic[key] = new <Function>[onComp];
				
				var decoder:DxrDecoder = new DxrDecoder();
				decoder.decode(data,key,onGetDxrData);
			}
			else
			{
				(compFuncDic[key] as Vector.<Function>).push(onComp);
			}
			
		}
		
		private function onGetDxrData(dxrData:DxrData):void
		{
			dxrDataDic[dxrData] = dxrData.key;
			var funcVec:Vector.<Function> = compFuncDic[dxrData.key];
			delete compFuncDic[dxrData.key];
			for each(var compFunc:Function in funcVec)
				compFunc(dxrData);
		}
		
	}
>>>>>>> master
}