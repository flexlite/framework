package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.events.PropertyChangeEvent;
	
	import flash.events.EventDispatcher;
	
	[DXML(show="false")]
	
	/**
	 * GradientEntry 类定义多个对象，这些对象控制渐变填充过程中的过渡。
	 * 将此类与 LinearGradient 和 RadialGradient 类配合使用可以定义渐变填充。
	 * @author DOM
	 */	
	public class GradientEntry extends EventDispatcher
	{
		public function GradientEntry(color:uint = 0x000000,
									  ratio:Number = NaN,
									  alpha:Number = 1.0)
		{
			super();
			
			this.color = color; 
			this.ratio = ratio; 
			this.alpha = alpha;
		}
		
		private var _alpha:Number = 1.0;
		/**
		 * 渐变填充的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。
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
				dispatchEntryChangedEvent("alpha", oldValue, value);
			}
		}
		
		private var _color:uint;
		/**
		 * 渐变填充的颜色值。
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
				dispatchEntryChangedEvent("color", oldValue, value);
			}
		}
		
		private var _ratio:Number;
		/**
		 * 在图形元素中的某位置，百分比值为 0.0 到 1.0，Flex 以 100% 对关联颜色采样。
		 */		
		public function get ratio():Number
		{
			return _ratio;
		}
		
		public function set ratio(value:Number):void
		{
			var oldValue:Number = _ratio;
			if (value != oldValue)
			{
				_ratio = value;
				dispatchEntryChangedEvent("ratio", oldValue, value);
			}
		}
		
		private function dispatchEntryChangedEvent(prop:String,
												   oldValue:*, value:*):void
		{
			if (hasEventListener("propertyChange"))
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
					oldValue, value));
		}
	}
	
}
