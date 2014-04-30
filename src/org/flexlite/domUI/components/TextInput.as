package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;

	[DefaultProperty(name="text",array="false")]
	
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
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TextInput;
		}
		
		/**
		 * 控件的默认宽度（使用字号：size为单位测量）。 若同时设置了maxChars属性，将会根据两者测量结果的最小值作为测量宽度。
		 */		
		public function get widthInChars():Number
		{
			return getWidthInChars();
		}
		
		public function set widthInChars(value:Number):void
		{
			setWidthInChars(value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void
		{
			super.text = value;
			dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
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
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.top = 1;
			textDisplay.bottom = 1;
			addToDisplayList(DisplayObject(textDisplay));
			partAdded("textDisplay",textDisplay);
		}
	}
	
}
