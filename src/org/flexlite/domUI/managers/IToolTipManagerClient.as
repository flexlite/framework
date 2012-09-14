<<<<<<< HEAD
package org.flexlite.domUI.managers
{
	import flash.events.IEventDispatcher;

	/**
	 * 包含工具提示功能的组件接口
	 * @author DOM
	 */	
	public interface IToolTipManagerClient extends IEventDispatcher
	{
		/**
		 * 此组件的工具提示数据。<br/>
		 * 此属性将赋值给工具提示显示对象的toolTipData属性。通常给此属性直接赋值一个String。<br/>
		 * 当组件的toolTipClass为空时，ToolTipManager将采用注入的默认工具提示类创建显示对象。<br/>
		 * 若toolTipClass不为空时，ToolTipManager将使用指定的toolTipClass创建显示对象。
		 */		
		function get toolTip():Object;
		function set toolTip(value:Object):void;
		
		/**
		 * 创建工具提示显示对象要用到的类,要实现IToolTip接口。注意：若ToolTipManager.reuseToolTip为true，
		 * 所有组件将会共享同一个toolTipClass的实例，缓存在ToolTipManager内，
		 * 销毁时需调用ToolTipManager.destroyToolTip(toolTipClass)才能回收实例。
		 * @see org.flexlite.domUI.managers.ToolTipManager#reuseToolTip
		 * @see org.flexlite.domUI.managers.ToolTipManager#destroyToolTip()
		 */		
		function get toolTipClass():Class;
		function set toolTipClass(value:Class):void;
		
		/**
		 * 当用户将鼠标移至具有工具提示的组件上方时，等待 ToolTip框出现所需的时间（以毫秒为单位）。
		 * 若要立即显示ToolTip框，请将toolTipShowDelay设为0。。默认值：500。
		 */		
		function get toolTipShowDelay():Number;
		function set toolTipShowDelay(value:Number):void;
	}
	
}
=======
package org.flexlite.domUI.managers
{
	import flash.events.IEventDispatcher;

	/**
	 * 包含工具提示功能的组件接口
	 * @author DOM
	 */	
	public interface IToolTipManagerClient extends IEventDispatcher
	{
		/**
		 * 此组件的工具提示数据。<br/>
		 * 此属性将赋值给工具提示显示对象的toolTipData属性。通常给此属性直接赋值一个String。<br/>
		 * 当组件的toolTipClass为空时，ToolTipManager将采用注入的默认工具提示类创建显示对象。<br/>
		 * 若toolTipClass不为空时，ToolTipManager将使用指定的toolTipClass创建显示对象。
		 */		
		function get toolTip():Object;
		function set toolTip(value:Object):void;
		
		/**
		 * 创建工具提示显示对象要用到的类,要实现IToolTip接口。注意：若ToolTipManager.reuseToolTip为true，
		 * 所有组件将会共享同一个toolTipClass的实例，缓存在ToolTipManager内，
		 * 销毁时需调用ToolTipManager.destroyToolTip(toolTipClass)才能回收实例。
		 * @see org.flexlite.domUI.managers.ToolTipManager#reuseToolTip
		 * @see org.flexlite.domUI.managers.ToolTipManager#destroyToolTip()
		 */		
		function get toolTipClass():Class;
		function set toolTipClass(value:Class):void;
		
		/**
		 * 当用户将鼠标移至具有工具提示的组件上方时，等待 ToolTip框出现所需的时间（以毫秒为单位）。
		 * 若要立即显示ToolTip框，请将toolTipShowDelay设为0。。默认值：500。
		 */		
		function get toolTipShowDelay():Number;
		function set toolTipShowDelay(value:Number):void;
	}
	
}
>>>>>>> master
