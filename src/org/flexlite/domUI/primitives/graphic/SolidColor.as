package org.flexlite.domUI.primitives.graphic
{
	import org.flexlite.domUI.events.PropertyChangeEvent;
	
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	[DefaultProperty(name="color",array="false")]
	
	/**
	 * 定义颜色的表示形式，包括颜色值和 alpha 值。
	 * @author DOM
	 */	
	public class SolidColor extends EventDispatcher implements IFill
	{
		/**
		 * 构造函数 
		 * @param color 指定颜色。默认值为 0x000000（黑色）。
		 * @param alpha 指定颜色。默认值为 0x000000（黑色）。
		 */		
		public function SolidColor(color:uint = 0x000000, alpha:Number = 1.0)
		{
			super();
			
			this.color = color;
			this.alpha = alpha;
		}
		
		
		private var _alpha:Number = 1.0;
		/**
		 * 颜色的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。
		 */		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			var oldValue:Number = _alpha;
			if (value != oldValue)
			{
				_alpha = value;
				dispatchFillChangedEvent("alpha", oldValue, value);
			}
		}
		
		private var _color:uint = 0x000000;
		
		/**
		 * 颜色的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。 
		 */	
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			var oldValue:uint = _color;
			if (value != oldValue)
			{
				_color = value;
				dispatchFillChangedEvent("color", oldValue, value);
			}
		}
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			target.beginFill(color, alpha);
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
		
		/**
		 * 抛出属性改变事件
		 */
		private function dispatchFillChangedEvent(prop:String, oldValue:*,
												  value:*):void
		{
			if (hasEventListener("propertyChange")) 
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
					oldValue, value));
		}
	}
	
}
