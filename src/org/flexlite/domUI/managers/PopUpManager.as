package org.flexlite.domUI.managers
{

	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.PopUpEvent;
	import org.flexlite.domUI.managers.impl.PopUpManagerImpl;
	
	use namespace dx_internal;
	
	/**
	 * 窗口弹出管理器<p/>
	 * 若项目需要自定义弹出框管理器，请实现IPopUpManager接口，
	 * 并在项目初始化前调用Injector.mapClass(IPopUpManager,YourPopUpManager)，
	 * 注入自定义的弹出框管理器类。
	 * @author DOM
	 */	
	public class PopUpManager
	{
		/**
		 * 构造函数
		 */		
		public function PopUpManager()
		{
		}
		
		private static var _impl:IPopUpManager;
		/**
		 * 获取单例
		 */		
		private static function get impl():IPopUpManager
		{
			if (!_impl)
			{
				try
				{
					_impl = Injector.getInstance(IPopUpManager);
				}
				catch(e:Error)
				{
					_impl = new PopUpManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 模态遮罩的填充颜色
		 */
		public function get modalColor():uint
		{
			return impl.modalColor;
		}
		public function set modalColor(value:uint):void
		{
			impl.modalColor = value;
		}
		
		/**
		 * 模态遮罩的透明度
		 */
		public function get modalAlpha():Number
		{
			return impl.modalAlpha;
		}
		public function set modalAlpha(value:Number):void
		{
			impl.modalAlpha = value;
		}
		
		/**
		 * 弹出一个窗口。<br/>
		 * @param popUp 要弹出的窗口
		 * @param modal 是否启用模态。即禁用弹出窗口所在层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。等效于在外部调用centerPopUp()来居中。默认true。
		 * @param systemManager 要弹出到的系统管理器。若项目中只含有一个系统管理器，可以留空。
		 */		
		public static function addPopUp(popUp:IVisualElement,modal:Boolean=false,
										center:Boolean=true,systemManager:ISystemManager=null):void
		{
			impl.addPopUp(popUp,modal,center,systemManager);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.ADD_POPUP,false,false,popUp,modal));
		}
		
		/**
		 * 移除由addPopUp()方法弹出的窗口。
		 * @param popUp 要移除的窗口
		 */		
		public static function removePopUp(popUp:IVisualElement):void
		{
			impl.removePopUp(popUp);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.REMOVE_POPUP,false,false,popUp));
		}
		
		/**
		 * 将指定窗口居中显示
		 * @param popUp 要居中显示的窗口
		 */
		public static function centerPopUp(popUp:IVisualElement):void
		{
			impl.centerPopUp(popUp);
		}
		
		/**
		 * 将指定窗口的层级调至最前
		 * @param popUp 要最前显示的窗口
		 */		
		public static function bringToFront(popUp:IVisualElement):void
		{
			impl.bringToFront(popUp);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.BRING_TO_FRONT,false,false,popUp));
		}
		/**
		 * 已经弹出的窗口列表
		 */		
		public static function get popUpList():Array
		{
			return impl.popUpList;
		}
		
		/**
		 * 添加事件监听,参考PopUpEvent定义的常量。
		 * @see org.flexlite.domUI.events.PopUpEvent
		 */		
		public static function addEventListener(type:String, listener:Function,
												useCapture:Boolean = false,
												priority:int = 0,
												useWeakReference:Boolean = true):void
		{
			impl.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		/**
		 * 移除事件监听,参考PopUpEvent定义的常量。
		 * @see org.flexlite.domUI.events.PopUpEvent
		 */	
		public static function removeEventListener(type:String, listener:Function,
															useCapture:Boolean = false):void
		{
			impl.removeEventListener(type,listener,useCapture);
		}
	}
}