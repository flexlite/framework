<<<<<<< HEAD
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.primitives.supportClasses.StrokedElement;
	
	import flash.display.Graphics;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	[DXML(show="false")]
	
	/**
	 * Line 类是绘制两点之间的直线的图形元素。 
	 * 未定义直线的默认笔触；因此，如果未指定笔触，则该直线不可见。
	 * @author DOM
	 */	
	public class Line extends StrokedElement
	{
		public function Line()
		{
			super();
		}
		
		private var _xFrom:Number = 0;
		/**
		 * 直线的起始 x 位置。
		 */		
		public function get xFrom():Number 
		{
			return _xFrom;
		}
		
		public function set xFrom(value:Number):void
		{
			if (value != _xFrom)
			{
				_xFrom = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _xTo:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get xTo():Number 
		{
			return _xTo;
		}
		
		public function set xTo(value:Number):void
		{        
			if (value != _xTo)
			{
				_xTo = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _yFrom:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get yFrom():Number 
		{
			return _yFrom;
		}
		public function set yFrom(value:Number):void
		{
			if (value != _yFrom)
			{
				_yFrom = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _yTo:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get yTo():Number 
		{
			return _yTo;
		}
		public function set yTo(value:Number):void
		{        
			if (value != _yTo)
			{
				_yTo = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		override protected function canSkipMeasurement():Boolean
		{
			return false;
		}
		
		override protected function measure():void
		{
			measuredWidth = Math.abs(xFrom - xTo);
			measuredHeight = Math.abs(yFrom - yTo);
			measuredX = Math.min(xFrom, xTo);
			measuredY = Math.min(yFrom, yTo);
		}
		
		override protected function beginDraw(g:Graphics):void
		{
			var graphicsStroke:GraphicsStroke; 
			if (stroke)
				graphicsStroke = GraphicsStroke(stroke.createGraphicsStroke(new 
					Rectangle(drawX + measuredX, drawY + measuredY, 
						Math.max(width, stroke.weight), Math.max(height, stroke.weight)),
					new Point(drawX + measuredX, drawY + measuredY))); 
			if (graphicsStroke)
				g.drawGraphicsData(new <IGraphicsData>[graphicsStroke]);
			else 
				super.beginDraw(g);
		}
		
		override protected function draw(g:Graphics):void
		{
			
			var x1:Number = measuredX + drawX;
			var y1:Number = measuredY + drawY;
			var x2:Number = measuredX + drawX + width;
			var y2:Number = measuredY + drawY + height;    
			if ((xFrom <= xTo) == (yFrom <= yTo))
			{ 
				
				g.moveTo(x1, y1);
				g.lineTo(x2, y2);
			}
			else
			{
				
				g.moveTo(x1, y2);
				g.lineTo(x2, y1);
			}
		}
	}
	
}
=======
package org.flexlite.domUI.primitives
{
	import org.flexlite.domUI.primitives.supportClasses.StrokedElement;
	
	import flash.display.Graphics;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	[DXML(show="false")]
	
	/**
	 * Line 类是绘制两点之间的直线的图形元素。 
	 * 未定义直线的默认笔触；因此，如果未指定笔触，则该直线不可见。
	 * @author DOM
	 */	
	public class Line extends StrokedElement
	{
		public function Line()
		{
			super();
		}
		
		private var _xFrom:Number = 0;
		/**
		 * 直线的起始 x 位置。
		 */		
		public function get xFrom():Number 
		{
			return _xFrom;
		}
		
		public function set xFrom(value:Number):void
		{
			if (value != _xFrom)
			{
				_xFrom = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _xTo:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get xTo():Number 
		{
			return _xTo;
		}
		
		public function set xTo(value:Number):void
		{        
			if (value != _xTo)
			{
				_xTo = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _yFrom:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get yFrom():Number 
		{
			return _yFrom;
		}
		public function set yFrom(value:Number):void
		{
			if (value != _yFrom)
			{
				_yFrom = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _yTo:Number = 0;
		/**
		 * 直线的结束 x 位置。
		 */		
		public function get yTo():Number 
		{
			return _yTo;
		}
		public function set yTo(value:Number):void
		{        
			if (value != _yTo)
			{
				_yTo = value;
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		override protected function canSkipMeasurement():Boolean
		{
			return false;
		}
		
		override protected function measure():void
		{
			measuredWidth = Math.abs(xFrom - xTo);
			measuredHeight = Math.abs(yFrom - yTo);
			measuredX = Math.min(xFrom, xTo);
			measuredY = Math.min(yFrom, yTo);
		}
		
		override protected function beginDraw(g:Graphics):void
		{
			var graphicsStroke:GraphicsStroke; 
			if (stroke)
				graphicsStroke = GraphicsStroke(stroke.createGraphicsStroke(new 
					Rectangle(drawX + measuredX, drawY + measuredY, 
						Math.max(width, stroke.weight), Math.max(height, stroke.weight)),
					new Point(drawX + measuredX, drawY + measuredY))); 
			if (graphicsStroke)
				g.drawGraphicsData(new <IGraphicsData>[graphicsStroke]);
			else 
				super.beginDraw(g);
		}
		
		override protected function draw(g:Graphics):void
		{
			
			var x1:Number = measuredX + drawX;
			var y1:Number = measuredY + drawY;
			var x2:Number = measuredX + drawX + width;
			var y2:Number = measuredY + drawY + height;    
			if ((xFrom <= xTo) == (yFrom <= yTo))
			{ 
				
				g.moveTo(x1, y1);
				g.lineTo(x2, y2);
			}
			else
			{
				
				g.moveTo(x1, y2);
				g.lineTo(x2, y1);
			}
		}
	}
	
}
>>>>>>> master
