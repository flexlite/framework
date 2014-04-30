package org.flexlite.domUI.components
{
	import org.flexlite.domUI.core.ILayoutElement;

	/**
	 * 列表类组件的项呈示器接口
	 * @author DOM
	 */
	public interface IItemRenderer extends ILayoutElement
	{
		/**
		 * 要呈示或编辑的数据。
		 */		
		function get data():Object;
		function set data(value:Object):void;
		/**
		 * 如果项呈示器可以将其自身显示为已选中，则包含 true。
		 */		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		/**
		 * 项呈示器的主机组件的数据提供程序中的项目索引。
		 */		
		function get itemIndex():int;
		function set itemIndex(value:int):void;
		/**
		 * 要在项呈示器中显示的 String。 
		 */		
		function get label():String;
		function set label(value:String):void;
	}
}