package org.flexlite.domUI.components
{
	
	import org.flexlite.domUI.components.supportClasses.SkinnableTextBase;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.events.Event;
	
	use namespace dx_internal;
	
	[DefaultProperty("text")]
	
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
		
		override protected function get hostComponentKey():Object
		{
			return TextArea;
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
		 * @copy org.flexlite.domUI.components.Scroller#horizontalScrollPolicy
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
		 * @copy org.flexlite.domUI.components.Scroller#verticalScrollPolicy
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
		
		override public function set text(value:String):void
		{
			super.text = value;
			dispatchEvent(new Event("textChanged"));        
		}

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

		override dx_internal function createTextDisplay():void
		{
			if(textDisplay)
				return;
			textDisplay = new EditableText();
			textDisplay.widthInChars = 15;
			textDisplay.heightInLines = 10;
			addToDisplyList(textDisplay);
			partAdded("textDisplay",textDisplay);
		}
		
	}
	
}
