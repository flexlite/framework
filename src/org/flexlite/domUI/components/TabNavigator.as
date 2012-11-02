package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ArrayCollection;
	import org.flexlite.domUI.core.INavigatorContent;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.IndexChangeEvent;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * Tab导航容器。<br/>
	 * 注意:虽然扩展自ViewStack，但此容器只接受实现了INavigatorContent的组件作为子项,
	 * 非INavigatorContent子项将会被过滤并忽略。
	 * @see org.flexlite.domUI.core.INavigatorContent
	 * @author DOM
	 */
	public class TabNavigator extends ViewStack
	{
		/**
		 * 构造函数
		 */		
		public function TabNavigator()
		{
			super();
		}
		
		private var _tabBarSkinName:Object;
		/**
		 * tabBar的skinName属性值
		 */
		public function get tabBarSkinName():Object
		{
			return _tabBarSkinName;
		}
		public function set tabBarSkinName(value:Object):void
		{
			if(_tabBarSkinName==value)
				return;
			_tabBarSkinName = value;
			if(tabBar)
			{
				tabBar.skinName = value;
			}
		}

		private var _tabBar:TabBar;
		/**
		 * TabBar组件的引用
		 */
		public function get tabBar():TabBar
		{
			return _tabBar;
		}
		/**
		 * 内容区域
		 */		
		private var content:UIComponent = new UIComponent;
		
		/**
		 * TabBar数据源
		 */		
		private var tabBarData:ArrayCollection = new ArrayCollection;
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			_tabBar = new TabBar();
			_tabBar.skinName = _tabBarSkinName;
			_tabBar.dataProvider = tabBarData;
			_tabBar.addEventListener(IndexChangeEvent.CHANGE,onIndexChange);
			addToDisplyListAt(_tabBar,0);
			addToDisplyListAt(content,0);
			super.createChildren();
			
			var elements:Array = getElementsContent();
			for each(var element:INavigatorContent in elements)
			{
				tabBarData.addItem(element.navigatorLabel);
			}
			
		}
		/**
		 * 选中项改变事件
		 */		
		private function onIndexChange(event:IndexChangeEvent):void
		{
			setSelectedIndex(event.newIndex);
		}
		/**
		 * @inheritDoc
		 */
		override dx_internal function setSelectedIndex(value:int):void
		{
			super.setSelectedIndex(value);
			tabBar.selectedIndex = _selectedIndex;
		}
		/**
		 * @inheritDoc
		 */
		override public function set elementsContent(value:Array):void
		{
			if(value)
			{
				value = value.concat();
				for(var i:int=0;i<value.length;i++)
				{
					if(!(value[i] is INavigatorContent))
					{
						value.splice(i,1);
						i--
					}
				}
			}
			super.elementsContent = value;
		}
		/**
		 * @inheritDoc
		 */
		override public function addElementAt(element:IVisualElement,index:int):IVisualElement
		{
			if(!(element is INavigatorContent))
				return element;
			return super.addElementAt(element,index);
		}
		/**
		 * @inheritDoc
		 */
		override public function addElement(element:IVisualElement):IVisualElement
		{
			if(!(element is INavigatorContent))
				return element;
			return super.addElement(element);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function elementAdded(element:IVisualElement,index:int):void
		{
			if(element is DisplayObject)
				content.addChildAt(DisplayObject(element), index);
			element.visible = false;
			if(_selectedIndex==-1)
				setSelectedIndex(0);
			tabBarData.addItemAt((element as INavigatorContent).navigatorLabel,index);
		}
		/**
		 * @inheritDoc
		 */
		override dx_internal function elementRemoved(element:IVisualElement,index:int):void
		{
			if(element is DisplayObject)
				content.addChildAt(DisplayObject(element), index);
			element.visible = false;
			if(_selectedIndex==-1)
				setSelectedIndex(0);
			tabBarData.removeItemAt(index);
		}
		
		private var _gap:Number = 0;
		/**
		 * tabBar和内容区域的垂直间隔,默认值0。
		 */
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			if(isNaN(value))
				value = 0;
			if(_gap==value)
				return;
			_gap = value;
			invalidateSize();
			invalidateDisplayList();
		}

		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(_tabBar)
			{
				measuredWidth = Math.max(_tabBar.preferredWidth,measuredWidth);
				measuredHeight += _tabBar.preferredHeight+_gap;
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var offsetY:Number = _tabBar.layoutBoundsHeight+_gap;
			unscaledHeight -= offsetY;
			unscaledHeight = Math.max(0,unscaledHeight);
			content.y = offsetY;
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
	}
}