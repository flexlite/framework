package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * ItemRenderer默认皮肤
	 * @author DOM
	 */
	public class ItemRendererSkin extends VectorSkin
	{
		public function ItemRendererSkin()
		{
			super();
			states = ["up","over","down"];
			this.minHeight = 21;
			this.minWidth = 21;
		}
		
		public var labelDisplay:Label;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextFormatAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 5;
			labelDisplay.right = 5;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			addElement(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			var textColor:uint;
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawRoundRect(
						0, 0, w, h, 0,
						0xFFFFFF, 1,
						verticalGradientMatrix(0, 0, w, h)); 
					textColor = themeColors[0];
					break;
				case "over":
				case "down":
					drawRoundRect(
						0, 0, w, h, 0,
						borderColors[0], 1,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 0, y: 0, w: w, h: h - 1, r: 0});
					drawRoundRect(
						0, 0, w, h - 1, 0,
						0x4f83c4, 1,
						verticalGradientMatrix(0, 0, w, h - 1)); 
					textColor = themeColors[1];
					break;
			}
			if(labelDisplay)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = (currentState=="over"||currentState=="down")?textOverFilter:null;
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}