<<<<<<< HEAD
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.graphic.IStroke;
	import org.flexlite.domUI.primitives.supportClasses.FilledElement;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * Path 类是绘制一系列路径段的填充图形元素。
	 * 在矢量图形中，路径是按直线段或曲线段连接的一系列点。
	 * 这些线在一起形成一个图像。您可以使用 Path 
	 * 类来定义通过一组线段构造的一个复杂矢量形状。 
	 * @author DOM
	 */	
	public class Path extends FilledElement
	{
		public function Path()
		{
			super();
		}
		
		private var graphicsPathChanged:Boolean = true;
		
		private var segments:PathSegmentsCollection;
		
		private var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
		
		private var _data:String;
		/**
		 * 包含路径段的压缩表示的字符串。
		 * 这是设置 segments 属性的一种替代方式。
		 * 设置此属性会覆盖 segments array 属性中存储的任何值。 
		 */		
		public function set data(value:String):void
		{
			if (_data == value)
				return;
			
			segments = new PathSegmentsCollection(value);
			
			graphicsPathChanged = true;
			clearCachedBoundingBoxWithStroke();
			invalidateSize();
			invalidateDisplayList();
			
			_data = value;
		}
		
		public function get data():String 
		{
			return _data;
		}
		
		private var _winding:String = GraphicsPathWinding.EVEN_ODD;
		/**
		 * 相交或重叠路径段的填充规则。
		 * 可能的值有 GraphicsPathWinding.EVEN_ODD 或 GraphicsPathWinding.NON_ZERO。
		 */		
		public function set winding(value:String):void
		{
			if (_winding != value)
			{
				_winding = value;
				graphicsPathChanged = true;
				invalidateDisplayList();
			} 
		}
		
		public function get winding():String 
		{
			return _winding; 
		}
		
		private function getBounds():Rectangle
		{
			return segments ? segments.getBounds() : new Rectangle();
		}
		
		override protected function measure():void
		{
			var bounds:Rectangle = getBounds();
			measuredWidth = bounds.width;
			measuredHeight = bounds.height;
			measuredX = bounds.left;
			measuredY = bounds.top;
		}
		
		private var _boundingBoxCached:Rectangle;
		
		private var _boundingBoxMatrixCached:Matrix;
		
		private var _boundingBoxWidthParamCached:Number;
		
		private var _boundingBoxHeightParamCached:Number;
		
		private var _boundingBoxX:Number;
		
		private var _boundingBoxY:Number;
		
		private function getBoundingBoxWithStroke(width:Number, height:Number, m:Matrix):Rectangle
		{
			if (_boundingBoxCached && 
				_boundingBoxWidthParamCached == width && 
				_boundingBoxHeightParamCached == height)
			{
				
				if (!m && !_boundingBoxMatrixCached)
				{
					_boundingBoxCached.x = _boundingBoxX;
					_boundingBoxCached.y = _boundingBoxY;
					return _boundingBoxCached;
				}
				else if (m && _boundingBoxMatrixCached &&
					m.a == _boundingBoxMatrixCached.a &&
					m.b == _boundingBoxMatrixCached.b &&
					m.c == _boundingBoxMatrixCached.c &&
					m.d == _boundingBoxMatrixCached.d)
				{
					_boundingBoxCached.x = _boundingBoxX + m.tx;
					_boundingBoxCached.y = _boundingBoxY + m.ty;
					return _boundingBoxCached;
				}
			}
			if (m)
			{
				_boundingBoxMatrixCached = m.clone();
				_boundingBoxMatrixCached.tx = 0;
				_boundingBoxMatrixCached.ty = 0;
			}
			else
				_boundingBoxMatrixCached = null;
			_boundingBoxWidthParamCached = width;
			_boundingBoxHeightParamCached = height;
			
			_boundingBoxCached = computeBoundsWithStroke(_boundingBoxWidthParamCached,
				_boundingBoxHeightParamCached,
				m);
			_boundingBoxX = _boundingBoxCached.x - (m ? m.tx : 0);
			_boundingBoxY = _boundingBoxCached.y - (m ? m.ty : 0);
			
			return _boundingBoxCached; 
		}
		
		static private var tangent:Point = new Point();
		
		private function tangentIsValid(prevSegment:PathSegment, curSegment:PathSegment,
										sx:Number, sy:Number, m:Matrix):Boolean
		{
			curSegment.getTangent(prevSegment, true, sx, sy, m, tangent);
			return (tangent.x != 0 || tangent.y != 0);
		}
		
		private function computeBoundsWithStroke(width:Number,
												 height:Number,
												 m:Matrix):Rectangle
		{
			var naturalBounds:Rectangle = getBounds();
			var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
			var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
			var pathBBox:Rectangle;
			if (!m || MatrixUtil.isDeltaIdentity(m) || !this.segments)
			{
				pathBBox = new Rectangle(naturalBounds.x * sx,
					naturalBounds.y * sy,
					naturalBounds.width * sx,
					naturalBounds.height * sy);
				if (m)
					pathBBox.offset(m.tx, m.ty);
			}
			else
			{
				pathBBox = this.segments.getBoundingBox(width, height, m);
			}
			var strokeSettings:IStroke = this.stroke;
			if (!strokeSettings || !this.segments)
				return pathBBox;
			var strokeExtents:Rectangle = getStrokeExtents();
			pathBBox.inflate(strokeExtents.right, strokeExtents.bottom);
			
			var seg:Vector.<PathSegment> = segments.data;
			
			if (strokeSettings.joints != "miter" || seg.length < 2)
			{
				return pathBBox;
			}
			var halfWeight:Number = strokeExtents.width / 2;
			var miterLimit:Number = Math.max(1, strokeSettings.miterLimit);
			var count:int = seg.length;
			var start:int = 0;
			var end:int;
			var lastMoveX:Number = 0;
			var lastMoveY:Number = 0;
			var lastOpenSegment:int = 0;
			
			while (true)
			{
				
				while (start < count && !(seg[start] is MoveSegment))
				{
					var prevSegment:PathSegment = start > 0 ? seg[start - 1] : null;
					if (tangentIsValid(prevSegment, seg[start], sx, sy, m))
						break;
					start++;
				}
				
				if (start >= count)
					break; 
				
				var startSegment:PathSegment = seg[start];
				if (startSegment is MoveSegment)
				{
					
					lastOpenSegment = start + 1;
					lastMoveX = startSegment.x;
					lastMoveY = startSegment.y;
					start++;
					continue;
				}
				if ((start == count - 1 || seg[start + 1] is MoveSegment) && 
					startSegment.x == lastMoveX &&
					startSegment.y == lastMoveY)
				{
					end = lastOpenSegment;
				}
				else
					end = start + 1;
				while (end < count && !(seg[end] is MoveSegment))
				{
					if (tangentIsValid(startSegment, seg[end], sx, sy, m))
						break;
					end++;
				}
				
				if (end >= count)
					break; 
				
				var endSegment:PathSegment = seg[end];
				
				if (!(endSegment is MoveSegment))
				{
					addMiterLimitStrokeToBounds(start > 0 ? seg[start - 1] : null, 
						startSegment,
						endSegment, 
						miterLimit,
						halfWeight,
						sx,
						sy,
						m,
						pathBBox);
				}
				start = start > end ? start + 1 : end;
			}
			return pathBBox;
		}
		
		override protected function getStrokeBounds():Rectangle
		{
			return getBoundingBoxWithStroke(width, height, null);
		}
		
		override protected function get needsDisplayObject():Boolean
		{
			return super.needsDisplayObject || (stroke && stroke.joints == "miter");
		}
		
		private function addMiterLimitStrokeToBounds(segment0:PathSegment,
													 segment1:PathSegment,
													 segment2:PathSegment,
													 miterLimit:Number,
													 weight:Number,
													 sx:Number,
													 sy:Number,
													 m:Matrix,
													 result:Rectangle):void
		{
			
			var pt:Point;
			pt = MatrixUtil.transformPoint(segment1.x * sx, segment1.y * sy, m).clone();
			var jointX:Number = pt.x;
			var jointY:Number = pt.y;
			var t0:Point = new Point();
			segment1.getTangent(segment0, false , sx, sy, m, t0);
			var t1:Point = new Point();
			segment2.getTangent(segment1, true , sx, sy, m, t1);
			if (t0.length == 0 || t1.length == 0)
				return;
			t0.normalize(1);
			t0.x = -t0.x;
			t0.y = -t0.y;
			t1.normalize(1);
			var halfT0T1:Point = new Point( (t1.x - t0.x) * 0.5, (t1.y - t0.y) * 0.5);
			var sinHalfAlpha:Number = halfT0T1.length;
			if (Math.abs(sinHalfAlpha) < 1.0E-9)
			{
				return; 
			}
			var bisect:Point = new Point( -0.5 * (t0.x + t1.x), -0.5 * (t0.y + t1.y) );
			if (bisect.length == 0)
			{
				
				return;
			}
			if (sinHalfAlpha == 0 || miterLimit < 1 / sinHalfAlpha)
			{
				var bisectLength:Number = bisect.length;
				bisect.normalize(1);
				
				halfT0T1.normalize((weight - miterLimit * weight * sinHalfAlpha) / bisectLength);
				
				var pt0:Point = new Point(jointX + miterLimit * weight * bisect.x + halfT0T1.x,
					jointY + miterLimit * weight * bisect.y + halfT0T1.y);
				
				var pt1:Point = new Point(jointX + miterLimit * weight * bisect.x - halfT0T1.x,
					jointY + miterLimit * weight * bisect.y - halfT0T1.y);
				MatrixUtil.rectUnion(pt0.x, pt0.y, pt0.x, pt0.y, result);
				MatrixUtil.rectUnion(pt1.x, pt1.y, pt1.x, pt1.y, result);
			}
			else
			{
				
				bisect.normalize(1);
				var strokeTip:Point = new Point(jointX + bisect.x * weight / sinHalfAlpha,
					jointY + bisect.y * weight / sinHalfAlpha);
				MatrixUtil.rectUnion(strokeTip.x, strokeTip.y, strokeTip.x, strokeTip.y, result);
			}
		}
		
		override protected function transformWidthForLayout(width:Number,
															height:Number,
															postLayoutTransform:Boolean = true):Number
		{
			var m:Matrix = getComplexMatrix(postLayoutTransform);
			
			if (!m && !stroke)
				return width;
			return getBoundingBoxWithStroke(width, height, m).width;
		}
		
		override protected function transformHeightForLayout(width:Number,
															 height:Number,
															 postLayoutTransform:Boolean = true):Number
		{
			var m:Matrix = getComplexMatrix(postLayoutTransform);
			
			if (!m && !stroke)
				return height;
			return getBoundingBoxWithStroke(width, height, m).height;
		}
		
		private function getBoundsAtSize(width:Number, height:Number, m:Matrix):Rectangle
		{
			var strokeExtents:Rectangle = null;
			
			if (!isNaN(width))
			{
				strokeExtents = getStrokeExtents(true );
				width -= strokeExtents.width;
			}
			
			if (!isNaN(height))
			{
				if (!strokeExtents)
					strokeExtents = getStrokeExtents(true );
				height -= strokeExtents.height;
			}
			
			var newWidth:Number = preferredWidthPreTransform();
			var newHeight:Number = preferredHeightPreTransform();
			if (m)
			{
				var newSize:Point = MatrixUtil.fitBounds(width,
					height,
					m,
					explicitWidth,
					explicitHeight,
					newWidth,
					newHeight,
					minWidth, minHeight,
					maxWidth, maxHeight);
				
				if (newSize)
				{
					newWidth = newSize.x;
					newHeight = newSize.y;
				}
				else
				{
					newWidth = minWidth;
					newHeight = minHeight;
				}
			}
			
			return getBoundingBoxWithStroke(newWidth, newHeight, m);
		}
		
		override public function get preferredX():Number
		{
			var m:Matrix = getComplexMatrix();
			return getBoundsAtSize(NaN, NaN, m).x + (m ? 0 : this.x);
		}
		
		override public function get preferredY():Number
		{
			var m:Matrix = getComplexMatrix();
			return getBoundsAtSize(NaN, NaN, m).y + (m ? 0 : this.y);
		}
		
		override public function get layoutBoundsX():Number
		{
			var m:Matrix = getComplexMatrix();
			
			if (!m && !stroke)
			{
				if (measuredX == 0)
					return this.x;
				var naturalBounds:Rectangle = getBounds();
				var sx:Number = (naturalBounds.width == 0 || width == 0) ? 1 : width / naturalBounds.width;
				return this.x + measuredX * sx;
			}
			return getBoundingBoxWithStroke(width, height, m).x + (m ? 0 : this.x);
		}
		
		override public function get layoutBoundsY():Number
		{
			var m:Matrix = getComplexMatrix();
			
			if (!m && !stroke)
			{
				if (measuredY == 0)
					return this.y;
				var naturalBounds:Rectangle = getBounds();
				var sy:Number = (naturalBounds.height == 0 || height == 0) ? 1 : height / naturalBounds.height;
				return this.y + measuredY * sy;
			}
			return getBoundingBoxWithStroke(width, height, m).y + (m ? 0 : this.y);
		}
		
		private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix):void
		{
			var size:Point = fitLayoutBoundsIterative(width, height, m);
			if (!size && !isNaN(width) && !isNaN(height))
			{
				
				var size1:Point = fitLayoutBoundsIterative(NaN, height, m);
				var size2:Point = fitLayoutBoundsIterative(width, NaN, m);
				if (size1 && getBoundingBoxWithStroke(size1.x, size1.y, m).width > width)
					size1 = null;
				if (size2 && getBoundingBoxWithStroke(size2.x, size2.y, m).height > height)
					size2 = null;
				if (size1 && size2)
				{
					var n:Point = getBounds().size;
					var pickSize1:Boolean = Math.abs( n.x * size1.y - n.y * size1.x ) * size2.y < 
						Math.abs( n.x * size2.y - n.y * size2.x ) * size1.y;
					
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
				
				var transformedBounds:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, m);
				
				var widthDistance:Number = isNaN(width) ? 0 : width - transformedBounds.width;
				var heightDistance:Number = isNaN(height) ? 0 : height - transformedBounds.height;
				if (Math.abs(widthDistance) < 0.1 && Math.abs(heightDistance) < 0.1)
				{
					return new Point(newWidth, newHeight);
				}
				fitWidth += widthDistance * 0.5;
				fitHeight += heightDistance * 0.5;
				
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
		
		override public function setLayoutBoundsSize(width:Number, height:Number):void
		{
			if (isNaN(width) && isNaN(height))     
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			var m:Matrix = getComplexMatrix();
			if (m)
			{
				setLayoutBoundsTransformed(width, height, m);
				return;
			}
			
			if (!stroke || stroke.joints != "miter") 
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			var newWidth:Number = preferredWidthPreTransform();
			var newHeight:Number = preferredHeightPreTransform();
			var bestWidth:Number;
			var bestHeight:Number;
			var bestScore:Number;
			if (!isNaN(width) && !isNaN(height))
			{
				var size:Point = fitLayoutBoundsIterative(width, height, new Matrix());
				if (size)
				{
					setActualSize(size.x, size.y);
					return;
				}
				newWidth = getBounds().width;
				newHeight = getBounds().height;
				bestWidth = this.minWidth;
				bestHeight = this.minHeight;
				bestScore = (width - bestWidth) * (width - bestWidth) + (height - bestHeight) * (height - bestHeight);
			}
			
			var i:int = 0;
			while (i++ < 150)
			{
				var boundsWithStroke:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, null);
				
				var widthProximity:Number = 0;
				var heightProximity:Number = 0;
				if (!isNaN(width))
					widthProximity = Math.abs(width - boundsWithStroke.width);
				if (!isNaN(height))
					heightProximity = Math.abs(height - boundsWithStroke.height);
				
				if (!isNaN(width) && !isNaN(height))
				{
					var score:Number = (width - boundsWithStroke.width) * (width - boundsWithStroke.width) + 
						(height - boundsWithStroke.height) * (height - boundsWithStroke.height);
					
					if (!isNaN(score) && score < bestScore && boundsWithStroke.width <= width && boundsWithStroke.height <= height)
					{
						bestScore = score;
						bestWidth = newWidth;
						bestHeight = newHeight;
					}
				}
				if (widthProximity < 1e-5 && heightProximity < 1e-5)
				{
					setActualSize(newWidth, newHeight);
					return;
				}
				
				var boundsWithoutStroke:Rectangle = segments.getBoundingBox(newWidth, newHeight, null);
				var strokeWidth:Number = boundsWithStroke.width - boundsWithoutStroke.width;
				var strokeHeight:Number = boundsWithStroke.height - boundsWithoutStroke.height;
				
				if (!isNaN(width))
					newWidth = width - strokeWidth;
				
				if (!isNaN(height))
					newHeight = height - strokeHeight;
			}
			
			setActualSize(bestWidth, bestHeight);
		}
		
		override protected function beginDraw(g:Graphics):void
		{
			var naturalBounds:Rectangle = getBounds();
			var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
			var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
			
			var origin:Point = new Point(drawX, drawY);
			var bounds:Rectangle = new Rectangle(
				drawX + measuredX * sx,
				drawY + measuredY * sy,
				width, 
				height);
			if (stroke)
			{
				var strokeBounds:Rectangle = getStrokeBounds();
				strokeBounds.offsetPoint(origin);
				stroke.apply(g, strokeBounds, origin);
			}
			else
			{
				g.lineStyle();
			}
			
			if (fill)
				fill.begin(g, bounds, origin);
		}
		
		private var _drawBounds:Rectangle = new Rectangle(); 
		
		override protected function draw(g:Graphics):void
		{
			if (drawX !=  _drawBounds.x || drawY !=  _drawBounds.y ||
				width !=  _drawBounds.width || height !=  _drawBounds.height)
			{
				graphicsPathChanged = true;
				_drawBounds.x = drawX;
				_drawBounds.y = drawY;
				_drawBounds.width = width;
				_drawBounds.height = height;            
			}
			
			if (graphicsPathChanged)
			{
				var rcBounds:Rectangle = getBounds();
				var sx:Number = rcBounds.width == 0 ? 1 : width / rcBounds.width;
				var sy:Number = rcBounds.height == 0 ? 1 : height / rcBounds.height;
				if (segments)
					segments.generateGraphicsPath(graphicsPath, drawX, drawY, sx, sy);
				graphicsPathChanged = false;
			}
			
			g.drawPath(graphicsPath.commands, graphicsPath.data, winding);
		}
		
		override protected function endDraw(g:Graphics):void
		{
			g.lineStyle();
			super.endDraw(g);
		} 
		
		override protected function invalidateDisplayObjectSharing():void
		{
			graphicsPathChanged = true;
			super.invalidateDisplayObjectSharing();
		}
		
		private function clearCachedBoundingBoxWithStroke():void
		{
			_boundingBoxCached = null;
			_boundingBoxMatrixCached = null;
		}
		
		override protected function stroke_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			super.stroke_propertyChangeHandler(event);
			switch (event.property)
			{
				case "weight":
				case "scaleMode":
				case "joints":
				case "miterLimit":
					clearCachedBoundingBoxWithStroke();
					
					invalidateParentSizeAndDisplayList();
					break;
			}
		}
		
		override public function set stroke(value:IStroke):void
		{
			super.stroke = value;
			clearCachedBoundingBoxWithStroke();
		}
	}
	
}
class PathSegmentsCollection
{
	public function PathSegmentsCollection(value:String)
	{
		if (!value)
		{
			_segments = new Vector.<PathSegment>();
			return;
		}
		
		var newSegments:Vector.<PathSegment> = new Vector.<PathSegment>();
		var charCount:int = value.length;
		var c:Number; 
		var useRelative:Boolean;
		var prevIdentifier:Number = 0;
		var prevX:Number = 0;
		var prevY:Number = 0;
		var lastMoveX:Number = 0;
		var lastMoveY:Number = 0;
		var x:Number;
		var y:Number;
		var controlX:Number;
		var controlY:Number;
		var control2X:Number;
		var control2Y:Number;
		var lastMoveSegmentIndex:int = -1;
		
		_dataLength = charCount;
		_charPos = 0;
		while (true)
		{
			
			skipWhiteSpace(value);
			if (_charPos >= charCount)
				break;
			c = value.charCodeAt(_charPos++);
			if ((c >= 0x30 && c < 0x3A) ||   
				(c == 0x2B || c == 0x2D) ||  
				(c == 0x2E))                 
			{
				c = prevIdentifier;
				_charPos--;
			}
			else if (c >= 0x41 && c <= 0x56) 
				useRelative = false;
			else if (c >= 0x61 && c <= 0x7A) 
				useRelative = true;
			
			switch(c)
			{
				case 0x63:  
				case 0x43:  
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative,  prevY, value);
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY, 
						control2X, control2Y,
						x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x63;
					
					break;
				
				case 0x6D:  
				case 0x4D:  
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new MoveSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = (c == 0x6D) ? 0x6C : 0x4C; 
					var curSegmentIndex:int = newSegments.length - 1;
					if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
						newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
					{
						
						newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
						curSegmentIndex++;
					}
					
					lastMoveSegmentIndex = curSegmentIndex;
					lastMoveX = x;
					lastMoveY = y;
					break;
				
				case 0x6C:  
				case 0x4C:  
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x6C;
					break;
				
				case 0x68:  
				case 0x48:  
					x = getNumber(useRelative, prevX, value);
					y = prevY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x68;
					break;
				
				case 0x76:  
				case 0x56:  
					x = prevX;
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x76;
					break;
				
				case 0x71:  
				case 0x51:  
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x71;
					break;
				
				case 0x74:  
				case 0x54:  
					
					if (prevIdentifier == 0x74 || prevIdentifier == 0x71) 
					{
						controlX = prevX + (prevX - controlX);
						controlY = prevY + (prevY - controlY);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x74;
					
					break;
				
				case 0x73:  
				case 0x53:  
					if (prevIdentifier == 0x73 || prevIdentifier == 0x63) 
					{
						controlX = prevX + (prevX - control2X);
						controlY = prevY + (prevY - control2Y);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY,
						control2X, control2Y, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x73;
					
					break;
				
				case 0x7A:  
				case 0x5A:  
					x = lastMoveX;
					y = lastMoveY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x7A;
					
					break;
				
				default:
					
					_segments = new Vector.<PathSegment>();
					return;
			}
		}
		curSegmentIndex = newSegments.length;
		if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
			newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
		{
			
			newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
			curSegmentIndex++;
		}
		
		_segments = newSegments;
	}
	
	private var _segments:Vector.<PathSegment>;
	
	public function get data():Vector.<PathSegment>
	{
		return _segments;
	}
	
	private var _bounds:Rectangle;
	
	public function getBounds():Rectangle
	{
		if (_bounds)
			return _bounds;
		_bounds = new Rectangle(0, 0, 1, 1);
		_bounds = getBoundingBox(1, 1, null );
		return _bounds;
	}
	
	public function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
	{
		var naturalBounds:Rectangle = getBounds();
		var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
		var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
		
		var prevSegment:PathSegment;
		var pathBBox:Rectangle;
		var count:int = _segments.length;
		
		for (var i:int = 0; i < count; i++)
		{
			var segment:PathSegment = _segments[i];
			pathBBox = segment.getBoundingBox(prevSegment, sx, sy, m, pathBBox);
			prevSegment = segment;
		}
		if (!pathBBox)
		{
			var x:Number = m ? m.tx : 0;
			var y:Number = m ? m.ty : 0;
			pathBBox = new Rectangle(x, y);
		}
		return pathBBox;
	}
	
	public function generateGraphicsPath(graphicsPath:GraphicsPath,
										 tx:Number, 
										 ty:Number, 
										 sx:Number, 
										 sy:Number):void
	{
		graphicsPath.commands = null;
		graphicsPath.data = null;
		graphicsPath.moveTo(tx, ty);
		
		var curSegment:PathSegment;
		var prevSegment:PathSegment;
		var count:int = _segments.length;
		for (var i:int = 0; i < count; i++)
		{
			prevSegment = curSegment;
			curSegment = _segments[i];
			curSegment.draw(graphicsPath, tx, ty, sx, sy, prevSegment);
		}
	}
	
	private var _charPos:int = 0;
	
	private var _dataLength:int = 0;
	
	private function skipWhiteSpace(data:String):void
	{
		while (_charPos < _dataLength)
		{
			var c:Number = data.charCodeAt(_charPos);
			if (c != 0x20 && 
				c != 0x2C && 
				c != 0xD  && 
				c != 0x9  && 
				c != 0xA)    
			{
				break;
			}
			_charPos++;
		}
	}
	
	private function getNumber(useRelative:Boolean, offset:Number, value:String):Number
	{
		skipWhiteSpace(value); 
		if (_charPos >= _dataLength)
			return NaN;
		var numberStart:int = _charPos;
		var hasSignCharacter:Boolean = false;
		var hasDigits:Boolean = false;
		var c:Number = value.charCodeAt(_charPos);
		if (c == 0x2B || c == 0x2D) 
		{
			hasSignCharacter = true;
			_charPos++;
		}
		var dotIndex:int = -1;
		while (_charPos < _dataLength)
		{
			c = value.charCodeAt(_charPos);
			
			if (c >= 0x30 && c < 0x3A) 
			{
				hasDigits = true;
			}
			else if (c == 0x2E && dotIndex == -1) 
			{
				dotIndex = _charPos;
			}
			else
				break;
			
			_charPos++;
		}
		if (!hasDigits)
		{
			
			_charPos = _dataLength;
			return NaN;
		}
		if (c == 0x2E)
			_charPos--;
		var numberEnd:int = _charPos;
		if (c == 0x45 || c == 0x65)
		{
			_charPos++;
			if (_charPos < _dataLength)
			{            
				c = value.charCodeAt(_charPos);
				if (c == 0x2B || c == 0x2D)
					_charPos++;
			}
			var digitStart:int = _charPos;
			while (_charPos < _dataLength)
			{
				c = value.charCodeAt(_charPos);
				if (!(c >= 0x30 && c < 0x3A))
				{
					break;
				}
				
				_charPos++;
			}
			if (digitStart < _charPos)
				numberEnd = _charPos; 
			else
				_charPos = numberEnd; 
		}
		
		var subString:String = value.substr(numberStart, numberEnd - numberStart);
		var result:Number = parseFloat(subString);
		if (isNaN(result))
		{
			
			_charPos = _dataLength;
			return NaN;
		}
		_charPos = numberEnd;
		return useRelative ? result + offset : result;
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Rectangle;

class PathSegment extends Object
{
	public function PathSegment(_x:Number = 0, _y:Number = 0)
	{
		super();
		x = _x;  
		y = _y; 
	}   
	public var x:Number = 0;
	public var y:Number = 0;
	public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		
	}
	public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		
		return rect;
	}
	public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		result.x = 0;
		result.y = 0;
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class LineSegment extends PathSegment
{
	public function LineSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.lineTo(dx + x*sx, dy + y*sy);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		pt = MatrixUtil.transformPoint(x * sx, y * sy, m);
		var x1:Number = pt.x;
		var y1:Number = pt.y;
		if (prev != null && !(prev is MoveSegment))
			return MatrixUtil.rectUnion(x1, y1, x1, y1, rect); 
		
		var pt:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m);
		var x2:Number = pt.x;
		var y2:Number = pt.y;
		
		return MatrixUtil.rectUnion(Math.min(x1, x2), Math.min(y1, y2),
			Math.max(x1, x2), Math.max(y1, y2), rect); 
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(x * sx, y * sy, m);
		
		result.x = pt1.x - pt0.x;
		result.y = pt1.y - pt0.y;
	}
}

