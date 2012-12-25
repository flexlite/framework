package org.flexlite.domDll.core
{
	import flash.utils.ByteArray;

	
	/**
	 * 文件解析器接口
	 * @author DOM
	 */
	public interface IResolver
	{
		/**
		 * 加载一个资源文件
		 * @param dllItem 加载项信息
		 * @param compFunc 加载完成回调函数,示例:compFunc(dllItem:DllItem):void;
		 * @param onProgress 加载进度回调函数,示例:onProgress(bytesLoaded:int,dllItem:DllItem):void;
		 */			
		function loadFile(dllItem:DllItem,compFunc:Function,onProgress:Function):void;
		/**
		 * 通过字节流解析并缓存一个资源文件
		 * @param bytes 资源文件字节流
		 * @param name 配置文件中加载项的name属性
		 */
		function loadBytes(bytes:ByteArray,name:String):void
		/**
		 * 同步方式获取解析完成的数据
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */
		function getRes(key:String):*;
		/**
		 * 异步方式获取解析完成的数据。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 * @param compFunc 解析完成回调函数
		 */		
		function getResAsync(key:String,compFunc:Function):void;
		/**
		 * 是否已经含有某个资源文件的缓存数据
		 * @param name 配置文件中加载项的name属性
		 */		
		function hasRes(name:String):Boolean;
		/**
		 * 销毁某个资源文件的二进制数据,返回是否删除成功。
		 * @param name 配置文件中加载项的name属性
		 */		
		function destroyRes(name:String):Boolean;
	}
}