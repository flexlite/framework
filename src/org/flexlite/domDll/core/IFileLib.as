package org.flexlite.domDll.core
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * 文件解析缓存库接口
	 * @author DOM
	 */
	public interface IFileLib
	{
		/**
		 * 缓存字节流数据。若name已经存在于缓存中，则以放弃当前字节流。
		 * @param bytes 要解析的二进制字节流
		 * @param name 文件的唯一标识符
		 */		
		function addFileBytes(bytes:ByteArray,name:String):void;
		/**
		 * 同步方式获取解析完成的数据
		 * @param key 通常对应配置文件里的name属性。
		 * @param subKey 二级键名(可选)，通常对应swf里的导出类名。
		 */
		function getRes(key:String,subKey:String=""):*;
		/**
		 * 异步方式获取解析完成的数据。
		 * @param key 通常对应配置文件里的name属性。
		 * @param compFunc 解析完成回调函数
		 * @param subKey 二级键名(可选)，通常对应swf里的导出类名。
		 */		
		function getResAsync(key:String,compFunc:Function,subKey:String=""):void;
		/**
		 * 销毁指定key对应文件的缓存数据。
		 * @param key 通常对应配置文件里的name属性
		 */		
		function destoryRes(key:String):void;
	}
}