package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;

	[DefaultProperty("text")]
	
	[DXML(show="true")]
	
	/**
	 * 可设置外观的单行文本输入控件
	 * @author DOM
	 */	
	public class TextInput extends SkinnableTextBase
	{
		/**
		 * 构造函数
		 */		
		public function TextInput()
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return TextInput;
		}
		
		/**
		 * @copy org.flexlite.domUI.components.EditableText#widthInChars 
		 */		
		public function get widthInChars():Number
		{
			return getWidthInChars();
		}
		
		public function set widthInChars(value:Number):void
		{
			setWidthInChars(value);
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			dispatchEvent(new Event("textChanged"));
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == textDisplay)
			{
				textDisplay.multiline = false;
				if(textDisplay is IViewport)
					(textDisplay as IViewport).clipAndEnableScrolling = false;
			}
		}
		
		override dx_internal function createTextDisplay():void
		{
			if(textDisplay)
				return;
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.top = 1;
			textDisplay.bottom = 1;
			addToDisplyList(DisplayObject(textDisplay));
			partAdded("textDisplay",textDisplay);
		}
	}
	
}