import flash.display.GraphicsPath;

class MoveSegment extends PathSegment
{
	public function MoveSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.moveTo(dx+x*sx, dy+y*sy);
	}
}

import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


class CubicBezierSegment extends PathSegment
{
	public function CubicBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0,
		_control2X:Number = 0, _control2Y:Number = 0,
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
		control2X = _control2X;
		control2Y = _control2Y;
	}   
	
	private var _qPts:QuadraticPoints;
	
	public var control1X:Number = 0;
	
	public var control1Y:Number = 0;
	
	public var control2X:Number = 0;
	
	public var control2Y:Number = 0;
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment):void
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		graphicsPath.curveTo(dx + qPts.control1.x*sx, dy+qPts.control1.y*sy, dx+qPts.anchor1.x*sx, dy+qPts.anchor1.y*sy);
		graphicsPath.curveTo(dx + qPts.control2.x*sx, dy+qPts.control2.y*sy, dx+qPts.anchor2.x*sx, dy+qPts.anchor2.y*sy);
		graphicsPath.curveTo(dx + qPts.control3.x*sx, dy+qPts.control3.y*sy, dx+qPts.anchor3.x*sx, dy+qPts.anchor3.y*sy);
		graphicsPath.curveTo(dx + qPts.control4.x*sx, dy+qPts.control4.y*sy, dx+qPts.anchor4.x*sx, dy+qPts.anchor4.y*sy);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		rect = MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			qPts.control1.x, qPts.control1.y,
			qPts.anchor1.x, qPts.anchor1.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor1.x, qPts.anchor1.y,
			qPts.control2.x, qPts.control2.y,
			qPts.anchor2.x, qPts.anchor2.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor2.x, qPts.anchor2.y,
			qPts.control3.x, qPts.control3.y,
			qPts.anchor3.x, qPts.anchor3.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor3.x, qPts.anchor3.y,
			qPts.control4.x, qPts.control4.y,
			qPts.anchor4.x, qPts.anchor4.y,
			sx, sy, m, rect); 
		return rect;
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(qPts.control1.x * sx, qPts.control1.y * sy, m).clone();
		var pt2:Point = MatrixUtil.transformPoint(qPts.anchor1.x * sx, qPts.anchor1.y * sy, m).clone();
		var pt3:Point = MatrixUtil.transformPoint(qPts.control2.x * sx, qPts.control2.y * sy, m).clone();
		var pt4:Point = MatrixUtil.transformPoint(qPts.anchor2.x * sx, qPts.anchor2.y * sy, m).clone();
		var pt5:Point = MatrixUtil.transformPoint(qPts.control3.x * sx, qPts.control3.y * sy, m).clone();
		var pt6:Point = MatrixUtil.transformPoint(qPts.anchor3.x * sx, qPts.anchor3.y * sy, m).clone();
		var pt7:Point = MatrixUtil.transformPoint(qPts.control4.x * sx, qPts.control4.y * sy, m).clone();
		var pt8:Point = MatrixUtil.transformPoint(qPts.anchor4.x * sx, qPts.anchor4.y * sy, m).clone();
		
		if (start)
		{
			QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
			
			if (result.x == 0 && result.y == 0)
			{
				
				QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt3.x, pt3.y, pt4.x, pt4.y, start, result);
				if (result.x == 0 && result.y == 0)
				{
					
					QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt5.x, pt5.y, pt6.x, pt6.y, start, result);
					if (result.x == 0 && result.y == 0)
						
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
				}
			}
		}
		else
		{
			QuadraticBezierSegment.getQTangent(pt6.x, pt6.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
			
			if (result.x == 0 && result.y == 0)
			{
				
				QuadraticBezierSegment.getQTangent(pt4.x, pt4.y, pt5.x, pt5.y, pt8.x, pt8.y, start, result);
				if (result.x == 0 && result.y == 0)
				{
					
					QuadraticBezierSegment.getQTangent(pt2.x, pt2.y, pt3.x, pt3.y, pt8.x, pt8.y, start, result);
					if (result.x == 0 && result.y == 0)
						
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt8.x, pt8.y, start, result);
				}
			}
		}
	}   
	
	private function getQuadraticPoints(prev:PathSegment):QuadraticPoints
	{
		if (_qPts)
			return _qPts;
		
		var p1:Point = new Point(prev ? prev.x : 0, prev ? prev.y : 0);
		var p2:Point = new Point(x, y);
		var c1:Point = new Point(control1X, control1Y);     
		var c2:Point = new Point(control2X, control2Y);
		var PA:Point = Point.interpolate(c1, p1, 3/4);
		var PB:Point = Point.interpolate(c2, p2, 3/4);
		var dx:Number = (p2.x - p1.x) / 16;
		var dy:Number = (p2.y - p1.y) / 16;
		
		_qPts = new QuadraticPoints;
		_qPts.control1 = Point.interpolate(c1, p1, 3/8);
		_qPts.control2 = Point.interpolate(PB, PA, 3/8);
		_qPts.control2.x -= dx;
		_qPts.control2.y -= dy;
		_qPts.control3 = Point.interpolate(PA, PB, 3/8);
		_qPts.control3.x += dx;
		_qPts.control3.y += dy;
		_qPts.control4 = Point.interpolate(c2, p2, 3/8);
		_qPts.anchor1 = Point.interpolate(_qPts.control1, _qPts.control2, 0.5); 
		_qPts.anchor2 = Point.interpolate(PA, PB, 0.5); 
		_qPts.anchor3 = Point.interpolate(_qPts.control3, _qPts.control4, 0.5); 
		_qPts.anchor4 = p2;
		
		return _qPts;      
	}
}


