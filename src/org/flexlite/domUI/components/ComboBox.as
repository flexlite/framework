package org.flexlite.domUI.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.DropDownListBase;
	import org.flexlite.domUI.components.supportClasses.ListBase;
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

		/**
		 * @inheritDoc
		 */
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
		
		private var _prompt:String;
		
		private var promptChanged:Boolean = false;
		/**
		 * 输入文本为 null 时要显示的文本。 <p/>
		 * 先创建控件时将显示提示文本。控件获得焦点、输入文本为非 null 或选择了列表中的项目时提示文本将消失。
		 * 控件失去焦点时提示文本将重新显示，但仅当未输入文本时（如果文本字段的值为 null 或空字符串）。
		 */
		public function get prompt():String
		{
			return _prompt;
		}
		public function set prompt(value:String):void
		{
			if(_prompt==value)
				return;
			_prompt = value;
			promptChanged = true;
			invalidateProperties();       
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
		 * 表示用户可输入到文本字段中的字符集。如果 restrict 属性的值为 null，则可以输入任何字符。 
		 * 如果 restrict 属性的值为空字符串，则不能输入任何字符。如果 restrict 属性的值为一串字符，
		 *  则只能在文本字段中输入该字符串中的字符。从左向右扫描该字符串。可以使用连字符 (-) 指定一个范围。
		 *  只限制用户交互；脚本可将任何文本放入文本字段中。此属性不与属性检查器中的“嵌入字体”选项同步。 <p/>
		 * 如果字符串以尖号 (ˆ) 开头，则先接受所有字符，然后从接受字符集中排除字符串中 ˆ 之后的字符。
		 *  如果字符串不以尖号 (ˆ) 开头，则最初不接受任何字符，然后将字符串中的字符包括在接受字符集中。
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
		
		/**
		 * @inheritDoc
		 */
		override public function set selectedIndex(value:int):void
		{
			super.selectedIndex = value;
			actualProposedSelectedIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
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
				if(promptChanged)
				{
					textInput.prompt = _prompt;
					promptChanged = false;
				}
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
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == textInput)
			{
				textInput.removeEventListener(Event.CHANGE,textInput_changeHandler);
			}
		}
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if (stage && textInput)
			{            
				stage.focus = textInput.textDisplay as InteractiveObject;            
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function dropDownController_openHandler(event:UIEvent):void
		{
			super.dropDownController_openHandler(event);
			userProposedSelectedIndex = userTypedIntoText ? NO_SELECTION : selectedIndex;  
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dropDownController_closeHandler(event:UIEvent):void
		{        
			super.dropDownController_closeHandler(event);      
			if (!event.isDefaultPrevented())
			{
				applySelection();
			}
		}
		
		/**
		 * @inheritDoc
		 */
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