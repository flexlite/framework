package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import org.flexlite.domUI.components.supportClasses.TextBase;
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domUI.core.IEditableText;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.NavigationUnit;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	/**
	 * 当控件中的文本通过用户输入发生更改后分派。使用代码更改文本时不会引发此事件。 
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 当控件中的文本通过用户输入发生更改之前分派。但是当用户按 Delete 键或 Backspace 键时，不会分派任何事件。
	 * 可以调用preventDefault()方法阻止更改。  
	 */	
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	[DXML(show="true")]
	
	/**
	 * 可编辑文本控件
	 * @author DOM
	 */
	public class EditableText extends TextBase 
		implements IEditableText,IDisplayText,IViewport
	{
		public function EditableText()
		{
			super();
			selectable = true;
		}
		
		private var _displayAsPassword:Boolean = false;
		
		private var displayAsPasswordChanged:Boolean = true;
		/**
		 * @inheritDoc
		 */
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			if(value == _displayAsPassword)
				return;
			_displayAsPassword = value;
			displayAsPasswordChanged = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var pendingEditable:Boolean = true;
		
		private var _editable:Boolean = true;
		
		private var editableChanged:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get editable():Boolean
		{
			if(enabled)
				return _editable;
			return pendingEditable;
		}
		
		public function set editable(value:Boolean):void
		{
			if(_editable==value)
				return;
			if(enabled)
			{
				_editable = value;
				editableChanged = true;
				invalidateProperties();
			}
			else
			{
				pendingEditable = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set enabled(value:Boolean):void
		{
			if (value == super.enabled)
				return;
			
			super.enabled = value;
			if(enabled)
			{
				if(_editable!=pendingEditable)
					editableChanged = true;
				_editable = pendingEditable;
			}
			else
			{
				if(editable)
					editableChanged = true;
				pendingEditable = _editable;
				_editable = false;
			}
			invalidateProperties();
		}
		
		private var _maxChars:int = 0;
		
		private var maxCharsChanged:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get maxChars():int
		{
			return _maxChars;
		}
		
		public function set maxChars(value:int):void
		{
			if(value==_maxChars)
				return;
			_maxChars = value;
			maxCharsChanged = true;
			invalidateProperties();
		}
		
		private var _multiline:Boolean = true;
		
		private var multilineChanged:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get multiline():Boolean
		{
			return _multiline;
		}
		
		public function set multiline(value:Boolean):void
		{
			if(value==multiline)
				return;
			_multiline = value;
			multilineChanged = true;
			invalidateProperties();
		}
		
		
		private var _restrict:String = null;
		
		private var restrictChanged:Boolean = false;
		/**
		 * @inheritDoc
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
		override public function set size(value:uint):void
		{
			if(size==value)
				return;
			super.size = value;
			heightInLinesChanged = true;
			widthInCharsChanged = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set leading(value:int):void
		{
			if(leading==value)
				return;
			super.leading = value;
			heightInLinesChanged = true;
		}
		
		private var _heightInLines:Number = NaN;
		
		private var heightInLinesChanged:Boolean = false;

		/**
		 * 控件的默认高度（以行为单位测量）。 若设置了multiline属性为false，则忽略此属性。
		 */		
		public function get heightInLines():Number
		{
			return _heightInLines;
			
		}

		public function set heightInLines(value:Number):void
		{
			if(_heightInLines == value)
				return;
			_heightInLines = value;
			heightInLinesChanged = true;
			
			invalidateProperties();
		}

		
		private var _widthInChars:Number = NaN;
		
		private var widthInCharsChanged:Boolean = false;

		/**
		 * 控件的默认宽度（使用字号：size为单位测量）。 若同时设置了maxChars属性，将会根据两者测量结果的最小值作为测量宽度。
		 */		
		public function get widthInChars():Number
		{
			return _widthInChars;
		}

		public function set widthInChars(value:Number):void
		{
			if(_widthInChars==value)
				return;
			_widthInChars = value;
			widthInCharsChanged = true;
			
			invalidateProperties();
		}

		
		private var _contentWidth:Number = 0;
		
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		
		private function setContentWidth(value:Number):void
		{
			if (value == _contentWidth)
				return;
			var oldValue:Number = _contentWidth;
			_contentWidth = value;
			dispatchPropertyChangeEvent("contentWidth", oldValue, value); 
		}
		
		private var _contentHeight:Number = 0;
		
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		private function setContentHeight(value:Number):void
		{
			if (value == _contentHeight)
				return;
			var oldValue:Number = _contentHeight;
			_contentHeight = value;
			dispatchPropertyChangeEvent("contentHeight", oldValue, value); 
		}
		
		
		private var _horizontalScrollPosition:Number = 0;
		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		
		public function set horizontalScrollPosition(value:Number):void
		{
			if(_horizontalScrollPosition == value)
				return;
			value = Math.round(value);
			var oldValue:Number = _horizontalScrollPosition;
			_horizontalScrollPosition = value;
			if (_clipAndEnableScrolling)
			{
				if(textField)
					textField.scrollH = value;
				dispatchPropertyChangeEvent("horizontalScrollPosition",oldValue,value);
			}
		}
		
		private var _verticalScrollPosition:Number = 0
		/**
		 * @inheritDoc
		 */
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		
		public function set verticalScrollPosition(value:Number):void
		{
			if(_verticalScrollPosition == value)
				return;
			value = Math.round(value);
			var oldValue:Number = _verticalScrollPosition;
			_verticalScrollPosition = value;
			if (_clipAndEnableScrolling)
			{
				if (textField)
					textField.scrollV = getScrollVByVertitcalPos(value);
				dispatchPropertyChangeEvent("verticalScrollPosition",oldValue,value);
			}
		}
		
		/**
		 * 根据垂直像素位置获取对应的垂直滚动位置
		 */		
		private function getScrollVByVertitcalPos(value:Number):int
		{
			if(textField.numLines==0)
				return 1;
			var lineHeight:Number = textField.getLineMetrics(0).height;
			return int((value)/lineHeight)+1;
		}
		/**
		 * 根据垂直滚动位置获取对应的垂直像位置
		 */		
		private function getVerticalPosByScrollV(scrollV:int):Number
		{
			if(scrollV == 1||textField.numLines == 0)
				return 0;
			var lineHeight:Number = textField.getLineMetrics(0).height;
			if(scrollV == textField.maxScrollV)
			{
				var offsetHeight:Number = (height-4)%lineHeight;
				return textField.textHeight + offsetHeight-height;
			}
			return lineHeight*(scrollV-1)+2;
		}
		/**
		 * @inheritDoc
		 */
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			var delta:Number = 0;
			
			var maxDelta:Number = _contentWidth - _horizontalScrollPosition - width;
			var minDelta:Number = -_horizontalScrollPosition;
			
			switch(navigationUnit)
			{
				case NavigationUnit.LEFT:
					delta = _horizontalScrollPosition<=0?0:Math.max(minDelta,-size);
					break;
				case NavigationUnit.RIGHT:
					delta = (_horizontalScrollPosition+width >= contentWidth) ? 0 : Math.min(maxDelta, size);
					break;
				case NavigationUnit.PAGE_LEFT:
					delta = Math.max(minDelta, -width);
					break;
				case NavigationUnit.PAGE_RIGHT:
					delta = Math.min(maxDelta, width);
					break;
				case NavigationUnit.HOME:
					delta = minDelta;
					break;
				case NavigationUnit.END:
					delta = maxDelta;
					break;
			}
			return delta;
		}
		/**
		 * @inheritDoc
		 */
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			var delta:Number = 0;
			
			var maxDelta:Number = _contentHeight - _verticalScrollPosition - height;
			var minDelta:Number = -_verticalScrollPosition;
			
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
					delta = getVScrollDelta(-1);
					break;
				case NavigationUnit.DOWN:
					delta = getVScrollDelta(1);
					break;
				case NavigationUnit.PAGE_UP:
					delta = Math.max(minDelta, -width);
					break;
				case NavigationUnit.PAGE_DOWN:
					delta = Math.min(maxDelta, width);
					break;
				case NavigationUnit.HOME:
					delta = minDelta;
					break;
				case NavigationUnit.END:
					delta = maxDelta;
					break;
			}
			return delta;
		}
		
		/**
		 * 返回指定偏移行数的滚动条偏移量
		 */		
		private function getVScrollDelta(offsetLine:int):Number
		{
			if(!textField)
				return 0;
			var currentScrollV:int = getScrollVByVertitcalPos(_verticalScrollPosition);
			var scrollV:int = currentScrollV + offsetLine;
			scrollV = Math.max(1,Math.min(textField.maxScrollV,scrollV));
			var startPos:Number = getVerticalPosByScrollV(scrollV);
			var delta:int = startPos-_verticalScrollPosition;
			return delta;
		}
		
		private var _clipAndEnableScrolling:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get clipAndEnableScrolling():Boolean
		{
			return _clipAndEnableScrolling;
		}
		
		public function set clipAndEnableScrolling(value:Boolean):void
		{
			if(_clipAndEnableScrolling == value)
				return;
			_clipAndEnableScrolling = value;
			
			if(textField)
			{
				if(value)
				{
					textField.scrollH = _horizontalScrollPosition;
					textField.scrollV = getScrollVByVertitcalPos(_verticalScrollPosition);
					updateContentSize();
				}
				else
				{
					textField.scrollH = 0;
					textField.scrollV = 1;
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if(!textField)
			{
				editableChanged = true;
				displayAsPasswordChanged = true;
				maxCharsChanged = true;
				multilineChanged = true;
				restrictChanged = true;
			}
			
			super.commitProperties();
			
			if(editableChanged)
			{
				textField.type = _editable?TextFieldType.INPUT:TextFieldType.DYNAMIC;
				editableChanged = false;
			}
			
			if (displayAsPasswordChanged)
			{
				textField.displayAsPassword = _displayAsPassword;
				displayAsPasswordChanged = false;
			}
			
			if(maxCharsChanged)
			{
				textField.maxChars = _maxChars;
				maxCharsChanged = false;
			}
			
			if(multilineChanged)
			{
				textField.multiline = _multiline;
				textField.wordWrap = _multiline;
				multilineChanged = false;
			}
			
			if (restrictChanged)
			{
				textField.restrict = _restrict;
				
				restrictChanged = false;
			}
			
			if(heightInLinesChanged)
			{
				heightInLinesChanged = false;
				if(isNaN(_heightInLines))
				{
					defaultHeight = NaN;
				}
				else
				{
					var hInLine:int = int(heightInLines);
					var lineHeight:Number = 22;
					if(textField.length>0)
					{
						lineHeight = textField.getLineMetrics(0).height;
					}
					else
					{
						textField.$text = "M";
						lineHeight = textField.getLineMetrics(0).height;
						textField.$text = "";
					}
					defaultHeight = hInLine*lineHeight+4;
				}
			}
			
			if(widthInCharsChanged)
			{
				widthInCharsChanged = false;
				if(isNaN(_widthInChars))
				{
					defaultWidth = NaN;
				}
				else
				{
					var wInChars:int = int(_widthInChars);
					defaultWidth = size*wInChars+5;
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			isValidating = true;
			var oldScrollH:int = textField.scrollH;
			var oldScrollV:int = textField.scrollV;
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			updateContentSize();
			
			textField.scrollH = oldScrollH;
			textField.scrollV = oldScrollV;
			isValidating = false;
		}
		
		/**
		 * 更新内容尺寸大小
		 */		
		private function updateContentSize():void
		{
			if(!clipAndEnableScrolling)
				return;
			setContentWidth(textField.textWidth);
			var contentHeight:Number = 0;
			var numLines:int = textField.numLines;
			if(numLines==0)
			{
				contentHeight = 4;
			}
			else
			{
				var lineHeight:Number = (textField.textHeight-4)/numLines;
				var offsetHeight:Number = (height-4)%lineHeight;
				contentHeight = textField.textHeight + offsetHeight;
			}
			setContentHeight(contentHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectionBeginIndex():int
		{
			validateProperties();
			if(textField)
				return textField.selectionBeginIndex;
			return 0;
		}
		/**
		 * @inheritDoc
		 */
		public function get selectionEndIndex():int
		{
			validateProperties();
			if(textField)
				return textField.selectionEndIndex;
			return 0;
		}
		/**
		 * @inheritDoc
		 */
		public function get caretIndex():int
		{
			validateProperties();
			if(textField)
				return textField.caretIndex;
			return 0;
		}
		/**
		 * @inheritDoc
		 */
		public function setSelection(beginIndex:int,endIndex:int):void
		{
			validateProperties();
			if(textField)
			{
				textField.setSelection(beginIndex,endIndex);
			}
		}
		/**
		 * @inheritDoc
		 */
		public function selectAll():void
		{
			validateProperties();
			if(textField)
			{
				textField.setSelection(0,textField.length-1);
			}
		}
		
		/**
		 * heightInLines计算出来的默认高度。 
		 */		
		private var defaultHeight:Number = NaN;
		/**
		 * widthInChars计算出来的默认宽度。
		 */		
		private var defaultWidth:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			measuredWidth = isNaN(defaultWidth)? DEFAULT_MEASURED_WIDTH:defaultWidth;
			
			if(_maxChars!=0)
			{
				measuredWidth = Math.min(measuredWidth,textField.textWidth);
			}
			if(_multiline)
			{
				measuredHeight = isNaN(defaultHeight)?DEFAULT_MEASURED_HEIGHT*2:defaultHeight;
			}
			else
			{
				measuredHeight = textField.textHeight;
			}
		}
		/**
		 * 创建文本显示对象
		 */		
		override protected function createTextField():void
		{   
			super.createTextField();
			textField.type = _editable?TextFieldType.INPUT:TextFieldType.DYNAMIC;
			textField.multiline = _multiline;
			textField.wordWrap = _multiline;
			
			textField.addEventListener(Event.CHANGE, textField_changeHandler);
			textField.addEventListener(Event.SCROLL, textField_scrollHandler);
			textField.addEventListener(TextEvent.TEXT_INPUT,
				textField_textInputHandler);
			if(_clipAndEnableScrolling)
			{
				textField.scrollH = _horizontalScrollPosition;
				textField.scrollV = getScrollVByVertitcalPos(_verticalScrollPosition);
			}
		}
		
		private function textField_changeHandler(event:Event):void
		{
			textFieldChanged(false);
			event.stopImmediatePropagation();
			dispatchEvent(new Event(Event.CHANGE));
			invalidateSize();
			invalidateDisplayList();
			updateContentSize();
		}
		
		
		private var isValidating:Boolean = false;
		
		/**
		 *  @private
		 */
		private function textField_scrollHandler(event:Event):void
		{
			if(isValidating)
				return;
			horizontalScrollPosition = textField.scrollH;
			verticalScrollPosition = getVerticalPosByScrollV(textField.scrollV);
			
		}
		
		/**
		 * 即将输入文字
		 */
		private function textField_textInputHandler(event:TextEvent):void
		{
			event.stopImmediatePropagation();
			
			var newEvent:TextEvent =
				new TextEvent(TextEvent.TEXT_INPUT, false, true);
			newEvent.text = event.text;
			dispatchEvent(newEvent);
			
			if (newEvent.isDefaultPrevented())
				event.preventDefault();
		}
	}
}