package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 集合类型数据改变事件
	 * @author DOM
	 */
	public class CollectionEvent extends Event
	{
		/**
		 * 集合类数据发生改变 
		 */		
		public static const COLLECTION_CHANGE:String = "collectionChange";
		
		public function CollectionEvent(type:String, bubbles:Boolean = false,
										cancelable:Boolean = false,
										kind:String = null, location:int = -1,
										oldLocation:int = -1, items:Array = null,oldItems:Array=null)
		{
			super(type, bubbles, cancelable);
			
			this.kind = kind;
			this.location = location;
			this.oldLocation = oldLocation;
			this.items = items ? items : [];
			this.oldItems = oldItems?oldItems:[];
		}
		/**
		 * 指示发生的事件类型。此属性值可以是 CollectionEventKind 类中的一个值，也可以是 null，用于指示类型未知。 
		 */		
		public var kind:String;
		/**
		 * 受事件影响的项目的列表
		 */		
		public var items:Array;
		/**
		 * 仅当kind的值为CollectionEventKind.REPLACE时，表示替换前的项目列表
		 */		
		public var oldItems:Array;
		/**
		 * 如果 kind 值为 CollectionEventKind.ADD、 CollectionEventKind.MOVE、
		 * CollectionEventKind.REMOVE 或 CollectionEventKind.REPLACE，
		 * CollectionEventKind.UPDATE
		 * 则此属性为 items 属性中指定的项目集合中零号元素的的索引。 
		 */		
		public var location:int;
		/**
		 * 如果 kind 的值为 CollectionEventKind.MOVE，
		 * 则此属性为 items 属性中指定的项目在目标集合中原来位置的从零开始的索引。 
		 */		
		public var oldLocation:int;
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return formatToString("CollectionEvent", "kind", "location",
				"oldLocation", "type", "bubbles",
				"cancelable", "eventPhase");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CollectionEvent(type, bubbles, cancelable, kind, location, oldLocation, items,oldItems);
		}
	}
}