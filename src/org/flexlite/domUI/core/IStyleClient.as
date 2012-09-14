<<<<<<< HEAD
package org.flexlite.domUI.core
{
	import flash.utils.Dictionary;

	/**
	 * 支持样式绑定的组件接口
	 * @author DOM
	 */	
	public interface IStyleClient
	{
		/**
		 * 获取样式属性值
		 * @param styleName 样式名
		 */		
		function getStyle(styleName:String):*;
		/**
		 * 设置样式属性值
		 * @param styleName 样式名
		 * @param value 属性值
		 */		
		function setStyle(styleName:String,value:*):void;
	}
=======
package org.flexlite.domUI.core
{
	import flash.utils.Dictionary;

	/**
	 * 支持样式绑定的组件接口
	 * @author DOM
	 */	
	public interface IStyleClient
	{
		/**
		 * 获取样式属性值
		 * @param styleName 样式名
		 */		
		function getStyle(styleName:String):*;
		/**
		 * 设置样式属性值
		 * @param styleName 样式名
		 * @param value 属性值
		 */		
		function setStyle(styleName:String,value:*):void;
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}