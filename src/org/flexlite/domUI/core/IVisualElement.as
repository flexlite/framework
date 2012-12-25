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
		 * 元素名称。此属性在TabNavigator里作为选项卡显示的字符串。
		 */		
		function get name():String;
		function set name(value:String):void;
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
		 * 表示指定对象的 Alpha 透明度值。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。alpha 设置为 0 的显示对象是活动的，即使它们不可见。
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
		 * 表示 DisplayObject 实例相对于父级 DisplayObjectContainer 本地坐标的 x 坐标。
		 * 如果该对象位于具有变形的 DisplayObjectContainer 内，则它也位于包含 DisplayObjectContainer 
		 * 的本地坐标系中。因此，对于逆时针旋转 90 度的 DisplayObjectContainer，该 DisplayObjectContainer 
		 * 的子级将继承逆时针旋转 90 度的坐标系。对象的坐标指的是注册点的位置。
		 */		
		function get x():Number;
		function set x(value:Number):void;
		/**
		 * 表示 DisplayObject 实例相对于父级 DisplayObjectContainer 本地坐标的 y 坐标。
		 * 如果该对象位于具有变形的 DisplayObjectContainer 内，则它也位于包含 DisplayObjectContainer 
		 * 的本地坐标系中。因此，对于逆时针旋转 90 度的 DisplayObjectContainer，该 DisplayObjectContainer 
		 * 的子级将继承逆时针旋转 90 度的坐标系。对象的坐标指的是注册点的位置。
		 */		
		function get y():Number;
		function set y(value:Number):void;
	}
}
