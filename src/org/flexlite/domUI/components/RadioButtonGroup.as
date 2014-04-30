package org.flexlite.domUI.components
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.UIEvent;
	
	use namespace dx_internal;
	
	/**
	 * 选中项改变事件。仅当用户与此控件交互时才抛出此事件。 
	 * 以编程方式更改选中项的值时，该控件并不抛出change事件，而是抛出valueCommit事件。
	 */	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 属性提交事件
	 */	
	[Event(name="valueCommit", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="false")]
	
	/**
	 * 单选按钮组
	 * @author DOM
	 */
	public class RadioButtonGroup extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function RadioButtonGroup()
		{
			super();
			name = "radioButtonGroup"+groupCount;
			groupCount++;
		}
		
		private static var groupCount:int = 0;
		/**
		 * 组名
		 */		
		dx_internal var name:String;
		/**
		 * 单选按钮列表
		 */		
		private var radioButtons:Array  = [];
		
		private var _enabled:Boolean = true;
		/**
		 * 组件是否可以接受用户交互。默认值为true。设置此属性将影响组内所有单选按钮。
		 */	
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			_enabled = value;
			for (var i:int = 0; i < numRadioButtons; i++)
				getRadioButtonAt(i).invalidateSkinState();
		}
		/**
		 * 组内单选按钮数量
		 */		
		public function get numRadioButtons():int
		{
			return radioButtons.length;
		}
		
		private var _selectedValue:Object;
		/**
		 * 当前被选中的单选按钮的value属性值。注意，此属性仅当目标RadioButton在显示列表时有效。
		 */		
		public function get selectedValue():Object
		{
			if (selection)
			{
				return selection.value!=null?
					selection.value :
					selection.label;
			}
			return null;
		}
		public function set selectedValue(value:Object):void
		{
			_selectedValue = value;
			if (value==null)
			{
				setSelection(null, false);
				return;
			}
			var n:int = numRadioButtons;
			for (var i:int = 0; i < n; i++)
			{
				var radioButton:RadioButton = getRadioButtonAt(i);
				if (radioButton.value == value ||
					radioButton.label == value)
				{
					changeSelection(i, false);
					_selectedValue = null;
					
					dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
					
					break;
				}
			}
		}
		
		private var _selection:RadioButton;
		/**
		 * 当前被选中的单选按钮引用,注意，此属性仅当目标RadioButton在显示列表时有效。
		 */		
		public function get selection():RadioButton
		{
			return _selection;
		}
		public function set selection(value:RadioButton):void
		{
			if ( _selection == value)
				return;
			setSelection(value, false);
		}
		/**
		 * 获取指定索引的单选按钮
		 * @param index 单选按钮的索引
		 */		
		public function getRadioButtonAt(index:int):RadioButton
		{
			if (index >= 0 && index < numRadioButtons)
				return radioButtons[index];
			
			return null;
		}
		/**
		 * 添加单选按钮到组内
		 */
		dx_internal function addInstance(instance:RadioButton):void
		{
			instance.addEventListener(Event.REMOVED, radioButton_removedHandler);
			
			radioButtons.push(instance);
			radioButtons.sort(breadthOrderCompare);
			for (var i:int = 0; i < radioButtons.length; i++)
				radioButtons[i].indexNumber = i;
			if (_selectedValue)
				selectedValue = _selectedValue;
			if (instance.selected == true)
				selection = instance;
			
			instance.radioButtonGroup = this;
			instance.invalidateSkinState();
			
			dispatchEvent(new Event("numRadioButtonsChanged"));
		}
		/**
		 * 从组里移除单选按钮
		 */		
		dx_internal function removeInstance(instance:RadioButton):void
		{
			doRemoveInstance(instance,false);
		}
		/**
		 * 执行从组里移除单选按钮
		 */		
		private function doRemoveInstance(instance:RadioButton,addListener:Boolean=true):void
		{
			if (instance)
			{
				var foundInstance:Boolean = false;
				for (var i:int = 0; i < numRadioButtons; i++)
				{
					var rb:RadioButton = getRadioButtonAt(i);
					
					if (foundInstance)
					{
						
						rb.indexNumber = rb.indexNumber - 1;
					}
					else if (rb == instance)
					{
						if(addListener)
							instance.addEventListener(Event.ADDED, radioButton_addedHandler);
						if (instance == _selection)
							_selection = null;
						
						instance.radioButtonGroup = null;
						instance.invalidateSkinState();
						radioButtons.splice(i,1);
						foundInstance = true;
						i--;
					}
				}
				
				if (foundInstance)
					dispatchEvent(new Event("numRadioButtonsChanged"));
			}
		}
		/**
		 * 设置选中的单选按钮
		 */		
		dx_internal function setSelection(value:RadioButton, fireChange:Boolean = true):void
		{
			if (_selection == value)
				return;
			
			if (!value)
			{
				if (selection)
				{
					_selection.selected = false;
					_selection = null;
					if (fireChange)
						dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else
			{
				var n:int = numRadioButtons;
				for (var i:int = 0; i < n; i++)
				{
					if (value == getRadioButtonAt(i))
					{
						changeSelection(i, fireChange);
						break;
					}
				}
			}
			dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
		}
		/**
		 * 改变选中项
		 */		
		private function changeSelection(index:int, fireChange:Boolean = true):void
		{
			var rb:RadioButton = getRadioButtonAt(index);
			if (rb && rb != _selection)
			{
				
				if (_selection)
					_selection.selected = false;
				_selection = rb;
				_selection.selected = true;
				if (fireChange)
					dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 显示对象深度排序
		 */		
		private function breadthOrderCompare(a:DisplayObject, b:DisplayObject):Number
		{
			var aParent:DisplayObjectContainer = a.parent;
			var bParent:DisplayObjectContainer = b.parent;
			
			if (!aParent || !bParent)
				return 0;
			
			var aNestLevel:int = (a is UIComponent) ? UIComponent(a).nestLevel : -1;
			var bNestLevel:int = (b is UIComponent) ? UIComponent(b).nestLevel : -1;
			
			var aIndex:int = 0;
			var bIndex:int = 0;
			
			if (aParent == bParent)
			{
				if (aParent is IVisualElementContainer && a is IVisualElement)
					aIndex = IVisualElementContainer(aParent).getElementIndex(IVisualElement(a));
				else
					aIndex = DisplayObjectContainer(aParent).getChildIndex(a);
				
				if (bParent is IVisualElementContainer && b is IVisualElement)
					bIndex = IVisualElementContainer(bParent).getElementIndex(IVisualElement(b));
				else
					bIndex = DisplayObjectContainer(bParent).getChildIndex(b);
			}
			
			if (aNestLevel > bNestLevel || aIndex > bIndex)
				return 1;
			else if (aNestLevel < bNestLevel ||  bIndex > aIndex)
				return -1;
			else if (a == b)
				return 0;
			else 
				return breadthOrderCompare(aParent, bParent);
		}
		/**
		 * 单选按钮添加到显示列表
		 */		
		private function radioButton_addedHandler(event:Event):void
		{
			var rb:RadioButton = event.target as RadioButton;
			if (rb)
			{
				rb.removeEventListener(Event.ADDED, radioButton_addedHandler);
				addInstance(rb);
			}
		}
		/**
		 * 单选按钮从显示列表移除
		 */		
		private function radioButton_removedHandler(event:Event):void
		{
			var rb:RadioButton = event.target as RadioButton;
			if (rb)
			{
				rb.removeEventListener(Event.REMOVED, radioButton_removedHandler);
				doRemoveInstance(rb);
			}
		}
	}
	
}
