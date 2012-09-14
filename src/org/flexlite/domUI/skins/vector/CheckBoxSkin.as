<<<<<<< HEAD
package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	
	/**
	 * CheckBox默认皮肤
	 * @author DOM
	 */
	public class CheckBoxSkin extends VectorSkin
	{
		public function CheckBoxSkin()
		{
			super();
			states = ["up","over","down","upAndSelected","overAndSelected","downAndSelected"];
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 18;
			labelDisplay.right = 0;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.verticalCenter = 2;
			addElement(labelDisplay);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var startY:Number = Math.round((h-14)*0.5);
			if(startY<0)
				startY = 0;
			w = 14;
			h = 14;
			var checkColor:uint = 0x2B333C;
			
			var bDrawCheck:Boolean = false;
			
			var upFillColors:Array;
			var upFillAlphas:Array;
			
			var overFillColors:Array;
			var overFillAlphas:Array;
			
			var disFillColors:Array;
			var disFillAlphas:Array;
			
			var g:Graphics = graphics;
			
			g.clear();
			
			switch (currentState)
			{
				case "up":
				{
					upFillColors = [ fillColors[0], fillColors[1] ];
					upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 });
					
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					
					break;
				}
					
				case "over":
				{
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2));
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "down":
				{				
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h)); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						[fillColorPress1,
							fillColorPress2 ], 1,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2));
					
					break;
				}
					
				case "disabled":
				{
					disFillColors = [ fillColors[0], fillColors[1] ];
					disFillAlphas = [ Math.max(0, fillAlphas[0] - 0.15),
						Math.max(0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					break;
				}
				case "upAndSelected":
				{
					bDrawCheck = true;
					
					upFillColors = [ fillColors[0], fillColors[1] ];
					upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2));
					
					break;
				}
				case "overAndSelected":
				{
					bDrawCheck = true;
					
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null,
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "downAndSelected":
				{
					bDrawCheck = true;
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h)); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						[fillColorPress1,
							fillColorPress2 ], 1,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					break;
				}
					
				case "disabledAndSelected":
				{
					bDrawCheck = true;
					checkColor = 0x999999;
					
					disFillColors = [ fillColors[0], fillColors[1] ];
					disFillAlphas = [ Math.max( 0, fillAlphas[0] - 0.15),
						Math.max( 0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					break;
				}
			}
			
			if (bDrawCheck)
			{
				g.beginFill(checkColor);
				g.moveTo(3, startY+5);
				g.lineTo(5, startY+10);
				g.lineTo(7, startY+10);
				g.lineTo(12, startY+2);
				g.lineTo(13, startY+1);
				g.lineTo(11, startY+1);
				g.lineTo(6.5, startY+7);
				g.lineTo(5, startY+5);
				g.lineTo(3, startY+5);
				g.endFill();
			}
		}
	}
=======
package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	
	/**
	 * CheckBox默认皮肤
	 * @author DOM
	 */
	public class CheckBoxSkin extends VectorSkin
	{
		public function CheckBoxSkin()
		{
			super();
			states = ["up","over","down","upAndSelected","overAndSelected","downAndSelected"];
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 18;
			labelDisplay.right = 0;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.verticalCenter = 2;
			addElement(labelDisplay);
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var startY:Number = Math.round((h-14)*0.5);
			if(startY<0)
				startY = 0;
			w = 14;
			h = 14;
			var checkColor:uint = 0x2B333C;
			
			var bDrawCheck:Boolean = false;
			
			var upFillColors:Array;
			var upFillAlphas:Array;
			
			var overFillColors:Array;
			var overFillAlphas:Array;
			
			var disFillColors:Array;
			var disFillAlphas:Array;
			
			var g:Graphics = graphics;
			
			g.clear();
			
			switch (currentState)
			{
				case "up":
				{
					upFillColors = [ fillColors[0], fillColors[1] ];
					upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h ),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 });
					
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					
					break;
				}
					
				case "over":
				{
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2));
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "down":
				{				
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h)); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						[fillColorPress1,
							fillColorPress2 ], 1,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2));
					
					break;
				}
					
				case "disabled":
				{
					disFillColors = [ fillColors[0], fillColors[1] ];
					disFillAlphas = [ Math.max(0, fillAlphas[0] - 0.15),
						Math.max(0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					break;
				}
				case "upAndSelected":
				{
					bDrawCheck = true;
					
					upFillColors = [ fillColors[0], fillColors[1] ];
					upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2));
					
					break;
				}
				case "overAndSelected":
				{
					bDrawCheck = true;
					
					if (fillColors.length > 2)
						overFillColors = [ fillColors[2], fillColors[3] ];
					else
						overFillColors = [ fillColors[0], fillColors[1] ];
					
					if (fillAlphas.length > 2)
						overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
					else
						overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null,
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					
					break;
				}
					
				case "downAndSelected":
				{
					bDrawCheck = true;
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, startY, w, h)); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						[fillColorPress1,
							fillColorPress2 ], 1,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					drawRoundRect(
						1, startY+1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, (h - 2) / 2)); 
					break;
				}
					
				case "disabledAndSelected":
				{
					bDrawCheck = true;
					checkColor = 0x999999;
					
					disFillColors = [ fillColors[0], fillColors[1] ];
					disFillAlphas = [ Math.max( 0, fillAlphas[0] - 0.15),
						Math.max( 0, fillAlphas[1] - 0.15) ];
					
					drawRoundRect(
						0, startY, w, h, 0,
						[ borderColor, borderColorDrk1 ], 0.5,
						verticalGradientMatrix(0, startY, w, h),
						GradientType.LINEAR, null, 
						{ x: 1, y: startY+1, w: w - 2, h: h - 2, r: 0 }); 
					
					drawRoundRect(
						1, startY+1, w - 2, h - 2, 0,
						disFillColors, disFillAlphas,
						verticalGradientMatrix(1, startY+1, w - 2, h - 2)); 
					
					break;
				}
			}
			
			if (bDrawCheck)
			{
				g.beginFill(checkColor);
				g.moveTo(3, startY+5);
				g.lineTo(5, startY+10);
				g.lineTo(7, startY+10);
				g.lineTo(12, startY+2);
				g.lineTo(13, startY+1);
				g.lineTo(11, startY+1);
				g.lineTo(6.5, startY+7);
				g.lineTo(5, startY+5);
				g.lineTo(3, startY+5);
				g.endFill();
			}
		}
	}
>>>>>>> master
}