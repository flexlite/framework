package org.flexlite.domDll.analyze
{
	import flash.utils.ByteArray;
	
	/**
	 * 资源解析类接口
	 * @author DOM
	 */
	public interface IAnalyze
	{
		/**
		 * 
		 * @param bytes
		 * @param name
		 * @param compFunc
		 */		
		function analyze(bytes:ByteArray,name:String,compFunc:Function):void;
		/**
		 * 获取解析完成的数据
		 * @param key 通常对应配置文件里的name属性。
		 * @param subKey 二级键名(可选)，例如swf里的导出类名。
		 * 
		 */
		function getData(key:String,subKey:String):*;
	}
}