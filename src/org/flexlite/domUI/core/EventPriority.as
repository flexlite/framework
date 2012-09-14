package org.flexlite.domUI.core
{
	/**
	 * 事件优先级常量定义
	 * @author DOM
	 */		
	public final class EventPriority
	{
		/**
		 * 鼠标管理器的事件优先级
		 */		
		public static const CURSOR_MANAGEMENT:int = 200;
		
		
		/**
		 * 默认的优先级
		 */		
		public static const DEFAULT:int = 0;
		
		/**
		 * 低于默认优先级的事件。好让别的组件使用preventDefault()以阻止事件发生
		 */		
		public static const DEFAULT_HANDLER:int = -50;
		
	}
}