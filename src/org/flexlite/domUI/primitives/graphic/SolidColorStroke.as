package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.events.PropertyChangeEvent;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.JointStyle;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[DXML(show="false")]
	
	/**
	 * SolidColorStroke 类定义线条的属性。 
	 * @author DOM
	 */	
	public class SolidColorStroke extends EventDispatcher implements IStroke
	{
		public function SolidColorStroke(color:uint = 0x000000,
										 weight:Number = 1,
										 alpha:Number = 1.0,
										 pixelHinting:Boolean = false,
										 scaleMode:String = "normal",
										 caps:String = "round",
										 joints:String = "round",
										 miterLimit:Number = 3)
		{
			super();
			
			this.color = color;
			this._weight = weight;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		private var _alpha:Number = 0.0;
		
		/**
		 * 线条的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。
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
				dispatchStrokeChangedEvent("alpha", oldValue, value);
			}
		}
		
		
		private var _caps:String = CapsStyle.ROUND;
		
		/**
		 * 指定线条结尾处的端点的类型。有效值为：CapsStyle.ROUND、CapsStyle.SQUARE 和 CapsStyle.NONE。
		 */		
		public function get caps():String
		{
			return _caps;
		}
		
		public function set caps(value:String):void
		{
			var oldValue:String = _caps;
			if (value != oldValue)
			{
				_caps = value;
				dispatchStrokeChangedEvent("caps", oldValue, value);
			}
		}
		
		private var _color:uint = 0x000000;
		
		/**
		 * 线条颜色。
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
				dispatchStrokeChangedEvent("color", oldValue, value);
			}
		}
		
		private var _joints:String = JointStyle.ROUND;
		
		public function get joints():String
		{
			return _joints;
		}
		
		public function set joints(value:String):void
		{
			var oldValue:String = _joints;
			if (value != oldValue)
			{
				_joints = value;
				dispatchStrokeChangedEvent("joints", oldValue, value);
			}
		}
		
		private var _miterLimit:Number = 3;
		
		public function get miterLimit():Number
		{
			return _miterLimit;
		}
		
		public function set miterLimit(value:Number):void
		{
			var oldValue:Number = _miterLimit;
			if (value != oldValue)
			{
				_miterLimit = value;
				dispatchStrokeChangedEvent("miterLimit", oldValue, value);
			}
		}
		
		private var _pixelHinting:Boolean = false;
		
		/**
		 * 指定是否提示笔触采用完整像素。此值同时影响曲线锚点的位置以及线条笔触大小本身。
		 */		
		public function get pixelHinting():Boolean
		{
			return _pixelHinting;
		}
		
		public function set pixelHinting(value:Boolean):void
		{
			var oldValue:Boolean = _pixelHinting;
			if (value != oldValue)
			{
				_pixelHinting = value;
				dispatchStrokeChangedEvent("pixelHinting", oldValue, value);
			}
		}
		
		private var _scaleMode:String = "normal";
		
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void
		{
			var oldValue:String = _scaleMode;
			if (value != oldValue)
			{
				_scaleMode = value;
				dispatchStrokeChangedEvent("scaleMode", oldValue, value);
			}
		}
		
		private var _weight:Number;
		
		public function get weight():Number
		{
			return _weight;
		}
		
		public function set weight(value:Number):void
		{
			var oldValue:Number = _weight;
			if (value != oldValue)
			{
				_weight = value;
				dispatchStrokeChangedEvent("weight", oldValue, value);
			}
		}
		
		public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			graphics.lineStyle(weight, color, alpha, pixelHinting,
				scaleMode, caps, joints, miterLimit);
		}
		
		public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
		{
			var graphicsStroke:GraphicsStroke = new GraphicsStroke(); 
			graphicsStroke.thickness = weight;  
			graphicsStroke.miterLimit = miterLimit; 
			graphicsStroke.pixelHinting = pixelHinting;
			graphicsStroke.scaleMode = scaleMode;
			
			graphicsStroke.caps = (!caps) ? CapsStyle.ROUND : caps;
			
			var graphicsSolidFill:GraphicsSolidFill = new GraphicsSolidFill();
			graphicsSolidFill.color = color; 
			graphicsSolidFill.alpha = alpha; 
			graphicsStroke.fill = graphicsSolidFill; 
			
			return graphicsStroke;  
		}
		
		/**
		 * 抛出属性改变事件
		 */		
		private function dispatchStrokeChangedEvent(prop:String, oldValue:*,
													value:*):void
		{
			if (hasEventListener("propertyChange")) 
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
					oldValue, value));
		}
	}
	
}
