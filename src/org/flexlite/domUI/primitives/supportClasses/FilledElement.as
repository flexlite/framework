package org.flexlite.domUI.primitives.supportClasses
{
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.graphic.IFill;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * FilledElement 类是包含笔触和填充的图形元素的基类。
	 * @author DOM
	 */	
	public class FilledElement extends StrokedElement
	{
		public function FilledElement()
		{
			super();
		}
		
		protected var _fill:IFill;
		/**
		 * 定义填充的属性的对象。如果未定义，则会绘制对象而不使用填充。
		 */		
		public function get fill():IFill
		{
			return _fill;
		}
		
		public function set fill(value:IFill):void
		{
			var oldValue:IFill = _fill;
			var fillEventDispatcher:EventDispatcher;
			
			fillEventDispatcher = _fill as EventDispatcher;
			if (fillEventDispatcher)
				fillEventDispatcher.removeEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					fill_propertyChangeHandler);
			
			_fill = value;
			
			fillEventDispatcher = _fill as EventDispatcher;
			if (fillEventDispatcher)
				fillEventDispatcher.addEventListener(
					PropertyChangeEvent.PROPERTY_CHANGE, 
					fill_propertyChangeHandler);
			
			dispatchPropertyChangeEvent("fill", oldValue, _fill);    
			invalidateDisplayList();
		}
		
		override protected function beginDraw(g:Graphics):void
		{
			var origin:Point = new Point(drawX, drawY);
			if (stroke)
			{
				var strokeBounds:Rectangle = getStrokeBounds();
				strokeBounds.offset(drawX, drawY);
				stroke.apply(g, strokeBounds, origin);
			}
			else
				g.lineStyle();
			
			if (fill)
			{
				var fillBounds:Rectangle = new Rectangle(drawX, drawY, width, height);
				fill.begin(g, fillBounds, origin);
			}
		}
		
		override protected function endDraw(g:Graphics):void
		{
			if (fill)
				fill.end(g);
		}
		/**
		 * 定义填充的对象的属性发生变化
		 */		
		private function fill_propertyChangeHandler(event:Event):void
		{
			invalidateDisplayList();
		}
	}
}
