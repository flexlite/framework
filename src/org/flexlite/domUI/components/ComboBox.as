package org.flexlite.domUI.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import org.flexlite.domUI.components.supportClasses.DropDownListBase;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	use namespace dx_internal;

	[DXML(show="true")]
	/**
	 * 带输入框的下拉列表控件。不带输入功能的下拉列表请使用DropDownList。
	 * @see org.flexlite.domUI.components.DropDownList
	 * @author DOM
	 */	
	public class ComboBox extends DropDownListBase
	{
		/**
		 * 构造函数
		 */		
		public function ComboBox()
		{
			super();
			
			allowCustomSelectedItem = true;
		}

		override protected function get hostComponentKey():Object
		{
			return ComboBox;
		}
		
		/**
		 * [SkinPart]文本输入控件
		 */		
		public var textInput:TextInput;
		/**
		 * 当用户在文本输入框中输入值且该值被提交时，用来表示当前选中项索引的静态常量。
		 */		
		private static const CUSTOM_SELECTED_ITEM:int = ListBase.CUSTOM_SELECTED_ITEM;
		
		private var actualProposedSelectedIndex:Number = NO_SELECTION;  
		
		private var userTypedIntoText:Boolean;
		/**
		 * 文本改变前上一次的文本内容。
		 */		
		private var previousTextInputText:String = "";
		/**
		 * 当用户在提示区域中输入字符时,用于根据输入文字返回匹配的数据项索引列表的回调函数。
		 * 示例：function myMatchingFunction(comboBox:ComboBox, inputText:String):Vector.<int>
		 */		
		public var itemMatchingFunction:Function = null; 
		
		private var _labelToItemFunction:Function;
		/**
		 * labelToItemFunction属性改标志
		 */		
		private var labelToItemFunctionChanged:Boolean = false;
		/**
		 * 指定用于将在提示区域中输入的新值转换为与数据提供程序中的数据项具有相同数据类型的回调函数。
		 * 当提示区域中的文本提交且在数据提供程序中未找到时，将调用该属性引用的函数。
		 * 示例： function myLabelToItem(value:String):Object
		 */		
		public function set labelToItemFunction(value:Function):void
		{
			if (value == _labelToItemFunction)
				return;
			
			_labelToItemFunction = value;
			labelToItemFunctionChanged = true;
			invalidateProperties();
		}
		
		public function get labelToItemFunction():Function
		{
			return _labelToItemFunction;
		}
		
		private var _maxChars:int = 0;
		
		private var maxCharsChanged:Boolean = false;
		/**
		 * 文本输入框中最多可包含的字符数（即用户输入的字符数）。0 值相当于无限制。默认值为0.
		 */		
		public function get maxChars():int
		{
			return _maxChars;
		}
		public function set maxChars(value:int):void
		{
			if (value == _maxChars)
				return;
			
			_maxChars = value;
			maxCharsChanged = true;
			invalidateProperties();
		}
		/**
		 * 如果为 true，则用户在文本输入框编辑时会打开下拉列表。
		 */		
		public var openOnInput:Boolean = true;
		
		private var _restrict:String;
		/**
		 * restrict属性改变标志
		 */		
		private var restrictChanged:Boolean;
		/**
		 * @copy org.flexlite.domUI.components.EditableText#restrict
		 */
		public function get restrict():String
		{
			return _restrict;
		}
		public function set restrict(value:String):void
		{
			if (value == _restrict)
				return;
			
			_restrict = value;
			restrictChanged = true;
			invalidateProperties();
		}
		
		override public function set selectedIndex(value:int):void
		{
			super.selectedIndex = value;
			actualProposedSelectedIndex = value;
		}
		
		override dx_internal function set userProposedSelectedIndex(value:Number):void
		{
			super.userProposedSelectedIndex = value;
			actualProposedSelectedIndex = value;
		}
		
		/**
		 * 处理正在输入文本的操作，搜索并匹配数据项。
		 */		
		private function processInputField():void
		{
			var matchingItems:Vector.<int>;
			actualProposedSelectedIndex = CUSTOM_SELECTED_ITEM; 
			if (!dataProvider || dataProvider.length <= 0)
				return;
			
			if (textInput.text != "")
			{
				if (itemMatchingFunction != null)
					matchingItems = itemMatchingFunction(this, textInput.text);
				else
					matchingItems = findMatchingItems(textInput.text);
				
				if (matchingItems.length > 0)
				{
					super.changeHighlightedSelection(matchingItems[0], true);
					
					var typedLength:int = textInput.text.length;
					var item:Object = dataProvider ? dataProvider.getItemAt(matchingItems[0]) : undefined;
					if (item)
					{
						var itemString:String = itemToLabel(item);
						previousTextInputText = textInput.text = itemString;
						textInput.setSelection(typedLength,itemString.length);
					}
				}
				else
				{
					super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
				}
			}
			else
			{
				super.changeHighlightedSelection(NO_SELECTION);  
			}
		}
		/**
		 * 根据指定字符串找到匹配的数据项索引列表。
		 */		
		private function findMatchingItems(input:String):Vector.<int>
		{
			
			var startIndex:int;
			var stopIndex:int;
			var retVal:int;  
			var retVector:Vector.<int> = new Vector.<int>;
			
			retVal = findStringLoop(input, 0, dataProvider.length); 
			
			if (retVal != -1)
				retVector.push(retVal);
			return retVector;
		}
		
		/**
		 * 在数据源中查询指定索引区间的数据项，返回数据字符串与str开头匹配的数据项索引。
		 */		
		private function findStringLoop(str:String, startIndex:int, stopIndex:int):Number
		{
			for (startIndex; startIndex != stopIndex; startIndex++)
			{
				var itmStr:String = itemToLabel(dataProvider.getItemAt(startIndex));
				
				itmStr = itmStr.substring(0, str.length);
				if (str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
				{
					return startIndex;
				}
			}
			return -1;
		}
		
		private function getCustomSelectedItem():*
		{
			
			var input:String = textInput.text;
			if (input == "")
				return undefined;
			else if (labelToItemFunction != null)
				return _labelToItemFunction(input);
			else
				return input;
		}
		
		dx_internal function applySelection():void
		{
			if (actualProposedSelectedIndex == CUSTOM_SELECTED_ITEM)
			{
				var itemFromInput:* = getCustomSelectedItem();
				if (itemFromInput != undefined)
					setSelectedItem(itemFromInput, true);
				else
					setSelectedIndex(NO_SELECTION, true);
			}
			else
			{
				setSelectedIndex(actualProposedSelectedIndex, true);
			}
			
			if (textInput)
				textInput.setSelection(-1, -1);
			
			userTypedIntoText = false;
		}
		
		override protected function commitProperties():void
		{        
			
			var selectedIndexChanged:Boolean = _proposedSelectedIndex != NO_PROPOSED_SELECTION;
			if (_proposedSelectedIndex == CUSTOM_SELECTED_ITEM && 
				_pendingSelectedItem == undefined)
			{
				_proposedSelectedIndex = NO_PROPOSED_SELECTION;
			}
			
			super.commitProperties();
			
			if (textInput)
			{
				if (maxCharsChanged)
				{
					textInput.maxChars = _maxChars;
					maxCharsChanged = false;
				}
				
				if (restrictChanged)
				{
					textInput.restrict = _restrict;
					restrictChanged = false;
				}
			}
			if (selectedIndexChanged && selectedIndex == NO_SELECTION)
				previousTextInputText = textInput.text = "";
		}    
		
		override dx_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			super.updateLabelDisplay();
			
			if (textInput)
			{
				if (displayItem == undefined)
					displayItem = selectedItem;
				if (displayItem != null && displayItem != undefined)
				{
					previousTextInputText = textInput.text = itemToLabel(displayItem);
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == textInput)
			{
				updateLabelDisplay();
				textInput.addEventListener(Event.CHANGE,textInput_changeHandler);
				textInput.maxChars = maxChars;
				textInput.restrict = restrict;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == textInput)
			{
				textInput.removeEventListener(Event.CHANGE,textInput_changeHandler);
			}
		}
		override dx_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
		{
			super.changeHighlightedSelection(newIndex, scrollToTop);
			
			if (newIndex >= 0)
			{
				var item:Object = dataProvider ? dataProvider.getItemAt(newIndex) : undefined;
				if (item && textInput)
				{
					var itemString:String = itemToLabel(item); 
					previousTextInputText = textInput.text = itemString;
					textInput.selectAll();
					
					userTypedIntoText = false;
				}
			}
		}
		
		override public function setFocus():void
		{
			if (stage && textInput)
			{            
				stage.focus = textInput.textDisplay as InteractiveObject;            
			}
		}
		
		override dx_internal function dropDownController_openHandler(event:UIEvent):void
		{
			super.dropDownController_openHandler(event);
			userProposedSelectedIndex = userTypedIntoText ? NO_SELECTION : selectedIndex;  
		}
		
		override protected function dropDownController_closeHandler(event:UIEvent):void
		{        
			super.dropDownController_closeHandler(event);      
			if (!event.isDefaultPrevented())
			{
				applySelection();
			}
		}
		
		override protected function itemRemoved(index:int):void
		{
			if (index == selectedIndex)
				updateLabelDisplay("");
			
			super.itemRemoved(index);       
		}
		/**
		 * 文本输入改变事件处理函数
		 */		
		protected function textInput_changeHandler(event:Event):void
		{  
			userTypedIntoText = true;
			if(previousTextInputText.length>textInput.text.length)
			{
				super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
			}
			else if (previousTextInputText != textInput.text)
			{
				if (openOnInput)
				{
					if (!isDropDownOpen)
					{
						openDropDown();
						addEventListener(UIEvent.OPEN, editingOpenHandler);
						return;
					}   
				}
				processInputField();
			}
			previousTextInputText = textInput.text;
		}
		/**
		 * 第一次输入等待下拉列表打开后在处理数据匹配
		 */		
		private function editingOpenHandler(event:UIEvent):void
		{
			removeEventListener(UIEvent.OPEN, editingOpenHandler);
			processInputField();
		}
		
	}
}