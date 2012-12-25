package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	import org.flexlite.domUI.core.IVisualElement;
	
	/**
	 * Group添加或移除元素时分派的事件。
	 * @author DOM
	 */	
	public class ElementExistenceEvent extends Event
	{
		/**
		 * 元素添加 
		 */		
		public static const ELEMENT_ADD:String = "elementAdd";
		/**
		 * 元素移除 
		 */		
		public static const ELEMENT_REMOVE:String = "elementRemove";

		public function ElementExistenceEvent(
			type:String, bubbles:Boolean = false,
			cancelable:Boolean = false,
			element:IVisualElement = null, 
			index:int = -1)
		{
			super(type, bubbles, cancelable);
			
			this.element = element;
			this.index = index;
		}
		
		/**
		 * 指向已添加或删除元素的位置的索引。 
		 */		
		public var index:int;
		
		/**
		 * 对已添加或删除的视觉元素的引用。 
		 */		
		public var element:IVisualElement;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ElementExistenceEvent(type, bubbles, cancelable,
				element, index);
		}
	}
	
}
