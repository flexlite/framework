package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * TabBarButton默认皮肤
	 * @author DOM
	 */
	public class TabBarButtonSkin extends VectorSkin
	{
		public function TabBarButtonSkin()
		{
			super();
			states = ["up","over","down","disabled","upAndSelected","overAndSelected"
				,"downAndSelected","disabledAndSelected"];
			this.currentState = "up";
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
			
			graphics.clear();
			var textColor:uint;
			var radius:Object = {tl:cornerRadius,tr:cornerRadius,bl:0,br:0};
			var crr1:Object = {tl:cornerRadius-1,tr:cornerRadius-1,bl:0,br:0};
			switch (currentState)
			{
				case "up":
				case "disabled":
					drawCurrentState(0,0,w,h,borderColors[0],bottomLineColors[0],
						[fillColors[0],fillColors[1]],radius);
					textColor = themeColors[0];
					break;
				case "over":
					drawCurrentState(0,0,w,h,borderColors[0],bottomLineColors[0],
						[fillColors[2],fillColors[3]],radius);
					textColor = themeColors[1];
					break;
				case "down":
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					drawRoundRect(
						x, y, w, h, radius,
						borderColors[0], 1,
						verticalGradientMatrix(x, y, w, h ),
						GradientType.LINEAR, null, 
						{ x: x+1, y: y+1, w: w - 2, h: h - 1, r: crr1}); 
					drawRoundRect(
						x+1, y+1, w - 2, h - 1, crr1,
						0xFFFFFF, 1,
						verticalGradientMatrix(x+1, y+1, w - 2, h - 1)); 
					textColor = themeColors[0];
					break;
			}
			if(labelDisplay)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = currentState=="over"?textOverFilter:null;
			}
			this.alpha = currentState=="disabled"||currentState=="disabledAndSelected"?0.5:1;
		}
	}
}