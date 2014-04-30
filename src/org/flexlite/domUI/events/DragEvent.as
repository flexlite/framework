package org.flexlite.domUI.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.core.DragSource;

	/**
	 * 拖拽事件
	 * @author DOM
	 */	
	public class DragEvent extends MouseEvent
	{
		/**
		 * 拖拽开始,此事件由启动拖拽的组件自身抛出。
		 */		
		public static const DRAG_START:String = "dragStart";
		/**
		 * 拖拽完成，此事件由拖拽管理器在启动拖拽的组件上抛出。
		 */		
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		/**
		 * 在目标区域放下拖拽的数据,此事件由拖拽管理器在经过的目标组件上抛出。
		 */		
		public static const DRAG_DROP:String = "dragDrop";
		/**
		 * 拖拽进入目标区域，此事件由拖拽管理器在经过的目标组件上抛出。
		 */		
		public static const DRAG_ENTER:String = "dragEnter";
		/**
		 * 拖拽移出目标区域，此事件由拖拽管理器在经过的目标组件上抛出。
		 */		
		public static const DRAG_EXIT:String = "dragExit";
		/**
		 * 拖拽经过目标区域，相当于MouseOver事件，此事件由拖拽管理器在经过的目标组件上抛出。
		 */		
		public static const DRAG_OVER:String = "dragOver";
		
		
		/**
		 * 创建一个 Event 对象，其中包含有关鼠标事件的信息。将 Event 对象作为参数传递给事件侦听器。
		 * @param type 事件类型；指示引发事件的动作。
		 * @param bubbles 指定该事件是否可以在显示列表层次结构得到冒泡处理。
		 * @param cancelable 指定是否可以防止与事件相关联的行为。
		 * @param dragInitiator 启动拖拽的组件。
		 * @param dragSource 包含正在拖拽数据的DragSource对象。
		 * @param ctrlKey 指示是否已按下 Ctrl 键。
		 * @param altKey 指示是否已按下 Alt 键。
		 * @param shiftKey 指示是否已按下 Shift 键。
		 */		
		public function DragEvent(type:String, bubbles:Boolean = false,
								  cancelable:Boolean = true,
								  dragInitiator:InteractiveObject = null,
								  dragSource:DragSource = null,
								  ctrlKey:Boolean = false,
								  altKey:Boolean = false,
								  shiftKey:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.dragInitiator = dragInitiator;
			this.dragSource = dragSource;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
		}
		/**
		 * 启动拖拽的组件
		 */		
		public var dragInitiator:InteractiveObject;
		/**
		 * 包含正在拖拽数据的DragSource对象。
		 */		
		public var dragSource:DragSource;
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var cloneEvent:DragEvent = new DragEvent(type, bubbles, cancelable, 
				dragInitiator, dragSource,
				ctrlKey,altKey, shiftKey);
			cloneEvent.relatedObject = this.relatedObject;
			cloneEvent.localX = this.localX;
			cloneEvent.localY = this.localY;
			
			return cloneEvent;
		}
	}
	
}
