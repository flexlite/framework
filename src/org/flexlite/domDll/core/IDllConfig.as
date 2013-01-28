package org.flexlite.domDll.core
{
	
	/**
	 * Dll配置文件解析器接口
	 * @author DOM
	 */
	public interface IDllConfig
	{
		/**
		 * 设置当前的语言环境
		 */
		function setLanguage(value:String):void;
		/**
		 * 解析一个配置文件
		 * @param data 配置文件数据
		 * @param folder 加载项的路径前缀。
		 */				
		function parseConfig(data:Object,folder:String):void;
		/**
		 * 根据组名获取组加载项列表
		 * @param name 组名
		 */		
		function getGroupByName(name:String):Vector.<DllItem>;
		/**
		 * 获取加载项类型。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		function getType(key:String):String;
		/**
		 * 获取加载项名称(name属性)
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		function getName(key:String):String;
		/**
		 * 获取加载项信息对象
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		function getDllItem(key:String):DllItem;
	}
}