import flash.geom.Point;

class QuadraticPoints
{
	public var control1:Point;
	public var anchor1:Point;
	public var control2:Point;
	public var anchor2:Point;
	public var control3:Point;
	public var anchor3:Point;
	public var control4:Point;
	public var anchor4:Point;
	public function QuadraticPoints()
	{
		super();
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.flexlite.domUI.utils.MatrixUtil;

class QuadraticBezierSegment extends PathSegment
{
	public function QuadraticBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0, 
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
	}   
	
	public var control1X:Number = 0;
	
	public var control1Y:Number = 0;
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.curveTo(dx+control1X*sx, dy+control1Y*sy, dx+x*sx, dy+y*sy);
	}
	
	static public function getQTangent(x0:Number, y0:Number,
									   x1:Number, y1:Number,
									   x2:Number, y2:Number,
									   start:Boolean,
									   result:Point):void
	{
		if (start)
		{
			if (x0 == x1 && y0 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x1 - x0;
				result.y = y1 - y0;
			}
		}
		else
		{
			if (x2 == x1 && y2 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x2 - x1;
				result.y = y2 - y1;
			}
		}
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(control1X * sx, control1Y * sy, m).clone();;
		var pt2:Point = MatrixUtil.transformPoint(x * sx, y * sy, m).clone();
		
		getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		return MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			control1X, control1Y, x, y, sx, sy, m, rect);
	}
}
=======
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.graphic.IStroke;
	import org.flexlite.domUI.primitives.supportClasses.FilledElement;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * Path 类是绘制一系列路径段的填充图形元素。
	 * 在矢量图形中，路径是按直线段或曲线段连接的一系列点。
	 * 这些线在一起形成一个图像。您可以使用 Path 
	 * 类来定义通过一组线段构造的一个复杂矢量形状。 
	 * @author DOM
	 */	
	public class Path extends FilledElement
	{
		public function Path()
		{
			super();
		}
		
		private var graphicsPathChanged:Boolean = true;
		
		private var segments:PathSegmentsCollection;
		
		private var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
		
		private var _data:String;
		/**
		 * 包含路径段的压缩表示的字符串。
		 * 这是设置 segments 属性的一种替代方式。
		 * 设置此属性会覆盖 segments array 属性中存储的任何值。 
		 */		
		public function set data(value:String):void
		{
			if (_data == value)
				return;
			
			segments = new PathSegmentsCollection(value);
			
			graphicsPathChanged = true;
			clearCachedBoundingBoxWithStroke();
			invalidateSize();
			invalidateDisplayList();
			
			_data = value;
		}
		
		public function get data():String 
		{
			return _data;
		}
		
		private var _winding:String = GraphicsPathWinding.EVEN_ODD;
		/**
		 * 相交或重叠路径段的填充规则。
		 * 可能的值有 GraphicsPathWinding.EVEN_ODD 或 GraphicsPathWinding.NON_ZERO。
		 */		
		public function set winding(value:String):void
		{
			if (_winding != value)
			{
				_winding = value;
				graphicsPathChanged = true;
				invalidateDisplayList();
			} 
		}
		
		public function get winding():String 
		{
			return _winding; 
		}
		
		private function getBounds():Rectangle
		{
			return segments ? segments.getBounds() : new Rectangle();
		}
		
		override protected function measure():void
		{
			var bounds:Rectangle = getBounds();
			measuredWidth = bounds.width;
			measuredHeight = bounds.height;
			measuredX = bounds.left;
			measuredY = bounds.top;
		}
		
		private var _boundingBoxCached:Rectangle;
		
		private var _boundingBoxMatrixCached:Matrix;
		
		private var _boundingBoxWidthParamCached:Number;
		
		private var _boundingBoxHeightParamCached:Number;
		
		private var _boundingBoxX:Number;
		
		private var _boundingBoxY:Number;
		
		private function getBoundingBoxWithStroke(width:Number, height:Number, m:Matrix):Rectangle
		{
			if (_boundingBoxCached && 
				_boundingBoxWidthParamCached == width && 
				_boundingBoxHeightParamCached == height)
			{
				
				if (!m && !_boundingBoxMatrixCached)
				{
					_boundingBoxCached.x = _boundingBoxX;
					_boundingBoxCached.y = _boundingBoxY;
					return _boundingBoxCached;
				}
				else if (m && _boundingBoxMatrixCached &&
					m.a == _boundingBoxMatrixCached.a &&
					m.b == _boundingBoxMatrixCached.b &&
					m.c == _boundingBoxMatrixCached.c &&
					m.d == _boundingBoxMatrixCached.d)
				{
					_boundingBoxCached.x = _boundingBoxX + m.tx;
					_boundingBoxCached.y = _boundingBoxY + m.ty;
					return _boundingBoxCached;
				}
			}
			if (m)
			{
				_boundingBoxMatrixCached = m.clone();
				_boundingBoxMatrixCached.tx = 0;
				_boundingBoxMatrixCached.ty = 0;
			}
			else
				_boundingBoxMatrixCached = null;
			_boundingBoxWidthParamCached = width;
			_boundingBoxHeightParamCached = height;
			
			_boundingBoxCached = computeBoundsWithStroke(_boundingBoxWidthParamCached,
				_boundingBoxHeightParamCached,
				m);
			_boundingBoxX = _boundingBoxCached.x - (m ? m.tx : 0);
			_boundingBoxY = _boundingBoxCached.y - (m ? m.ty : 0);
			
			return _boundingBoxCached; 
		}
		
		static private var tangent:Point = new Point();
		
		private function tangentIsValid(prevSegment:PathSegment, curSegment:PathSegment,
										sx:Number, sy:Number, m:Matrix):Boolean
		{
			curSegment.getTangent(prevSegment, true, sx, sy, m, tangent);
			return (tangent.x != 0 || tangent.y != 0);
		}
		
		private function computeBoundsWithStroke(width:Number,
												 height:Number,
												 m:Matrix):Rectangle
		{
			var naturalBounds:Rectangle = getBounds();
			var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
			var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
			var pathBBox:Rectangle;
			if (!m || MatrixUtil.isDeltaIdentity(m) || !this.segments)
			{
				pathBBox = new Rectangle(naturalBounds.x * sx,
					naturalBounds.y * sy,
					naturalBounds.width * sx,
					naturalBounds.height * sy);
				if (m)
					pathBBox.offset(m.tx, m.ty);
			}
			else
			{
				pathBBox = this.segments.getBoundingBox(width, height, m);
			}
			var strokeSettings:IStroke = this.stroke;
			if (!strokeSettings || !this.segments)
				return pathBBox;
			var strokeExtents:Rectangle = getStrokeExtents();
			pathBBox.inflate(strokeExtents.right, strokeExtents.bottom);
			
			var seg:Vector.<PathSegment> = segments.data;
			
			if (strokeSettings.joints != "miter" || seg.length < 2)
			{
				return pathBBox;
			}
			var halfWeight:Number = strokeExtents.width / 2;
			var miterLimit:Number = Math.max(1, strokeSettings.miterLimit);
			var count:int = seg.length;
			var start:int = 0;
			var end:int;
			var lastMoveX:Number = 0;
			var lastMoveY:Number = 0;
			var lastOpenSegment:int = 0;
			
			while (true)
			{
				
				while (start < count && !(seg[start] is MoveSegment))
				{
					var prevSegment:PathSegment = start > 0 ? seg[start - 1] : null;
					if (tangentIsValid(prevSegment, seg[start], sx, sy, m))
						break;
					start++;
				}
				
				if (start >= count)
					break; 
				
				var startSegment:PathSegment = seg[start];
				if (startSegment is MoveSegment)
				{
					
					lastOpenSegment = start + 1;
					lastMoveX = startSegment.x;
					lastMoveY = startSegment.y;
					start++;
					continue;
				}
				if ((start == count - 1 || seg[start + 1] is MoveSegment) && 
					startSegment.x == lastMoveX &&
					startSegment.y == lastMoveY)
				{
					end = lastOpenSegment;
				}
				else
					end = start + 1;
				while (end < count && !(seg[end] is MoveSegment))
				{
					if (tangentIsValid(startSegment, seg[end], sx, sy, m))
						break;
					end++;
				}
				
				if (end >= count)
					break; 
				
				var endSegment:PathSegment = seg[end];
				
				if (!(endSegment is MoveSegment))
				{
					addMiterLimitStrokeToBounds(start > 0 ? seg[start - 1] : null, 
						startSegment,
						endSegment, 
						miterLimit,
						halfWeight,
						sx,
						sy,
						m,
						pathBBox);
				}
				start = start > end ? start + 1 : end;
			}
			return pathBBox;
		}
		
		override protected function getStrokeBounds():Rectangle
		{
			return getBoundingBoxWithStroke(width, height, null);
		}
		
		override protected function get needsDisplayObject():Boolean
		{
			return super.needsDisplayObject || (stroke && stroke.joints == "miter");
		}
		
		private function addMiterLimitStrokeToBounds(segment0:PathSegment,
													 segment1:PathSegment,
													 segment2:PathSegment,
													 miterLimit:Number,
													 weight:Number,
													 sx:Number,
													 sy:Number,
													 m:Matrix,
													 result:Rectangle):void
		{
			
			var pt:Point;
			pt = MatrixUtil.transformPoint(segment1.x * sx, segment1.y * sy, m).clone();
			var jointX:Number = pt.x;
			var jointY:Number = pt.y;
			var t0:Point = new Point();
			segment1.getTangent(segment0, false , sx, sy, m, t0);
			var t1:Point = new Point();
			segment2.getTangent(segment1, true , sx, sy, m, t1);
			if (t0.length == 0 || t1.length == 0)
				return;
			t0.normalize(1);
			t0.x = -t0.x;
			t0.y = -t0.y;
			t1.normalize(1);
			var halfT0T1:Point = new Point( (t1.x - t0.x) * 0.5, (t1.y - t0.y) * 0.5);
			var sinHalfAlpha:Number = halfT0T1.length;
			if (Math.abs(sinHalfAlpha) < 1.0E-9)
			{
				return; 
			}
			var bisect:Point = new Point( -0.5 * (t0.x + t1.x), -0.5 * (t0.y + t1.y) );
			if (bisect.length == 0)
			{
				
				return;
			}
			if (sinHalfAlpha == 0 || miterLimit < 1 / sinHalfAlpha)
			{
				var bisectLength:Number = bisect.length;
				bisect.normalize(1);
				
				halfT0T1.normalize((weight - miterLimit * weight * sinHalfAlpha) / bisectLength);
				
				var pt0:Point = new Point(jointX + miterLimit * weight * bisect.x + halfT0T1.x,
					jointY + miterLimit * weight * bisect.y + halfT0T1.y);
				
				var pt1:Point = new Point(jointX + miterLimit * weight * bisect.x - halfT0T1.x,
					jointY + miterLimit * weight * bisect.y - halfT0T1.y);
				MatrixUtil.rectUnion(pt0.x, pt0.y, pt0.x, pt0.y, result);
				MatrixUtil.rectUnion(pt1.x, pt1.y, pt1.x, pt1.y, result);
			}
			else
			{
				
				bisect.normalize(1);
				var strokeTip:Point = new Point(jointX + bisect.x * weight / sinHalfAlpha,
					jointY + bisect.y * weight / sinHalfAlpha);
				MatrixUtil.rectUnion(strokeTip.x, strokeTip.y, strokeTip.x, strokeTip.y, result);
			}
		}
		
		override protected function transformWidthForLayout(width:Number,
															height:Number,
															postLayoutTransform:Boolean = true):Number
		{
			var m:Matrix = getComplexMatrix(postLayoutTransform);
			
			if (!m && !stroke)
				return width;
			return getBoundingBoxWithStroke(width, height, m).width;
		}
		
		override protected function transformHeightForLayout(width:Number,
															 height:Number,
															 postLayoutTransform:Boolean = true):Number
		{
			var m:Matrix = getComplexMatrix(postLayoutTransform);
			
			if (!m && !stroke)
				return height;
			return getBoundingBoxWithStroke(width, height, m).height;
		}
		
		private function getBoundsAtSize(width:Number, height:Number, m:Matrix):Rectangle
		{
			var strokeExtents:Rectangle = null;
			
			if (!isNaN(width))
			{
				strokeExtents = getStrokeExtents(true );
				width -= strokeExtents.width;
			}
			
			if (!isNaN(height))
			{
				if (!strokeExtents)
					strokeExtents = getStrokeExtents(true );
				height -= strokeExtents.height;
			}
			
			var newWidth:Number = preferredWidthPreTransform();
			var newHeight:Number = preferredHeightPreTransform();
			if (m)
			{
				var newSize:Point = MatrixUtil.fitBounds(width,
					height,
					m,
					explicitWidth,
					explicitHeight,
					newWidth,
					newHeight,
					minWidth, minHeight,
					maxWidth, maxHeight);
				
				if (newSize)
				{
					newWidth = newSize.x;
					newHeight = newSize.y;
				}
				else
				{
					newWidth = minWidth;
					newHeight = minHeight;
				}
			}
			
			return getBoundingBoxWithStroke(newWidth, newHeight, m);
		}
		
		override public function get preferredX():Number
		{
			var m:Matrix = getComplexMatrix();
			return getBoundsAtSize(NaN, NaN, m).x + (m ? 0 : this.x);
		}
		
		override public function get preferredY():Number
		{
			var m:Matrix = getComplexMatrix();
			return getBoundsAtSize(NaN, NaN, m).y + (m ? 0 : this.y);
		}
		
		override public function get layoutBoundsX():Number
		{
			var m:Matrix = getComplexMatrix();
			
			if (!m && !stroke)
			{
				if (measuredX == 0)
					return this.x;
				var naturalBounds:Rectangle = getBounds();
				var sx:Number = (naturalBounds.width == 0 || width == 0) ? 1 : width / naturalBounds.width;
				return this.x + measuredX * sx;
			}
			return getBoundingBoxWithStroke(width, height, m).x + (m ? 0 : this.x);
		}
		
		override public function get layoutBoundsY():Number
		{
			var m:Matrix = getComplexMatrix();
			
			if (!m && !stroke)
			{
				if (measuredY == 0)
					return this.y;
				var naturalBounds:Rectangle = getBounds();
				var sy:Number = (naturalBounds.height == 0 || height == 0) ? 1 : height / naturalBounds.height;
				return this.y + measuredY * sy;
			}
			return getBoundingBoxWithStroke(width, height, m).y + (m ? 0 : this.y);
		}
		
		private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix):void
		{
			var size:Point = fitLayoutBoundsIterative(width, height, m);
			if (!size && !isNaN(width) && !isNaN(height))
			{
				
				var size1:Point = fitLayoutBoundsIterative(NaN, height, m);
				var size2:Point = fitLayoutBoundsIterative(width, NaN, m);
				if (size1 && getBoundingBoxWithStroke(size1.x, size1.y, m).width > width)
					size1 = null;
				if (size2 && getBoundingBoxWithStroke(size2.x, size2.y, m).height > height)
					size2 = null;
				if (size1 && size2)
				{
					var n:Point = getBounds().size;
					var pickSize1:Boolean = Math.abs( n.x * size1.y - n.y * size1.x ) * size2.y < 
						Math.abs( n.x * size2.y - n.y * size2.x ) * size1.y;
					
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
				
				var transformedBounds:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, m);
				
				var widthDistance:Number = isNaN(width) ? 0 : width - transformedBounds.width;
				var heightDistance:Number = isNaN(height) ? 0 : height - transformedBounds.height;
				if (Math.abs(widthDistance) < 0.1 && Math.abs(heightDistance) < 0.1)
				{
					return new Point(newWidth, newHeight);
				}
				fitWidth += widthDistance * 0.5;
				fitHeight += heightDistance * 0.5;
				
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
		
		override public function setLayoutBoundsSize(width:Number, height:Number):void
		{
			if (isNaN(width) && isNaN(height))     
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			var m:Matrix = getComplexMatrix();
			if (m)
			{
				setLayoutBoundsTransformed(width, height, m);
				return;
			}
			
			if (!stroke || stroke.joints != "miter") 
			{
				super.setLayoutBoundsSize(width, height);
				return;
			}
			var newWidth:Number = preferredWidthPreTransform();
			var newHeight:Number = preferredHeightPreTransform();
			var bestWidth:Number;
			var bestHeight:Number;
			var bestScore:Number;
			if (!isNaN(width) && !isNaN(height))
			{
				var size:Point = fitLayoutBoundsIterative(width, height, new Matrix());
				if (size)
				{
					setActualSize(size.x, size.y);
					return;
				}
				newWidth = getBounds().width;
				newHeight = getBounds().height;
				bestWidth = this.minWidth;
				bestHeight = this.minHeight;
				bestScore = (width - bestWidth) * (width - bestWidth) + (height - bestHeight) * (height - bestHeight);
			}
			
			var i:int = 0;
			while (i++ < 150)
			{
				var boundsWithStroke:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, null);
				
				var widthProximity:Number = 0;
				var heightProximity:Number = 0;
				if (!isNaN(width))
					widthProximity = Math.abs(width - boundsWithStroke.width);
				if (!isNaN(height))
					heightProximity = Math.abs(height - boundsWithStroke.height);
				
				if (!isNaN(width) && !isNaN(height))
				{
					var score:Number = (width - boundsWithStroke.width) * (width - boundsWithStroke.width) + 
						(height - boundsWithStroke.height) * (height - boundsWithStroke.height);
					
					if (!isNaN(score) && score < bestScore && boundsWithStroke.width <= width && boundsWithStroke.height <= height)
					{
						bestScore = score;
						bestWidth = newWidth;
						bestHeight = newHeight;
					}
				}
				if (widthProximity < 1e-5 && heightProximity < 1e-5)
				{
					setActualSize(newWidth, newHeight);
					return;
				}
				
				var boundsWithoutStroke:Rectangle = segments.getBoundingBox(newWidth, newHeight, null);
				var strokeWidth:Number = boundsWithStroke.width - boundsWithoutStroke.width;
				var strokeHeight:Number = boundsWithStroke.height - boundsWithoutStroke.height;
				
				if (!isNaN(width))
					newWidth = width - strokeWidth;
				
				if (!isNaN(height))
					newHeight = height - strokeHeight;
			}
			
			setActualSize(bestWidth, bestHeight);
		}
		
		override protected function beginDraw(g:Graphics):void
		{
			var naturalBounds:Rectangle = getBounds();
			var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
			var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
			
			var origin:Point = new Point(drawX, drawY);
			var bounds:Rectangle = new Rectangle(
				drawX + measuredX * sx,
				drawY + measuredY * sy,
				width, 
				height);
			if (stroke)
			{
				var strokeBounds:Rectangle = getStrokeBounds();
				strokeBounds.offsetPoint(origin);
				stroke.apply(g, strokeBounds, origin);
			}
			else
			{
				g.lineStyle();
			}
			
			if (fill)
				fill.begin(g, bounds, origin);
		}
		
		private var _drawBounds:Rectangle = new Rectangle(); 
		
		override protected function draw(g:Graphics):void
		{
			if (drawX !=  _drawBounds.x || drawY !=  _drawBounds.y ||
				width !=  _drawBounds.width || height !=  _drawBounds.height)
			{
				graphicsPathChanged = true;
				_drawBounds.x = drawX;
				_drawBounds.y = drawY;
				_drawBounds.width = width;
				_drawBounds.height = height;            
			}
			
			if (graphicsPathChanged)
			{
				var rcBounds:Rectangle = getBounds();
				var sx:Number = rcBounds.width == 0 ? 1 : width / rcBounds.width;
				var sy:Number = rcBounds.height == 0 ? 1 : height / rcBounds.height;
				if (segments)
					segments.generateGraphicsPath(graphicsPath, drawX, drawY, sx, sy);
				graphicsPathChanged = false;
			}
			
			g.drawPath(graphicsPath.commands, graphicsPath.data, winding);
		}
		
		override protected function endDraw(g:Graphics):void
		{
			g.lineStyle();
			super.endDraw(g);
		} 
		
		override protected function invalidateDisplayObjectSharing():void
		{
			graphicsPathChanged = true;
			super.invalidateDisplayObjectSharing();
		}
		
		private function clearCachedBoundingBoxWithStroke():void
		{
			_boundingBoxCached = null;
			_boundingBoxMatrixCached = null;
		}
		
		override protected function stroke_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			super.stroke_propertyChangeHandler(event);
			switch (event.property)
			{
				case "weight":
				case "scaleMode":
				case "joints":
				case "miterLimit":
					clearCachedBoundingBoxWithStroke();
					
					invalidateParentSizeAndDisplayList();
					break;
			}
		}
		
		override public function set stroke(value:IStroke):void
		{
			super.stroke = value;
			clearCachedBoundingBoxWithStroke();
		}
	}
	
}
class PathSegmentsCollection
{
	public function PathSegmentsCollection(value:String)
	{
		if (!value)
		{
			_segments = new Vector.<PathSegment>();
			return;
		}
		
		var newSegments:Vector.<PathSegment> = new Vector.<PathSegment>();
		var charCount:int = value.length;
		var c:Number; 
		var useRelative:Boolean;
		var prevIdentifier:Number = 0;
		var prevX:Number = 0;
		var prevY:Number = 0;
		var lastMoveX:Number = 0;
		var lastMoveY:Number = 0;
		var x:Number;
		var y:Number;
		var controlX:Number;
		var controlY:Number;
		var control2X:Number;
		var control2Y:Number;
		var lastMoveSegmentIndex:int = -1;
		
		_dataLength = charCount;
		_charPos = 0;
		while (true)
		{
			
			skipWhiteSpace(value);
			if (_charPos >= charCount)
				break;
			c = value.charCodeAt(_charPos++);
			if ((c >= 0x30 && c < 0x3A) ||   
				(c == 0x2B || c == 0x2D) ||  
				(c == 0x2E))                 
			{
				c = prevIdentifier;
				_charPos--;
			}
			else if (c >= 0x41 && c <= 0x56) 
				useRelative = false;
			else if (c >= 0x61 && c <= 0x7A) 
				useRelative = true;
			
			switch(c)
			{
				case 0x63:  
				case 0x43:  
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative,  prevY, value);
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY, 
						control2X, control2Y,
						x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x63;
					
					break;
				
				case 0x6D:  
				case 0x4D:  
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new MoveSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = (c == 0x6D) ? 0x6C : 0x4C; 
					var curSegmentIndex:int = newSegments.length - 1;
					if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
						newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
					{
						
						newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
						curSegmentIndex++;
					}
					
					lastMoveSegmentIndex = curSegmentIndex;
					lastMoveX = x;
					lastMoveY = y;
					break;
				
				case 0x6C:  
				case 0x4C:  
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x6C;
					break;
				
				case 0x68:  
				case 0x48:  
					x = getNumber(useRelative, prevX, value);
					y = prevY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x68;
					break;
				
				case 0x76:  
				case 0x56:  
					x = prevX;
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x76;
					break;
				
				case 0x71:  
				case 0x51:  
					controlX = getNumber(useRelative, prevX, value);
					controlY = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x71;
					break;
				
				case 0x74:  
				case 0x54:  
					
					if (prevIdentifier == 0x74 || prevIdentifier == 0x71) 
					{
						controlX = prevX + (prevX - controlX);
						controlY = prevY + (prevY - controlY);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x74;
					
					break;
				
				case 0x73:  
				case 0x53:  
					if (prevIdentifier == 0x73 || prevIdentifier == 0x63) 
					{
						controlX = prevX + (prevX - control2X);
						controlY = prevY + (prevY - control2Y);
					}
					else
					{
						controlX = prevX;
						controlY = prevY;
					}
					
					control2X = getNumber(useRelative, prevX, value);
					control2Y = getNumber(useRelative, prevY, value);
					x = getNumber(useRelative, prevX, value);
					y = getNumber(useRelative, prevY, value);
					newSegments.push(new CubicBezierSegment(controlX, controlY,
						control2X, control2Y, x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x73;
					
					break;
				
				case 0x7A:  
				case 0x5A:  
					x = lastMoveX;
					y = lastMoveY;
					newSegments.push(new LineSegment(x, y));
					prevX = x;
					prevY = y;
					prevIdentifier = 0x7A;
					
					break;
				
				default:
					
					_segments = new Vector.<PathSegment>();
					return;
			}
		}
		curSegmentIndex = newSegments.length;
		if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
			newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
		{
			
			newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
			curSegmentIndex++;
		}
		
		_segments = newSegments;
	}
	
	private var _segments:Vector.<PathSegment>;
	
	public function get data():Vector.<PathSegment>
	{
		return _segments;
	}
	
	private var _bounds:Rectangle;
	
	public function getBounds():Rectangle
	{
		if (_bounds)
			return _bounds;
		_bounds = new Rectangle(0, 0, 1, 1);
		_bounds = getBoundingBox(1, 1, null );
		return _bounds;
	}
	
	public function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
	{
		var naturalBounds:Rectangle = getBounds();
		var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
		var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
		
		var prevSegment:PathSegment;
		var pathBBox:Rectangle;
		var count:int = _segments.length;
		
		for (var i:int = 0; i < count; i++)
		{
			var segment:PathSegment = _segments[i];
			pathBBox = segment.getBoundingBox(prevSegment, sx, sy, m, pathBBox);
			prevSegment = segment;
		}
		if (!pathBBox)
		{
			var x:Number = m ? m.tx : 0;
			var y:Number = m ? m.ty : 0;
			pathBBox = new Rectangle(x, y);
		}
		return pathBBox;
	}
	
	public function generateGraphicsPath(graphicsPath:GraphicsPath,
										 tx:Number, 
										 ty:Number, 
										 sx:Number, 
										 sy:Number):void
	{
		graphicsPath.commands = null;
		graphicsPath.data = null;
		graphicsPath.moveTo(tx, ty);
		
		var curSegment:PathSegment;
		var prevSegment:PathSegment;
		var count:int = _segments.length;
		for (var i:int = 0; i < count; i++)
		{
			prevSegment = curSegment;
			curSegment = _segments[i];
			curSegment.draw(graphicsPath, tx, ty, sx, sy, prevSegment);
		}
	}
	
	private var _charPos:int = 0;
	
	private var _dataLength:int = 0;
	
	private function skipWhiteSpace(data:String):void
	{
		while (_charPos < _dataLength)
		{
			var c:Number = data.charCodeAt(_charPos);
			if (c != 0x20 && 
				c != 0x2C && 
				c != 0xD  && 
				c != 0x9  && 
				c != 0xA)    
			{
				break;
			}
			_charPos++;
		}
	}
	
	private function getNumber(useRelative:Boolean, offset:Number, value:String):Number
	{
		skipWhiteSpace(value); 
		if (_charPos >= _dataLength)
			return NaN;
		var numberStart:int = _charPos;
		var hasSignCharacter:Boolean = false;
		var hasDigits:Boolean = false;
		var c:Number = value.charCodeAt(_charPos);
		if (c == 0x2B || c == 0x2D) 
		{
			hasSignCharacter = true;
			_charPos++;
		}
		var dotIndex:int = -1;
		while (_charPos < _dataLength)
		{
			c = value.charCodeAt(_charPos);
			
			if (c >= 0x30 && c < 0x3A) 
			{
				hasDigits = true;
			}
			else if (c == 0x2E && dotIndex == -1) 
			{
				dotIndex = _charPos;
			}
			else
				break;
			
			_charPos++;
		}
		if (!hasDigits)
		{
			
			_charPos = _dataLength;
			return NaN;
		}
		if (c == 0x2E)
			_charPos--;
		var numberEnd:int = _charPos;
		if (c == 0x45 || c == 0x65)
		{
			_charPos++;
			if (_charPos < _dataLength)
			{            
				c = value.charCodeAt(_charPos);
				if (c == 0x2B || c == 0x2D)
					_charPos++;
			}
			var digitStart:int = _charPos;
			while (_charPos < _dataLength)
			{
				c = value.charCodeAt(_charPos);
				if (!(c >= 0x30 && c < 0x3A))
				{
					break;
				}
				
				_charPos++;
			}
			if (digitStart < _charPos)
				numberEnd = _charPos; 
			else
				_charPos = numberEnd; 
		}
		
		var subString:String = value.substr(numberStart, numberEnd - numberStart);
		var result:Number = parseFloat(subString);
		if (isNaN(result))
		{
			
			_charPos = _dataLength;
			return NaN;
		}
		_charPos = numberEnd;
		return useRelative ? result + offset : result;
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Rectangle;

class PathSegment extends Object
{
	public function PathSegment(_x:Number = 0, _y:Number = 0)
	{
		super();
		x = _x;  
		y = _y; 
	}   
	public var x:Number = 0;
	public var y:Number = 0;
	public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		
	}
	public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		
		return rect;
	}
	public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		result.x = 0;
		result.y = 0;
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class LineSegment extends PathSegment
{
	public function LineSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.lineTo(dx + x*sx, dy + y*sy);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
	{
		pt = MatrixUtil.transformPoint(x * sx, y * sy, m);
		var x1:Number = pt.x;
		var y1:Number = pt.y;
		if (prev != null && !(prev is MoveSegment))
			return MatrixUtil.rectUnion(x1, y1, x1, y1, rect); 
		
		var pt:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m);
		var x2:Number = pt.x;
		var y2:Number = pt.y;
		
		return MatrixUtil.rectUnion(Math.min(x1, x2), Math.min(y1, y2),
			Math.max(x1, x2), Math.max(y1, y2), rect); 
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(x * sx, y * sy, m);
		
		result.x = pt1.x - pt0.x;
		result.y = pt1.y - pt0.y;
	}
}

import flash.display.GraphicsPath;

class MoveSegment extends PathSegment
{
	public function MoveSegment(x:Number = 0, y:Number = 0)
	{
		super(x, y);
	}   
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.moveTo(dx+x*sx, dy+y*sy);
	}
}

import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


class CubicBezierSegment extends PathSegment
{
	public function CubicBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0,
		_control2X:Number = 0, _control2Y:Number = 0,
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
		control2X = _control2X;
		control2Y = _control2Y;
	}   
	
