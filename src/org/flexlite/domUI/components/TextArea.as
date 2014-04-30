package org.flexlite.domUI.components
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	[DefaultProperty(name="text",array="false")]
	
	[DXML(show="true")]
	
	/**
	 * 可设置外观的多行文本输入控件
	 * @author DOM
	 */	
	public class TextArea extends SkinnableTextBase
	{
		/**
		 * 构造函数
		 */		
		public function TextArea()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TextArea;
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
		 * 控件的默认高度（以行为单位测量）。 
		 */
		public function get heightInLines():Number
		{
			return getHeightInLines();
		}
		
		/**
		 *  @private
		 */
		public function set heightInLines(value:Number):void
		{
			setHeightInLines(value);
		}
		
		/**
		 * 水平滚动条策略改变标志
		 */		
		private var horizontalScrollPolicyChanged:Boolean = false;
		
		private var _horizontalScrollPolicy:String;

		/**
		 * 水平滚动条显示策略，参见ScrollPolicy类定义的常量。
		 */		
		public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}

		public function set horizontalScrollPolicy(value:String):void
		{
			if(_horizontalScrollPolicy==value)
				return;
			_horizontalScrollPolicy = value;
			horizontalScrollPolicyChanged = true;
			invalidateProperties();
		}

		/**
		 * 垂直滚动条策略改变标志 
		 */		
		private var verticalScrollPolicyChanged:Boolean = false;
		
		private var _verticalScrollPolicy:String;
		/**
		 * 垂直滚动条显示策略，参见ScrollPolicy类定义的常量。
		 */
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}

		public function set verticalScrollPolicy(value:String):void
		{
			if(_verticalScrollPolicy==value)
				return;
			_verticalScrollPolicy = value;
			verticalScrollPolicyChanged = true;
			invalidateProperties();
		}

		
		/**
		 * [SkinPart]实体滚动条组件
		 */
		public var scroller:Scroller;
		
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
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (horizontalScrollPolicyChanged)
			{
				if (scroller)
					scroller.horizontalScrollPolicy = horizontalScrollPolicy;
				horizontalScrollPolicyChanged = false;
			}
			
			if (verticalScrollPolicyChanged)
			{
				if (scroller)
					scroller.verticalScrollPolicy = verticalScrollPolicy;
				verticalScrollPolicyChanged = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == textDisplay)
			{
				textDisplay.multiline = true;
			}
			else if (instance == scroller)
			{
				if (scroller.horizontalScrollBar)
					scroller.horizontalScrollBar.snapInterval = 0;
				if (scroller.verticalScrollBar)
					scroller.verticalScrollBar.snapInterval = 0;
			}
		}

		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			textDisplay = new EditableText();
			textDisplay.widthInChars = 15;
			textDisplay.heightInLines = 10;
			addToDisplayList(DisplayObject(textDisplay));
			partAdded("textDisplay",textDisplay);
		}
		
	}
	
}
