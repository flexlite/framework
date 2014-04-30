package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.IndexChangeEvent;
	import org.flexlite.domUI.events.ListEvent;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	use namespace dx_internal;  
	
	[DXML(show="true")]
	
	/**
	 * 选项卡组件
	 * @author DOM
	 */	
	public class TabBar extends ListBase
	{
		/**
		 * 构造函数
		 */		
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
		override public function set dataProvider(value:ICollection):void
		{
			if(dataProvider is ViewStack)
			{
				dataProvider.removeEventListener("IndexChanged",onViewStackIndexChange);
				removeEventListener(IndexChangeEvent.CHANGE,onIndexChanged);
			}
			
			if(value is ViewStack)
			{
				value.addEventListener("IndexChanged",onViewStackIndexChange);
				addEventListener(IndexChangeEvent.CHANGE,onIndexChanged);
			}
			super.dataProvider = value;
		}
		/**
		 * 鼠标点击的选中项改变
		 */		
		private function onIndexChanged(event:IndexChangeEvent):void
		{
			ViewStack(dataProvider).setSelectedIndex(event.newIndex,false);
		}
		
		/**
		 * ViewStack选中项发生改变
		 */		
		private function onViewStackIndexChange(event:Event):void
		{
			setSelectedIndex(ViewStack(dataProvider).selectedIndex, false);
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
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			var newIndex:int
			if (itemRenderer)
				newIndex = itemRenderer.itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			if (newIndex == selectedIndex)
			{
				if (!requireSelection)
					setSelectedIndex(NO_SELECTION, true);
			}
			else
				setSelectedIndex(newIndex, true);
			dispatchListEvent(event,ListEvent.ITEM_CLICK,itemRenderer);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = -1;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			addToDisplayList(dataGroup);
			partAdded("dataGroup",dataGroup);
		}
	}
}