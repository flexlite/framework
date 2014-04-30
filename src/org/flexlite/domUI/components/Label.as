package org.flexlite.domUI.components
{
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.TextBase;
	import org.flexlite.domUI.core.ITranslator;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	use namespace dx_internal;
	
	
	[DXML(show="true")]
	
	/**
	 * 一行或多行不可编辑的文本控件
	 * @author DOM
	 */
	public class Label extends TextBase
	{
		public function Label()
		{
			super();
			addEventListener(UIEvent.UPDATE_COMPLETE, updateCompleteHandler);
			if(isFirstLabel)
			{
				isFirstLabel = false;
				try
				{
					translator = Injector.getInstance(ITranslator);
				}
				catch(e:Error){}
			}
		}
		/**
		 * 是否只显示嵌入的字体。此属性对只所有Label实例有效。true表示如果指定的fontFamily没有被嵌入，
		 * 即使用户机上存在该设备字体也不显示。而将使用默认的字体。默认值为false。
		 */		
		public static var showEmbedFontsOnly:Boolean = false;
		/**
		 * 是否是第一个创建的Label实例
		 */		
		private static var isFirstLabel:Boolean = true;
		/**
		 * 注入的文本翻译对象
		 */		
		private static var translator:ITranslator;
		/**
		 * @inheritDoc
		 */
		override public function set fontFamily(value:String):void
		{
			if(fontFamily==value)
				return;
			var fontList:Array = Font.enumerateFonts(false);
			embedFonts = false;
			for each(var font:Font in fontList)
			{
				if(font.fontName==value)
				{
					embedFonts = true;
					break;
				}
			}
			if(!embedFonts&&showEmbedFontsOnly)
				return;
			super.fontFamily = value;
		}
		
		private var toolTipSet:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function set toolTip(value:Object):void
		{
			super.toolTip = value;
			toolTipSet = (value != null);
		}
		
		/**
		 * 一个验证阶段完成
		 */		
		private function updateCompleteHandler(event:UIEvent):void
		{
			lastUnscaledWidth = NaN;
		}
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		/**
		 * 垂直对齐方式,支持VerticalAlign.TOP,VerticalAlign.BOTTOM,VerticalAlign.MIDDLE和VerticalAlign.JUSTIFY(两端对齐);
		 * 默认值：VerticalAlign.TOP。
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign==value)
				return;
			_verticalAlign = value;
			if(textField)
				textField.leading = realLeading;
			defaultStyleChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		override dx_internal function get realLeading():int
		{
			return _verticalAlign==VerticalAlign.JUSTIFY?0:leading;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultTextFormat():TextFormat
		{
			if(defaultStyleChanged)
			{
				_textFormat = getDefaultTextFormat();
				//当设置了verticalAlign为VerticalAlign.JUSTIFY时将忽略行高
				if(_verticalAlign == VerticalAlign.JUSTIFY)
					_textFormat.leading = 0;
				defaultStyleChanged = false;
			}
			return _textFormat;
		}
		
		/**
		 * 从另外一个文本组件复制默认文字格式信息到自身，不包括对setFormatOfRange()的调用。<br/>
		 * 复制的值包含：<br/>
		 * fontFamily，size，textColor，bold，italic，underline，textAlign，<br/>
		 * leading，letterSpacing，disabledColor,verticalAlign属性。
		 */	
		override public function copyDefaultFormatFrom(textBase:TextBase):void
		{
			super.copyDefaultFormatFrom(textBase);
			if(textBase is Label)
			{
				verticalAlign = (textBase as Label).verticalAlign;
			}
		}
		
		
		private var _maxDisplayedLines:int = 0;
		/**
		 * 最大显示行数,0或负值代表不限制。
		 */
		public function get maxDisplayedLines():int
		{
			return _maxDisplayedLines;
		}
		
		public function set maxDisplayedLines(value:int):void
		{
			if(_maxDisplayedLines==value)
				return;
			_maxDisplayedLines = value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void
		{
			if (value==null)
				value = "";
			if (!isHTML && value == _text)
				return;
			if(translator)
				super.text = translator.translate(value);
			else
				super.text = value;
			rangeFormatDic = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set htmlText(value:String):void
		{
			if (!value)
				value = "";
			
			if (isHTML && value == explicitHTMLText)
				return;
			
			super.htmlText = value;
			
			rangeFormatDic = null;
		}
		/**
		 * 上一次测量的宽度 
		 */		
		private var lastUnscaledWidth:Number = NaN;
		
		private var _padding:Number = 0;
		/**
		 * 四个边缘的共同内边距。若单独设置了任一边缘的内边距，则该边缘的内边距以单独设置的值为准。
		 * 此属性主要用于快速设置多个边缘的相同内边距。默认值：0。
		 */
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(_padding==value)
				return;
			_padding = value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _paddingLeft:Number = NaN;
		/**
		 * 文字距离左边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			invalidateSize();
			invalidateDisplayList();
		}    
		
		private var _paddingRight:Number = NaN;
		/**
		 * 文字距离右边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			invalidateSize();
			invalidateDisplayList();
		}    
		
		private var _paddingTop:Number = NaN;
		/**
		 * 文字距离顶部边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			invalidateSize();
			invalidateDisplayList();
		}    
		
		private var _paddingBottom:Number = NaN;
		/**
		 * 文字距离底部边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			invalidateSize();
			invalidateDisplayList();
		}    
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			var needSetDefaultFormat:Boolean = defaultStyleChanged||textChanged || htmlTextChanged;
			rangeFormatChanged = needSetDefaultFormat||rangeFormatChanged;
			
			super.commitProperties();
			
			if(rangeFormatChanged)
			{
				if(!needSetDefaultFormat)//如果样式发生改变，父级会执行样式刷新的过程。这里就不用重复了。
					textField.$setTextFormat(defaultTextFormat);
				applyRangeFormat();
				rangeFormatChanged = false;
			}
		}

		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			//先提交属性，防止样式发生改变导致的测量不准确问题。
			if(invalidatePropertiesFlag)
				validateProperties();
			if (isSpecialCase())
			{
				if (isNaN(lastUnscaledWidth))
				{
					oldPreferWidth = NaN;
					oldPreferHeight = NaN;
				}
				else
				{
					measureUsingWidth(lastUnscaledWidth);
					return;
				}
			}
			
			var availableWidth:Number;
			
			if (!isNaN(explicitWidth))
				availableWidth = explicitWidth;
			else if (maxWidth!=10000)
				availableWidth = maxWidth;
			
			measureUsingWidth(availableWidth);
		}
		
		/**
		 * 特殊情况，组件尺寸由父级决定，要等到父级UpdateDisplayList的阶段才能测量
		 */		
		private function isSpecialCase():Boolean
		{
			return _maxDisplayedLines!=1&&
				(!isNaN(percentWidth) || (!isNaN(left) && !isNaN(right))) &&
				isNaN(explicitHeight) &&
				isNaN(percentHeight);
		}
		
		/**
		 * 使用指定的宽度进行测量
		 */	
		private function measureUsingWidth(w:Number):void
		{
			var originalText:String = textField.text;
			if(_isTruncated||textChanged||htmlTextChanged)
			{
				if (isHTML)
					textField.$htmlText = explicitHTMLText;
				else
					textField.$text = _text;
				applyRangeFormat();
			}
			
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;

			textField.autoSize = "left";
			
			if (!isNaN(w))
			{
				textField.$width = w - paddingL - paddingR;
				measuredWidth = Math.ceil(textField.textWidth);
				measuredHeight = Math.ceil(textField.textHeight);
			}
			else
			{
				var oldWordWrap:Boolean = textField.wordWrap;
				textField.wordWrap = false;
				
				measuredWidth = Math.ceil(textField.textWidth);
				measuredHeight = Math.ceil(textField.textHeight);
				
				textField.wordWrap = oldWordWrap;
			}
			
			textField.autoSize = "none";
			
			if(_maxDisplayedLines>0&&textField.numLines>_maxDisplayedLines)
			{
				var lineM:TextLineMetrics = textField.getLineMetrics(0);
				measuredHeight = lineM.height*_maxDisplayedLines-lineM.leading+4;
			}
			
			measuredWidth += paddingL + paddingR;
			measuredHeight += paddingT + paddingB;
			
			if(_isTruncated)
			{
				textField.$text = originalText;
				applyRangeFormat();
			}
		}
		
		/**
		 * 记录不同范围的格式信息 
		 */		
		private var rangeFormatDic:Dictionary;
		
		/**
		 * 范围格式信息发送改变标志
		 */		
		private var rangeFormatChanged:Boolean = false;
		
		/**
		 * 将指定的格式应用于指定范围中的每个字符。
		 * 注意：使用此方法应用的格式只能影响到当前的文字内容，若改变文字内容，所有文字将会被重置为默认格式。
		 * @param format 一个包含字符和段落格式设置信息的 TextFormat 对象。
		 * @param beginIndex 可选；一个整数，指定所需文本范围内第一个字符的从零开始的索引位置。
		 * @param endIndex 可选；一个整数，指定所需文本范围后面的第一个字符。
		 * 如果指定 beginIndex 和 endIndex 值，则更新索引从 beginIndex 到 endIndex-1 的文本。
		 */		
		public function setFormatOfRange(format:TextFormat, beginIndex:int=-1, endIndex:int=-1):void
		{
			if(!rangeFormatDic)
				rangeFormatDic = new Dictionary;
			if(!rangeFormatDic[beginIndex])
				rangeFormatDic[beginIndex] = new Dictionary;
			rangeFormatDic[beginIndex][endIndex] = cloneTextFormat(format);
			
			rangeFormatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 克隆一个文本格式对象
		 */		
		private static function cloneTextFormat(tf:TextFormat):TextFormat
		{
			return new TextFormat(tf.font, tf.size, tf.color, tf.bold, tf.italic,
				tf.underline, tf.url, tf.target, tf.align,
				tf.leftMargin, tf.rightMargin, tf.indent, tf.leading);
		}
		
		
		/**
		 * 应用范围格式信息
		 */
		private function applyRangeFormat(expLeading:Object=null):void
		{
			rangeFormatChanged = false;
			if(!rangeFormatDic||!textField||!_text)
				return;
			var useLeading:Boolean = Boolean(expLeading!=null);
			for(var beginIndex:* in rangeFormatDic)
			{
				var endDic:Dictionary = rangeFormatDic[beginIndex] as Dictionary;
				if(endDic)
				{
					for(var index:* in endDic)
					{
						if(!endDic[index])
							continue;
						var oldLeading:Object;
						if(useLeading)
						{
							oldLeading = (endDic[index] as TextFormat).leading;
							(endDic[index] as TextFormat).leading = expLeading;
						}
						var endIndex:int = index;
						if(endIndex>textField.text.length)
							endIndex = textField.text.length;
						try
						{
							textField.$setTextFormat(endDic[index],beginIndex,endIndex);
						}
						catch(e:Error){}
						if(useLeading)
						{
							(endDic[index] as TextFormat).leading = oldLeading;
						}
					}
				}
			}
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			$updateDisplayList(unscaledWidth,unscaledHeight);
			
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			
			textField.x = paddingL;
			textField.y = paddingT;
			if (isSpecialCase())
			{
				var firstTime:Boolean = isNaN(lastUnscaledWidth) ||
					lastUnscaledWidth != unscaledWidth;
				lastUnscaledWidth = unscaledWidth;
				if (firstTime)
				{
					oldPreferWidth = NaN;
					oldPreferHeight = NaN;
					invalidateSize();
					return;
				}
			}
			//防止在父级validateDisplayList()阶段改变的text属性值，
			//接下来直接调用自身的updateDisplayList()而没有经过measu(),使用的测量尺寸是上一次的错误值。
			if(invalidateSizeFlag)
				validateSize();
			
			if(!textField.visible)//解决初始化时文本闪烁问题
				textField.visible = true;
			if(_isTruncated)
			{
				textField.$text = _text;
				applyRangeFormat();
			}
			
			textField.scrollH = 0;
			textField.scrollV = 1;
			
			textField.$width = unscaledWidth - paddingL - paddingR;
			var unscaledTextHeight:Number = unscaledHeight - paddingT - paddingB;
			textField.$height = unscaledTextHeight;
			
			if(_maxDisplayedLines==1)
				textField.wordWrap = false;
			else if (Math.floor(width) < Math.floor(measuredWidth))
				textField.wordWrap = true;
			
			_textWidth = textField.textWidth;
			_textHeight = textField.textHeight;
			
			if(_maxDisplayedLines>0&&textField.numLines>_maxDisplayedLines)
			{
				var lineM:TextLineMetrics = textField.getLineMetrics(0);
				var h:Number = lineM.height*_maxDisplayedLines-lineM.leading+4;
				textField.$height = Math.min(unscaledTextHeight,h);
			}
			if(_verticalAlign==VerticalAlign.JUSTIFY)
			{
				textField.$setTextFormat(defaultTextFormat);
				applyRangeFormat(0);
			}
			
			if(_truncateToFit)
			{
				_isTruncated = truncateTextToFit();
				if (!toolTipSet)
					super.toolTip = _isTruncated ? _text : null;
			}
			if(textField.textHeight>=unscaledTextHeight)
				return;
			if(_verticalAlign==VerticalAlign.JUSTIFY)
			{
				if(textField.numLines > 1)
				{
					textField.$height = unscaledTextHeight;
					var extHeight:Number = Math.max(0,unscaledTextHeight-4 - textField.textHeight);
					defaultTextFormat.leading = Math.floor(extHeight/(textField.numLines-1));
					textField.$setTextFormat(defaultTextFormat);
					applyRangeFormat(defaultTextFormat.leading);
					defaultTextFormat.leading = 0;
				}
			}
			else
			{
				var valign:Number = 0;
				if(_verticalAlign==VerticalAlign.MIDDLE)
					valign = 0.5;
				else if(_verticalAlign==VerticalAlign.BOTTOM)
					valign = 1;
				textField.y += Math.floor((unscaledTextHeight-textField.textHeight)*valign);
				textField.$height = unscaledTextHeight-textField.y;
			}
		}
		
		
		private var _isTruncated:Boolean = false;
		
		/**
		 * 文本是否已经截断并以...结尾的标志。注意：当使用htmlText显示文本时，始终直接截断文本,不显示...。
		 */		
		public function get isTruncated():Boolean
		{
			return _isTruncated;
		}
		
		private var _truncateToFit:Boolean = true;
		/**
		 * 如果此属性为true，并且Label控件大小小于其文本大小，则使用"..."截断 Label控件的文本。
		 * 反之将直接截断文本。注意：当使用htmlText显示文本或设置maxDisplayedLines=1时，始终直接截断文本,不显示...。
		 */
		public function get truncateToFit():Boolean
		{
			return _truncateToFit;
		}
		
		public function set truncateToFit(value:Boolean):void
		{
			if(_truncateToFit==value)
				return;
			_truncateToFit = value;
			invalidateDisplayList();
		}
		
		
		/**
		 * 截断超过边界的字符串，使用"..."结尾
		 */		
		private function truncateTextToFit():Boolean
		{
			if(isHTML)
				return false;
			var truncationIndicator:String = "...";
			var originalText:String = text;
			
			var expLeading:Object = verticalAlign==VerticalAlign.JUSTIFY?0:null;
			
			try
			{
				var lineM:TextLineMetrics = textField.getLineMetrics(0);
				var realTextHeight:Number = textField.height-4+textField.leading;
				var lastLineIndex:int =int(realTextHeight/lineM.height);
			}
			catch(e:Error)
			{
				lastLineIndex = 1;
			}
			if(lastLineIndex<1)
				lastLineIndex = 1;
			if(textField.numLines>lastLineIndex&&textField.textHeight>textField.height)
			{
				var offset:int = textField.getLineOffset(lastLineIndex);
				originalText = originalText.substr(0,offset);
				textField.$text = originalText+truncationIndicator;
				applyRangeFormat(expLeading);
				while (originalText.length > 1 && textField.numLines>lastLineIndex)
				{
					originalText = originalText.slice(0, -1);
					textField.$text = originalText+truncationIndicator;
					applyRangeFormat(expLeading);
				}
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createTextField():void
		{
			super.createTextField();
			textField.wordWrap = true;
			textField.multiline = true;
			textField.visible = false;
			textField.mouseWheelEnabled = false;
		}
		
		/**
		 * 文字内容发生改变
		 */		
		override dx_internal function textField_textModifiedHandler(event:Event):void
		{
			super.textField_textModifiedHandler(event);
			rangeFormatDic = null;
		}
	}
}