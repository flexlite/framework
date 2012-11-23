package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.layouts.BasicLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 层级堆叠容器,一次只显示一个子对象。
	 * @author DOM
	 */
	public class ViewStack extends Group
	{
		/**
		 * 构造函数
		 */		
		public function ViewStack()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(proposedSelectedIndex!=-1)
			{
				var index:int = proposedSelectedIndex;
				proposedSelectedIndex = -1;
				setSelectedIndex(index);
			}
		}
		
		/**
		 * 此容器的布局对象,仅支持BasicLayout,设置其他布局将会被忽略。
		 */		
		override public function get layout():LayoutBase
		{
			return super.layout;
		}
		override public function set layout(value:LayoutBase):void
		{
			if(value is BasicLayout)
				super.layout = value;
		}
		
		private var _selectedChild:IVisualElement;
		/**
		 * 当前可见的子容器。
		 */		
		public function get selectedChild():IVisualElement
		{
			return _selectedChild;
		}
		public function set selectedChild(value:IVisualElement):void
		{
			if(_selectedChild==value)
				return;
			var index:int = getElementIndex(value);
			setSelectedIndex(index);
		}
		
		private var proposedSelectedIndex:int = -1;
		
		dx_internal var _selectedIndex:int = -1;
		/**
		 * 当前可见子容器的索引。索引从0开始。
		 */		
		public function get selectedIndex():int
		{
			return proposedSelectedIndex!=-1?proposedSelectedIndex:_selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if(createChildrenCalled)
			{
				setSelectedIndex(value);
			}
			else
			{
				proposedSelectedIndex = value;
			}
		}
		/**
		 * 设置选中项索引
		 */		
		dx_internal function setSelectedIndex(value:int):void
		{
			if(_selectedIndex==value)
				return;
			if(value>=0&&value<numElements)
			{
				_selectedIndex = value;
				if(_selectedChild)
				{
					_selectedChild.visible = false;
					_selectedChild.includeInLayout = false;
				}
				_selectedChild = getElementAt(_selectedIndex);
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
		 * 添加一个显示元素到容器
		 */		
		override dx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean=true):void
		{
			super.elementAdded(element,index,notifyListeners);
			element.visible = false;
			element.includeInLayout = false;
			if(_selectedIndex==-1)
				setSelectedIndex(0);
		}
		/**
		 * 从容器移除一个显示元素
		 */		
		override dx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean=true):void
		{
			super.elementRemoved(element,index,notifyListeners);
			element.visible = true;
			element.includeInLayout = true;
			if(index==_selectedIndex)
				setSelectedIndex(0);
		}
	}
}