package org.flexlite.domUI.core
{
	
	/**
	 * 可设置外观的组件接口
	 * @author DOM
	 */
	public interface ISkinnableClient extends IVisualElement
	{
		/**
		 * 皮肤标识符。可以为Class,String,或DisplayObject实例等任意类型。
		 * 具体规则由项目注入的ISkinAdapter决定，皮肤适配器将在运行时解析此标识符，然后返回皮肤对象给组件。
		 */	
		function get skinName():Object;
		function set skinName(value:Object):void;
	}
}