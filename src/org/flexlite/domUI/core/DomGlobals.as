package org.flexlite.domUI.core
{
	import org.flexlite.domUI.managers.AppContainer;
	import org.flexlite.domUI.managers.ILanguageManager;
	import org.flexlite.domUI.managers.LayoutManager;
	
	import flash.display.Stage;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	use namespace dx_internal;
	
	/**
	 * 全局静态量
	 * @author DOM
	 */
	public class DomGlobals
	{
		private static var _stage:Stage;
		/**
		 * 舞台引用，当第一个UIComponent添加到舞台时此属性被自动赋值
		 */		
		public static function get stage():Stage
		{
			return _stage;
		}
		/**
		 * 已经初始化完成标志
		 */		
		private static var initlized:Boolean = false;
		/**
		 * 初始化管理器
		 */		
		dx_internal static function initlize(stage:Stage):void
		{
			if(initlized)
				return;
			_stage = stage;
			layoutManager = new LayoutManager;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, 1000);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseEventHandler, true, 1000);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, true, 1000);
			initlized = true;
		}
		
		private static function mouseEventHandler(e:MouseEvent):void
		{
			if (!e.cancelable&&e.eventPhase!=EventPhase.BUBBLING_PHASE)
			{
				e.stopImmediatePropagation();
				var cancelableEvent:MouseEvent = null;
				if ("clickCount" in e)
				{
					var mouseEventClass:Class = MouseEvent;
					
					cancelableEvent = new mouseEventClass(e.type, e.bubbles, true, e.localX,
						e.localY, e.relatedObject, e.ctrlKey, e.altKey,
						e.shiftKey, e.buttonDown, e.delta, 
						e["commandKey"], e["controlKey"], e["clickCount"]);
				}
				else
				{
					cancelableEvent = new MouseEvent(e.type, e.bubbles, true, e.localX, 
						e.localY, e.relatedObject, e.ctrlKey, e.altKey,
						e.shiftKey, e.buttonDown, e.delta);
				}
				
				e.target.dispatchEvent(cancelableEvent);               
			}
		}
		
		private static function keyDownHandler(e:KeyboardEvent):void
		{
			if (!e.cancelable)
			{
				switch (e.keyCode)
				{
					case Keyboard.UP:
					case Keyboard.DOWN:
					case Keyboard.PAGE_UP:
					case Keyboard.PAGE_DOWN:
					case Keyboard.HOME:
					case Keyboard.END:
					case Keyboard.LEFT:
					case Keyboard.RIGHT:
					case Keyboard.ENTER:
					{
						e.stopImmediatePropagation();
						var cancelableEvent:KeyboardEvent =
							new KeyboardEvent(e.type, e.bubbles, true, e.charCode, e.keyCode, 
								e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey)              
						e.target.dispatchEvent(cancelableEvent);
					}
				}
			}
		}
		
		/**
		 * 延迟渲染布局管理器 
		 */		
		dx_internal static var layoutManager:LayoutManager;
		
		/**
		 * 多语言管理器 
		 */
		dx_internal static var languageManager:ILanguageManager;

		/**
		 * 设置多语言管理器
		 */
		public static function setLanguageManager(value:ILanguageManager):void
		{
			languageManager = value;
		}
		
		/**
		 * 全局容器的类
		 */		
		public static var appContainer:AppContainer;

		
	}
}