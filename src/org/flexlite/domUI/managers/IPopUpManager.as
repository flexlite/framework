package org.flexlite.domUI.managers
{
	import flash.events.IEventDispatcher;
	
	import org.flexlite.domUI.core.IVisualElement;
	
	
	/**
	 * 窗口弹出管理器接口。若项目需要自定义弹出框管理器，请实现此接口，
	 * 并在项目初始化前调用Injector.mapClass(IPopUpManager,YourPopUpManager)，
	 * 注入自定义的弹出框管理器类。
	 * @author DOM
	 */
	public interface IPopUpManager extends IEventDispatcher
	{
		/**
		 * 模态遮罩的填充颜色
		 */
		function get modalColor():uint;
		function set modalColor(value:uint):void;
		
		/**
		 * 模态遮罩的透明度
		 */
		function get modalAlpha():Number;
		function set modalAlpha(value:Number):void;
		
		/**
		 * 弹出一个窗口。<br/>
		 * @param popUp 要弹出的窗口
		 * @param modal 是否启用模态。即禁用弹出窗口所在层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。等效于在外部调用centerPopUp()来居中。默认true。
		 * @param systemManager 要弹出到的系统管理器。若项目中只含有一个系统管理器，可以留空。
		 */		
		function addPopUp(popUp:IVisualElement,modal:Boolean=false,
										center:Boolean=true,systemManager:ISystemManager=null):void;
		
		/**
		 * 移除由addPopUp()方法弹出的窗口。
		 * @param popUp 要移除的窗口
		 */		
		function removePopUp(popUp:IVisualElement):void;
		
		/**
		 * 将指定窗口居中显示
		 * @param popUp 要居中显示的窗口
		 */
		function centerPopUp(popUp:IVisualElement):void;
		
		/**
		 * 将指定窗口的层级调至最前
		 * @param popUp 要最前显示的窗口
		 */		
		function bringToFront(popUp:IVisualElement):void;
		
		/**
		 * 已经弹出的窗口列表
		 */		
		function get popUpList():Array;
	}
}