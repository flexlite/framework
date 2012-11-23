package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ArrayCollection;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.IndexChangeEvent;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * Tab导航容器。<br/>
	 * 使用子项的name属性作为选项卡上显示的字符串。
	 * @author DOM
	 */
	public class TabNavigator extends SkinnableContainer
	{
		/**
		 * 构造函数
		 */		
		public function TabNavigator()
		{
			super();
		}
		
		/**
		 * [SkinPart]选项卡组件
		 */
		public var tabBar:TabBar;
		/**
		 * viewStack引用
		 */		
		private function get viewStack():ViewStack
		{
			return contentGroup as ViewStack;
		}
		/**
		 * TabBar数据源
		 */		
		private var tabBarData:ArrayCollection = new ArrayCollection;
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance==tabBar)
			{
				tabBar.dataProvider = tabBarData;
				tabBar.addEventListener(IndexChangeEvent.CHANGE,onIndexChange);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance==tabBar)
			{
				tabBar.dataProvider = null;
				tabBar.removeEventListener(IndexChangeEvent.CHANGE,onIndexChange);
			}
		}
		/**
		 * 选中项改变事件
		 */		
		private function onIndexChange(event:IndexChangeEvent):void
		{
			if(viewStack)
				viewStack.selectedIndex = event.newIndex;
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
		{
			super.contentGroup_elementAddedHandler(event);
			tabBarData.addItemAt(event.element.name,event.index);
		}
		/**
		 * @inheritDoc
		 */
		override dx_internal function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
		{
			super.contentGroup_elementRemovedHandler(event);
			tabBarData.removeItemAt(event.index);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
		}
		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void
		{
		}
	}
}