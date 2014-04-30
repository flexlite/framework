package org.flexlite.domUI.components
{
	
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.flexlite.domUI.core.IToolTip;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.UITextField;
	
	/**
	 * 工具提示组件
	 * @author DOM
	 */	
	public class ToolTip extends UIComponent implements IToolTip
	{
		/**
		 * 组件最大宽度
		 */		
		public static var maxWidth:Number = 300;
		/**
		 * 构造函数
		 */		
		public function ToolTip()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}

		private var _toolTipData:Object;
		/**
		 * toolTipData发生改变标志
		 */		
		private var toolTipDataChanged:Boolean;
		/**
		 * @inheritDoc
		 */
		public function get toolTipData():Object
		{
			return _toolTipData;
		}
		public function set toolTipData(value:Object):void
		{
			_toolTipData = value;
			toolTipDataChanged = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 文本显示对象
		 */		
		private var textField:UITextField;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			drawBackground();
			createTextField(-1);
			this.filters = [new DropShadowFilter(1,45,0,0.7,2,2,1,1)];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (toolTipDataChanged)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textFormat.leftMargin = 0;
				textFormat.rightMargin = 0;
				textField.defaultTextFormat = textFormat;
				
				textField.text = _toolTipData as String;
				toolTipDataChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			
			var widthSlop:Number = 10;
			var heightSlop:Number = 10;
			
			textField.wordWrap = false;
			
			if (textField.textWidth + widthSlop > ToolTip.maxWidth)
			{
				textField.width = ToolTip.maxWidth - widthSlop;
				textField.wordWrap = true;
			}
			
			measuredWidth = textField.width + widthSlop;
			measuredHeight = textField.height + heightSlop;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var widthSlop:Number = 10;
			var heightSlop:Number = 10;
			
			textField.x = 5;
			textField.y = 5;
			textField.width = unscaledWidth - widthSlop;
			textField.height = unscaledHeight - heightSlop;
			drawBackground();
		}
		/**
		 * 创建文字
		 */		
		private function createTextField(childIndex:int):void
		{
			if (!textField)
			{
				textField = new UITextField();
				
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.mouseEnabled = false;
				textField.multiline = true;
				textField.selectable = false;
				textField.wordWrap = false;
				var tf:TextFormat = textField.getTextFormat();
				tf.font = "SimSun";
				tf.color = 0xFFFFFF;
				tf.leading = 2;
				textField.defaultTextFormat = tf;
				
				if (childIndex == -1)
					addChild(textField);
				else 
					addChildAt(textField, childIndex);
			}
		}
		/**
		 * 移除文字
		 */		
		private function removeTextField():void
		{
			if (textField)
			{
				removeChild(textField);
				textField = null;
			}
		}
		/**
		 * 绘制背景
		 */		
		private function drawBackground():void
		{        
			graphics.clear();
			graphics.beginFill(0x000000,0.7);
			var w:Number = isNaN(width)?0:width;
			var h:Number = isNaN(height)?0:height;
			graphics.drawRoundRect(0,0,w,h,5,5);
			graphics.endFill();
		}
	}
	
}
