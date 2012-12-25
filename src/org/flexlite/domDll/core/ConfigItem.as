package org.flexlite.domDll.core
{
	import org.flexlite.domCore.dx_internal;
	
	/**
	 * 一项Dll配置文件信息
	 * @author DOM
	 */
	public class ConfigItem
	{
		/**
		 * 构造函数
		 * @param url 配置文件路径
		 * @param type 配置文件类型
		 * @param folder 加载项的路径前缀。可将加载项url中重复的部分提取出来作为folder属性。
		 */		
		public function ConfigItem(url:String,type:String="xml",folder:String="")
		{
			this.url = url;
			this.type = type;
			this.folder = folder;
		}
		/**
		 * 配置文件路径
		 */		
		public var url:String;
		/**
		 * 配置文件类型
		 */		
		public var type:String;
		/**
		 * 加载项的路径前缀。可将加载项url中重复的部分提取出来作为folder属性。
		 */		
		public var folder:String;
		/**
		 * 资源名称
		 */		
		dx_internal var name:String;
	}
}