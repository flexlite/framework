<<<<<<< HEAD
package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 按钮默认皮肤
	 * @author DOM
	 */
	public class ButtonSkin extends VectorSkin
	{
		public function ButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.minHeight = 21;
			this.minWidth = 21;
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 5;
			labelDisplay.right = 5;
			labelDisplay.top = 5;
			labelDisplay.bottom = 5;
			addElement(labelDisplay);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var cornerRadius:Number = 4;
			var cr:Number = 4;
			var cr1:Number = 3;
			var cr2:Number = 2;
			
			graphics.clear();
			
			switch (currentState)
			{			
				case "up":
				{
					var upFillColors:Array = [ fillColors[0], fillColors[1] ];
					
					var upFillAlphas:Array = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, 1, w - 2, (h - 2) / 2,
						{ tl: cr1, tr: cr1, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					break;
				}
					
				case "over":
				{
					var overFillColors:Array;
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					var overFillAlphas:Array;
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, 1, w - 2, (h - 2) / 2,
						{ tl: cr1, tr: cr1, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "down":
				{
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h )); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						[fillColorPress1, fillColorPress2], 1,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					// top highlight
					drawRoundRect(
						2, 2, w - 4, (h - 4) / 2,
						{ tl: cr2, tr: cr2, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "disabled":
				{
					var disFillColors:Array = [ fillColors[0], fillColors[1] ];
					
					var disFillAlphas:Array =
						[ Math.max( 0, fillAlphas[0] - 0.15),
							Math.max( 0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 });
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					break;
				}
			}
		}
	}
=======
package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 按钮默认皮肤
	 * @author DOM
	 */
	public class ButtonSkin extends VectorSkin
	{
		public function ButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.minHeight = 21;
			this.minWidth = 21;
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 5;
			labelDisplay.right = 5;
			labelDisplay.top = 5;
			labelDisplay.bottom = 5;
			addElement(labelDisplay);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var cornerRadius:Number = 4;
			var cr:Number = 4;
			var cr1:Number = 3;
			var cr2:Number = 2;
			
			graphics.clear();
			
			switch (currentState)
			{			
				case "up":
				{
					var upFillColors:Array = [ fillColors[0], fillColors[1] ];
					
					var upFillAlphas:Array = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, 1, w - 2, (h - 2) / 2,
						{ tl: cr1, tr: cr1, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					break;
				}
					
				case "over":
				{
					var overFillColors:Array;
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					var overFillAlphas:Array;
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 }); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, 1, w - 2, (h - 2) / 2,
						{ tl: cr1, tr: cr1, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "down":
				{
					drawRoundRect(
						0, 0, w, h, cr,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w, h )); 
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						[fillColorPress1, fillColorPress2], 1,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					// top highlight
					drawRoundRect(
						2, 2, w - 4, (h - 4) / 2,
						{ tl: cr2, tr: cr2, bl: 0, br: 0 },
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "disabled":
				{
					var disFillColors:Array = [ fillColors[0], fillColors[1] ];
					
					var disFillAlphas:Array =
						[ Math.max( 0, fillAlphas[0] - 0.15),
							Math.max( 0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, 0, w, h, cr,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, 0, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius - 1 });
					
					drawRoundRect(
						1, 1, w - 2, h - 2, cr1,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2)); 
					
					break;
				}
			}
		}
	}
>>>>>>> master
}