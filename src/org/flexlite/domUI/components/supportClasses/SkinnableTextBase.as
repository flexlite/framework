package org.flexlite.domUI.components.supportClasses
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.IEditableText;
	import org.flexlite.domUI.core.ISkinPartHost;
	import org.flexlite.domUI.core.dx_internal;
	
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
	
	[DXML(show="false")]
	
	/**
	 * 可设置外观的文本输入控件基类
	 * @author DOM
	 */	
	public class SkinnableTextBase extends SkinnableComponent
	{
		public function SkinnableTextBase()
		{
			super();
		}
		
		/**
		 * [SkinPart]实体文本输入组件
		 */		
		public var textDisplay:IEditableText;
		/**
		 * textDisplay改变时传递的参数
		 */		
		private var textDisplayProperties:Object = {};
		
		override public function get maxWidth():Number
		{
			if(textDisplay!=null)
				return textDisplay.maxWidth;
			var v:* = textDisplayProperties.maxWidth;
			return (v === undefined) ? super.maxWidth : v;        
		}
			
		override public function set maxWidth(value:Number):void
		{
			if(textDisplay!=null)
			{
				textDisplay.maxWidth = value;
				textDisplayProperties.maxWidth = true;
			}
			else
			{
				textDisplayProperties.maxWidth = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy flash.text.TextField#displayAsPassword
		 */	
		public function get displayAsPassword():Boolean
		{
			if(textDisplay!=null)
				return textDisplay.displayAsPassword;
			var v:* = textDisplayProperties.displayAsPassword
			return (v === undefined) ? false : v;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			if(textDisplay!=null)
			{
				textDisplay.displayAsPassword = value;
				textDisplayProperties.displayAsPassword = true;
			}
			else
			{
				textDisplayProperties.displayAsPassword = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy org.flexlite.domUI.core.IEditableText#editable
		 */		
		public function get editable():Boolean
		{
			if(textDisplay!=null)
				return textDisplay.editable;
			var v:* = textDisplayProperties.editable;
			return (v === undefined) ? true : v;
		}
		
		public function set editable(value:Boolean):void
		{
			if(textDisplay!=null)
			{
				textDisplay.editable = value;
				textDisplayProperties.editable = true;
			}
			else
			{
				textDisplayProperties.editable = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy flash.text.TextField#maxChars
		 */	
		public function get maxChars():int 
		{
			if(textDisplay!=null)
				return textDisplay.maxChars;
			var v:* = textDisplayProperties.maxChars;
			return (v === undefined) ? 0 : v;
		}
		
		public function set maxChars(value:int):void
		{
			if(textDisplay!=null)
			{
				textDisplay.maxChars = value;
				textDisplayProperties.maxChars = true;
			}
			else
			{
				textDisplayProperties.maxChars = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy flash.text.TextField#restrict
		 */
		public function get restrict():String 
		{
			if(textDisplay!=null)
				return textDisplay.restrict;
			var v:* = textDisplayProperties.restrict;
			return (v === undefined) ? null : v;
		}
		
		public function set restrict(value:String):void
		{
			if(textDisplay!=null)
			{
				textDisplay.restrict = value;
				textDisplayProperties.restrict = true;
			}
			else
			{
				textDisplayProperties.restrict = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy flash.text.TextField#selectable
		 */
		public function get selectable():Boolean
		{
			if(textDisplay!=null)
				return textDisplay.selectable;
			var v:* = textDisplayProperties.selectable;
			return (v === undefined) ? true : v;
		}
		
		public function set selectable(value:Boolean):void
		{
			if(textDisplay!=null)
			{
				textDisplay.selectable = value;
				textDisplayProperties.selectable = true;
			}
			else
			{
				textDisplayProperties.selectable = value;
			}
			invalidateProperties();                    
		}
		
		/**
		 * @copy flash.text.TextField#selectionBeginIndex
		 */
		public function get selectionBeginIndex():int
		{
			if(textDisplay!=null)
				return textDisplay.selectionBeginIndex;
			if(textDisplayProperties.selectionBeginIndex===undefined)
				return -1;
			return textDisplayProperties.selectionBeginIndex;
		}
		
		/**
		 * @copy flash.text.TextField#selectionEndIndex
		 */
		public function get selectionEndIndex():int
		{
			if(textDisplay!=null)
				return textDisplay.selectionEndIndex;
			if(textDisplayProperties.selectionEndIndex===undefined)
				return -1;
			return textDisplayProperties.selectionEndIndex;
		}
		
		/**
		 * @copy flash.text.TextField#caretIndex
		 */
		public function get caretIndex():int
		{
			return textDisplay!=null?textDisplay.caretIndex:0;
		}
		
		/**
		 * @copy flash.text.TextField#setSelection()
		 */
		public function setSelection(beginIndex:int,endIndex:int):void
		{
			if(textDisplay!=null)
			{
				textDisplay.setSelection(beginIndex,endIndex);
			}
			else
			{
				textDisplayProperties.selectionBeginIndex = beginIndex;
				textDisplayProperties.selectionEndIndex = endIndex;
			}
		}
		
		/**
		 * @copy org.flexlite.domUI.core.IEditableText#selectAll()
		 */
		public function selectAll():void
		{
			if(textDisplay!=null)
			{
				textDisplay.selectAll();
			}
			else if(textDisplayProperties.text!==undefined)
			{
				setSelection(0,textDisplayProperties.text.length-1);
			}
		}
		
		/**
		 * @copy org.flexlite.domUI.core.IDisplayText#text
		 */		
		public function get text():String
		{
			if(textDisplay!=null)
				return textDisplay.text;
			var v:* = textDisplayProperties.text;
			return (v === undefined) ? "" : v;
		}
		
		public function set text(value:String):void
		{
			if(textDisplay!=null)
			{
				textDisplay.text = value;
				textDisplayProperties.text = true;
			}
			else
			{
				textDisplayProperties.text = value;
				textDisplayProperties.selectionBeginIndex = 0;
				textDisplayProperties.selectionEndIndex = 0;
			}
			invalidateProperties();                    
		}
		
		dx_internal function getWidthInChars():Number
		{
			var richEditableText:EditableText = textDisplay as EditableText;
			
			if (richEditableText)
				return richEditableText.widthInChars
			
			var v:* = textDisplay ? undefined : textDisplayProperties.widthInChars;
			return (v === undefined) ? NaN : v;
		}
		
		dx_internal function setWidthInChars(value:Number):void
		{
			if (textDisplay)
			{
				var richEditableText:EditableText = textDisplay as EditableText;
				
				if (richEditableText)
					richEditableText.widthInChars = value;
				textDisplayProperties.widthInChars = true;
			}
			else
			{
				textDisplayProperties.widthInChars = value;
			}
			
			invalidateProperties();                    
		}
		
		dx_internal function getHeightInLines():Number
		{
			var richEditableText:EditableText = textDisplay as EditableText;
			
			if (richEditableText)
				return richEditableText.heightInLines;
			
			var v:* = textDisplay ? undefined : textDisplayProperties.heightInLines;        
			return (v === undefined) ? NaN : v;
		}
		
		dx_internal function setHeightInLines(value:Number):void
		{
			if (textDisplay)
			{
				var richEditableText:EditableText = textDisplay as EditableText;
				
				if (richEditableText)
					richEditableText.heightInLines = value;
				textDisplayProperties.heightInLines = true;
			}
			else
			{
				textDisplayProperties.heightInLines = value;
			}
			
			invalidateProperties();                    
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == textDisplay)
			{
				textDisplayAdded();            
				
				textDisplay.addEventListener(TextEvent.TEXT_INPUT,
					textDisplay_changingHandler);
				
				textDisplay.addEventListener(Event.CHANGE,
					textDisplay_changeHandler);
			}
		}
		
		override protected function partRemoved(partName:String, 
												instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == textDisplay)
			{
				textDisplayRemoved();      
				
				textDisplay.removeEventListener(TextEvent.TEXT_INPUT,
					textDisplay_changingHandler);
				
				textDisplay.removeEventListener(Event.CHANGE,
					textDisplay_changeHandler);
			}
		}
		
		override public function setFocus():void
		{
			if(textDisplay!=null)
				textDisplay.setFocus();
		}
		
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			if(!(skin is ISkinPartHost))
			{
				createTextDisplay();
			}
		}
		/**
		 * 当皮肤不为ISkinPartHost时，创建TextDisplay显示对象
		 */		
		dx_internal function createTextDisplay():void
		{
		}
		
		override protected function detachSkin(skin:Object):void
		{
			if(!(skin is ISkinPartHost)&&textDisplay)
			{
				partRemoved("textDisplay",textDisplay);
				removeFromDisplayList(DisplayObject(textDisplay));
				textDisplay = null;
			}
			super.detachSkin(skin);
		}
		
		/**
		 * textDisplay附加
		 */		
		private function textDisplayAdded():void
		{        
			var newTextDisplayProperties:Object = {};
			var richEditableText:EditableText = textDisplay as EditableText;
			
			if(textDisplayProperties.displayAsPassword !== undefined)
			{
				textDisplay.displayAsPassword = textDisplayProperties.displayAsPassword;
				newTextDisplayProperties.displayAsPassword = true;
			}
			
			if(textDisplayProperties.editable !== undefined)
			{
				textDisplay.editable = textDisplayProperties.editable;
				newTextDisplayProperties.editable = true;
			}
			
			if(textDisplayProperties.maxChars !== undefined)
			{
				textDisplay.maxChars = textDisplayProperties.maxChars;
				newTextDisplayProperties.maxChars = true;
			}
			
			if(textDisplayProperties.maxHeight !== undefined)
			{
				textDisplay.maxHeight = textDisplayProperties.maxHeight;
				newTextDisplayProperties.maxHeight = true;
			}
			
			if(textDisplayProperties.maxWidth !== undefined)
			{
				textDisplay.maxWidth = textDisplayProperties.maxWidth;
				newTextDisplayProperties.maxWidth = true;
			}
			
			if(textDisplayProperties.restrict !== undefined)
			{
				textDisplay.restrict = textDisplayProperties.restrict;
				newTextDisplayProperties.restrict = true;
			}
			
			if(textDisplayProperties.selectable !== undefined)
			{
				textDisplay.selectable = textDisplayProperties.selectable;
				newTextDisplayProperties.selectable = true;
			}
			
			if(textDisplayProperties.text !== undefined)
			{
				textDisplay.text = textDisplayProperties.text;
				newTextDisplayProperties.text = true;
			}
			
			if(textDisplayProperties.selectionBeginIndex !== undefined)
			{
				textDisplay.setSelection(textDisplayProperties.selectionBeginIndex,
					textDisplayProperties.selectionEndIndex);
			}
			if (textDisplayProperties.widthInChars !== undefined && richEditableText)
			{
				richEditableText.widthInChars = textDisplayProperties.widthInChars;
				newTextDisplayProperties.widthInChars = true;
			}
			if (textDisplayProperties.heightInLines !== undefined && richEditableText)
			{
				richEditableText.heightInLines = textDisplayProperties.heightInLines;
				newTextDisplayProperties.heightInLines = true;
			}
			
			textDisplayProperties = newTextDisplayProperties;    
		}
		/**
		 * textDisplay移除
		 */		
		private function textDisplayRemoved():void
		{        
			var newTextDisplayProperties:Object = {};
			var richEditableText:EditableText = textDisplay as EditableText;
			
			if(textDisplayProperties.displayAsPassword)
			{
				newTextDisplayProperties.displayAsPassword = textDisplay.displayAsPassword;
			}
			
			if(textDisplayProperties.editable)
			{
				newTextDisplayProperties.editable = textDisplay.editable;
			}
			
			if(textDisplayProperties.maxChars)
			{
				newTextDisplayProperties.maxChars = textDisplay.maxChars;
			}
			
			if(textDisplayProperties.maxHeight)
			{
				newTextDisplayProperties.maxHeight = textDisplay.maxHeight;
			}
			
			if(textDisplayProperties.maxWidth)
			{
				newTextDisplayProperties.maxWidth = textDisplay.maxWidth;
			}
			
			if(textDisplayProperties.restrict)
			{
				newTextDisplayProperties.restrict = textDisplay.restrict;
			}
			
			if(textDisplayProperties.selectable)
			{
				newTextDisplayProperties.selectable = textDisplay.selectable;
			}
			
			if(textDisplayProperties.text)
			{
				newTextDisplayProperties.text = textDisplay.text;
			}
			
			if (textDisplayProperties.heightInLines&& richEditableText)
			{
				newTextDisplayProperties.heightInLines = richEditableText.heightInLines;
			}
			
			if (textDisplayProperties.widthInChars && richEditableText)
			{
				newTextDisplayProperties.widthInChars = richEditableText.widthInChars;
			}
			
			textDisplayProperties = newTextDisplayProperties;
		}
		/**
		 * textDisplay文字改变事件
		 */
		private function textDisplay_changeHandler(event:Event):void
		{        
			invalidateDisplayList();
			dispatchEvent(event);
		}
		/**
		 * textDisplay文字即将改变事件
		 */		
		private function textDisplay_changingHandler(event:TextEvent):void
		{
			
			var newEvent:Event = event.clone();
			dispatchEvent(newEvent);
			if(newEvent.isDefaultPrevented())
				event.preventDefault();
		}
	}
	
}
