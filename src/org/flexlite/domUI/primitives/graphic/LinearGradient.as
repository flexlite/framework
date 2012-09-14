package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 使用 LinearGradient 类，您可以指定图形元素的填充，其中渐变指定在填充颜色中逐渐产生的颜色过渡。
	 * 您可以将一系列 GradientEntry 对象添加到 LinearGradient 对象的 entries Array 中，
	 * 以定义组成渐变填充的颜色。
	 * @author DOM
	 */	
	public class LinearGradient extends GradientBase implements IFill
	{
		public function LinearGradient()
		{
			super();
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
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
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			
			if (!compoundTransform)
			{
				var tx:Number = x;
				var ty:Number = y;
				var length:Number = scaleX;
				
				if (isNaN(length))
				{
					
					if (rotation % 90 != 0)
					{			
						
						var normalizedAngle:Number = rotation % 360;
						
						if (normalizedAngle < 0)
							normalizedAngle += 360;
						normalizedAngle %= 180;
						if (normalizedAngle > 90)
							normalizedAngle = 180 - normalizedAngle;
						
						var side:Number = targetBounds.width;
						
						var hypotenuse:Number = Math.sqrt(targetBounds.width * targetBounds.width + targetBounds.height * targetBounds.height);
						
						var hypotenuseAngle:Number =  Math.acos(targetBounds.width / hypotenuse) * 180 / Math.PI;
						if (normalizedAngle > hypotenuseAngle)
						{
							normalizedAngle = 90 - normalizedAngle;
							side = targetBounds.height;
						}
						length = side / Math.cos(normalizedAngle / 180 * Math.PI);
					}
					else 
					{
						
						length = (rotation % 180) == 0 ? targetBounds.width : targetBounds.height;
					}
				}
				if (!isNaN(tx) && isNaN(ty))
					ty = 0;
				else if (isNaN(tx) && !isNaN(ty))
					tx = 0;
				if (!isNaN(tx) && !isNaN(ty))
					commonMatrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); 
				if (length >= 0 && length < 2)
					length = 2;
				else if (length < 0 && length > -2)
					length = -2;
				commonMatrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				
				commonMatrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
				if (isNaN(tx))
					tx = targetBounds.left + targetBounds.width / 2;
				else
					tx += targetOrigin.x;
				if (isNaN(ty))
					ty = targetBounds.top + targetBounds.height / 2;
				else
					ty += targetOrigin.y;
				commonMatrix.translate(tx, ty);	
			}
			else
			{
				commonMatrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
				commonMatrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				commonMatrix.concat(compoundTransform.matrix);
				commonMatrix.translate(targetOrigin.x, targetOrigin.y);
			}			 
			
			target.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios,
				commonMatrix, spreadMethod, interpolationMethod);						 
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
	}
	
}
