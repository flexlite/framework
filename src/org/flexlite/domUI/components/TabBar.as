package org.flexlite.domUI.components
{
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.components.supportClasses.TabBarHorizontalLayout;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	
	use namespace dx_internal;  
	
	[DXML(show="true")]
	
	/**
	 * 选项卡组件
	 * @author DOM
	 */	
	public class TabBar extends ListBase
	{
		
		public function TabBar()
		{
			super();
			
			tabChildren = false;
			tabEnabled = true;
			requireSelection = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TabBar;
		}
		
		/**
		 * requireSelection改变标志
		 */
		private var requireSelectionChanged:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function set requireSelection(value:Boolean):void
		{
			if (value == requireSelection)
				return;
			
			super.requireSelection = value;
			requireSelectionChanged = true;
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (requireSelectionChanged && dataGroup)
			{
				requireSelectionChanged = false;
				const n:int = dataGroup.numElements;
				for (var i:int = 0; i < n; i++)
				{
					var renderer:TabBarButton = dataGroup.getElementAt(i) as TabBarButton;
					if (renderer)
						renderer.allowDeselection = !requireSelection;
				}
			}
		}  
		/**
		 * 根据索引获取对应的ItemRender
		 */		
		private function getItemRenderer(index:int):IVisualElement
		{
			if (!dataGroup || (index < 0) || (index >= dataGroup.numElements))
				return null;
			
			return dataGroup.getElementAt(index);
		}
		
		 
		/**
		 * @inheritDoc
		 */
		override protected function itemSelected(index:int, selected:Boolean):void
		{
			super.itemSelected(index, selected);
			
			const renderer:IItemRenderer = getItemRenderer(index) as IItemRenderer;
			if (renderer)
			{
				renderer.selected = selected;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			const renderer:IItemRenderer = event.renderer; 
			if (renderer)
			{
				renderer.addEventListener(MouseEvent.CLICK, item_clickHandler);
				if (renderer is TabBarButton)
					TabBarButton(renderer).allowDeselection = !requireSelection;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{   
			super.dataGroup_rendererRemoveHandler(event);
			
			const renderer:IItemRenderer = event.renderer;
			if (renderer)
				renderer.removeEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		/**
		 * 鼠标在条目上按下
		 */		
		private function item_clickHandler(event:MouseEvent):void
		{
			var newIndex:int;
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			var oldSelectedIndex:int = selectedIndex;
			if (newIndex == selectedIndex)
			{
				if (!requireSelection)
					setSelectedIndex(NO_SELECTION, true);
			}
			else
				setSelectedIndex(newIndex, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance==dataGroup)
			{
				if(!dataGroup.layout||!(dataGroup.layout is TabBarHorizontalLayout))
					dataGroup.layout = new TabBarHorizontalLayout();
			}
		}
	}
}