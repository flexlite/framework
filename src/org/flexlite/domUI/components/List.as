package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.RendererExistenceEvent;

	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 列表组件
	 * @author DOM
	 */
	public class List extends ListBase
	{
		public function List()
		{
			super();
			useVirtualLayout = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(itemRenderer==null)
				itemRenderer = ItemRenderer;
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return List;
		}
		
		/**
		 * 是否使用虚拟布局,默认true
		 */		
		override public function get useVirtualLayout():Boolean
		{
			return super.useVirtualLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set useVirtualLayout(value:Boolean):void
		{
			super.useVirtualLayout = value;
		}

		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.removeEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
		}
		
		/**
		 * 鼠标在项呈示器上按下
		 */		
		protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if (event.isDefaultPrevented())
				return;
			
			var newIndex:int
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			setSelectedIndex(newIndex, true);
		}
	}
}