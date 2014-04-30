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
		 * 创建自定义的加载资源组
		 * @param name 要创建的加载资源组的组名
		 * @param keys 要包含的键名列表，key对应配置文件里的name属性或sbuKeys属性的一项。
		 * @param override 是否覆盖已经存在的同名资源组,默认false。
		 * @return 是否创建成功，如果传入的keys为空，或keys全部无效，则创建失败。
		 */	
		function createGroup(name:String,keys:Array,override:Boolean=false):Boolean;
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