package org.flexlite.domUI.primitives.graphic
{
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsStroke;
	import flash.display.JointStyle;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * GradientStroke 类使您可以指定渐变填充的笔触。
	 * 可以将 GradientStroke 类与 GradientEntry 类配合使用以定义渐变笔触。
	 * @author DOM
	 */	
	public class GradientStroke extends GradientBase implements IStroke 
	{
		
		public function GradientStroke(weight:Number = 1,
									   pixelHinting:Boolean = false,
									   scaleMode:String = "normal",
									   caps:String = "round",
									   joints:String = "round",
									   miterLimit:Number = 3)
		{
			super();
			
			this.weight = weight;
			this.pixelHinting = pixelHinting;
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		private var _caps:String = CapsStyle.ROUND;
		/**
		 * 指定各行末尾的外观。 
		 * 有效值为 CapsStyle.NONE、CapsStyle.ROUND 和 CapsStyle.SQUARE。null 值等效于 CapsStyle.ROUND。
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
				
				dispatchGradientChangedEvent("caps", oldValue, value);
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
				
				dispatchGradientChangedEvent("joints", oldValue, value);
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
				
				dispatchGradientChangedEvent("miterLimit", oldValue, value);
			}
		}
		
		private var _pixelHinting:Boolean = false;
		/**
		 * 用于指定是否提示笔触采用完整像素的布尔值。 
		 * 它同时影响曲线锚点的位置以及线条笔触大小本身。
		 * 在 pixelHinting 设置为 true 的情况下，Flash Player 和 AIR 将提示线条宽度采用完整像素宽度。在 pixelHinting 设置为 false 的情况下，对于曲线和直线可能会出现脱节。
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
				
				dispatchGradientChangedEvent("pixelHinting", oldValue, value);
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
				
				dispatchGradientChangedEvent("scaleMode", oldValue, value);
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
				
				dispatchGradientChangedEvent("weight", oldValue, value);
			}
		}
		
		public function apply(g:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			
		}
		
		public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
		{
			var graphicsStroke:GraphicsStroke = new GraphicsStroke(); 
			graphicsStroke.thickness = weight; 
			graphicsStroke.miterLimit = miterLimit; 
			graphicsStroke.pixelHinting = pixelHinting;
			graphicsStroke.scaleMode = scaleMode;   
			graphicsStroke.caps = (!caps) ? CapsStyle.ROUND : caps; 
			var graphicsGradientFill:GraphicsGradientFill = 
				new GraphicsGradientFill();
			
			graphicsGradientFill.colors = colors;  
			graphicsGradientFill.alphas = alphas;
			graphicsGradientFill.ratios = ratios;
			graphicsGradientFill.spreadMethod = spreadMethod;
			graphicsGradientFill.interpolationMethod = interpolationMethod;  
			
			graphicsStroke.fill = graphicsGradientFill;
			
			return graphicsStroke; 
		}
		
	}
	
}
