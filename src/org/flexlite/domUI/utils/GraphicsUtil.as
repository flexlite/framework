<<<<<<< HEAD
package org.flexlite.domUI.utils
{
	import flash.display.Graphics;
	
	/**
	 * 绘图元素相关工具类
	 * @author DOM
	 */	
	public class GraphicsUtil
	{
		/**
		 * 使用绘制圆角的半径大小来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
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
		
		/**
		 * 通过使用单独的 x 和 y 半径的大小绘制圆角，来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex2() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 方法来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
		 */		
		public static function drawRoundRectComplex2(graphics:Graphics, x:Number, y:Number, 
													 width:Number, height:Number, 
													 radiusX:Number, radiusY:Number,
													 topLeftRadiusX:Number, topLeftRadiusY:Number,
													 topRightRadiusX:Number, topRightRadiusY:Number,
													 bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
													 bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			var aX:Number = bottomRightRadiusX * 0.292893218813453;		
			var aY:Number = bottomRightRadiusY * 0.292893218813453;		
			var sX:Number = bottomRightRadiusX * 0.585786437626905; 	
			var sY:Number = bottomRightRadiusY * 0.585786437626905; 	
			graphics.moveTo(xw, yh - bottomRightRadiusY);
			graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
			graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadiusX, yh);
			graphics.curveTo(x + sX, yh, x + aX, yh - aY);
			graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadiusY);
			graphics.curveTo(x, y + sY, x + aX, y + aY);
			graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			graphics.lineTo(xw - topRightRadiusX, y);
			graphics.curveTo(xw - sX, y, xw - aX, y + aY);
			graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
			graphics.lineTo(xw, yh - bottomRightRadiusY);
		}
	}
	
}
=======
package org.flexlite.domUI.utils
{
	import flash.display.Graphics;
	
	/**
	 * 绘图元素相关工具类
	 * @author DOM
	 */	
	public class GraphicsUtil
	{
		/**
		 * 使用绘制圆角的半径大小来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
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
		
		/**
		 * 通过使用单独的 x 和 y 半径的大小绘制圆角，来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex2() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 方法来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
		 */		
		public static function drawRoundRectComplex2(graphics:Graphics, x:Number, y:Number, 
													 width:Number, height:Number, 
													 radiusX:Number, radiusY:Number,
													 topLeftRadiusX:Number, topLeftRadiusY:Number,
													 topRightRadiusX:Number, topRightRadiusY:Number,
													 bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
													 bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			var aX:Number = bottomRightRadiusX * 0.292893218813453;		
			var aY:Number = bottomRightRadiusY * 0.292893218813453;		
			var sX:Number = bottomRightRadiusX * 0.585786437626905; 	
			var sY:Number = bottomRightRadiusY * 0.585786437626905; 	
			graphics.moveTo(xw, yh - bottomRightRadiusY);
			graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
			graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadiusX, yh);
			graphics.curveTo(x + sX, yh, x + aX, yh - aY);
			graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadiusY);
			graphics.curveTo(x, y + sY, x + aX, y + aY);
			graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			graphics.lineTo(xw - topRightRadiusX, y);
			graphics.curveTo(xw - sX, y, xw - aX, y + aY);
			graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
			graphics.lineTo(xw, yh - bottomRightRadiusY);
		}
	}
	
}
>>>>>>> master
