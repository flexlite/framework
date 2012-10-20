package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * TextArea默认皮肤
	 * @author DOM
	 */
	public class TextAreaSkin extends VectorSkin
	{
		public function TextAreaSkin()
		{
			super();
			this.states = ["normal","disabled"];
		}
		
		public var scroller:Scroller;
		
		public var textDisplay:EditableText;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			textDisplay = new EditableText();
			textDisplay.widthInChars = 15;
			textDisplay.heightInLines = 10;
			
			scroller = new Scroller();
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 1;
			scroller.measuredSizeIncludesScrollBars = false;
			scroller.viewport = textDisplay;
			addElement(scroller);
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