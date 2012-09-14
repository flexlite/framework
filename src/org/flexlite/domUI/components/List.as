<<<<<<< HEAD
package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.ISkinPartHost;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

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
		
		override protected function createChildren():void
		{
			if(itemRenderer==null)
				itemRenderer = ItemRenderer;
			super.createChildren();
		}
		
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
		
		override public function set useVirtualLayout(value:Boolean):void
		{
			super.useVirtualLayout = value;
		}

		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
		}
		
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
		
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			if(!(skin is ISkinPartHost))
			{
				createDataGroup();
			}
		}
		
		override protected function detachSkin(skin:Object):void
		{
			if(!(skin is ISkinPartHost))
			{
				removeDataGroup();
			}
			super.detachSkin(skin);
		}
		
		/**
		 * 当皮肤不是ISkinPartHost时，创建DataGroup
		 */		
		private function createDataGroup():void
		{
			if(dataGroup)
				return;
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var temp:VerticalLayout = new VerticalLayout();
			dataGroup.layout = temp;
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			addToDisplyList(dataGroup);
			partAdded("dataGroup",dataGroup);
		}
		
		/**
		 * 销毁当皮肤不是ISkinPartHost时创建的DataGroup
		 */		
		private function removeDataGroup():void
		{
			if(!dataGroup)
				return;
			partRemoved("dataGroup",dataGroup);
			removeFromDisplayList(dataGroup);
			dataGroup = null;
		}
		
	}
=======
package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.ISkinPartHost;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

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
		
		override protected function createChildren():void
		{
			if(itemRenderer==null)
				itemRenderer = ItemRenderer;
			super.createChildren();
		}
		
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
		
		override public function set useVirtualLayout(value:Boolean):void
		{
			super.useVirtualLayout = value;
		}

		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
		}
		
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
		
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			if(!(skin is ISkinPartHost))
			{
				createDataGroup();
			}
		}
		
		override protected function detachSkin(skin:Object):void
		{
			if(!(skin is ISkinPartHost))
			{
				removeDataGroup();
			}
			super.detachSkin(skin);
		}
		
		/**
		 * 当皮肤不是ISkinPartHost时，创建DataGroup
		 */		
		private function createDataGroup():void
		{
			if(dataGroup)
				return;
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var temp:VerticalLayout = new VerticalLayout();
			dataGroup.layout = temp;
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			addToDisplyList(dataGroup);
			partAdded("dataGroup",dataGroup);
		}
		
		/**
		 * 销毁当皮肤不是ISkinPartHost时创建的DataGroup
		 */		
		private function removeDataGroup():void
		{
			if(!dataGroup)
				return;
			partRemoved("dataGroup",dataGroup);
			removeFromDisplayList(dataGroup);
			dataGroup = null;
		}
		
	}
>>>>>>> master
}