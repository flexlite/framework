package org.flexlite.domUI.managers.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.DragSource;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.managers.ILayoutManagerClient;
	import org.flexlite.domUI.managers.ISystemManager;
	import org.flexlite.domUI.managers.dragClasses.DragProxy;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * 拖拽管理器实现类
	 * @author DOM
	 */	
	public class DragManagerImpl extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function DragManagerImpl()
		{
			super();
			if(DomGlobals.stage)
			{
				eventAttached = true;
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN, sm_mouseDownHandler, false, 0, true);
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, sm_mouseUpHandler, false, 0, true);
			}
		}
		
		private var eventAttached:Boolean = false;
		/**
		 * 启动拖拽的组件
		 */		
		private var dragInitiator:IUIComponent;
		/**
		 * 拖拽显示的图标
		 */		
		private var dragProxy:DragProxy;
		/**
		 * 鼠标按下的标志
		 */		
		private var mouseIsDown:Boolean = false;
		
		private var _isDragging:Boolean = false;
		/**
		 * 正在拖拽的标志
		 */	
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		/**
		 * 启动拖拽操作。
		 * @param dragInitiator 启动拖拽的组件
		 * @param dragSource 拖拽的数据源
		 * @param dragImage 拖拽过程中显示的图像
		 * @param xOffset dragImage相对dragInitiator的x偏移量,默认0。
		 * @param yOffset dragImage相对dragInitiator的y偏移量,默认0。
		 * @param imageAlpha dragImage的透明度，默认0.5。
		 */		
		public function doDrag(
			dragInitiator:IUIComponent, 
			dragSource:DragSource, 
			dragImage:DisplayObject = null, 
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5):void
		{
			if(!eventAttached&&DomGlobals.stage)
			{
				eventAttached = true;
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN, sm_mouseDownHandler, false, 0, true);
				DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, sm_mouseUpHandler, false, 0, true);
			}
			
			if (_isDragging)
				return;
			
			_isDragging = true;
			
			this.dragInitiator = dragInitiator;
			
			dragProxy = new DragProxy(dragInitiator, dragSource);
			var sm:ISystemManager = dragInitiator.systemManager;
			if(!sm)
				sm = DomGlobals.systemManager;
			sm.popUpContainer.addElement(dragProxy);	
			
			if (dragImage)
			{
				dragProxy.addChild(DisplayObject(dragImage));
				if (dragImage is ILayoutManagerClient)
					DomGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage), true);
			}
			
			dragProxy.alpha = imageAlpha;
			
			var mouseX:Number = DisplayObject(sm).mouseX;
			var mouseY:Number = DisplayObject(sm).mouseY;
			var proxyOrigin:Point = DisplayObject(dragInitiator).localToGlobal(new Point(-xOffset, -yOffset));
			proxyOrigin = DisplayObject(sm).globalToLocal(proxyOrigin);
			dragProxy.xOffset = mouseX - proxyOrigin.x;
			dragProxy.yOffset = mouseY - proxyOrigin.y;
			dragProxy.x = proxyOrigin.x;
			dragProxy.y = proxyOrigin.y;
			dragProxy.startX = dragProxy.x;
			dragProxy.startY = dragProxy.y;
			if (dragImage is DisplayObject) 
				DisplayObject(dragImage).cacheAsBitmap = true;
		}
		/**
		 * 接受拖拽的数据源。通常在dragEnter事件处理函数调用此方法。
		 * 传入target后，若放下数据源。target将能监听到dragDrop事件。
		 */	
		public function acceptDragDrop(target:IUIComponent):void
		{
			if (dragProxy)
				dragProxy.target = target as DisplayObject;
		}
		/**
		 * 结束拖拽
		 */
		public function endDrag():void
		{
			var e:Event;
			
			if (!e || dispatchEvent(e))
			{
				if (dragProxy)
				{
					var parent:IVisualElementContainer = dragProxy.parent as IVisualElementContainer;
					parent.removeElement(dragProxy);	
					
					if (dragProxy.numChildren > 0)
						dragProxy.removeChildAt(0);
					dragProxy = null;
				}
			}
			
			dragInitiator = null;
			_isDragging = false;
			
		}
		/**
		 * 舞台上鼠标按下
		 */		
		private function sm_mouseDownHandler(event:MouseEvent):void
		{
			mouseIsDown = true;
		}
		/**
		 * 舞台上鼠标弹起
		 */		
		private function sm_mouseUpHandler(event:MouseEvent):void
		{
			mouseIsDown = false;
		}
	}
}