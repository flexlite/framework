package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	import org.flexlite.domUI.components.IItemRenderer;
	
	/**
	 * 在DataGroup添加或删除项呈示器时分派的事件。
	 * @author DOM
	 */	
	public class RendererExistenceEvent extends Event
	{
		/**
		 * 添加了项呈示器 
		 */		
		public static const RENDERER_ADD:String = "rendererAdd";
		/**
		 * 移除了项呈示器 
		 */		
		public static const RENDERER_REMOVE:String = "rendererRemove";

		public function RendererExistenceEvent(type:String, bubbles:Boolean = false,
											   cancelable:Boolean = false,renderer:IItemRenderer = null, 
											   index:int = -1, data:Object = null)
		{
			super(type, bubbles, cancelable);
			
			this.renderer = renderer;
			this.index = index;
			this.data = data;
		}
		
		/**
		 * 呈示器的数据项目。 
		 */		
		public var data:Object;
		
		/**
		 * 指向已添加或删除项呈示器的位置的索引。 
		 */		
		public var index:int;
		
		/**
		 * 对已添加或删除的项呈示器的引用。 
		 */		
		public var renderer:IItemRenderer;

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new RendererExistenceEvent(type, bubbles, cancelable,
				renderer, index, data);
		}
	}
}