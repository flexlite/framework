package org.flexlite.domUI.managers
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

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
		 * 创建工具提示显示对象要用到的类,要实现IToolTip接口。ToolTip默认会被禁用鼠标事件。
		 * 若此属性为空，ToolTipManager将采用默认的工具提示类创建显示对象。<br/>
		 */		
		function get toolTipClass():Class;
		function set toolTipClass(value:Class):void;
		
		/**
		 * toolTip弹出位置，请使用PopUpPosition定义的常量，若不设置或设置了非法的值，则弹出位置跟随鼠标。
		 */		
		function get toolTipPosition():String;
		function set toolTipPosition(value:String):void;
		/**
		 * toolTip弹出位置的偏移量
		 */		
		function get toolTipOffset():Point;
		function set toolTipOffset(value:Point):void;
	}
	
}
