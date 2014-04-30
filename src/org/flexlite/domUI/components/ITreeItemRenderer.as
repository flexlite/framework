package org.flexlite.domUI.components
{
	
	/**
	 * 树状列表组件的项呈示器接口
	 * @author DOM
	 */
	public interface ITreeItemRenderer extends IItemRenderer
	{
		/**
		 * 图标的皮肤名
		 */
		function get iconSkinName():Object;
		function set iconSkinName(value:Object):void;
		
		/**
		 * 缩进深度。0表示顶级节点，1表示第一层子节点，以此类推。
		 */
		function get depth():int;
		function set depth(value:int):void;
		
		/**
		 * 是否含有子节点。
		 */
		function get hasChildren():Boolean;
		function set hasChildren(value:Boolean):void;

		/**
		 * 节点是否处于开启状态。
		 */
		function get opened():Boolean;
		function set opened(value:Boolean):void;
	}
}