package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.ListEvent;
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
			if(!itemRenderer)
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
			//由于ItemRenderer.mouseChildren有可能不为false，在鼠标按下时会出现切换素材的情况，
			//导致target变化而无法抛出原生的click事件,所以此处监听MouseUp来抛出ItemClick事件。
			renderer.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
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
			renderer.removeEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
		}
		/**
		 * 是否捕获ItemRenderer以便在MouseUp时抛出ItemClick事件
		 */		
		dx_internal var captureItemRenderer:Boolean = true;
		
		private var mouseDownItemRenderer:IItemRenderer;
		/**
		 * 鼠标在项呈示器上按下
		 */		
		protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if (event.isDefaultPrevented())
				return;
			
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			var newIndex:int
			if (itemRenderer)
				newIndex = itemRenderer.itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			setSelectedIndex(newIndex, true);
			if(!captureItemRenderer)
				return;
			mouseDownItemRenderer = itemRenderer;
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler,false,0,true);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler,false,0,true);
		}
		/**
		 * 鼠标在项呈示器上弹起，抛出ItemClick事件。
		 */	
		private function item_mouseUpHandler(event:MouseEvent):void
		{
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			if(itemRenderer!=mouseDownItemRenderer)
				return;
			dispatchListEvent(event,ListEvent.ITEM_CLICK,itemRenderer);
		}
		
		/**
		 * 鼠标在舞台上弹起
		 */		
		private function stage_mouseUpHandler(event:Event):void
		{
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler);
			mouseDownItemRenderer = null;
		}
	}
}