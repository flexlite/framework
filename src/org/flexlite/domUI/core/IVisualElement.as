package org.flexlite.domUI.core
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 可视元素接口
	 * @author DOM
	 */	
	public interface IVisualElement extends ILayoutElement
	{
		/**
		 * 此IVisualElement对象的所有者。默认情况下，为parent属性的值。
		 * 但当此对象在Skin内部时，它的owner指向Skin的主机组件。
		 */		
		function get owner():DisplayObjectContainer;
		function set owner(value:DisplayObjectContainer):void;
		
		/**
		 * 此组件的父容器或组件。
		 * 只有可视元素应该具有 parent 属性。
		 * 非可视项目应该使用其他属性引用其所属对象。
		 * 一般而言，非可视对象使用 owner 属性引用其所属对象。
		 */
		function get parent():DisplayObjectContainer;
		
		/**
		 * 控制此可视元素的可见性。如果为 true，则对象可见。 
		 */		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		/**
		 * @copy flash.display.DisplayObject#alpha
		 */		
		function get alpha():Number;
		function set alpha(value:Number):void;
		/**
		 * 组件宽度
		 */		
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * 组件高度
		 */		
		function get height():Number;
		function set height(value:Number):void;
		
		/**
		 * @copy flash.display.DisplayObject#x
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * @copy flash.display.DisplayObject#y
		 */		
		function get y():Number;
		function set y(value:Number):void;
	}
}
