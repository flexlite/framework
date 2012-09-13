package org.flexlite.domUI.primitives.supportClasses
{
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.graphic.IStroke;
	
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * StrokedElement 类是所有具有笔触的图形元素的基类，这些元素包括 Line、Ellipse、Path 和 Rect。
	 * @author DOM
	 */	
	public class StrokedElement extends GraphicElement
	{
		public function StrokedElement()
		{
			super();
		}
		
		private var _stroke:IStroke;
		/**
		 * 此元素所用的笔触。
		 */		
		public function get stroke():IStroke
		{
			return _stroke;
		}
		public function set stroke(value:IStroke):void
		{
			var strokeEventDispatcher:EventDispatcher;
			var oldValue:IStroke = _stroke;
			
			strokeEventDispatcher = _stroke as EventDispatcher;
			if (strokeEventDispatcher)
				strokeEventDispatcher.removeEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					stroke_propertyChangeHandler);
			
			_stroke = value;
			
			strokeEventDispatcher = _stroke as EventDispatcher;
			if (strokeEventDispatcher)
				strokeEventDispatcher.addEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					stroke_propertyChangeHandler);
			
			dispatchPropertyChangeEvent("stroke", oldValue, _stroke);
			
			invalidateDisplayList();
			
			invalidateParentSizeAndDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
													  unscaledHeight:Number):void
		{
			
			if (!drawnDisplayObject || !(drawnDisplayObject is Sprite))
				return;
			var g:Graphics = (drawnDisplayObject as Sprite).graphics;
			
			beginDraw(g);
			draw(g);
			endDraw(g);
		}
		/**
		 * 为此元素设置绘制。这是在绘制过程中采取的三个步骤中的第一步。在这一步中，会应用笔触属性。
		 * @param g 要绘制的图形元素。
		 */		
		protected function beginDraw(g:Graphics):void
		{
			if (stroke)
			{
				var strokeBounds:Rectangle = getStrokeBounds();
				strokeBounds.offset(drawX, drawY);
				stroke.apply(g, strokeBounds, new Point(drawX, drawY));
			}
			else
				g.lineStyle();
			g.beginFill(0, 0);
		}
		/**
		 * 绘制元素。这是在绘制过程中采取的三个步骤中的第二步。
		 * 覆盖此方法以实现绘图。已在 beginDraw() 方法中设置笔触（和填充，如果有）。
		 * 您的覆盖仅应包含对诸如 moveTo()、curveTo() 和 drawRect() 等绘制方法的调用。
		 * @param g 要绘制的图形元素。
		 */		
		protected function draw(g:Graphics):void
		{
			
		}
		/**
		 * 完成此元素的绘制。这是在绘制过程中采取的三个步骤中的最后一步。在这一步中，填充已关闭。
		 * @param g 要绘制的图形元素。
		 */		
		protected function endDraw(g:Graphics):void
		{
			g.endFill();
			
		}
		
		protected function getStrokeBounds():Rectangle
		{
			var strokeBounds:Rectangle = getStrokeExtents(false);
			strokeBounds.x += measuredX;
			strokeBounds.width += width;
			strokeBounds.y += measuredY;
			strokeBounds.height += height;
			return strokeBounds;
		}
		
		override protected function getStrokeExtents(postLayoutTransform:Boolean = true):Rectangle
		{
			if (!stroke)
			{
				_strokeExtents.x      = 0;
				_strokeExtents.y      = 0;
				_strokeExtents.width  = 0;
				_strokeExtents.height = 0;
				return _strokeExtents;
			}
			var weight:Number = stroke.weight;
			if (weight == 0)
			{
				_strokeExtents.width  = 1;
				_strokeExtents.height = 1;
				_strokeExtents.x      = -0.5;
				_strokeExtents.y      = -0.5;
				return _strokeExtents;
			}
			
			var scaleMode:String = stroke.scaleMode;
			if (!scaleMode || scaleMode == LineScaleMode.NONE || !postLayoutTransform)
			{
				_strokeExtents.width  = weight;
				_strokeExtents.height = weight;
				_strokeExtents.x = -weight * 0.5;
				_strokeExtents.y = -weight * 0.5;
				return _strokeExtents;
			}
			
			var sX:Number = scaleX;
			var sY:Number = scaleY;
			if (scaleMode == LineScaleMode.NORMAL)
			{
				if (sX  == sY)
					weight *= sX;
				else
					weight *= Math.sqrt(0.5 * (sX * sX + sY * sY));
				
				_strokeExtents.width  = weight;
				_strokeExtents.height = weight;
				_strokeExtents.x      = weight * -0.5;
				_strokeExtents.y      = weight * -0.5;
				return _strokeExtents;
			}
			else if (scaleMode == LineScaleMode.HORIZONTAL)
			{
				_strokeExtents.width  = weight * sX;
				_strokeExtents.height = weight;
				_strokeExtents.x      = weight * sX * -0.5;
				_strokeExtents.y      = weight * -0.5;
				return _strokeExtents;
			}
			else if (scaleMode == LineScaleMode.VERTICAL)
			{
				_strokeExtents.width  = weight;
				_strokeExtents.height = weight * sY;
				_strokeExtents.x      = weight * -0.5;
				_strokeExtents.y      = weight * sY * -0.5;
				return _strokeExtents;
			}
			
			return null;
		}
		/**
		 * 笔触对象属性改变
		 */		
		protected function stroke_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			invalidateDisplayList();
			switch (event.property)
			{
				case "weight":
				case "scaleMode":
					
					invalidateParentSizeAndDisplayList();
					break;
			}
		}
		
	}
	
}