	private var _qPts:QuadraticPoints;
	
	public var control1X:Number = 0;
	
	public var control1Y:Number = 0;
	
	public var control2X:Number = 0;
	
	public var control2Y:Number = 0;
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment):void
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		graphicsPath.curveTo(dx + qPts.control1.x*sx, dy+qPts.control1.y*sy, dx+qPts.anchor1.x*sx, dy+qPts.anchor1.y*sy);
		graphicsPath.curveTo(dx + qPts.control2.x*sx, dy+qPts.control2.y*sy, dx+qPts.anchor2.x*sx, dy+qPts.anchor2.y*sy);
		graphicsPath.curveTo(dx + qPts.control3.x*sx, dy+qPts.control3.y*sy, dx+qPts.anchor3.x*sx, dy+qPts.anchor3.y*sy);
		graphicsPath.curveTo(dx + qPts.control4.x*sx, dy+qPts.control4.y*sy, dx+qPts.anchor4.x*sx, dy+qPts.anchor4.y*sy);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		rect = MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			qPts.control1.x, qPts.control1.y,
			qPts.anchor1.x, qPts.anchor1.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor1.x, qPts.anchor1.y,
			qPts.control2.x, qPts.control2.y,
			qPts.anchor2.x, qPts.anchor2.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor2.x, qPts.anchor2.y,
			qPts.control3.x, qPts.control3.y,
			qPts.anchor3.x, qPts.anchor3.y,
			sx, sy, m, rect); 
		
		rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor3.x, qPts.anchor3.y,
			qPts.control4.x, qPts.control4.y,
			qPts.anchor4.x, qPts.anchor4.y,
			sx, sy, m, rect); 
		return rect;
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		
		var qPts:QuadraticPoints = getQuadraticPoints(prev);
		
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(qPts.control1.x * sx, qPts.control1.y * sy, m).clone();
		var pt2:Point = MatrixUtil.transformPoint(qPts.anchor1.x * sx, qPts.anchor1.y * sy, m).clone();
		var pt3:Point = MatrixUtil.transformPoint(qPts.control2.x * sx, qPts.control2.y * sy, m).clone();
		var pt4:Point = MatrixUtil.transformPoint(qPts.anchor2.x * sx, qPts.anchor2.y * sy, m).clone();
		var pt5:Point = MatrixUtil.transformPoint(qPts.control3.x * sx, qPts.control3.y * sy, m).clone();
		var pt6:Point = MatrixUtil.transformPoint(qPts.anchor3.x * sx, qPts.anchor3.y * sy, m).clone();
		var pt7:Point = MatrixUtil.transformPoint(qPts.control4.x * sx, qPts.control4.y * sy, m).clone();
		var pt8:Point = MatrixUtil.transformPoint(qPts.anchor4.x * sx, qPts.anchor4.y * sy, m).clone();
		
		if (start)
		{
			QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
			
			if (result.x == 0 && result.y == 0)
			{
				
				QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt3.x, pt3.y, pt4.x, pt4.y, start, result);
				if (result.x == 0 && result.y == 0)
				{
					
					QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt5.x, pt5.y, pt6.x, pt6.y, start, result);
					if (result.x == 0 && result.y == 0)
						
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
				}
			}
		}
		else
		{
			QuadraticBezierSegment.getQTangent(pt6.x, pt6.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
			
			if (result.x == 0 && result.y == 0)
			{
				
				QuadraticBezierSegment.getQTangent(pt4.x, pt4.y, pt5.x, pt5.y, pt8.x, pt8.y, start, result);
				if (result.x == 0 && result.y == 0)
				{
					
					QuadraticBezierSegment.getQTangent(pt2.x, pt2.y, pt3.x, pt3.y, pt8.x, pt8.y, start, result);
					if (result.x == 0 && result.y == 0)
						
						QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt8.x, pt8.y, start, result);
				}
			}
		}
	}   
	
	private function getQuadraticPoints(prev:PathSegment):QuadraticPoints
	{
		if (_qPts)
			return _qPts;
		
		var p1:Point = new Point(prev ? prev.x : 0, prev ? prev.y : 0);
		var p2:Point = new Point(x, y);
		var c1:Point = new Point(control1X, control1Y);     
		var c2:Point = new Point(control2X, control2Y);
		var PA:Point = Point.interpolate(c1, p1, 3/4);
		var PB:Point = Point.interpolate(c2, p2, 3/4);
		var dx:Number = (p2.x - p1.x) / 16;
		var dy:Number = (p2.y - p1.y) / 16;
		
		_qPts = new QuadraticPoints;
		_qPts.control1 = Point.interpolate(c1, p1, 3/8);
		_qPts.control2 = Point.interpolate(PB, PA, 3/8);
		_qPts.control2.x -= dx;
		_qPts.control2.y -= dy;
		_qPts.control3 = Point.interpolate(PA, PB, 3/8);
		_qPts.control3.x += dx;
		_qPts.control3.y += dy;
		_qPts.control4 = Point.interpolate(c2, p2, 3/8);
		_qPts.anchor1 = Point.interpolate(_qPts.control1, _qPts.control2, 0.5); 
		_qPts.anchor2 = Point.interpolate(PA, PB, 0.5); 
		_qPts.anchor3 = Point.interpolate(_qPts.control3, _qPts.control4, 0.5); 
		_qPts.anchor4 = p2;
		
		return _qPts;      
	}
}


