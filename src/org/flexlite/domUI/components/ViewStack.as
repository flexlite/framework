package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.core.IViewStack;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.IndexChangeEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.BasicLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	/**
	 * 集合数据发生改变 
	 */	
	[Event(name="collectionChange", type="org.flexlite.domUI.events.CollectionEvent")]
	/**
	 * 属性提交事件,当修改选中项时会抛出这个事件。
	 */	
	[Event(name="valueCommit", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 层级堆叠容器,一次只显示一个子对象。
	 * @author DOM
	 */
	public class ViewStack extends Group implements IViewStack,ICollection
	{
		/**
		 * 构造函数
		 */		
		public function ViewStack()
		{
			super();
			super.layout = new BasicLayout();
		}

		/**
		 * 此容器的布局对象为只读,默认限制为BasicLayout。
		 */		
		override public function get layout():LayoutBase
		{
			return super.layout;
		}
		override public function set layout(value:LayoutBase):void
		{
		}
		
		private var _createAllChildren:Boolean = false;
		/**
		 * 是否立即初始化化所有子项。false表示当子项第一次被显示时再初始化它。默认值false。
		 */
		public function get createAllChildren():Boolean
		{
			return _createAllChildren;
		}

		public function set createAllChildren(value:Boolean):void
		{
			if(_createAllChildren==value)
				return;
			_createAllChildren = value;
			if(_createAllChildren)
			{
				var elements:Array = getElementsContent();
				for each(var element:IVisualElement in elements)
				{
					if(element is DisplayObject&&element.parent!=this)
					{
						childOrderingChanged = true;
						addToDisplayList(DisplayObject(element));
					}
				}
				if(childOrderingChanged)
					invalidateProperties();
			}
		}


		private var _selectedChild:IVisualElement;
		/**
		 * @inheritDoc
		 */	
		public function get selectedChild():IVisualElement
		{
			var index:int = selectedIndex;
			if (index>=0&&index<numElements)
				return getElementAt(index);
			return null;
		}
		public function set selectedChild(value:IVisualElement):void
		{
			var index:int = getElementIndex(value);
			if(index>=0&&index<numElements)
				setSelectedIndex(index);
		}
		/**
		 * 未设置缓存选中项的值
		 */
		dx_internal static const NO_PROPOSED_SELECTION:int = -2;

		/**
		 * 在属性提交前缓存选中项索引
		 */		
		private var proposedSelectedIndex:int = NO_PROPOSED_SELECTION;
		
		dx_internal var _selectedIndex:int = -1;
		/**
		 * @inheritDoc
		 */	
		public function get selectedIndex():int
		{
			return proposedSelectedIndex!=NO_PROPOSED_SELECTION?proposedSelectedIndex:_selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			setSelectedIndex(value);
		}
		
		private var notifyTabBar:Boolean = false;
		/**
		 * 设置选中项索引
		 */		
		dx_internal function setSelectedIndex(value:int,notifyListeners:Boolean=true):void
		{
			if (value == selectedIndex)
			{
				return;
			}
			
			proposedSelectedIndex = value;
			invalidateProperties();
			
			dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			notifyTabBar = notifyTabBar||notifyListeners;
		}
		
		/**
		 * 添加一个显示元素到容器
		 */		
		override dx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean=true):void
		{
			if(_createAllChildren)
			{
				if(element is DisplayObject)
					addToDisplayList(DisplayObject(element), index);
			}
			if (notifyListeners)
			{
				if (hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_ADD, false, false, element, index));
			}
			
			element.visible = false;
			element.includeInLayout = false;
			if (selectedIndex == -1)
			{
				setSelectedIndex(index,false);
			}
			else if (index <= selectedIndex&&initialized)
			{
				setSelectedIndex(selectedIndex + 1);
			}
			dispatchCoEvent(CollectionEventKind.ADD,index,-1,[element.name]);
		}
		
		
		/**
		 * 从容器移除一个显示元素
		 */		
		override dx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean=true):void
		{
			super.elementRemoved(element,index,notifyListeners);
			element.visible = true;
			element.includeInLayout = true;
			if (index == selectedIndex)
			{
				if (numElements > 0)
				{       
					if (index == 0)
					{
						proposedSelectedIndex = 0;
						invalidateProperties();
					}
					else
						setSelectedIndex(0, false);
				}
				else
					setSelectedIndex(-1);
			}
			else if (index < selectedIndex)
			{
				setSelectedIndex(selectedIndex - 1);
			}
			dispatchCoEvent(CollectionEventKind.REMOVE,index,-1,[element.name]);
		}
		
		/**
		 * 子项显示列表顺序发生改变。
		 */		
		private var childOrderingChanged:Boolean = false;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (proposedSelectedIndex != NO_PROPOSED_SELECTION)
			{
				commitSelection(proposedSelectedIndex);
				proposedSelectedIndex = NO_PROPOSED_SELECTION;
			}
			
			if(childOrderingChanged)
			{
				childOrderingChanged = false;
				var elements:Array = getElementsContent();
				for each(var element:IVisualElement in elements)
				{
					if(element is DisplayObject&&element.parent==this)
					{
						addToDisplayList(DisplayObject(element));
					}
				}
			}
			
			if(notifyTabBar)
			{
				notifyTabBar = true;
				dispatchEvent(new Event("IndexChanged"));//通知TabBar自己的选中项发生改变
			}
		}
		
		private function commitSelection(newIndex:int):void
		{
			var oldIndex:int = _selectedIndex;
			if(newIndex>=0&&newIndex<numElements)
			{
				_selectedIndex = newIndex;
				if(_selectedChild&&_selectedChild.parent==this)
				{
					_selectedChild.visible = false;
					_selectedChild.includeInLayout = false;
				}
				_selectedChild = getElementAt(_selectedIndex);
				_selectedChild.visible = true;
				_selectedChild.includeInLayout = true;
				if(_selectedChild.parent!=this&&_selectedChild is DisplayObject)
				{
					addToDisplayList(DisplayObject(_selectedChild));
					if(!childOrderingChanged)
					{
						childOrderingChanged = true;
					}
				}
			}
			else
			{
				_selectedChild = null;
				_selectedIndex = -1;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * @inheritDoc
		 */	
		public function get length():int
		{
			return numElements;
		}
		/**
		 * @inheritDoc
		 */			
		public function getItemAt(index:int):Object
		{
			var element:IVisualElement = getElementAt(index);
			if(element)
				return element.name;
			return "";
		}
		/**
		 * @inheritDoc
		 */		
		public function getItemIndex(item:Object):int
		{
			var list:Array = getElementsContent();
			var length:int = list.length;
			for(var i:int=0;i<length;i++)
			{
				if(list[i].name===item)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 抛出事件
		 */		
		private function dispatchCoEvent(kind:String = null, location:int = -1,
										 oldLocation:int = -1, items:Array = null,oldItems:Array=null):void
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,
				kind,location,oldLocation,items,oldItems);
			dispatchEvent(event);
		}

	}
}