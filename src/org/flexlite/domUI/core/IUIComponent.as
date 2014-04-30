package org.flexlite.domUI.core
{
	import org.flexlite.domUI.managers.ISystemManager;

	/**
	 * UI组件接口
	 * @author DOM
	 */	
	public interface IUIComponent extends IVisualElement
	{
		/**
		 * 组件是否可以接受用户交互。
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		/**
		 * PopUpManager将其设置为true,以指示已弹出该组件。
		 */
		function get isPopUp():Boolean;
		function set isPopUp(value:Boolean):void;
		/**
		 * 外部显式指定的高度
		 */
		function get explicitHeight():Number;
		/**
		 * 外部显式指定的宽度
		 */
		function get explicitWidth():Number;
		/**
		 * 设置组件的宽高，w,h均不包含scale值。此方法不同于直接设置width,height属性，
		 * 不会影响显式标记尺寸属性widthExplicitlySet,_heightExplicitlySet
		 */		
		function setActualSize(newWidth:Number, newHeight:Number):void;
		/**
		 * 当鼠标在组件上按下时，是否能够自动获得焦点的标志。注意：UIComponent的此属性默认值为false。
		 */		
		function get focusEnabled():Boolean;
		function set focusEnabled(value:Boolean):void;
		/**
		 * 设置当前组件为焦点对象
		 */		
		function setFocus():void;
		/**
		 * 所属的系统管理器
		 */		
		function get systemManager():ISystemManager;
		function set systemManager(value:ISystemManager):void;
	}
	
}
