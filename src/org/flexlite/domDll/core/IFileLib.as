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
		 * 除了swf文件是缓存显示对象外，其余文件都缓存字节流数据。若name已经存在于缓存中，则放弃缓存。
		 * @param file 要缓存的对象
		 * @param name 配置文件中加载项的name属性
		 */		
		function addFile(file:*,name:String):void;
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
	}
}