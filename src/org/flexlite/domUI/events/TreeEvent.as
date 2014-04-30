package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	import org.flexlite.domUI.components.IItemRenderer;
	import org.flexlite.domUI.components.ITreeItemRenderer;
	
	
	/**
	 * Tree事件
	 * @author DOM
	 */
	public class TreeEvent extends Event
	{
		/**
		 * 节点关闭,注意：只有通过交互操作引起的节点关闭才会抛出此事件。
		 */		
		public static const ITEM_CLOSE:String = "itemClose";
		/**
		 * 节点打开,注意：只有通过交互操作引起的节点打开才会抛出此事件。
		 */		
		public static const ITEM_OPEN:String = "itemOpen";
		/**
		 * 子节点打开或关闭前一刻分派。可以调用preventDefault()方法阻止节点的状态改变。
		 */		
		public static const ITEM_OPENING:String = "itemOpening";
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true,
								  itemIndex:int = -1,item:Object = null,itemRenderer:ITreeItemRenderer = null)
		{
			super(type, bubbles, cancelable);
			this.item = item;
			this.itemRenderer = itemRenderer;
			this.itemIndex = itemIndex;
		}
		
		/**
		 * 触发鼠标事件的项呈示器数据源项。
		 */
		public var item:Object;
		
		/**
		 * 触发鼠标事件的项呈示器。 
		 */		
		public var itemRenderer:ITreeItemRenderer;
		/**
		 * 触发鼠标事件的项索引
		 */		
		public var itemIndex:int;
		/**
		 * 当事件类型为ITEM_OPENING时，true表示即将打开节点，反之关闭。
		 */		
		public var opening:Boolean;
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var evt:TreeEvent = new TreeEvent(type, bubbles, cancelable,
				itemIndex,item, itemRenderer);
			evt.opening = opening;
			return evt;
		}
	}
}