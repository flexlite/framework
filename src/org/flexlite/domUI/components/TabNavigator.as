package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IViewStack;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.IndexChangeEvent;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 指示索引即将更改,可以通过调用preventDefault()方法阻止索引发生更改
	 */	
	[Event(name="changing", type="org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * 指示索引已更改  
	 */	
	[Event(name="change", type="org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * Tab导航容器。<br/>
	 * 使用子项的name属性作为选项卡上显示的字符串。
	 * @author DOM
	 */
	public class TabNavigator extends SkinnableContainer implements IViewStack
	{
		/**
		 * 构造函数
		 */		
		public function TabNavigator()
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return TabNavigator;
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
		 * @inheritDoc
		 */
		override dx_internal function get currentContentGroup():Group
		{
			if (!contentGroup)
			{
				if (!_placeHolderGroup)
				{
					_placeHolderGroup = new ViewStack();
					_placeHolderGroup.visible = false;
					addToDisplayList(_placeHolderGroup);
				}
				_placeHolderGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				_placeHolderGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				return _placeHolderGroup;
			}
			else
			{
				return contentGroup;    
			}
		}
		
		private var viewStackProperties:Object = {};
		
		private var _createAllChildren:Boolean = false;
		/**
		 * 是否立即初始化化所有子项。false表示当子项第一次被显示时再初始化它。默认值false。
		 */
		public function get createAllChildren():Boolean
		{
			return viewStack?viewStack.createAllChildren:
				viewStackProperties.createAllChildren;
		}

		public function set createAllChildren(value:Boolean):void
		{
			if(viewStack)
			{
				viewStack.createAllChildren = value;
			}
			else
			{
				viewStackProperties.createAllChildren = value;
			}
		}

		/**
		 * @inheritDoc
		 */		
		public function get selectedChild():IVisualElement
		{
			return viewStack?viewStack.selectedChild:
				viewStackProperties.selectedChild;
		}
		public function set selectedChild(value:IVisualElement):void
		{
			if(viewStack)
			{
				viewStack.selectedChild = value;
			}
			else
			{
				delete viewStackProperties.selectedIndex;
				viewStackProperties.selectedChild = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get selectedIndex():int
		{
			if(viewStack)
				return viewStack.selectedIndex;
			if(viewStackProperties.selectedIndex!==undefined)
				return viewStackProperties.selectedIndex;
			return -1;
		}
		public function set selectedIndex(value:int):void
		{
			if(viewStack)
			{
				viewStack.selectedIndex = value;
			}
			else
			{
				delete viewStackProperties.selectedChild;
				viewStackProperties.selectedIndex = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance==tabBar)
			{
				if(viewStack&&tabBar.dataProvider != viewStack)
					tabBar.dataProvider = viewStack;
				tabBar.selectedIndex = viewStack?viewStack.selectedIndex:-1;
				tabBar.addEventListener(IndexChangeEvent.CHANGE,dispatchEvent);
				tabBar.addEventListener(IndexChangeEvent.CHANGING,onTabBarIndexChanging);
			}
			else if(instance==viewStack)
			{
				if(tabBar&&tabBar.dataProvider != viewStack)
					tabBar.dataProvider = viewStack;
				if(viewStackProperties.selectedIndex!==undefined)
				{
					viewStack.selectedIndex = viewStackProperties.selectedIndex;
				}
				else if(viewStackProperties.selectedChild!==undefined)
				{
					viewStack.selectedChild = viewStackProperties.selectedChild;
				}
				else if(viewStackProperties.createAllChildren!==undefined)
				{
					viewStack.createAllChildren = viewStackProperties.createAllChildren;
				}
				viewStackProperties = {};
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance==tabBar)
			{
				tabBar.dataProvider = null;
				tabBar.removeEventListener(IndexChangeEvent.CHANGE,dispatchEvent);
				tabBar.removeEventListener(IndexChangeEvent.CHANGING,onTabBarIndexChanging);
			}
			else if(instance==viewStack)
			{
				viewStackProperties.selectedIndex = viewStack.selectedIndex;
			}
		}
		
		/**
		 * 传递TabBar的IndexChanging事件
		 */		
		private function onTabBarIndexChanging(event:IndexChangeEvent):void
		{
			if(!dispatchEvent(event))
				event.preventDefault();
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void{}
		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void{}
	}
}