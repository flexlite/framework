package org.flexlite.domUI.primitives.graphic
{
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsStroke;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * RadialGradientStroke 类使您可以指定渐变填充的笔触。
	 * 可以将 RadialGradientStroke 类与 GradientEntry 类配合使用以定义渐变笔触。
	 * @author DOM
	 */	
	public class RadialGradientStroke extends GradientStroke
	{
		
		public function RadialGradientStroke(weight:Number = 1,
											 pixelHinting:Boolean = false,
											 scaleMode:String = "normal",
											 caps:String = "round",
											 joints:String = "round",
											 miterLimit:Number = 3)
		{
			super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		private var _focalPointRatio:Number = 0.0;
		/**
		 * 设置径向填充的起始位置。 <br/>
		 * 有效值范围是从 -1.0 到 1.0。如果值为 -1.0，则会将焦点（或渐变填充的起始点）设置在边界 Rectangle 的左侧。如果值为 1.0，则会将焦点设置在边界 Rectangle 的右侧。 <br/>
		 * 如果将此属性与 angle 属性配合使用，则此值指定焦点相对于中心的偏移量。例如，如果角度为 45 并且 focalPointRatio 为 0.25，则焦点位于中心的右下方。如果将 focalPointRatio 设置为 0，则焦点位于边界 Rectangle 的中央。<br/>
		 * 如果将 focalPointRatio 设置为 1，则焦点始终位于边界 Rectangle 的右下角。
		 */		
		public function get focalPointRatio():Number
		{
			return _focalPointRatio;
		}
		
		public function set focalPointRatio(value:Number):void
		{
			var oldValue:Number = _focalPointRatio;
			if (value != oldValue)
			{
				_focalPointRatio = value;
				
				dispatchGradientChangedEvent("focalPointRatio",
					oldValue, value);
			}
		}
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
			scaleY = NaN;
			super.matrix = value;
		}
		
		private var _scaleX:Number;
		/**
		 * @copy flash.display.DisplayObject#scaleX
		 */	
		public function get scaleX():Number
		{
			return compoundTransform ? compoundTransform.scaleX : _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if (value != scaleX)
			{
				var oldValue:Number = scaleX;
				
				if (compoundTransform)
				{
					
					if (!isNaN(value))
						compoundTransform.scaleX = value;
				}
				else
				{
					_scaleX = value;
				}
				dispatchGradientChangedEvent("scaleX", oldValue, value);
			}
		}
		
		private var _scaleY:Number;
		/**
		 * @copy flash.display.DisplayObject#scaleY
		 */	
		public function get scaleY():Number
		{
			return compoundTransform ? compoundTransform.scaleY : _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if (value != scaleY)
			{
				var oldValue:Number = scaleY;
				
				if (compoundTransform)
				{
					
					if (!isNaN(value))
						compoundTransform.scaleY = value;
				}
				else
				{
					_scaleY = value;
				}
				dispatchGradientChangedEvent("scaleY", oldValue, value);
			}
		}
		
		override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			
			graphics.lineStyle(weight, 0, 1, pixelHinting, scaleMode,
				caps, joints, miterLimit);
			
			if (targetBounds)
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin); 
			
			graphics.lineGradientStyle(GradientType.RADIAL, colors,
				alphas, ratios, commonMatrix, 
				spreadMethod, interpolationMethod, 
				focalPointRatio);                       
		}
		
		override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
		{
			var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds, targetOrigin);
			
			if (graphicsStroke)
			{
				
				GraphicsGradientFill(graphicsStroke.fill).type = GradientType.RADIAL; 
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin);
				GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix; 
				GraphicsGradientFill(graphicsStroke.fill).focalPointRatio = focalPointRatio;
				
			}
			
			return graphicsStroke; 
		} 
		
		private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
		{
			matrix.identity();
			
			if (!compoundTransform)
			{   
				var w:Number = !isNaN(scaleX) ? scaleX : targetBounds.width;
				var h:Number = !isNaN(scaleY) ? scaleY : targetBounds.height;
				var regX:Number = !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
				var regY:Number = !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
				
				matrix.scale (w / GRADIENT_DIMENSION, h / GRADIENT_DIMENSION);
				matrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
				matrix.translate(regX, regY);	    
			}             
			else
			{                     
				matrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				matrix.concat(compoundTransform.matrix);
				matrix.translate(targetOrigin.x, targetOrigin.y);
			}   
		}
		
	}
}
