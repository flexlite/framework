package org.flexlite.domUI.core
{
	import flash.ui.Keyboard;
	
	/**
	 * NavigationUnit 类为 IViewport 类的getVerticalScrollPositionDelta() 
	 * 和 getHorizontalScrollPositionDelta() 方法定义可能的值。 
	 * @author DOM
	 */	
	public final class NavigationUnit
	{
		/**
		 * 导航到文档的开头。 
		 */		
		public static const HOME:uint = Keyboard.HOME;
		/**
		 * 导航到文档的末尾。 
		 */		
		public static const END:uint = Keyboard.END;
		/**
		 * 向上导航一行或向上“步进”。 
		 */		
		public static const UP:uint = Keyboard.UP;
		/**
		 * 向上导航一行或向上“步进”。
		 */		
		public static const DOWN:uint = Keyboard.DOWN;
		/**
		 * 向上导航一行或向上“步进”。 
		 */		
		public static const LEFT:uint = Keyboard.LEFT;
		/**
		 * 向右导航一行或向右“步进”。
		 */		
		public static const RIGHT:uint = Keyboard.RIGHT;
		/**
		 * 向上导航一页。
		 */		
		public static const PAGE_UP:uint = Keyboard.PAGE_UP;
		/**
		 * 向下导航一页。
		 */		
		public static const PAGE_DOWN:uint = Keyboard.PAGE_DOWN;
		/**
		 * 向左导航一页。
		 */		
		public static const PAGE_LEFT:uint = 0x2397;
		/**
		 * 向左导航一页。
		 */		
		public static const PAGE_RIGHT:uint = 0x2398;
	}
}
