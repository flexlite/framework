package org.flexlite.domUI.primitives.graphic
{
	import org.flexlite.domUI.utils.GraphicsUtil;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 通常使用 DropShadowFilter 类创建投影。但是，与所有位图滤镜一样，DropShadowFilter 从运算角度看可能需要昂贵的成本。
	 * 如果将 DropShadowFilter 应用到 DisplayObject，则在对象外观发生更改时将重新计算投影。
	 * 如果已对 DisplayObject 设置了动画效果（例如，使用 Resize 效果），则显示投影会影响动画刷新频率。 
	 * 此类通常用于优化投影。如果打算对边缘位于像素边界上的 rectangularly-shaped 对象应用投影，则应使用此类，而非直接使用 DropShadowFilter。
	 * 此类接受传递到 DropShadowFilter 的前四个参数：alpha、angle、color 和 distance。
	 * 此外，此类接受投射阴影的 rectangularly-shaped 对象每个角（共四个角）的角半径。
	 * 如果已经设置了这 8 个值，则此类会预先计算在屏幕外 Bitmap 中的投影。调用 drawShadow() 方法时，则会将预先计算的投影复制到传入的 Graphics 对象。
	 * @author DOM
	 */
	public class RectangularDropShadow
	{
		public function RectangularDropShadow()
		{
			super();
		}
		
		private var shadow:BitmapData;
		
		private var leftShadow:BitmapData;
		
		private var rightShadow:BitmapData;
		
		private var topShadow:BitmapData;
		
		private var bottomShadow:BitmapData;
		
		private var changed:Boolean = true;
		
		private var _alpha:Number = 0.4;
		
		/**
		 * @copy flash.filters.DropShadowFilter#alpha
		 */		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (_alpha != value)
			{
				_alpha = value;
				changed = true;
			}
		}
		
		private var _angle:Number = 45.0;
		
		/**
		 * @copy flash.filters.DropShadowFilter#angle
		 */	
		public function get angle():Number
		{
			return _angle;
		}
		public function set angle(value:Number):void
		{
			if (_angle != value)
			{
				_angle = value;
				changed = true;
			}
		}
		
		private var _color:int = 0;
		/**
		 * @copy flash.filters.DropShadowFilter#color
		 */		
		public function get color():int
		{
			return _color;
		}
		
		public function set color(value:int):void
		{
			if (_color != value)
			{
				_color = value;
				changed = true;
			}
		}
		
		private var _distance:Number = 4.0;
		/**
		 * @copy flash.filters.DropShadowFilter#distance
		 */		
		public function get distance():Number
		{
			return _distance;
		}
		
		public function set distance(value:Number):void
		{
			if (_distance != value)
			{
				_distance = value;
				changed = true;
			}
		}
		
		private var _tlRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
		public function get tlRadius():Number
		{
			return _tlRadius;
		}
		
		public function set tlRadius(value:Number):void
		{
			if (_tlRadius != value)
			{
				_tlRadius = value;
				changed = true;
			}
		}
		
		private var _trRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
		public function get trRadius():Number
		{
			return _trRadius;
		}
		
		public function set trRadius(value:Number):void
		{
			if (_trRadius != value)
			{
				_trRadius = value;
				changed = true;
			}
		}
		
		private var _blRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
		public function get blRadius():Number
		{
			return _blRadius;
		}
		
		public function set blRadius(value:Number):void
		{
			if (_blRadius != value)
			{
				_blRadius = value;
				changed = true;
			}
		}
		
		private var _brRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
		public function get brRadius():Number
		{
			return _brRadius;
		}
		
		public function set brRadius(value:Number):void
		{
			if (_brRadius != value)
			{
				_brRadius = value;
				changed = true;
			}
		}
		
		private var _blurX:Number = 4;
		/**
		 * 水平模糊量。
		 */		
		public function get blurX():Number
		{
			return _blurX;
		}
		
		public function set blurX(value:Number):void
		{
			if (_blurX != value)
			{
				_blurX = value;
				changed = true;
			}
		}
		
		private var _blurY:Number = 4;
		/**
		 * 垂直模糊量。
		 */		
		public function get blurY():Number
		{
			return _blurY;
		}
		
		public function set blurY(value:Number):void
		{
			if (_blurY != value)
			{
				_blurY = value;
				changed = true;
			}
		}
		/**
		 * 在屏幕上呈示阴影。 
		 * @param g 要对其绘制阴影的 Graphics 对象。
		 * @param x 投影相对于 Graphics 对象位置的水平偏移量。
		 * @param y Graphics 对象位置的垂直偏移量。
		 * @param width 阴影的宽度（以像素为单位）。
		 * @param height 阴影的高度（以像素为单位）。
		 */		
		public function drawShadow(g:Graphics, 
								   x:Number, y:Number, 
								   width:Number, height:Number):void
		{	
			if (changed)
			{
				createShadowBitmaps();
				changed = false;
			}
			
			width = Math.ceil(width);
			height = Math.ceil(height);
			var leftThickness:int = leftShadow ? leftShadow.width : 0;
			var rightThickness:int = rightShadow ? rightShadow.width : 0;
			var topThickness:int = topShadow ? topShadow.height : 0;
			var bottomThickness:int = bottomShadow ? bottomShadow.height : 0;
			
			var widthThickness:int = leftThickness + rightThickness;
			var heightThickness:int = topThickness + bottomThickness;
			var maxCornerHeight:Number = (height + heightThickness) / 2;
			var maxCornerWidth:Number = (width + widthThickness) / 2;
			
			var matrix:Matrix = new Matrix();
			if (leftShadow || topShadow)
			{
				var tlWidth:Number = Math.min(tlRadius + widthThickness,
					maxCornerWidth);
				var tlHeight:Number = Math.min(tlRadius + heightThickness,
					maxCornerHeight);
				
				matrix.tx = x - leftThickness;
				matrix.ty = y - topThickness;
				g.beginBitmapFill(shadow, matrix, false);
				g.drawRect(x - leftThickness, y - topThickness, tlWidth, tlHeight);
				g.endFill();
			}
			
			if (rightShadow || topShadow)
			{
				var trWidth:Number = Math.min(trRadius + widthThickness,
					maxCornerWidth);
				var trHeight:Number = Math.min(trRadius + heightThickness,
					maxCornerHeight);
				
				matrix.tx = x + width + rightThickness - shadow.width;
				matrix.ty = y - topThickness;			
				
				g.beginBitmapFill(shadow, matrix, false);
				g.drawRect(x + width + rightThickness - trWidth,
					y - topThickness,
					trWidth, trHeight);
				g.endFill();
			}
			
			if (leftShadow || bottomShadow)
			{
				var blWidth:Number = Math.min(blRadius + widthThickness,
					maxCornerWidth);
				var blHeight:Number = Math.min(blRadius + heightThickness,
					maxCornerHeight);
				
				matrix.tx = x - leftThickness;
				matrix.ty = y + height + bottomThickness - shadow.height;
				
				g.beginBitmapFill(shadow, matrix, false);
				g.drawRect(x - leftThickness, 
					y + height + bottomThickness - blHeight,
					blWidth, blHeight);
				g.endFill();
			}
			
			if (rightShadow || bottomShadow)
			{
				var brWidth:Number = Math.min(brRadius + widthThickness,
					maxCornerWidth);
				var brHeight:Number = Math.min(brRadius + heightThickness,
					maxCornerHeight);
				
				matrix.tx = x + width + rightThickness - shadow.width; 
				matrix.ty = y + height + bottomThickness - shadow.height; 
				
				g.beginBitmapFill(shadow, matrix, false);
				g.drawRect(x + width + rightThickness - brWidth, 
					y + height + bottomThickness - brHeight,
					brWidth, brHeight);
				g.endFill();
			}
			if (leftShadow)
			{		
				matrix.tx = x - leftThickness;
				matrix.ty = 0;
				
				g.beginBitmapFill(leftShadow, matrix, false);
				g.drawRect(x - leftThickness, 
					y - topThickness + tlHeight,
					leftThickness,
					height + topThickness +
					bottomThickness - tlHeight - blHeight);
				g.endFill();
			}
			
			if (rightShadow)
			{		
				matrix.tx = x + width;
				matrix.ty = 0;
				
				g.beginBitmapFill(rightShadow, matrix, false);
				g.drawRect(x + width,
					y - topThickness + trHeight,
					rightThickness,
					height + topThickness +
					bottomThickness - trHeight - brHeight);
				g.endFill();
			}
			
			if (topShadow)
			{		
				matrix.tx = 0;
				matrix.ty = y - topThickness;
				
				g.beginBitmapFill(topShadow, matrix, false);
				g.drawRect(x - leftThickness + tlWidth,
					y - topThickness, 
					width + leftThickness +
					rightThickness - tlWidth - trWidth,
					topThickness);
				g.endFill();
			}
			
			if (bottomShadow)
			{
				matrix.tx = 0;
				matrix.ty = y + height;
				
				g.beginBitmapFill(bottomShadow, matrix, false);
				g.drawRect(x - leftThickness + blWidth,
					y + height,
					width + leftThickness +
					rightThickness - blWidth - brWidth, 
					bottomThickness);
				g.endFill();		
			}
		}	
		
		private function createShadowBitmaps():void
		{		
			var roundRectWidth:Number = Math.max(tlRadius, blRadius) + 
				3 * Math.max(Math.abs(distance), 2) + 
				Math.max(trRadius, brRadius);
			var roundRectHeight:Number = Math.max(tlRadius, trRadius) +
				3 * Math.max(Math.abs(distance), 2) +
				Math.max(blRadius, brRadius);
			
			if (roundRectWidth < 0 || roundRectHeight < 0)
				return;
			
			var roundRect:Shape = new Shape();
			var g:Graphics = roundRect.graphics;
			g.beginFill(0xFFFFFF);
			GraphicsUtil.drawRoundRectComplex(
				g, 0, 0, roundRectWidth, roundRectHeight,
				tlRadius, trRadius, blRadius, brRadius);
			g.endFill();
			var roundRectBitmap:BitmapData = new BitmapData(
				roundRectWidth,
				roundRectHeight,
				true,
				0x00000000);
			roundRectBitmap.draw(roundRect, new Matrix());
			var filter:DropShadowFilter = 
				new DropShadowFilter(distance, angle, color, alpha, blurX, blurY);
			filter.knockout = true;	
			var inputRect:Rectangle = new Rectangle(0, 0, 
				roundRectWidth, roundRectHeight);
			var outputRect:Rectangle = 
				roundRectBitmap.generateFilterRect(inputRect, filter);
			var leftThickness:Number = inputRect.left - outputRect.left;
			var rightThickness:Number = outputRect.right - inputRect.right;
			var topThickness:Number = inputRect.top - outputRect.top;
			var bottomThickness:Number = outputRect.bottom - inputRect.bottom;
			shadow = new BitmapData(outputRect.width, outputRect.height);
			shadow.applyFilter(roundRectBitmap, inputRect, 
				new Point(leftThickness, topThickness),
				filter);
			var origin:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle();
			
			if (leftThickness > 0)
			{
				rect.x = 0;
				rect.y = tlRadius + topThickness + bottomThickness;
				rect.width = leftThickness;
				rect.height = 1;
				
				leftShadow = new BitmapData(leftThickness, 1);
				leftShadow.copyPixels(shadow, rect, origin);
			}
			else
			{
				leftShadow = null;
			}
			
			if (rightThickness > 0)
			{
				rect.x = shadow.width - rightThickness;
				rect.y = trRadius + topThickness + bottomThickness;
				rect.width = rightThickness;
				rect.height = 1;
				
				rightShadow = new BitmapData(rightThickness, 1);
				rightShadow.copyPixels(shadow, rect, origin);
			}
			else
			{
				rightShadow = null;
			}
			
			if (topThickness > 0)
			{
				rect.x = tlRadius + leftThickness + rightThickness;
				rect.y = 0;
				rect.width = 1;
				rect.height = topThickness;
				
				topShadow = new BitmapData(1, topThickness);
				topShadow.copyPixels(shadow, rect, origin);
			}
			else
			{
				topShadow = null;
			}
			
			if (bottomThickness > 0)
			{
				rect.x = blRadius + leftThickness + rightThickness;
				rect.y = shadow.height - bottomThickness;
				rect.width = 1;
				rect.height = bottomThickness;
				
				bottomShadow = new BitmapData(1, bottomThickness);
				bottomShadow.copyPixels(shadow, rect, origin);
			}
			else
			{
				bottomShadow = null;
			}		
		}	
	}
	
}
