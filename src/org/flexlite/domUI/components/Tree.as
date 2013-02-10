package org.flexlite.domUI.components
{
	import org.flexlite.domUI.collections.XMLCollection;
	import org.flexlite.domUI.components.supportClasses.TreeItemRenderer;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.events.TreeEvent;
	
	/**
	 * 子节点打开或关闭前一刻分派。可以调用preventDefault()方法阻止节点的状态改变。 
	 */	
	[Event(name="itemOpening", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点打开
	 */	
	[Event(name="itemOpen", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点关闭
	 */	
	[Event(name="itemClose", type="org.flexlite.domUI.events.TreeEvent")]
	
	[DXML(show="true")]
	
	/**
	 * 树状列表组件
	 * @author DOM
	 */
	public class Tree extends List
	{
		/**
		 * 构造函数
		 */		
		public function Tree()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(!itemRenderer)
				itemRenderer = TreeItemRenderer;
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Tree;
		}
		
		private var _indentation:Number = 17;
		/**
		 * 子节点相对父节点的缩进值，以像素为单位。默认17。
		 */
		public function get indentation():Number
		{
			return _indentation;
		}
		public function set indentation(value:Number):void
		{
			_indentation = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is TreeItemRenderer&&dataProvider is XMLCollection)
			{
				var treeRenderer:TreeItemRenderer = renderer as TreeItemRenderer;
				treeRenderer.hasChildren = XML(data).children().length()>0;
				treeRenderer.opened = XMLCollection(dataProvider).isOpen(data as XML);
				treeRenderer.indentation = XMLCollection(dataProvider).getDepth(data as XML)*_indentation;
			}
			return super.updateRenderer(renderer, itemIndex, data); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			if(event.renderer is TreeItemRenderer)
				event.renderer.addEventListener(TreeEvent.ITEM_OPENING,onItemOpening);
		}
		/**
		 * 节点即将打开
		 */		
		private function onItemOpening(event:TreeEvent):void
		{
			var renderer:TreeItemRenderer = event.itemRenderer;
			var item:XML = event.item as XML;
			if(!renderer||!(dataProvider is XMLCollection))
				return;
			if(dispatchEvent(event))
			{
				renderer.opened = !renderer.opened;
				if(renderer.opened)
					XMLCollection(dataProvider).openNode(item);
				else
					XMLCollection(dataProvider).closeNode(item);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			if(event.renderer is TreeItemRenderer)
				event.renderer.removeEventListener(TreeEvent.ITEM_OPENING,onItemOpening);
		}
	}
}