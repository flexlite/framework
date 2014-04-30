package org.flexlite.domUI.managers
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import org.flexlite.domUI.core.IContainer;
	
	/**
	 * 
	 * @author DOM
	 */
	public interface ISystemManager extends IEventDispatcher
	{
		/**
		 * 弹出窗口层容器。
		 */	
		function get popUpContainer():IContainer;
		/**
		 * 工具提示层容器。
		 */		
		function get toolTipContainer():IContainer;
		/**
		 * 鼠标样式层容器。
		 */		
		function get cursorContainer():IContainer;
		/**
		 * 舞台引用
		 */		
		function get stage():Stage;
	}
}