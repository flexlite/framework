package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.primitives.supportClasses.FilledElement;
	import org.flexlite.domUI.utils.GraphicsUtil;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * Rect 类是绘制矩形的填充图形元素。矩形的角可以是圆角。
	 * @author DOM
	 */	
	public class Rect extends FilledElement
	{
		public function Rect()
		{
			super();
		}
		
		private var _bottomLeftRadiusX:Number;
		/**
		 * 矩形的左下角的x半径。
		 */		
		public function get bottomLeftRadiusX():Number 
		{
			return _bottomLeftRadiusX;
		}
		
		public function set bottomLeftRadiusX(value:Number):void
		{        
			if (value != _bottomLeftRadiusX)
			{
				_bottomLeftRadiusX = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _bottomLeftRadiusY:Number;
		/**
		 * 矩形的左下角的x半径。
		 */		
		public function get bottomLeftRadiusY():Number 
		{
			return _bottomLeftRadiusY;
		}
		
		public function set bottomLeftRadiusY(value:Number):void
		{        
			if (value != _bottomLeftRadiusY)
			{
				_bottomLeftRadiusY = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _bottomRightRadiusX:Number;
		/**
		 * 矩形右下角的x半径。
		 */		
		public function get bottomRightRadiusX():Number 
		{
			return _bottomRightRadiusX;
		}

		public function set bottomRightRadiusX(value:Number):void
		{        
			if (value != bottomRightRadiusX)
			{
				_bottomRightRadiusX = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _bottomRightRadiusY:Number;
		/**
		 * 矩形右下角的y半径。
		 */		
		public function get bottomRightRadiusY():Number 
		{
			return _bottomRightRadiusY;
		}
		
		public function set bottomRightRadiusY(value:Number):void
		{        
			if (value != _bottomRightRadiusY)
			{
				_bottomRightRadiusY = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _radiusX:Number = 0;
		/**
		 * 要用于所有角上的 x 轴的默认角半径。
		 * topLeftRadiusX、topRightRadiusX、bottomLeftRadiusX 和 bottomRightRadiusX 属性优先于此属性。
		 */			
		public function get radiusX():Number 
		{
			return _radiusX;
		}
		
		public function set radiusX(value:Number):void
		{        
			if (value != _radiusX)
			{
				_radiusX = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _radiusY:Number = 0;
		/**
		 * 要用于所有角上的 y 轴的默认角半径。
		 * topLeftRadiusY、topRightRadiusY、bottomLeftRadiusY 和 bottomRightRadiusY 属性优先于此属性。
		 */		
		public function get radiusY():Number 
		{
			return _radiusY;
		}
		
		public function set radiusY(value:Number):void
		{        
			if (value != _radiusY)
			{
				_radiusY = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _topLeftRadiusX:Number;
		/**
		 * 矩形左上角的x半径。
		 */		
		public function get topLeftRadiusX():Number 
		{
			return _topLeftRadiusX;
		}
		
		public function set topLeftRadiusX(value:Number):void
		{        
			if (value != _topLeftRadiusX)
			{
				_topLeftRadiusX = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _topLeftRadiusY:Number;
		/**
		 * 矩形左上角的 y半径。
		 */		
		public function get topLeftRadiusY():Number 
		{
			return _topLeftRadiusY;
		}
		
		public function set topLeftRadiusY(value:Number):void
		{        
			if (value != _topLeftRadiusY)
			{
				_topLeftRadiusY = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _topRightRadiusX:Number;
		/**
		 * 矩形右上角的 x半径。
		 */		
		public function get topRightRadiusX():Number 
		{
			return _topRightRadiusX;
		}
		
		public function set topRightRadiusX(value:Number):void
		{        
			if (value != topRightRadiusX)
			{
				_topRightRadiusX = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		private var _topRightRadiusY:Number;
		/**
		 * 矩形右上角的 y半径。
		 */		
		public function get topRightRadiusY():Number 
		{
			return _topRightRadiusY;
		}
		
		public function set topRightRadiusY(value:Number):void
		{        
			if (value != _topRightRadiusY)
			{
				_topRightRadiusY = value;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		override protected function draw(g:Graphics):void
		{
			
			if (!isNaN(topLeftRadiusX) || !isNaN(topRightRadiusX) ||
				!isNaN(bottomLeftRadiusX) || !isNaN(bottomRightRadiusX))
			{      
				
				GraphicsUtil.drawRoundRectComplex2(g, drawX, drawY, width, height, 
					radiusX, radiusY, 
					topLeftRadiusX, topLeftRadiusY,
					topRightRadiusX, topRightRadiusY,
					bottomLeftRadiusX, bottomLeftRadiusY,
					bottomRightRadiusX, bottomRightRadiusY);
			}
			else if (radiusX != 0)
			{
				var rX:Number = radiusX;
				var rY:Number =  radiusY == 0 ? radiusX : radiusY;
				g.drawRoundRect(drawX, drawY, width, height, rX * 2, rY * 2);
			}
			else
			{
				g.drawRect(drawX, drawY, width, height);
			}
		}
		
		override protected function transformWidthForLayout(width:Number,
															height:Number,
															postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				width = getRoundRectBoundingBox(width, height, this, 
					layoutFeatures.layoutMatrix).width;
			return width + getStrokeExtents(postLayoutTransform).width;
		}
		
		override protected function transformHeightForLayout(width:Number,
															 height:Number,
															 postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				height = getRoundRectBoundingBox(width, height, this, 
					layoutFeatures.layoutMatrix).height;
			return height + getStrokeExtents(postLayoutTransform).height;
		}
		
		override public function get preferredX():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix();
			if (!m)
				return strokeExtents.left + this.x;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN, NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			return strokeExtents.left +
				getRoundRectBoundingBox(newSize.x, newSize.y, this, m).x;
		}
		
		override public function get preferredY():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix();
			if (!m)
				return strokeExtents.top + this.y;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN,NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			return strokeExtents.top +
				getRoundRectBoundingBox(newSize.x, newSize.y, this, m).y;
		}
		
		override public function get layoutBoundsX():Number
		{
			var stroke:Number = getStrokeExtents().left;
			if (hasComplexLayoutMatrix)
				return stroke + getRoundRectBoundingBox(width, height, this, 
					layoutFeatures.layoutMatrix).x;  
			
			return stroke + this.x;
		}
		
		override public function get layoutBoundsY():Number
		{
			var stroke:Number = getStrokeExtents().top;
			if (hasComplexLayoutMatrix)
				return stroke + getRoundRectBoundingBox(width, height, this, 
					layoutFeatures.layoutMatrix).y;
			
			return stroke + this.y;
		}
		
		override public function setLayoutBoundsSize(width:Number,
													 height:Number):void
		{
			super.setLayoutBoundsSize(width, height);
			
			var isRounded:Boolean = !isNaN(topLeftRadiusX) || 
				!isNaN(topRightRadiusX) ||
				!isNaN(bottomLeftRadiusX) || 
				!isNaN(bottomRightRadiusX) ||
				radiusX != 0 ||
				radiusY != 0;
			if (!isRounded)
				return;
			
			var m:Matrix = getComplexMatrix();
			if (!m)
				return;
			
			setLayoutBoundsTransformed(width, height, m);
		}
		
		private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix):void
		{
			var strokeExtents:Rectangle = getStrokeExtents(true);
			width -= strokeExtents.width;
			height -= strokeExtents.height;
			
			var size:Point = fitLayoutBoundsIterative(width, height, m);
			if (!size && !isNaN(width) && !isNaN(height))
			{
				
				var size1:Point = fitLayoutBoundsIterative(NaN, height, m);
				var size2:Point = fitLayoutBoundsIterative(width, NaN, m);
				if (size1 && getRoundRectBoundingBox(size1.x, size1.y, this, m).width > width)
					size1 = null;
				if (size2 && getRoundRectBoundingBox(size2.x, size2.y, this, m).height > height)
					size2 = null;
				if (size1 && size2)
				{
					var pickSize1:Boolean = size1.x * size1.y > size2.x * size2.y;
					
					if (pickSize1)
						size = size1;
					else
						size = size2;
				}
				else if (size1)
				{
					size = size1;
				}
				else
				{
					size = size2;
				}
			}
			
			if (size)
				setActualSize(size.x, size.y);
			else
				setActualSize(minWidth, minHeight);
		}
		
		private function fitLayoutBoundsIterative(width:Number, height:Number, m:Matrix):Point
		{
			var newWidth:Number = this.preferredWidthPreTransform();
			var newHeight:Number = this.preferredHeightPreTransform();
			var fitWidth:Number = MatrixUtil.transformBounds(newWidth, newHeight, m).x;
			var fitHeight:Number = MatrixUtil.transformBounds(newWidth, newHeight, m).y;
			
			if (isNaN(width))
				fitWidth = NaN;
			if (isNaN(height))
				fitHeight = NaN;
			
			var i:int = 0;
			while (i++ < 150)
			{
				var roundedRectBounds:Rectangle = getRoundRectBoundingBox(newWidth, newHeight, this, m);
				
				var widthDifference:Number = isNaN(width) ? 0 : width - roundedRectBounds.width;
				var heightDifference:Number = isNaN(height) ? 0 : height - roundedRectBounds.height;
				
				if (Math.abs(widthDifference) < 0.1 && Math.abs(heightDifference) < 0.1)
				{
					return new Point(newWidth, newHeight);
				}
				
				fitWidth += widthDifference * 0.5;
				fitHeight += heightDifference * 0.5;
				
				var newSize:Point = MatrixUtil.fitBounds(fitWidth, 
					fitHeight, 
					m,
					explicitWidth, 
					explicitHeight,
					preferredWidthPreTransform(),
					preferredHeightPreTransform(),
					minWidth, minHeight,
					maxWidth, maxHeight);
				if (!newSize)
					break;
				
				newWidth = newSize.x;
				newHeight = newSize.y;
			}
			
			return null;        
		}
		
		static private function getRoundRectBoundingBox(width:Number,
														height:Number,
														r:Rect,
														m:Matrix):Rectangle
		{
			var maxRadiusX:Number = width / 2;
			var maxRadiusY:Number = height / 2;
			
			var radiusX:Number = r.radiusX;
			var radiusY:Number = r.radiusY == 0 ? radiusX : r.radiusY;
			
			function radiusValue(def:Number, value:Number, max:Number):Number
			{
				var result:Number = isNaN(value) ? def : value;
				return Math.min(result, max);
			}
			
			var boundingBox:Rectangle;
			var rX:Number;
			var rY:Number;
			rX = radiusValue(radiusX, r.topLeftRadiusX, maxRadiusX);
			rY = radiusValue(radiusY, r.topLeftRadiusY, maxRadiusY);
			boundingBox = MatrixUtil.getEllipseBoundingBox(rX, rY, rX, rY, m, boundingBox);
			rX = radiusValue(radiusX, r.topRightRadiusX, maxRadiusX);
			rY = radiusValue(radiusY, r.topRightRadiusY, maxRadiusY);
			boundingBox = MatrixUtil.getEllipseBoundingBox(width - rX, rY, rX, rY, m, boundingBox);
			rX = radiusValue(radiusX, r.bottomRightRadiusX, maxRadiusX);
			rY = radiusValue(radiusY, r.bottomRightRadiusY, maxRadiusY);
			boundingBox = MatrixUtil.getEllipseBoundingBox(width - rX, height - rY, rX, rY, m, boundingBox);
			rX = radiusValue(radiusX, r.bottomLeftRadiusX, maxRadiusX);
			rY = radiusValue(radiusY, r.bottomLeftRadiusY, maxRadiusY);
			boundingBox = MatrixUtil.getEllipseBoundingBox(rX, height - rY, rX, rY, m, boundingBox);
			
			return boundingBox;
		}
	}
	
}
