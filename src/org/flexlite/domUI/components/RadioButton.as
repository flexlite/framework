package org.flexlite.domUI.components
{
	import flash.events.Event;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.ToggleButtonBase;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUtils.SharedMap;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 单选按钮
	 * @author DOM
	 */
	public class RadioButton extends ToggleButtonBase
	{
		/**
		 * 构造函数
		 */
		public function RadioButton()
		{
			super();
			groupName = "radioGroup";
		}
		
		override protected function get hostComponentKey():Object
		{
			return RadioButton;
		}
		/**
		 * 在RadioButtonGroup中的索引
		 */		
		dx_internal var indexNumber:int = 0;
		/**
		 * 所属的RadioButtonGroup
		 */		
		dx_internal var radioButtonGroup:RadioButtonGroup = null;
		
		override public function get enabled():Boolean
		{
			if (!super.enabled)
				return false;
			return !radioButtonGroup || 
				radioButtonGroup.enabled;
		}

		/**
		 * 存储根据groupName自动创建的RadioButtonGroup列表
		 */		
		private static var automaticRadioButtonGroups:SharedMap;
		
		private var _group:RadioButtonGroup;
		/**
		 * 此单选按钮所属的组。同一个组的多个单选按钮之间互斥。
		 * 若不设置此属性，则根据groupName属性自动创建一个唯一的RadioButtonGroup。
		 */		
		public function get group():RadioButtonGroup
		{
			if (!_group&&_groupName)
			{
				if(!automaticRadioButtonGroups)
					automaticRadioButtonGroups = new SharedMap;
				var g:RadioButtonGroup = automaticRadioButtonGroups.get(_groupName);
				if (!g)
				{
					g = new RadioButtonGroup();
					g.name = _groupName;
					automaticRadioButtonGroups.set(_groupName,g);     
				}
				_group = g;
			}
			return _group;
		}
		public function set group(value:RadioButtonGroup):void
		{
			if (_group == value)
				return;
			if(radioButtonGroup)
				radioButtonGroup.removeInstance(this);
			_group = value;  
			_groupName = value ? group.name : "radioGroup";    
			groupChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		private var groupChanged:Boolean = false;
		
		private var _groupName:String = "radioGroup";
		/**
		 * 所属组的名称,具有相同组名的多个单选按钮之间互斥。默认值:"radioGroup"。
		 * 可以把此属性当做设置组的一个简便方式，作用与设置group属性相同,。
		 */		
		public function get groupName():String
		{
			return _groupName;
		}
		public function set groupName(value:String):void
		{
			if (!value || value == "")
				return;
			_groupName = value;
			if(radioButtonGroup)
				radioButtonGroup.removeInstance(this);
			_group = null;
			groupChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			invalidateDisplayList();
		}
		
		private var _value:Object;
		/**
		 * 与此单选按钮关联的自定义数据。
		 * 当被点击时，所属的RadioButtonGroup对象会把此属性赋值给ItemClickEvent.item属性并抛出事件。
		 */		
		public function get value():Object
		{
			return _value;
		}
		public function set value(value:Object):void
		{
			if (_value == value)
				return;
			
			_value = value;
			
			if (selected && group)
				group.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
		}
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if (groupChanged)
			{
				addToGroup();
				groupChanged = false;
			}
			super.commitProperties();
		}
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (group)
			{
				if (selected)
					_group.selection = this;
				else if (group.selection == this)
					_group.selection = null;   
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function buttonReleased():void
		{
			if(!enabled || selected)
				return; 
			if (!radioButtonGroup)
				addToGroup();
			super.buttonReleased();
			group.setSelection(this);
		}
		/**
		 * 添此单选按钮加到组
		 */		
		private function addToGroup():RadioButtonGroup
		{        
			var g:RadioButtonGroup = group; 
			if (g)
				g.addInstance(this);
			return g;
		}
	}
	
}
