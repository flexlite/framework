package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	import org.flexlite.domUI.components.IItemRenderer;
	import org.flexlite.domUI.components.supportClasses.TreeItemRenderer;
	
	
	/**
	 * Tree事件
	 * @author DOM
	 */
	public class TreeEvent extends Event
	{
		/**
		 * 节点关闭
		 */		
		public static const ITEM_CLOSE:String = "itemClose";
		/**
		 * 节点打开
		 */		
		public static const ITEM_OPEN:String = "itemOpen";
		/**
		 * 子节点打开或关闭前一刻分派。可以调用preventDefault()方法阻止节点的状态改变。
		 */		
		public static const ITEM_OPENING:String = "itemOpening";
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true,
								  item:Object = null,itemRenderer:TreeItemRenderer = null,opening:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.item = item;
			this.itemRenderer = itemRenderer;
			this.opening = opening;
		}
		
		/**
		 * 触发鼠标事件的项呈示器数据源项。
		 */
		public var item:Object;
		
		/**
		 * 触发鼠标事件的项呈示器。 
		 */		
		public var itemRenderer:TreeItemRenderer;
		
		/**
		 * 当事件类型为ITEM_OPENING是，表示是即将打开节点还是关闭它。
		 */		
		public var opening:Boolean = true;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new TreeEvent(type, bubbles, cancelable,
				item, itemRenderer,opening);
		}
	}
}