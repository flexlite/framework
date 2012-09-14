package org.flexlite.domUI.skins
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	/**
	 * Vector主题皮肤基类
	 * @author DOM
	 */
	public class VectorSkin extends Skin
	{
		public function VectorSkin()
		{
			super();
		}
		
		override protected function commitCurrentState():void
		{
			invalidateDisplayList();
		}
		
		private static var tempMatrix:Matrix = new Matrix();
		
		/**
		 * 创建垂直渐变矩阵。
		 * @param x 渐变的左边缘。
		 * @param y 渐变的上边缘。
		 * @param width 渐变的宽度。
		 * @param height 渐变的高度。
		 */		
		protected function verticalGradientMatrix(x:Number, y:Number,
												  width:Number,
												  height:Number):Matrix
		{
			tempMatrix.createGradientBox(width,height,
				0.5 * Math.PI,x,y);
			return tempMatrix;
		}
		
		/**
		 * 将RGB颜色的按比例调整亮度
		 */		
		protected static function adjustBrightness(rgb:uint, brite:Number):uint
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			if (brite == 0)
				return rgb;
			
			if (brite < 0)
			{
				brite = (100 + brite) / 100;
				r = ((rgb >> 16) & 0xFF) * brite;
				g = ((rgb >> 8) & 0xFF) * brite;
				b = (rgb & 0xFF) * brite;
			}
			else
			{
				brite /= 100;
				r = ((rgb >> 16) & 0xFF);
				g = ((rgb >> 8) & 0xFF);
				b = (rgb & 0xFF);
				
				r += ((0xFF - r) * brite);
				g += ((0xFF - g) * brite);
				b += ((0xFF - b) * brite);
				
				r = Math.min(r, 255);
				g = Math.min(g, 255);
				b = Math.min(b, 255);
			}
			
			return (r << 16) | (g << 8) | b;
		}
		
		protected var borderColor:uint = 0xB7BABC;
		protected var fillAlphas:Array = [0.6,0.4,0.75,0.65];
		protected var fillColors:Array = [0xFFFFFF,0xCCCCCC,0xFFFFFF,0xEEEEEE];
		protected var highlightAlphas:Array = [0.3,0,2];				
		protected var themeColor:uint = 0x009DFF;
		protected var fillColorPress1:uint = 0xD8F0FF;
		protected var fillColorPress2:uint = 0x99D7FF;
		protected var borderColorDrk1:uint = 0x5B5D5E;
		protected var themeColorDrk1:uint = 0x0075BF;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			fillColorPress1 = adjustBrightness(themeColor, 85);
			fillColorPress2 = adjustBrightness(themeColor, 60);
		}
		
		/**
		 * 绘制一个圆角矩形
		 * @param x 此外观中矩形左上角的水平位置。
		 * @param y 此外观中矩形左上角的垂直位置。
		 * @param width 矩形的宽度（以像素为单位）。
		 * @param height 矩形的高度（以像素为单位）。
		 * @param cornerRadius 矩形的角半径。可以是 null、Number 或 Object。如果为 null，则表示该角应为方形而不是弧形。如果为 Number，则为所有四个角指定相同半径（以像素为单位）。如果为 Object，则应具有 tl、tr、bl 和 br 属性，这些属性值是用于指定左上角、右上角、左下角、右下角的半径的 Number（以像素为单位）。例如，您可以传递简单 Object，如 { tl: 5, tr: 5, bl: 0, br: 0 }。默认值为 null（方形角）。
		 * @param color 填充的 RGB 颜色。可以是 null、uint 或 Array。如果为 null，则不为矩形填充颜色。如果为 uint，则会指定一个 RGB 填充色。例如，传递 0xFF0000 可填充红色。如果为 Array，则应包含用于指定渐变颜色的 uint。例如，传递 [ 0xFF0000, 0xFFFF00, 0x0000FF ] 可填充红-黄-蓝渐变。在渐变中最多可以指定 15 种颜色。默认值为 null（无填充颜色）。
		 * @param alpha 用于填充的 Alpha 值。可以是 null、Number 或 Array。如果 color 为空，则忽略此参数。如果 color 是用于指定 RGB 填充颜色的 uint，则 alpha 应该是用于指定填充透明度的 Number，其中 0.0 表示完全透明，1.0 表示完全不透明。在本例中，您还可以通过传递空值而不是 1.0 来指定完全不透明。如果 color 是用于指定渐变颜色的 Array，则 alpha 应该是长度相同的数字 Array，用于为渐变指定相应的 alpha 值。在本例中，默认值为 null（完全不透明）。
		 * @param gradientMatrix 用于渐变填充的 Matrix 对象。可使用实用程序方法 horizontalGradientMatrix()、verticalGradientMatrix() 和 rotatedGradientMatrix() 来创建此参数的值。
		 * @param gradientType 渐变填充的类型。可能的值为 GradientType.LINEAR 或 GradientType.RADIAL。（GradientType 类位于 flash.display 包中。）
		 * @param gradientRatios （可选默认值为 [0,255]）指定颜色分布。条目数必须与在 color 参数中定义的颜色数匹配。各值均定义 100% 采样的颜色所在位置的宽度百分比。值 0 表示渐变框中的左侧位置，255 表示渐变框中的右侧位置。
		 * @param hole （可选）应从另一个实心填充的圆角矩形 { x: #, y: #, w: #, h: #, r: # 或 { br: #, bl: #, tl: #, tr: # } } 中央凸出的圆角矩形孔
		 * 
		 */		
		protected function drawRoundRect(
			x:Number, y:Number, width:Number, height:Number,
			cornerRadius:Object = null,
			color:Object = null,
			alpha:Object = null,
			gradientMatrix:Matrix = null,
			gradientType:String = "linear",
			gradientRatios:Array = null,
			hole:Object = null):void
		{
			var g:Graphics = graphics;
			
			if (width == 0 || height == 0)
				return;
			
			if (color !== null)
			{
				if (color is uint)
				{
					g.beginFill(uint(color), Number(alpha));
				}
				else if (color is Array)
				{
					var alphas:Array = alpha is Array ?
						alpha as Array :
						[ alpha, alpha ];
					
					if (!gradientRatios)
						gradientRatios = [ 0, 0xFF ];
					
					g.beginGradientFill(gradientType,
						color as Array, alphas,
						gradientRatios, gradientMatrix);
				}
			}
			
			var ellipseSize:Number;
			
			if (!cornerRadius)
			{
				g.drawRect(x, y, width, height);
			}
			else if (cornerRadius is Number)
			{
				ellipseSize = Number(cornerRadius) * 2;
				g.drawRoundRect(x, y, width, height, 
					ellipseSize, ellipseSize);
			}
			else
			{
				drawRoundRectComplex(g,
					x, y, width, height,
					cornerRadius.tl, cornerRadius.tr,
					cornerRadius.bl, cornerRadius.br);
			}
			
			if (hole)
			{
				var holeR:Object = hole.r;
				if (holeR is Number)
				{
					ellipseSize = Number(holeR) * 2;
					g.drawRoundRect(hole.x, hole.y, hole.w, hole.h, 
						ellipseSize, ellipseSize);
				}
				else
				{
					drawRoundRectComplex(g,
						hole.x, hole.y, hole.w, hole.h,
						holeR.tl, holeR.tr, holeR.bl, holeR.br);
				}	
			}
			
			if (color !== null)
				g.endFill();
		}
		/**
		 * 绘制圆角矩形
		 */		
		private static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
													width:Number, height:Number, 
													topLeftRadius:Number, topRightRadius:Number, 
													bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			
			var minSize:Number = width < height ? width * 2 : height * 2;
			topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
			topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
			bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
			bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
			
			var a:Number = bottomRightRadius * 0.292893218813453;
			var s:Number = bottomRightRadius * 0.585786437626905;
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
			
			a = bottomLeftRadius * 0.292893218813453;
			s = bottomLeftRadius * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
			
			a = topLeftRadius * 0.292893218813453;
			s = topLeftRadius * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);
			
			a = topRightRadius * 0.292893218813453;
			s = topRightRadius * 0.585786437626905;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
	}
}