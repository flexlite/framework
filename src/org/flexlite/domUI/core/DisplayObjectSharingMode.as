package org.flexlite.domUI.core
{
	/**
	 * DisplayObjectSharingMode 类为 IGraphicElement 类的 displayObjectSharingMode 属性定义可能的值。
	 * @author DOM
	 */	
	public final class DisplayObjectSharingMode
	{   
		/**
		 * IGraphicElement 专门拥有一个 DisplayObject。
		 */		
		public static const OWNS_UNSHARED_OBJECT:String = "ownsUnsharedObject";
		
		/**
		 * IGraphicElement 拥有一个被父 IGraphicElementContainer 容器指定给其它 IGraphicElement 的 DisplayObject。 
		 */		
		public static const OWNS_SHARED_OBJECT:String = "ownsSharedObject";
		
		/**
		 * IGraphicElement 已由其父 IGraphicElementContainer 容器指定了一个 DisplayObject。
		 */		
		public static const USES_SHARED_OBJECT:String = "usesSharedObject";
	}
}
