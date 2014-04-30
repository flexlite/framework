package org.flexlite.domDisplay
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.codec.DxrDecoder;
	import org.flexlite.domDisplay.codec.IBitmapDecoder;
	import org.flexlite.domUtils.SharedMap;

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
			if(!keyObject)
				keyObject = {keyList:{}};
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
		 * DxrData缓存表
		 */		
		private var dxrDataMap:SharedMap = new SharedMap();
		/**
		 * 回调函数字典
		 */		
		private var compDic:Dictionary = new Dictionary();
		
		/**
		 * 通过动画导出键名获取指定的DxrData动画数据
		 * @param key 动画导出键名
		 * @param onComp 结果回调函数，示例：onComp(data:DxrData):void,若设置了other参数则为:onComp(data,other):void
		 * @param other 回调参数(可选),若设置了此参数，获取资源后它将会作为回调函数的第二个参数传入。
		 */		
		public function getDxrData(key:String,onComp:Function,other:Object=null):void
		{
			if(onComp==null)
				return;
			var dxr:DxrData = dxrDataMap.get(key);
			if(dxr)
			{
				if(other==null)
					onComp(dxr);
				else
					onComp(dxr,other);
				return;
			}
			
			var data:Object = keyObject.keyList[key];
			if(!data)
			{
				if(other==null)
					onComp(null);
				else
					onComp(null,other);
				return;
			}
			if(compDic[key])
			{
				compDic[key].push({onComp:onComp,other:other});
			}
			else
			{
				compDic[key] = [{onComp:onComp,other:other}];
				var decoder:DxrDecoder = new DxrDecoder();
				decoder.decode(data,key,onGetDxrData);
			}
			
		}
		/**
		 * 解析DxrData完成回调函数
		 */		
		private function onGetDxrData(dxrData:DxrData):void
		{
			dxrDataMap.set(dxrData.key,dxrData);
			var compArr:Array = compDic[dxrData.key];
			delete compDic[dxrData.key];
			var other:Object;
			for each(var data:Object in compArr)
			{
				if(data.other==null)
					data.onComp(dxrData);
				else
					data.onComp(dxrData,data.other);
			}
		}
		
	}
}