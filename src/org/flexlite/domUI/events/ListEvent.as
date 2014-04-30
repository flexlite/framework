package org.flexlite.domUI.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.IItemRenderer;
	
	/**
	 * 列表事件
	 * @author DOM
	 */	
	public class ListEvent extends MouseEvent
	{
		/**
		 * 指示用户执行了将鼠标指针从控件中某个项呈示器上移开的操作 
		 */		
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		
		/**
		 * 指示用户执行了将鼠标指针滑过控件中某个项呈示器的操作。 
		 */
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		/**
		 * 指示用户执行了将鼠标在某个项呈示器上单击的操作。 
		 */		
		public static const ITEM_CLICK:String = "itemClick";
		
		
		public function ListEvent(type:String, bubbles:Boolean = false,
								  cancelable:Boolean = false,
								  localX:Number = NaN,
								  localY:Number = NaN,
								  relatedObject:InteractiveObject = null,
								  ctrlKey:Boolean = false,
								  altKey:Boolean = false,
								  shiftKey:Boolean = false,
								  buttonDown:Boolean = false,
								  delta:int = 0,
								  itemIndex:int = -1,
								  item:Object = null,
								  itemRenderer:IItemRenderer = null)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			
			this.itemIndex = itemIndex;
			this.item = item;
			this.itemRenderer = itemRenderer;
		}
		
		
		/**
		 * 触发鼠标事件的项呈示器数据源项。
		 */
		public var item:Object;
		
		/**
		 * 触发鼠标事件的项呈示器。 
		 */		
		public var itemRenderer:IItemRenderer;
		
		/**
		 * 触发鼠标事件的项索引
		 */		
		public var itemIndex:int;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var cloneEvent:ListEvent = new ListEvent(type, bubbles, cancelable, 
				localX, localY, relatedObject,
				ctrlKey, altKey, shiftKey, buttonDown, delta,
				itemIndex, item, itemRenderer);
			
			cloneEvent.relatedObject = this.relatedObject;
			
			return cloneEvent;
		}
	}
}