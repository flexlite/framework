package org.flexlite.domUI.events
{
	/**
	 * 定义  CollectionEvent 类 kind 属性的有效值的常量。
	 * 这些常量指示对集合进行的更改类型。
	 * @author DOM
	 */
	public class CollectionEventKind
	{
		/**
		 * 指示集合添加了一个或多个项目。 
		 */		
		public static const ADD:String = "add";
		/**
		 * 指示项目已从 CollectionEvent.oldLocation确定的位置移动到 location确定的位置。 
		 */		
		public static const MOVE:String = "move";
		/**
		 * 指示集合应用了排序或/和筛选。
		 */		
		public static const REFRESH:String = "refresh";
		/**
		 * 指示集合删除了一个或多个项目。 
		 */		
		public static const REMOVE:String = "remove";
		/**
		 * 指示已替换由 CollectionEvent.location 属性确定的位置处的项目。 
		 */		
		public static const REPLACE:String = "replace";
		/**
		 * 指示集合已彻底更改，需要进行重置。 
		 */		
		public static const RESET:String = "reset";
		/**
		 * 指示集合中一个或多个项目进行了更新。受影响的项目将存储在  CollectionEvent.items 属性中。 
		 */		
		public static const UPDATE:String = "update";
		/**
		 * 指示集合中某个节点的子项列表已打开，通常应用于Tree的数据源XMLCollection。
		 */		
		public static const OPEN:String = "open";
		/**
		 * 指示集合中某个节点的子项列表已关闭，通常应用于Tree的数据源XMLCollection。
		 */		
		public static const CLOSE:String = "close";
	}
}