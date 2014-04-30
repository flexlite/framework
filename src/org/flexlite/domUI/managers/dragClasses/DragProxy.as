package org.flexlite.domUI.managers.dragClasses
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.DragSource;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.effects.Move;
	import org.flexlite.domUI.effects.Scale;
	import org.flexlite.domUI.events.DragEvent;
	import org.flexlite.domUI.events.EffectEvent;
	import org.flexlite.domUI.managers.DragManager;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * 拖拽过程中显示的图标
	 * @author DOM
	 */	
	public class DragProxy extends UIComponent
	{
		/**
		 * 构造函数
		 * @param dragInitiator 启动拖拽的组件
		 * @param dragSource 拖拽的数据源
		 */		
		public function DragProxy(dragInitiator:InteractiveObject,
								  dragSource:DragSource)
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
			this.dragInitiator = dragInitiator;
			this.dragSource = dragSource;
			
			var ed:IEventDispatcher = stageRoot = DomGlobals.stage;
			ed.addEventListener(MouseEvent.MOUSE_MOVE,
				mouseMoveHandler);
			ed.addEventListener(MouseEvent.MOUSE_UP,
				mouseUpHandler);
			ed.addEventListener(Event.MOUSE_LEAVE, 
				mouseLeaveHandler);
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if (!stageRoot.focus)
				setFocus();
		}
		/**
		 * 上一次的鼠标事件对象
		 */		
		private var lastMouseEvent:MouseEvent;
		/**
		 * 舞台引用
		 */		
		private var stageRoot:Stage;
		/**
		 * 启动拖拽的组件
		 */		
		public var dragInitiator:InteractiveObject;
		/**
		 * 拖拽的数据源
		 */		
		public var dragSource:DragSource;
		/**
		 * 移动过程中自身的x偏移量
		 */		
		public var xOffset:Number;
		/**
		 * 移动过程中自身的y偏移量
		 */		
		public var yOffset:Number;
		/**
		 * 拖拽起始点x坐标
		 */		
		public var startX:Number;
		/**
		 * 拖拽起始点y坐标
		 */		
		public var startY:Number;
		/**
		 * 接受当前拖拽数据的目标对象
		 */		
		public var target:DisplayObject = null;
		/**
		 * 抛出拖拽事件
		 */		
		private function dispatchDragEvent(type:String, mouseEvent:MouseEvent, eventTarget:Object):void
		{
			var dragEvent:DragEvent = new DragEvent(type);
			var pt:Point = new Point();
			
			dragEvent.dragInitiator = dragInitiator;
			dragEvent.dragSource = dragSource;
			dragEvent.ctrlKey = mouseEvent.ctrlKey;
			dragEvent.altKey = mouseEvent.altKey;
			dragEvent.shiftKey = mouseEvent.shiftKey;
			pt.x = lastMouseEvent.localX;
			pt.y = lastMouseEvent.localY;
			pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
			pt = DisplayObject(eventTarget).globalToLocal(pt);
			dragEvent.localX = pt.x;
			dragEvent.localY = pt.y;
			IEventDispatcher(eventTarget).dispatchEvent(dragEvent);
		}
		/**
		 * 处理鼠标移动事件
		 */		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var dragEvent:DragEvent;
			var dropTarget:DisplayObject;
			var i:int;
			
			lastMouseEvent = event;
			
			var pt:Point = new Point();
			var point:Point = new Point(event.localX, event.localY);
			var stagePoint:Point = DisplayObject(event.target).localToGlobal(point);
			point = parent.globalToLocal(stagePoint);
			var mouseX:Number = point.x;
			var mouseY:Number = point.y;
			x = mouseX - xOffset;
			y = mouseY - yOffset;
			if (!event)
			{
				return;
			}
			
			var targetList:Array; 
			targetList = [];
			DragProxy.getObjectsUnderPoint(stageRoot, stagePoint, targetList);
			
			var newTarget:DisplayObject = null;
			var targetIndex:int = targetList.length - 1;
			while (targetIndex >= 0)
			{
				newTarget = targetList[targetIndex];
				if (newTarget != this && !contains(newTarget))
					break;
				targetIndex--;
			}
			if (target)
			{
				var foundIt:Boolean = false;
				var oldTarget:DisplayObject = target;
				
				dropTarget = newTarget;
				
				while (dropTarget)
				{
					if (dropTarget == target)
					{
						dispatchDragEvent(DragEvent.DRAG_OVER, event, dropTarget);
						foundIt = true;
						break;
					} 
					else 
					{
						dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
						if (target == dropTarget)
						{
							foundIt = false;
							break;
						}
					}
					dropTarget = dropTarget.parent;
				}
				
				if (!foundIt)
				{
					dispatchDragEvent(DragEvent.DRAG_EXIT, event, oldTarget);
					
					if (target == oldTarget)
						target = null;
				}
			}
			if (!target)
			{
				dropTarget = newTarget;
				while (dropTarget)
				{
					if (dropTarget != this)
					{
						dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
						if(target)
							break;
					}
					dropTarget = dropTarget.parent;
				}
			}
			if(DomGlobals.useUpdateAfterEvent)
				event.updateAfterEvent();
		}
		/**
		 * 鼠标移出舞台事件
		 */		
		private function mouseLeaveHandler(event:Event):void
		{
			mouseUpHandler(lastMouseEvent);
		}
		/**
		 * 处理鼠标弹起事件
		 */		
		private function mouseUpHandler(event:MouseEvent):void
		{
			var ed:IEventDispatcher = stageRoot;
			ed.removeEventListener(MouseEvent.MOUSE_MOVE,
				mouseMoveHandler);
			ed.removeEventListener(MouseEvent.MOUSE_UP,
				mouseUpHandler);
			ed.removeEventListener(Event.MOUSE_LEAVE,
				mouseLeaveHandler);
			
			var dragEvent:DragEvent;
			if (target)
			{
				dragEvent = new DragEvent(DragEvent.DRAG_DROP);
				dragEvent.dragInitiator = dragInitiator;
				dragEvent.dragSource = dragSource;
				if(event)
				{
					dragEvent.ctrlKey = event.ctrlKey;
					dragEvent.altKey = event.altKey;
					dragEvent.shiftKey = event.shiftKey;
				}
				var pt:Point = new Point();
				pt.x = lastMouseEvent.localX;
				pt.y = lastMouseEvent.localY;
				pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
				pt = DisplayObject(target).globalToLocal(pt);
				dragEvent.localX = pt.x;
				dragEvent.localY = pt.y;
				target.dispatchEvent(dragEvent);
				
				var scale:Scale = new Scale(this);
				scale.scaleXFrom = scale.scaleYFrom = 1.0;
				scale.scaleXTo = scale.scaleYTo = 0;
				scale.duration = 200;
				scale.play();
				
				var m:Move = new Move(this);
				m.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
				m.xFrom = x;
				m.yFrom = y;
				m.xTo = parent.mouseX;
				m.yTo = parent.mouseY;
				m.duration = 200;
				m.play();
			}
			else
			{
				
				var move:Move = new Move(this);
				move.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
				move.xFrom = x;
				move.yFrom = y;
				move.xTo = startX;
				move.yTo = startY;
				move.duration = 200;
				move.play();
			}

			dragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
			dragEvent.dragInitiator = dragInitiator;
			dragEvent.dragSource = dragSource;
			dragEvent.relatedObject = InteractiveObject(target);
			if(event)
			{
				dragEvent.ctrlKey = event.ctrlKey;
				dragEvent.altKey = event.altKey;
				dragEvent.shiftKey = event.shiftKey;
			}
			dragInitiator.dispatchEvent(dragEvent);
			
			this.lastMouseEvent = null;
		}
		/**
		 * 特效播放完成，结束拖拽。
		 */		
		private function effectEndHandler(event:EffectEvent):void
		{
			DragManager.endDrag();
		}
		/**
		 * 获取舞台下有鼠标事件的显示对象
		 */		
		private static function getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array):void
		{
			if (!obj.visible)
				return;
			
			if (obj is Stage||obj.hitTestPoint(pt.x, pt.y, true))
			{
				if (obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
					arr.push(obj);
				if (obj is DisplayObjectContainer)
				{
					var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
					if (doc.mouseChildren&&doc.numChildren)
					{
						var n:int = doc.numChildren;
						for (var i:int = 0; i < n; i++)
						{
							try
							{
								var child:DisplayObject = doc.getChildAt(i);
								getObjectsUnderPoint(child, pt, arr);
							}
							catch (e:Error)
							{
								
							}
						}
					}
				}
			}
		}
		
	}
	
}
