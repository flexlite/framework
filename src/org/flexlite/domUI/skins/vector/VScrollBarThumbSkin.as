package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 垂直滚动条thumb默认皮肤
	 * @author DOM
	 */
	public class VScrollBarThumbSkin extends VectorSkin
	{
		public function VScrollBarThumbSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
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
					break;
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}