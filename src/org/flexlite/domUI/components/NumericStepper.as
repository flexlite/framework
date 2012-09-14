package org.flexlite.domUI.components
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.globalization.LocaleID;
<<<<<<< HEAD
	import flash.globalization.NumberFormatter;
=======
	import flash.globalization.NumberFormatter;
>>>>>>> master
	
	use namespace dx_internal;
	
	/**
	 * 数字调节器
	 * @author DOM
	 */	
	public class NumericStepper extends Spinner 
	{
		/**
		 * 构造函数
		 */		
		public function NumericStepper()
		{
			super();
			maximum = 10;
		}
		
		override protected function get hostComponentKey():Object
		{
			return NumericStepper;
		}
		/**
		 * [SkinPart]文本输入组件
		 */		
		public var textDisplay:TextInput;
		
		private var dataFormatter:NumberFormatter;
		/**
		 * 最大值改变
		 */		
		private var maxChanged:Boolean = false;
		
		override public function set maximum(value:Number):void
		{
			maxChanged = true;
			super.maximum = value;
		}
		
		private var stepSizeChanged:Boolean = false;
		
		override public function set stepSize(value:Number):void
		{
			stepSizeChanged = true;
			super.stepSize = value;       
		}   
		
		private var _maxChars:int = 0;
		
		private var maxCharsChanged:Boolean = false;
		/**
		 * 字段中最多可输入的字符数。0 值表示可以输入任意数目的字符。
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
		
		private var _valueFormatFunction:Function;
		
		private var valueFormatFunctionChanged:Boolean;
		/**
		 * 格式化数字为textInput中显示的文字的回调函数。示例： funcName(value:Number):String
		 */		
		public function get valueFormatFunction():Function
		{
			return _valueFormatFunction;
		}
		
		public function set valueFormatFunction(value:Function):void
		{
			_valueFormatFunction = value;
			valueFormatFunctionChanged = true;
			invalidateProperties();
		}
		
		private var _valueParseFunction:Function;
		
		private var valueParseFunctionChanged:Boolean;
		/**
		 * 格式化textInput中输入的文字为数字的回调函数。示例： funcName(value:String):Number
		 */		
		public function get valueParseFunction():Function
		{
			return _valueParseFunction;
		}
		public function set valueParseFunction(value:Function):void
		{
			_valueParseFunction = value;
			valueParseFunctionChanged = true;
			invalidateProperties();
		}
		
		
		override protected function commitProperties():void
		{   
			super.commitProperties();
			
			if (maxChanged || stepSizeChanged || valueFormatFunctionChanged)
			{
				textDisplay.widthInChars = calculateWidestValue();
				maxChanged = false;
				stepSizeChanged = false;
				
				if (valueFormatFunctionChanged)
				{
					applyDisplayFormatFunction();
					
					valueFormatFunctionChanged = false;
				}
			}
			
			if (valueParseFunctionChanged)
			{
				commitTextInput(false);
				valueParseFunctionChanged = false;
			}
			
			if (maxCharsChanged)
			{
				textDisplay.maxChars = _maxChars;
				maxCharsChanged = false;
			}
		} 
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == textDisplay)
			{
				textDisplay.addEventListener(FocusEvent.FOCUS_OUT, 
					textDisplay_focusOutHandler); 
				textDisplay.maxChars = _maxChars;
				
				textDisplay.restrict = "0-9\\-\\.\\,";
				textDisplay.text = value.toString();
				textDisplay.widthInChars = calculateWidestValue(); 
			}
		}
		
		override public function setFocus():void
		{
			if (stage)
			{
				stage.focus = textDisplay.textDisplay as InteractiveObject;
				if (textDisplay.textDisplay && 
					(textDisplay.textDisplay.editable || textDisplay.textDisplay.selectable))
				{
					textDisplay.textDisplay.selectAll();
				}
			}
		}
		
		override protected function setValue(newValue:Number):void
		{
			super.setValue(newValue);
			
			applyDisplayFormatFunction();
		}
		
		override public function changeValueByStep(increase:Boolean = true):void
		{
			commitTextInput();
			
			super.changeValueByStep(increase);
		}
		/**
		 * 提交属性改变的值
		 */		
		private function commitTextInput(dispatchChange:Boolean = false):void
		{
			var inputValue:Number;
			var prevValue:Number = value;
			
			if (valueParseFunction != null)
			{
				inputValue = valueParseFunction(textDisplay.text);
			}
			else 
			{
				if (dataFormatter == null)
					dataFormatter = new NumberFormatter(LocaleID.DEFAULT);
				
				inputValue = dataFormatter.parseNumber(textDisplay.text);
			}
			
			if ((textDisplay.text && textDisplay.text.length != value.toString().length)
				|| textDisplay.text == "" || (inputValue != value && 
					(Math.abs(inputValue - value) >= 0.000001 || isNaN(inputValue))))
			{
				setValue(nearestValidValue(inputValue, snapInterval));
				if (value == prevValue && inputValue != prevValue)
					dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			}
			
			if (dispatchChange)
			{
				if (value != prevValue)
					dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 计算水平字符数
		 */		
		private function calculateWidestValue():Number
		{
			var widestNumber:Number = minimum.toString().length >
				maximum.toString().length ?
				minimum :
				maximum;
			widestNumber += stepSize;
			
			if (valueFormatFunction != null)
				return valueFormatFunction(widestNumber).length;
			else 
				return widestNumber.toString().length;
		}
		/**
		 * 应用格式化函数
		 */		
		private function applyDisplayFormatFunction():void
		{
			if (valueFormatFunction != null)
				textDisplay.text = valueFormatFunction(value);
			else
				textDisplay.text = value.toString();
		}
		/**
		 * 文本输入框失去焦点
		 */		
		private function textDisplay_focusOutHandler(event:Event):void
		{
			commitTextInput(true);
		}
	}
	
}
