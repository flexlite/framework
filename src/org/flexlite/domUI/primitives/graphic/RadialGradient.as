<<<<<<< HEAD
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
	 * RadialGradient 类允许指定在填充颜色中逐渐产生的颜色过渡。径向渐变定义从图形元素中心向外以放射方式进行的填充模式。
	 * 您可以将一系列 GradientEntry 对象添加到 RadialGradient 对象的 entries Array 中，以定义组成渐变填充的颜色。
	 * @author DOM
	 */	
	public class RadialGradient extends GradientBase implements IFill
	{
		public function RadialGradient()
		{
			super();
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		private var _focalPointRatio:Number = 0.0;
		
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
				
				dispatchGradientChangedEvent("focalPointRatio", oldValue, value);
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
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			var w:Number = !isNaN(scaleX) ? scaleX : targetBounds.width;
			var h:Number = !isNaN(scaleY) ? scaleY : targetBounds.height;
			var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
			var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
			
			commonMatrix.identity();
			
			if (!compoundTransform)
			{
				commonMatrix.scale (w / GRADIENT_DIMENSION, h / GRADIENT_DIMENSION);
				commonMatrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
				commonMatrix.translate(regX, regY);						
			}
			else
			{            
				commonMatrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				commonMatrix.concat(compoundTransform.matrix);
				commonMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			
			target.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios,
				commonMatrix, spreadMethod, interpolationMethod, focalPointRatio);      
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
		
	}
	
}
=======
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
	 * RadialGradient 类允许指定在填充颜色中逐渐产生的颜色过渡。径向渐变定义从图形元素中心向外以放射方式进行的填充模式。
	 * 您可以将一系列 GradientEntry 对象添加到 RadialGradient 对象的 entries Array 中，以定义组成渐变填充的颜色。
	 * @author DOM
	 */	
	public class RadialGradient extends GradientBase implements IFill
	{
		public function RadialGradient()
		{
			super();
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		private var _focalPointRatio:Number = 0.0;
		
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
				
				dispatchGradientChangedEvent("focalPointRatio", oldValue, value);
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
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{
			var w:Number = !isNaN(scaleX) ? scaleX : targetBounds.width;
			var h:Number = !isNaN(scaleY) ? scaleY : targetBounds.height;
			var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
			var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
			
			commonMatrix.identity();
			
			if (!compoundTransform)
			{
				commonMatrix.scale (w / GRADIENT_DIMENSION, h / GRADIENT_DIMENSION);
				commonMatrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
				commonMatrix.translate(regX, regY);						
			}
			else
			{            
				commonMatrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				commonMatrix.concat(compoundTransform.matrix);
				commonMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			
			target.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios,
				commonMatrix, spreadMethod, interpolationMethod, focalPointRatio);      
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
		
	}
	
}
>>>>>>> master
