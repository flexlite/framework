package org.flexlite.domUI.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	/**
	 * 使用布局管理器的组件接口
	 * @author DOM
	 */
	public interface ILayoutManagerClient extends IEventDispatcher
	{
		/**
		 * 验证组件的属性
		 */		
		function validateProperties():void;
		/**
		 * 验证组件的尺寸
		 */		
		function validateSize(recursive:Boolean = false):void;
		/**
		 * 验证子项的位置和大小，并绘制其他可视内容
		 */		
		function validateDisplayList():void;
		/**
		 * 在显示列表的嵌套深度
		 */		
		function get nestLevel():int;
		
		function set nestLevel(value:int):void;
		/**
		 * 是否完成初始化。此标志只能由 LayoutManager 修改。
		 */		
		function get initialized():Boolean;
		function set initialized(value:Boolean):void;
		/**
		 * 一个标志，用于确定某个对象是否正在等待分派其updateComplete事件。此标志只能由 LayoutManager 修改。
		 */		
		function get updateCompletePendingFlag():Boolean;
		function set updateCompletePendingFlag(value:Boolean):void;
		/**
		 * 父级显示对象
		 */		
		function get parent():DisplayObjectContainer;
	}
}