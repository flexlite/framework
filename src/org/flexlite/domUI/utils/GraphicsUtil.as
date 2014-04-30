package org.flexlite.domUI.utils
{
	import flash.display.Graphics;

	[ExcludeClass]
	/**
	 * 绘图工具类
	 * @author DOM
	 */
	public class GraphicsUtil
	{
		/**
		 * 绘制四个角不同的圆角矩形
		 * @param graphics 要绘制到的对象。
		 * @param x 起始点x坐标
		 * @param y 起始点y坐标
		 * @param width 矩形宽度
		 * @param height 矩形高度
		 * @param topLeftRadius 左上圆角半径
		 * @param topRightRadius 右上圆角半径
		 * @param bottomLeftRadius 左下圆角半径
		 * @param bottomRightRadius 右下圆角半径
		 */				
		public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
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