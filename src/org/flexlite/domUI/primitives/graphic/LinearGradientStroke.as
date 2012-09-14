<<<<<<< HEAD
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
	 * LinearGradientStroke 类允许您指定渐变填充的笔触。
	 * 您可以将 LinearGradientStroke 类与 GradientEntry 类配合使用以定义渐变笔触。
	 * @author DOM
	 */	
	public class LinearGradientStroke extends GradientStroke
	{
		public function LinearGradientStroke(weight:Number = 1,
											 pixelHinting:Boolean = false,
											 scaleMode:String = "normal",
											 caps:String = "round",
											 joints:String = "round",
											 miterLimit:Number = 3)
		{
			super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
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
		
		override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			
			graphics.lineStyle(weight, 0, 1, pixelHinting, scaleMode,
				caps, joints, miterLimit);
			
			if (targetBounds)
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin); 
			
			graphics.lineGradientStyle(GradientType.LINEAR, colors,
				alphas, ratios,
				commonMatrix, spreadMethod,
				interpolationMethod);                        
		}
		
		override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
		{
			var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds, targetOrigin); 
			
			if (graphicsStroke)
			{
				
				GraphicsGradientFill(graphicsStroke.fill).type = GradientType.LINEAR; 
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin);
				GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix; 
			}
			
			return graphicsStroke; 
		}
		
		private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
		{        
			matrix.identity();
			
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
					matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); 
				if (length >= 0 && length < 2)
					length = 2;
				else if (length < 0 && length > -2)
					length = -2;
				matrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				
				matrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
				if (isNaN(tx))
					tx = targetBounds.left + targetBounds.width / 2;
				else
					tx += targetOrigin.x;
				if (isNaN(ty))
					ty = targetBounds.top + targetBounds.height / 2;
				else
					ty += targetOrigin.y;
				matrix.translate(tx, ty);   
			}
			else
			{
				matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
				matrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				matrix.concat(compoundTransform.matrix);
				matrix.translate(targetOrigin.x, targetOrigin.y);
			}               
		}
		
	}
	
}
=======
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
	 * LinearGradientStroke 类允许您指定渐变填充的笔触。
	 * 您可以将 LinearGradientStroke 类与 GradientEntry 类配合使用以定义渐变笔触。
	 * @author DOM
	 */	
	public class LinearGradientStroke extends GradientStroke
	{
		public function LinearGradientStroke(weight:Number = 1,
											 pixelHinting:Boolean = false,
											 scaleMode:String = "normal",
											 caps:String = "round",
											 joints:String = "round",
											 miterLimit:Number = 3)
		{
			super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
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
		
		override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			commonMatrix.identity();
			
			graphics.lineStyle(weight, 0, 1, pixelHinting, scaleMode,
				caps, joints, miterLimit);
			
			if (targetBounds)
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin); 
			
			graphics.lineGradientStyle(GradientType.LINEAR, colors,
				alphas, ratios,
				commonMatrix, spreadMethod,
				interpolationMethod);                        
		}
		
		override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke
		{
			var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds, targetOrigin); 
			
			if (graphicsStroke)
			{
				
				GraphicsGradientFill(graphicsStroke.fill).type = GradientType.LINEAR; 
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin);
				GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix; 
			}
			
			return graphicsStroke; 
		}
		
		private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
		{        
			matrix.identity();
			
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
					matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); 
				if (length >= 0 && length < 2)
					length = 2;
				else if (length < 0 && length > -2)
					length = -2;
				matrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				
				matrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
				if (isNaN(tx))
					tx = targetBounds.left + targetBounds.width / 2;
				else
					tx += targetOrigin.x;
				if (isNaN(ty))
					ty = targetBounds.top + targetBounds.height / 2;
				else
					ty += targetOrigin.y;
				matrix.translate(tx, ty);   
			}
			else
			{
				matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
				matrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				matrix.concat(compoundTransform.matrix);
				matrix.translate(targetOrigin.x, targetOrigin.y);
			}               
		}
		
	}
	
}
>>>>>>> master
