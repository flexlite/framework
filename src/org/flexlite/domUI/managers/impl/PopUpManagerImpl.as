package org.flexlite.domUI.managers.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.managers.IPopUpManager;
	import org.flexlite.domUI.managers.ISystemManager;

	[ExcludeClass]
	
	/**
	 * 窗口弹出管理器实现类
	 * @author DOM
	 */
	public class PopUpManagerImpl extends EventDispatcher implements IPopUpManager
	{
		/**
		 * 构造函数
		 */		
		public function PopUpManagerImpl()
		{
		}
		
		private var _popUpList:Array = [];
		/**
		 * 已经弹出的窗口列表
		 */		
		public function get popUpList():Array
		{
			return _popUpList.concat();
		}
		/**
		 * 模态窗口列表
		 */		
		private var popUpDataList:Vector.<PopUpData> = new Vector.<PopUpData>();
		/**
		 * 根据popUp获取对应的popUpData
		 */		
		private function findPopUpData(popUp:IVisualElement):PopUpData
		{
			for each(var data:PopUpData in popUpDataList)
			{
				if(data.popUp==popUp)
					return data;
			}
			return null;
		}
		
		private static const REMOVE_FROM_SYSTEMMANAGER:String = "removeFromSystemManager";
		/**
		 * 弹出一个窗口。<br/>
		 * @param popUp 要弹出的窗口
		 * @param modal 是否启用模态。即禁用弹出窗口所在层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。等效于在外部调用centerPopUp()来居中。默认true。
		 * @param systemManager 要弹出到的系统管理器。若项目中只含有一个系统管理器，则可以留空。
		 */		
		public function addPopUp(popUp:IVisualElement,modal:Boolean=false,
								 center:Boolean=true,systemManager:ISystemManager=null):void
		{
			if(!systemManager)
				systemManager = DomGlobals.systemManager;
			if(!systemManager)
				return;
			var data:PopUpData = findPopUpData(popUp);
			if(data)
			{
				data.modal = modal;
				popUp.removeEventListener(REMOVE_FROM_SYSTEMMANAGER,onRemoved);
			}
			else
			{
				data = new PopUpData(popUp,modal);
				popUpDataList.push(data);
				_popUpList.push(popUp);
			}
			systemManager.popUpContainer.addElement(popUp);
			if(center)
				centerPopUp(popUp);
			if(popUp is IUIComponent)
				IUIComponent(popUp).isPopUp = true;
			if(modal)
			{
				invalidateModal(systemManager);
			}
			popUp.addEventListener(REMOVE_FROM_SYSTEMMANAGER,onRemoved);
		}
		
		/**
		 * 从舞台移除
		 */		
		private function onRemoved(event:Event):void
		{
			var index:int = 0;
			for each(var data:PopUpData in popUpDataList)
			{
				if(data.popUp==event.target)
				{
					if(data.popUp is IUIComponent)
						IUIComponent(data.popUp).isPopUp = false;
					data.popUp.removeEventListener(REMOVE_FROM_SYSTEMMANAGER,onRemoved);
					popUpDataList.splice(index,1);
					_popUpList.splice(index,1);
					invalidateModal(data.popUp.parent as ISystemManager);
					break;
				}
				index++;
			}
		}
		
		
		private var _modalColor:uint = 0x000000;
		/**
		 * 模态遮罩的填充颜色
		 */
		public function get modalColor():uint
		{
			return _modalColor;
		}
		public function set modalColor(value:uint):void
		{
			if(_modalColor==value)
				return;
			_modalColor = value;
			invalidateModal(DomGlobals.systemManager);
		}
		
		private var _modalAlpha:Number = 0.5;
		/**
		 * 模态遮罩的透明度
		 */
		public function get modalAlpha():Number
		{
			return _modalAlpha;
		}
		public function set modalAlpha(value:Number):void
		{
			if(_modalAlpha==value)
				return;
			_modalAlpha = value;
			invalidateModal(DomGlobals.systemManager);
		}
		
		/**
		 * 模态层失效的SystemManager列表
		 */		
		private var invalidateModalList:Vector.<ISystemManager> = new Vector.<ISystemManager>();
		
		private var invalidateModalFlag:Boolean = false;
		/**
		 * 标记一个SystemManager的模态层失效
		 */		
		private function invalidateModal(systemManager:ISystemManager):void
		{
			if(!systemManager)
				return;
			if(invalidateModalList.indexOf(systemManager)==-1)
				invalidateModalList.push(systemManager);
			if(!invalidateModalFlag)
			{
				invalidateModalFlag = true;
				DomGlobals.stage.addEventListener(Event.ENTER_FRAME,validateModal);
				DomGlobals.stage.addEventListener(Event.RENDER,validateModal);
				DomGlobals.stage.invalidate();
			}
		}
		
		private function validateModal(event:Event):void
		{
			invalidateModalFlag = false;
			DomGlobals.stage.removeEventListener(Event.ENTER_FRAME,validateModal);
			DomGlobals.stage.removeEventListener(Event.RENDER,validateModal);
			for each(var sm:ISystemManager in invalidateModalList)
			{
				updateModal(sm);
			}
			invalidateModalList.length = 0;
		}
		
		private var modalMaskDic:Dictionary = new Dictionary(true);
		/**
		 * 更新窗口模态效果
		 */		
		private function updateModal(systemManager:ISystemManager):void
		{
			var popUpContainer:IContainer = systemManager.popUpContainer;
			var found:Boolean = false;
			for(var i:int = popUpContainer.numElements-1;i>=0;i--)
			{
				var element:IVisualElement = popUpContainer.getElementAt(i);
				var data:PopUpData = findPopUpData(element);
				if(data&&data.modal)
				{
					found = true;
					break;
				}
			}
			var modalMask:Rect = modalMaskDic[systemManager];
			if(found)
			{
				if(!modalMask)
				{
					modalMaskDic[systemManager] = modalMask = new Rect();
					modalMask.top = modalMask.left = modalMask.right = modalMask.bottom = 0;
				}
				(modalMask as Rect).fillColor = _modalColor;
				modalMask.alpha = _modalAlpha;
				if(modalMask.parent==systemManager)
				{
					if(popUpContainer.getElementIndex(modalMask)<i)
						i--;
					popUpContainer.setElementIndex(modalMask,i);
				}
				else
				{
					popUpContainer.addElementAt(modalMask,i);
				}
			}
			else if(modalMask&&modalMask.parent==systemManager)
			{
				popUpContainer.removeElement(modalMask);
			}
		}
		
		/**
		 * 移除由addPopUp()方法弹出的窗口。
		 * @param popUp 要移除的窗口
		 */		
		public function removePopUp(popUp:IVisualElement):void
		{
			if(popUp && popUp.parent&&findPopUpData(popUp))
			{
				if(popUp.parent is IVisualElementContainer)
					IVisualElementContainer(popUp.parent).removeElement(popUp);
				else if(popUp is DisplayObject)
					popUp.parent.removeChild(DisplayObject(popUp));
			}
		}
		
		/**
		 * 将指定窗口居中显示
		 * @param popUp 要居中显示的窗口
		 */
		public function centerPopUp(popUp:IVisualElement):void
		{
			popUp.top = popUp.bottom = popUp.left = popUp.right = NaN;
			popUp.verticalCenter = popUp.horizontalCenter = 0;
			var parent:DisplayObjectContainer = popUp.parent;
			if(parent)
			{
				if(popUp is IInvalidating)
					IInvalidating(popUp).validateNow();
				popUp.x = (parent.width-popUp.layoutBoundsWidth)*0.5;
				popUp.y = (parent.height-popUp.layoutBoundsHeight)*0.5;
			}
		}
		
		/**
		 * 将指定窗口的层级调至最前
		 * @param popUp 要最前显示的窗口
		 */		
		public function bringToFront(popUp:IVisualElement):void
		{
			var data:PopUpData = findPopUpData(popUp);
			if(data&&popUp.parent is ISystemManager)
			{
				var sm:ISystemManager = popUp.parent as ISystemManager;
				sm.popUpContainer.setElementIndex(popUp,sm.popUpContainer.numElements-1);
				invalidateModal(sm);
			}
		}
	}
}
import org.flexlite.domUI.core.IVisualElement;

class PopUpData
{
	public function PopUpData(popUp:IVisualElement,modal:Boolean)
	{
		this.popUp = popUp;
		this.modal = modal;
	}
	
	public var popUp:IVisualElement;
	
	public var modal:Boolean;
}
