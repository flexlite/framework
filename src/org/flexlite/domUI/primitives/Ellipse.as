<<<<<<< HEAD
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.primitives.supportClasses.FilledElement;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * Ellipse 类是绘制椭圆的填充图形元素。
	 * @author DOM
	 */	
	public class Ellipse extends FilledElement
	{
		public function Ellipse()
		{
			super();
		}
		
		override protected function draw(g:Graphics):void
		{
			g.drawEllipse(drawX, drawY, width, height);
		}
		
		override protected function transformWidthForLayout(width:Number,
															height:Number,
															postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				width = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).width;    
			return width + getStrokeExtents(postLayoutTransform).width;
		}
		
		override protected function transformHeightForLayout(width:Number,
															 height:Number,
															 postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				height = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
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
				MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).x;
		}
		
		override public function get preferredY():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix();
			if (!m)
				return strokeExtents.top + this.y;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN, NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			return strokeExtents.top + 
				MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).y;
		}
		
		override public function get layoutBoundsX():Number
		{
			var stroke:Number = getStrokeExtents().left;
			
			if (hasComplexLayoutMatrix)
				return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).x;
			
			return stroke + this.x;
		}
		
		override public function get layoutBoundsY():Number
		{
			var stroke:Number = getStrokeExtents().top;
			
			if (hasComplexLayoutMatrix)
				return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).y;
			
			return stroke + this.y;
		}
		
		private function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
		{
			return MatrixUtil.getEllipseBoundingBox(0, 0, width / 2, height / 2, m);
		}
		
		override public function setLayoutBoundsSize(width:Number,height:Number):void
		{
			var m:Matrix = getComplexMatrix();
			if (!m)
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			
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
				if (size1 && getBoundingBox(size1.x, size1.y, m).width > width)
					size1 = null;
				if (size2 && getBoundingBox(size2.x, size2.y, m).height > height)
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
				var postTransformBounds:Rectangle = getBoundingBox(newWidth, newHeight, m);
				
				var widthDifference:Number = isNaN(width) ? 0 : width - postTransformBounds.width;
				var heightDifference:Number = isNaN(height) ? 0 : height - postTransformBounds.height;
				
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
	}
}
=======
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.primitives.supportClasses.FilledElement;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * Ellipse 类是绘制椭圆的填充图形元素。
	 * @author DOM
	 */	
	public class Ellipse extends FilledElement
	{
		public function Ellipse()
		{
			super();
		}
		
		override protected function draw(g:Graphics):void
		{
			g.drawEllipse(drawX, drawY, width, height);
		}
		
		override protected function transformWidthForLayout(width:Number,
															height:Number,
															postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				width = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).width;    
			return width + getStrokeExtents(postLayoutTransform).width;
		}
		
		override protected function transformHeightForLayout(width:Number,
															 height:Number,
															 postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				height = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
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
				MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).x;
		}
		
		override public function get preferredY():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix();
			if (!m)
				return strokeExtents.top + this.y;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN, NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			return strokeExtents.top + 
				MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).y;
		}
		
		override public function get layoutBoundsX():Number
		{
			var stroke:Number = getStrokeExtents().left;
			
			if (hasComplexLayoutMatrix)
				return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).x;
			
			return stroke + this.x;
		}
		
		override public function get layoutBoundsY():Number
		{
			var stroke:Number = getStrokeExtents().top;
			
			if (hasComplexLayoutMatrix)
				return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
					layoutFeatures.layoutMatrix).y;
			
			return stroke + this.y;
		}
		
		private function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
		{
			return MatrixUtil.getEllipseBoundingBox(0, 0, width / 2, height / 2, m);
		}
		
		override public function setLayoutBoundsSize(width:Number,height:Number):void
		{
			var m:Matrix = getComplexMatrix();
			if (!m)
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			
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
				if (size1 && getBoundingBox(size1.x, size1.y, m).width > width)
					size1 = null;
				if (size2 && getBoundingBox(size2.x, size2.y, m).height > height)
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
				var postTransformBounds:Rectangle = getBoundingBox(newWidth, newHeight, m);
				
				var widthDifference:Number = isNaN(width) ? 0 : width - postTransformBounds.width;
				var heightDifference:Number = isNaN(height) ? 0 : height - postTransformBounds.height;
				
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
	}
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
