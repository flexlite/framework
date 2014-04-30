package org.flexlite.domUI.core
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	/**
	 * 框架中所有文本的显示对象使用的文本基类，隔离TextField,
	 * 对常用属性的改变进行事件封装,以通知父级组件重新验证尺寸和布局。
	 * @author DOM
	 */	
	public class UITextField extends TextField
	{
		public function UITextField()
		{
			super();
			if(isFirstTextFiled)
			{
				isFirstTextFiled = false;
				try
				{
					translator = Injector.getInstance(ITranslator);
				}
				catch(e:Error){}
			}
		}
		/**
		 * 是否是第一个创建的Label实例
		 */		
		private static var isFirstTextFiled:Boolean = true;
		/**
		 * 注入的文本翻译对象
		 */		
		private static var translator:ITranslator;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void  
		{
			var changed:Boolean = super.width != value;
			super.width = value;
			if(changed)
				dispatchEvent(new Event("widthChanged"));
		}
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return super.height-leading;
		}
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			var changed:Boolean = height != value;
			super.height = value+leading;
			if(changed)
				dispatchEvent(new Event("heightChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setTextFormat(format:TextFormat,beginIndex:int = -1,endIndex:int = -1):void
		{
			super.setTextFormat(format, beginIndex, endIndex);
			dispatchEvent(new Event("textFormatChanged"));
		}  
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void
		{
			if (!value)
				value = "";
			var changed:Boolean = super.text != value;
			
			if(translator)
				super.text = translator.translate(value);
			else
				super.text = value;
			
			if(changed)
				dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set htmlText(value:String):void
		{
			if (!value)
				value = "";
			var changed:Boolean = super.htmlText != value;
			
			super.htmlText = value;
			
			if(changed)
				dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function insertXMLText(beginIndex:int, endIndex:int,richText:String,pasting:Boolean = false):void
		{
			super.insertXMLText(beginIndex, endIndex, richText, pasting);
			
			dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function appendText(newText:String):void
		{
			super.appendText(newText);
			dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function replaceSelectedText(value:String):void
		{
			super.replaceSelectedText(value);
			dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function replaceText(beginIndex:int, endIndex:int,newText:String):void
		{
			super.replaceText(beginIndex, endIndex, newText);
			dispatchEvent(new Event("textChanged"));
		}
		
		//用于返回正确的文本高度，去除最后一行的行间距。
		dx_internal var leading:int = 0;
		/**
		 * Flash Player在计算TextField.textHeight时，
		 * 没有包含空白的4像素,为了方便使用，在这里做了统一处理,
		 * 此属性返回的值可以直接赋值给heihgt，不会造成截断
		 */	
		override public function get textHeight():Number
		{
			return super.textHeight+4-leading;
		}
		/**
		 * Flash Player在计算TextField.textWidth时，
		 * 没有包含空白的5像素,为了方便使用，在这里做了统一处理,
		 * 此属性返回的值可以直接赋值给width，不会造成截断
		 */
		override public function get textWidth():Number
		{
			return super.textWidth+5;
		}
		
		/**
		 * @copy flash.text.TextField#width
		 */			
		dx_internal final function set $width(value:Number):void
		{
			if(super.width==value)
				return;
			super.width = value;
		}
		
		/**
		 * @copy flash.text.TextField#height
		 */			
		dx_internal final function set $height(value:Number):void
		{
			if(height == value)
				return;
			super.height = value+leading;
		}
		
		/**
		 * @copy flash.text.TextField#htmlText
		 */			
		dx_internal final function set $htmlText(value:String):void
		{
			if (!value)
				value = "";
			super.htmlText = value;
		}
		
		/**
		 * @copy flash.text.TextField#text
		 */			
		dx_internal final function set $text(value:String):void
		{
			if (value==null)
				value = "";
			super.text = value;
		}
		
		
		/**
		 * @copy flash.text.TextField#setTextFormat()
		 */
		dx_internal final function $setTextFormat(format:TextFormat,beginIndex:int = -1,endIndex:int = -1):void
		{
			super.setTextFormat(format, beginIndex, endIndex);
		}  
		/**
		 * @copy flash.text.TextField#insertXMLText()
		 */
		dx_internal final function $insertXMLText(beginIndex:int, endIndex:int,richText:String,pasting:Boolean = false):void
		{
			super.insertXMLText(beginIndex, endIndex, richText, pasting);
		}
		/**
		 * @copy flash.text.TextField#replaceText()
		 */
		dx_internal function $replaceText(beginIndex:int, endIndex:int,newText:String):void
		{
			super.replaceText(beginIndex, endIndex, newText);
		}
		/**
		 * @copy flash.text.TextField#appendText()
		 */
		dx_internal function $appendText(newText:String):void
		{
			super.replaceText(text.length, text.length, newText);
		}
		/**
		 * @copy flash.text.TextField#replaceSelectedText()
		 */
		dx_internal function $replaceSelectedText(value:String):void
		{
			super.replaceSelectedText(value);
		}
	}
}