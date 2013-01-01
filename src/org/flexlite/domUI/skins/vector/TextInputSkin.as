package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * TextInput默认皮肤
	 * @author DOM
	 */
	public class TextInputSkin extends VectorSkin
	{
		public function TextInputSkin()
		{
			super();
			this.states = ["normal","disabled"];
		}
		
		public var textDisplay:EditableText;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.heightInLines = 1;
			textDisplay.multiline = false;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.verticalCenter = 1;
			addElement(textDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			//绘制边框
			drawRoundRect(
				0, 0, w, h, 0,
				borderColors[0], 1,
				verticalGradientMatrix(0, 0, w, h ),
				GradientType.LINEAR, null, 
				{ x: 1, y: 2, w: w - 2, h: h - 3, r: 0}); 
			//绘制填充
			drawRoundRect(
				1, 2, w - 2, h - 3, 0,
				0xFFFFFF, 1,
				verticalGradientMatrix(1, 2, w - 2, h - 3)); 
			//绘制底线
			drawLine(1,0,w,0,bottomLineColors[0]);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}