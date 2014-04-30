package org.flexlite.domUI.events
{
	/**
	 * PropertyChangeEventKind 类定义 PropertyChangeEvent 类的 kind 属性的常量值。
	 * @author DOM
	 */
	public class PropertyChangeEventKind
	{
		/**
		 * 指示该属性的值已更改。 
		 */		
		public static const UPDATE:String = "update";
		
		/**
		 * 指示该属性已从此对象中删除。
		 */
		public static const DELETE:String = "delete";
	}
}