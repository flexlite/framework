package org.flexlite.domUI.components
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.managers.PopUpManager;
	import org.flexlite.domUI.utils.LayoutUtil;
	
	use namespace dx_internal;
	
	
	[DXML(show="true")]
	
	/**
	 * 窗口关闭事件
	 */	
	[Event(name="close", type="org.flexlite.domUI.events.CloseEvent")]
	
	/**
	 * 可移动窗口组件。注意，此窗口必须使用PopUpManager.addPopUp()弹出之后才能移动。
	 * @author DOM
	 */
	public class TitleWindow extends Panel
	{
		public function TitleWindow()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onWindowMouseDown,true,100);
		}
		/**
		 * 在窗体上按下时前置窗口
		 */		
		private function onWindowMouseDown(event:MouseEvent):void
		{
			if(enabled&&isPopUp)
			{
				PopUpManager.bringToFront(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TitleWindow;
		}
		/**
		 * [SkinPart]关闭按钮
		 */	
		public var closeButton:Button;
		
		/**
		 * [SkinPart]可移动区域
		 */		
		public var moveArea:InteractiveObject;
		
		private var _showCloseButton:Boolean = true;
		/**
		 * 是否显示关闭按钮,默认true。
		 */
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}

		public function set showCloseButton(value:Boolean):void
		{
			if(_showCloseButton==value)
				return;
			_showCloseButton = value;
			if(closeButton)
				closeButton.visible = _showCloseButton;
		}


		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if (instance == moveArea)
			{
				moveArea.addEventListener(MouseEvent.MOUSE_DOWN, moveArea_mouseDownHandler);
			}
			else if (instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);   
				closeButton.visible = _showCloseButton;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == moveArea)
				moveArea.removeEventListener(MouseEvent.MOUSE_DOWN, moveArea_mouseDownHandler);
				
			else if (instance == closeButton)
				closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		}
		
		protected function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		/**
		 * 鼠标按下时的偏移量
		 */		
		private var offsetPoint:Point;
		/**
		 * 鼠标在可移动区域按下
		 */		
		protected function moveArea_mouseDownHandler(event:MouseEvent):void
		{
			if (enabled && isPopUp)
			{
				offsetPoint = globalToLocal(new Point(event.stageX, event.stageY));
				_includeInLayout = false;
				DomGlobals.stage.addEventListener(
					MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler);
				DomGlobals.stage.addEventListener(
					MouseEvent.MOUSE_UP, moveArea_mouseUpHandler);
				DomGlobals.stage.addEventListener(
					Event.MOUSE_LEAVE, moveArea_mouseUpHandler);
			}
		}
		/**
		 * 鼠标拖拽时的移动事件
		 */		
		protected function moveArea_mouseMoveHandler(event:MouseEvent):void
		{
			var pos:Point = globalToLocal(new Point(event.stageX,event.stageY));
			this.x += pos.x - offsetPoint.x;
			this.y += pos.y - offsetPoint.y;
			event.updateAfterEvent();
		}
		/**
		 * 鼠标在舞台上弹起事件
		 */		
		protected function moveArea_mouseUpHandler(event:Event):void
		{
			DomGlobals.stage.removeEventListener(
				MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler);
			DomGlobals.stage.removeEventListener(
				MouseEvent.MOUSE_UP, moveArea_mouseUpHandler);
			DomGlobals.stage.removeEventListener(
				Event.MOUSE_LEAVE, moveArea_mouseUpHandler);
			offsetPoint = null;
			LayoutUtil.adjustRelativeByXY(this);
			includeInLayout = true;
		}
	}
}
