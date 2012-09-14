<<<<<<< HEAD
package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.events.Event;
	
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
				textDisplay.clipAndEnableScrolling = false;
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
			addToDisplyList(textDisplay);
			partAdded("textDisplay",textDisplay);
		}
	}
	
}
=======
package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.events.Event;
	
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
				textDisplay.clipAndEnableScrolling = false;
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
			addToDisplyList(textDisplay);
			partAdded("textDisplay",textDisplay);
		}
	}
	
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
