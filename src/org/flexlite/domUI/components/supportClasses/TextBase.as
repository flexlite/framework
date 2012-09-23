package org.flexlite.domUI.components.supportClasses
{
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.UITextField;
	import org.flexlite.domUI.core.dx_internal;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 文本基类,实现对文本的自动布局，样式属性设置。
	 * @author DOM
	 */	
	public class TextBase extends UIComponent implements IDisplayText
	{
		public function TextBase()
		{
			super();
		}
		
		/**
		 * 默认的文本测量宽度 
		 */		
		public static const DEFAULT_MEASURED_WIDTH:Number = 160;
		/**
		 * 默认的文本测量高度
		 */		
		public static const DEFAULT_MEASURED_HEIGHT:Number = 22;
		
		/**
		 * 呈示此文本的内部 TextField 
		 */		
		protected var textField:UITextField;
		
		private var _condenseWhite:Boolean = false;
		
		private var condenseWhiteChanged:Boolean = false;
		
		/**
		 * @copy flash.text.TextField#condenseWhite
		 */		
		public function get condenseWhite():Boolean
		{
			return _condenseWhite;
		}
		
		public function set condenseWhite(value:Boolean):void
		{
			if (value == _condenseWhite)
				return;
			
			_condenseWhite = value;
			condenseWhiteChanged = true;
			
			if (isHTML)
				htmlTextChanged = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			dispatchEvent(new Event("condenseWhiteChanged"));
		}
		
		
		
		
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#enabled
		 */		
		override public function set enabled(value:Boolean):void
		{
			if(super.enabled==value)
				return;
			super.enabled = value;
			if(enabled)
			{
				if(_selectable != pendingSelectable)
					selectableChanged = true;
				if(_textColor != pendingColor)
					defaultStyleChanged = true;
				_selectable = pendingSelectable;
				_textColor = pendingColor;
			}
			else
			{
				if(_selectable)
					selectableChanged = true;
				if(_textColor != disabledColor)
					defaultStyleChanged = true;
				pendingSelectable = _selectable;
				pendingColor = _textColor;
				_selectable = false;
				_textColor = _disabledColor;
			}
			invalidateProperties();
		}
		
		//===========================字体样式=====================start==========================
		
		dx_internal var defaultStyleChanged:Boolean = true;
		
		private var _fontFamily:String = "Times New Roman";
		
		/**
		 * 字体名称 。默认值：Times New Roman
		 */
		public function get fontFamily():String
		{
			return _fontFamily;
		}
		
		public function set fontFamily(value:String):void
		{
			if(_fontFamily==value)
				return;
			_fontFamily = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _size:uint = 12;
		
		/**
		 * 字号大小,默认值12 。
		 */
		public function get size():uint
		{
			return _size;
		}
		
		public function set size(value:uint):void
		{
			if(_size==value)
				return;
			_size = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _bold:Boolean = false;
		
		/**
		 * 是否为粗体,默认false。
		 */
		public function get bold():Boolean
		{
			return _bold;
		}
		
		public function set bold(value:Boolean):void
		{
			if(_bold==value)
				return;
			_bold = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _italic:Boolean = false;
		
		/**
		 * 是否为斜体,默认false。
		 */
		public function get italic():Boolean
		{
			return _italic;
		}
		
		public function set italic(value:Boolean):void
		{
			if(_italic==value)
				return;
			_italic = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _underline:Boolean = false;
		
		/**
		 * 是否有下划线,默认false。
		 */
		public function get underline():Boolean
		{
			return _underline;
		}
		
		public function set underline(value:Boolean):void
		{
			if(_underline==value)
				return;
			_underline = value;
			defaultStyleChanged = true;
			invalidateProperties();
		}
		
		private var _textAlign:String = TextFormatAlign.LEFT;
		
		/**
		 * 文字的水平对齐方式 ,请使用TextFormatAlign中定义的常量。
		 * 默认值：TextFormatAlign.LEFT。
		 */
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void
		{
			if(_textAlign==value)
				return;
			_textAlign = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _leading:int = 0;
		
		/**
		 * 行距,默认值为0。
		 */
		public function get leading():int
		{
			return _leading;
		}
		
		public function set leading(value:int):void
		{
			if(_leading==value)
				return;
			_leading = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 在enabled属性为false时记录的颜色值 
		 */		
		private var pendingColor:uint = 0x000000;
		
		private var _textColor:uint = 0x000000;
		
		/**
		 * 文字颜色,默认值为0x000000。
		 */
		public function get textColor():uint
		{
			if(enabled)
				return _textColor;
			return pendingColor;
		}
		
		public function set textColor(value:uint):void
		{
			if(_textColor==value)
				return;
			if(enabled)
			{
				_textColor = value;
				defaultStyleChanged = true;
				invalidateProperties();
			}
			else
			{
				pendingColor = value;
			}
		}
		
		private var _disabledColor:uint = 0xaab3b3;
		/**
		 * 被禁用时的文字颜色,默认0xaab3b3。
		 */
		public function get disabledColor():uint
		{
			return _disabledColor;
		}
		
		public function set disabledColor(value:uint):void
		{
			if(_disabledColor==value)
				return;
			_disabledColor = value;
			if(!enabled)
			{
				_textColor = value;
				defaultStyleChanged = true;
				invalidateProperties();
			}
		}
		
		
		private var _letterSpacing:Number = NaN;
		
		/**
		 * 字符间距,默认值为NaN。
		 */
		public function get letterSpacing():Number
		{
			return _letterSpacing;
		}
		
		public function set letterSpacing(value:Number):void
		{
			if(_letterSpacing==value)
				return;
			_letterSpacing = value;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		dx_internal var _textFormat:TextFormat;
		
		/**
		 * 应用到所有文字的默认文字格式设置信息对象
		 */
		protected function get defaultTextFormat():TextFormat
		{
			if(defaultStyleChanged)
			{
				_textFormat = getDefaultTextFormat();
				defaultStyleChanged = false;
			}
			return _textFormat;
		}
		/**
		 * 由于设置了默认文本格式后，是延迟一帧才集中应用的，若需要立即应用文本样式，可以手动调用此方法。
		 */		
		public function applyTextFormatNow():void
		{
			if(defaultStyleChanged)
			{
				textField.$setTextFormat(defaultTextFormat);
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		
		/**
		 * 从另外一个文本组件复制默认文字格式信息到自身。<br/>
		 * 复制的值包含：<br/>
		 * fontFamily，size，textColor，bold，italic，underline，textAlign，<br/>
		 * leading，letterSpacing，disabledColor
		 */		
		public function copyDefaultFormatFrom(textBase:TextBase):void
		{
			fontFamily = textBase.fontFamily;
			size = textBase.size;
			textColor = textBase.textColor;
			bold = textBase.bold;
			italic = textBase.italic;
			underline = textBase.underline;
			textAlign = textBase.textAlign;
			leading = textBase.leading;
			letterSpacing = textBase.letterSpacing;
			disabledColor = textBase.disabledColor;
		}
		
		/**
		 * 获取文字的默认格式设置信息对象。
		 */		
		public function getDefaultTextFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat(_fontFamily,_size, _textColor, _bold, _italic, _underline, 
				"", "", _textAlign, 0, 0, 0, _leading);
			if(!isNaN(letterSpacing))
			{
				textFormat.kerning = true;
				textFormat.letterSpacing = letterSpacing;
			}
			else
			{
				textFormat.kerning = false;
				textFormat.letterSpacing = null;
			}
			return textFormat;
		}
		
		//===========================字体样式======================end===========================
		
		
		
		
		private var _htmlText:String = "";
		
		dx_internal var htmlTextChanged:Boolean = false;
		
		dx_internal var explicitHTMLText:String = null; 
		
		/**
		 *　HTML文本
		 */		
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			if (!value)
				value = "";
			
			if (isHTML && value == explicitHTMLText)
				return;
			
			_htmlText = value;
			htmlTextChanged = true;
			_text = null;
			
			explicitHTMLText = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * 当前是否为html文本
		 */		
		dx_internal function get isHTML():Boolean
		{
			return explicitHTMLText != null;
		}
		
		private var pendingSelectable:Boolean = false;
		
		private var _selectable:Boolean = false;
		
		private var selectableChanged:Boolean;
		
		/**
		 * 指定是否可以选择文本。允许选择文本将使您能够从控件中复制文本。 
		 */		
		public function get selectable():Boolean
		{
			if(enabled)
				return _selectable;
			return pendingSelectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			if (value == selectable)
				return;
			if(enabled)
			{
				_selectable = value;
				selectableChanged = true;
				invalidateProperties();
			}
			else
			{
				pendingSelectable = value;
			}
		}
		
		dx_internal var _text:String = "";
		
		dx_internal var textChanged:Boolean = false;
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (value==null)
				value = "";
			
			if (!isHTML && value == _text)
				return;
			
			_text = value;
			textChanged = true;
			_htmlText = null;
			
			explicitHTMLText = null;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		dx_internal var _textHeight:Number;
		
		/**
		 * 文本高度
		 */		
		public function get textHeight():Number
		{
			validateNowIfNeed();
			return _textHeight;
		}
		
		dx_internal var _textWidth:Number;
		
		/**
		 * 文本宽度
		 */		
		public function get textWidth():Number
		{
			validateNowIfNeed();
			return _textWidth;
		}
		
		/**
		 * 由于组件是延迟应用属性的，若需要在改变文本属性后立即获得正确的值，要先调用validateNow()方法。
		 */		
		private function validateNowIfNeed():void
		{
			if(invalidatePropertiesFlag||invalidateSizeFlag||invalidateDisplayListFlag)
				validateNow();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (textField == null)
			{
				createTextField();
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(textField==null)
			{
				createTextField();
				condenseWhiteChanged = true;
				selectableChanged = true;
				textChanged = true;
				defaultStyleChanged = true;
			}
			
			if (condenseWhiteChanged)
			{
				textField.condenseWhite = _condenseWhite;
				
				condenseWhiteChanged = false;
			}
			
			
			if (selectableChanged)
			{
				textField.selectable = _selectable;
				
				selectableChanged = false;
			}
			
			if(defaultStyleChanged)
			{
				textField.$setTextFormat(defaultTextFormat);
				textField.defaultTextFormat = defaultTextFormat;
			}
			
			if (textChanged || htmlTextChanged)
			{
				if (isHTML)
					textField.$htmlText = explicitHTMLText;
				else
					textField.$text = _text;
				
				textFieldChanged(false);
				textChanged = false;
				htmlTextChanged = false;
			}
			
		}
		
		override public function setFocus():void
		{
			if(textField!=null)
			{
				DomGlobals.stage.focus = textField;
			}
		}
		
		
		/**
		 * 创建文本显示对象
		 */		
		protected function createTextField():void
		{   
			if (textField==null)
			{
				textField = new UITextField;
				textField.selectable = selectable;
				textField.antiAliasType = AntiAliasType.ADVANCED; 
				textField.mouseWheelEnabled = false;
				
				textField.addEventListener("textChanged",
					textField_textModifiedHandler);
				textField.addEventListener("widthChanged",
					textField_textFieldSizeChangeHandler);
				textField.addEventListener("heightChanged",
					textField_textFieldSizeChangeHandler);
				textField.addEventListener("textFormatChanged",
					textField_textFormatChangeHandler);
				addChild(textField);
				
			}
		}
		
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = DEFAULT_MEASURED_WIDTH;
			measuredHeight = DEFAULT_MEASURED_HEIGHT;
		}
		
		/**
		 * 更新显示列表
		 */		
		final dx_internal function $updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			textField.x = 0;
			textField.y = 0;
			textField.$width = unscaledWidth;
			textField.$height = unscaledHeight;
			_textWidth = textField.textWidth;
			_textHeight = textField.textHeight;
		}
		
		/**
		 * 返回 TextLineMetrics 对象，其中包含控件中文本位置和文本行度量值的相关信息。
		 * @param lineIndex 要获得其度量值的行的索引（从零开始）。
		 */		
		public function getLineMetrics(lineIndex:int):TextLineMetrics
		{
			validateNowIfNeed();
			return textField ? textField.getLineMetrics(lineIndex) : null;
		}
		
		/**
		 * 文本显示对象属性改变
		 */		
		protected function textFieldChanged(styleChangeOnly:Boolean):void
		{
			if (!styleChangeOnly)
			{
				_text = textField.text;
			}
			
			_htmlText = textField.htmlText;
			
			_textWidth = textField.textWidth;
			_textHeight = textField.textHeight;
		}
		
		/**
		 * 文字内容发生改变
		 */		
		dx_internal function textField_textModifiedHandler(event:Event):void
		{
			textFieldChanged(false);
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * 标签尺寸发生改变
		 */		
		private function textField_textFieldSizeChangeHandler(event:Event):void
		{
			textFieldChanged(true);
			invalidateSize();
			invalidateDisplayList();
		}   
		/**
		 * 文字格式发生改变
		 */		
		private function textField_textFormatChangeHandler(event:Event):void
		{
			textFieldChanged(true);
			invalidateSize();
			invalidateDisplayList();
		}
	}
}