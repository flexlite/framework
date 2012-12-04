package org.flexlite.domUI.managers
{

	
	import org.flexlite.domCore.dx_internal;

	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.PopUpEvent;
	import org.flexlite.domUI.managers.impl.PopUpManagerImpl;
	
	use namespace dx_internal;
	
	/**
	 * 窗口弹出管理器
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
		
		private static var _impl:PopUpManagerImpl;
		/**
		 * 获取单例
		 */		
		private static function get impl():PopUpManagerImpl
		{
			if (!_impl)
			{
				_impl = new PopUpManagerImpl();
			}
			return _impl;
		}
		
		/**
		 * 模态遮罩层对象。若不设置，默认创建一个填充色为白色，透明度0.5的Rect对象作为模态遮罩。
		 */
		public static function get modalMask():IVisualElement
		{
			return impl.modalMask;
		}
		public static function set modalMask(value:IVisualElement):void
		{
			impl.modalMask = value;
		}
		
		/**
		 * 弹出一个窗口。<br/>
		 * @param popUp 要弹出的窗口
		 * @param modal 是否启用模态。即禁用弹出窗口所在层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。等效于在外部调用centerPopUp()来居中。默认true。
		 */		
		public static function addPopUp(popUp:IVisualElement,modal:Boolean=false,center:Boolean=true):void
		{
			impl.addPopUp(popUp,modal,center);
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