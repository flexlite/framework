package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 滚动条向上滚动按钮默认皮肤
	 * @author DOM
	 */
	public class ScrollBarUpButtonSkin extends VectorSkin
	{
		public function ScrollBarUpButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 17;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			var arrowColor:uint;
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawRoundRect(
						0, 0, w, h, 0,
						borderColors[0], 1,
						horizontalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0}); 
					drawRoundRect(
						1, 1, w - 2, h - 2, 0,
						[fillColors[0],fillColors[1]], 1,
						horizontalGradientMatrix(1, 1, w - 2, h - 2),GradientType.LINEAR); 
					drawLine(w-1,0,w-1,h,bottomLineColors[0]);
					arrowColor = themeColors[0];
					break;
				case "over":
					drawRoundRect(
						0, 0, w, h, 0,
						borderColors[1], 1,
						horizontalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0}); 
					drawRoundRect(
						1, 1, w - 2, h - 2, 0,
						[fillColors[2],fillColors[3]], 1,
						horizontalGradientMatrix(1, 1, w - 2, h - 2),GradientType.LINEAR); 
					drawLine(w-1,0,w-1,h,bottomLineColors[1]);
					arrowColor = themeColors[1];
					break;
				case "down":
					drawRoundRect(
						0, 0, w, h, 0,
						borderColors[2], 1,
						horizontalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0}); 
					drawRoundRect(
						1, 1, w - 2, h - 2, 0,
						[fillColors[4],fillColors[5]], 1,
						horizontalGradientMatrix(1, 1, w - 2, h - 2),GradientType.LINEAR); 
					drawLine(w-1,0,w-1,h,bottomLineColors[2]);
					arrowColor = themeColors[1];
					break;
			}
			this.alpha = currentState=="disabled"?0.5:1;
			g.lineStyle(0,0,0);
			g.beginFill(arrowColor);
			g.moveTo(w*0.5, h*0.5 - 3);
			g.lineTo(w*0.5-3.5, h*0.5 + 2);
			g.lineTo(w*0.5+3.5, h*0.5 + 2);
			g.lineTo(w*0.5, h*0.5 -3);
			g.endFill();
		}
	}
}