import flash.geom.Point;

class QuadraticPoints
{
	public var control1:Point;
	public var anchor1:Point;
	public var control2:Point;
	public var anchor2:Point;
	public var control3:Point;
	public var anchor3:Point;
	public var control4:Point;
	public var anchor4:Point;
	public function QuadraticPoints()
	{
		super();
	}
}


import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.flexlite.domUI.utils.MatrixUtil;

class QuadraticBezierSegment extends PathSegment
{
	public function QuadraticBezierSegment(
		_control1X:Number = 0, _control1Y:Number = 0, 
		x:Number = 0, y:Number = 0)
	{
		super(x, y);
		
		control1X = _control1X;
		control1Y = _control1Y;
	}   
	
	public var control1X:Number = 0;
	
	public var control1Y:Number = 0;
	
	override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
	{
		graphicsPath.curveTo(dx+control1X*sx, dy+control1Y*sy, dx+x*sx, dy+y*sy);
	}
	
	static public function getQTangent(x0:Number, y0:Number,
									   x1:Number, y1:Number,
									   x2:Number, y2:Number,
									   start:Boolean,
									   result:Point):void
	{
		if (start)
		{
			if (x0 == x1 && y0 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x1 - x0;
				result.y = y1 - y0;
			}
		}
		else
		{
			if (x2 == x1 && y2 == y1)
			{
				result.x = x2 - x0;
				result.y = y2 - y0;
			}
			else
			{
				result.x = x2 - x1;
				result.y = y2 - y1;
			}
		}
	}
	
	override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
	{
		var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
		var pt1:Point = MatrixUtil.transformPoint(control1X * sx, control1Y * sy, m).clone();;
		var pt2:Point = MatrixUtil.transformPoint(x * sx, y * sy, m).clone();
		
		getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
	}
	
	override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
											m:Matrix, rect:Rectangle):Rectangle
	{
		return MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
			control1X, control1Y, x, y, sx, sy, m, rect);
	}
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
