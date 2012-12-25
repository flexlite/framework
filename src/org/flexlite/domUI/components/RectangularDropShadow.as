package org.flexlite.domUI.components
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domUI.core.UIComponent;
	
	[DXML(show="false")]
	/**
	 * 矩形投影显示元素。<br/>
	 * 此类通常用于替代DropShadowFilter，优化投影性能。
	 * 当需要对矩形显示对象应用投影时，请尽可能使用此类来替代投影滤镜，以获取更高的性能。
	 * @author DOM
	 */
	public class RectangularDropShadow extends UIComponent
	{
		/**
		 * 构造函数
		 */		
		public function RectangularDropShadow()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * 投影属性改变标志
		 */		
		private var shadowChanged:Boolean = false;
		
		private var _alpha:Number = 0.4;
		/**
		 * @inheritDoc
		 */	
		override public function get alpha():Number
		{
			return _alpha;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			if (_alpha==value)
				return;
			_alpha = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _angle:Number = 45.0;
		/**
		 * 斜角的角度。有效值为 0 到 360 度。角度值表示理论上的光源落在对象上的角度，
		 * 它决定了效果相对于该对象的位置。如果 distance 属性设置为 0，
		 * 则效果相对于对象没有偏移，因此 angle 属性不起作用。
		 */		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set angle(value:Number):void
		{
			if (_angle==value)
				return;
			_angle = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _color:int = 0;
		/**
		 * 光晕颜色。有效值采用十六进制格式 0xRRGGBB。
		 */		
		public function get color():int
		{
			return _color;
		}
		
		public function set color(value:int):void
		{
			if (_color==value)
				return;
			_color = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _distance:Number = 4.0;
		/**
		 * 阴影的偏移距离，以像素为单位。默认值为 4.0（浮点）。
		 */		
		public function get distance():Number
		{
			return _distance;
		}
		
		public function set distance(value:Number):void
		{
			if (_distance==value)
				return;
			_distance = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _tlRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左上角的顶点半径。
		 */		
		public function get tlRadius():Number
		{
			return _tlRadius;
		}
		
		public function set tlRadius(value:Number):void
		{
			if (_tlRadius==value)
				return;
			_tlRadius = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _trRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右上角的顶点半径。
		 */		
		public function get trRadius():Number
		{
			return _trRadius;
		}
		
		public function set trRadius(value:Number):void
		{
			if (_trRadius==value)
				return;
			_trRadius = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _blRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左下角的顶点半径。
		 */		
		public function get blRadius():Number
		{
			return _blRadius;
		}
		
		public function set blRadius(value:Number):void
		{
			if (_blRadius == value)
				return;
			_blRadius = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _brRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右下角的顶点半径。
		 */		
		public function get brRadius():Number
		{
			return _brRadius;
		}
		
		public function set brRadius(value:Number):void
		{
			if (brRadius==value)
				return;
			_brRadius = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _blurX:Number = 4;
		/**
		 * 水平模糊量。有效值为 0 到 255.0（浮点）。默认值为 4.0。
		 */		
		public function get blurX():Number
		{
			return _blurX;
		}
		
		public function set blurX(value:Number):void
		{
			if (_blurX==value)
				return;
			_blurX = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		private var _blurY:Number = 4;
		/**
		 * 垂直模糊量。有效值为 0 到 255.0（浮点）。默认值为 4.0。
		 */		
		public function get blurY():Number
		{
			return _blurY;
		}
		
		public function set blurY(value:Number):void
		{
			if (_blurY==value)
				return;
			_blurY = value;
			shadowChanged = true;
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			
			if(shadowChanged)
			{
				shadowChanged = false;
				createShadowBitmaps();
			}
			drawShadow(0,0,unscaledWidth,unscaledHeight);
		}
		
		/**
		 * 绘制阴影。 
		 * @param x 投影位置的水平偏移量。
		 * @param y 投影位置的垂直偏移量。
		 * @param width 阴影的宽度。
		 * @param height 阴影的高度。
		 */		
		private function drawShadow(x:Number, y:Number,width:Number, height:Number):void
		{	
			var g:Graphics = graphics;
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
		
		private var shadow:BitmapData;
		
		private var leftShadow:BitmapData;
		
		private var rightShadow:BitmapData;
		
		private var topShadow:BitmapData;
		
		private var bottomShadow:BitmapData;
		/**
		 * 创建四个方向缓存的投影位图数据
		 */		
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
			drawRoundRectComplex(
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
		/**
		 * 绘制四个角圆角值不同的矩形。
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