package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.geom.CompoundTransform;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	[DefaultProperty(name="entries",array="true")]
	
	/**
	 * GradientBase 类是 LinearGradient、LinearGradientStroke 和 RadialGradient 的基类。
	 * @author DOM
	 */	
	public class GradientBase extends EventDispatcher
	{
		public function GradientBase() 
		{
			super();
		}
		
		dx_internal var colors:Array = [];
		
		dx_internal var ratios:Array = [];
		
		dx_internal var alphas:Array = [];
		
		/**
		 * 未转换的渐变的宽度值和高度值 
		 */		
		public static const GRADIENT_DIMENSION:Number = 1638.4;
		
		dx_internal var _angle:Number;
		/**
		 * 请使用rotation代替
		 */		
		public function get angle():Number
		{
			return _angle / Math.PI * 180;
		}
		
		public function set angle(value:Number):void
		{
			var oldValue:Number = _angle;
			_angle = value / 180 * Math.PI;
			
			dispatchGradientChangedEvent("angle", oldValue, _angle);
		}  
		
		protected var compoundTransform:CompoundTransform;
		
		private var _entries:Array = [];
		/**
		 * GradientEntry 对象 Array，用于定义渐变填充的填充模式。
		 */		
		public function get entries():Array
		{
			return _entries;
		}
		
		public function set entries(value:Array):void
		{
			var oldValue:Array = _entries;
			_entries = value;
			
			processEntries();
			
			dispatchGradientChangedEvent("entries", oldValue, value);
		}
		
		private var _interpolationMethod:String = "rgb";
		/**
		 * InterpolationMethod 类中的一个值，指定要使用的 interpolation 方法。 
		 * 有效值为 InterpolationMethod.LINEAR_RGB 和 InterpolationMethod.RGB。
		 */		
		public function get interpolationMethod():String
		{
			return _interpolationMethod;
		}
		
		public function set interpolationMethod(value:String):void
		{
			var oldValue:String = _interpolationMethod;
			if (value != oldValue)
			{
				_interpolationMethod = value;
				
				dispatchGradientChangedEvent("interpolationMethod", oldValue, value);
			}
		}
		
		private var _matrix:Matrix;
		/**
		 * 用于矩阵转换的值的数组。 
		 */		
		public function get matrix():Matrix
		{
			return compoundTransform ? compoundTransform.matrix : null;
		}
		
		public function set matrix(value:Matrix):void
		{
			var oldValue:Matrix = matrix;
			
			var oldX:Number = x;
			var oldY:Number = y;
			var oldRotation:Number = rotation;
			
			if (value == null)
			{
				compoundTransform = null;
				x = NaN;
				y = NaN;
				rotation = 0;
			}   
			else
			{
				
				if (compoundTransform == null)
					compoundTransform = new CompoundTransform();
				compoundTransform.matrix = value; 
				
				dispatchGradientChangedEvent("x", oldX, compoundTransform.x);
				dispatchGradientChangedEvent("y", oldY, compoundTransform.y);
				dispatchGradientChangedEvent("rotation", oldRotation, compoundTransform.rotationZ);
			}
		}
		
		private var _rotation:Number = 0.0;
		/**
		 * 默认情况下，LinearGradientStroke 定义控件进行从左到右的过渡。
		 * 使用 rotation 属性可以控制过渡方向。例如，当值为 180.0 时，将会发生从右到左的过渡，而非从左到右的过渡。
		 */		
		public function get rotation():Number
		{
			return compoundTransform ? compoundTransform.rotationZ : _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if (value != rotation)
			{
				var oldValue:Number = rotation;
				
				if (compoundTransform)
					compoundTransform.rotationZ = value;
				else
					_rotation = value;   
				dispatchGradientChangedEvent("rotation", oldValue, value);
			}
		}
		
		private var _spreadMethod:String = "pad";
		/**
		 * SpreadMethod 类中用于指定要使用的扩展方法的值。 
		 * 有效值为 SpreadMethod.PAD、SpreadMethod.REFLECT 和 SpreadMethod.REPEAT。
		 */		
		public function get spreadMethod():String
		{
			return _spreadMethod;
		}
		
		public function set spreadMethod(value:String):void
		{
			var oldValue:String = _spreadMethod;
			if (value != oldValue)
			{
				_spreadMethod = value;    
				dispatchGradientChangedEvent("spreadMethod", oldValue, value);
			}
		}
		
		private var _x:Number;
		/**
		 * 沿 x 轴平移每个点的距离。
		 */		
		public function get x():Number
		{
			return compoundTransform ? compoundTransform.x : _x;    
		}
		
		public function set x(value:Number):void
		{
			var oldValue:Number = x;
			if (value != oldValue)
			{
				if (compoundTransform)
				{
					
					if (!isNaN(value))
						compoundTransform.x = value; 
				}   
				else
				{
					_x = value;
				}       
				dispatchGradientChangedEvent("x", oldValue, value);
			}
		}
		
		private var _y:Number;
		/**
		 * 沿 y 轴平移每个点的距离。
		 */		
		public function get y():Number
		{
			return compoundTransform ? compoundTransform.y : _y;    
		}
		
		public function set y(value:Number):void
		{
			var oldValue:Number = y;
			if (value != oldValue)
			{
				if (compoundTransform)
				{
					
					if (!isNaN(value))
						compoundTransform.y = value;
				}
				else
				{
					_y = value;                
				}
				
				dispatchGradientChangedEvent("y", oldValue, value);
			}
		}
		
		dx_internal function get rotationInRadians():Number
		{
			return rotation / 180 * Math.PI;
		}
		
		private function processEntries():void
		{
			colors = [];
			ratios = [];
			alphas = [];
			
			if (!_entries || _entries.length == 0)
				return;
			
			var ratioConvert:Number = 255;
			
			var i:int;
			
			var n:int = _entries.length;
			for (i = 0; i < n; i++)
			{
				var e:GradientEntry = _entries[i];
				e.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, 
					entry_propertyChangeHandler, false, 0, true);
				colors.push(e.color);
				alphas.push(e.alpha);
				ratios.push(e.ratio * ratioConvert);
			}
			
			if (isNaN(ratios[0]))
				ratios[0] = 0;
			
			if (isNaN(ratios[n - 1]))
				ratios[n - 1] = 255;
			
			i = 1;
			
			while (true)
			{
				while (i < n && !isNaN(ratios[i]))
				{
					i++;
				}
				
				if (i == n)
					break;
				
				var start:int = i - 1;
				
				while (i < n && isNaN(ratios[i]))
				{
					i++;
				}
				
				var br:Number = ratios[start];
				var tr:Number = ratios[i];
				
				for (var j:int = 1; j < i - start; j++)
				{
					ratios[j] = br + j * (tr - br) / (i - start);
				}
			}
		}
		dx_internal function dispatchGradientChangedEvent(prop:String,
														  oldValue:*, value:*):void
		{
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
				oldValue, value));
		}
		private function entry_propertyChangeHandler(event:Event):void
		{
			processEntries();
			
			dispatchGradientChangedEvent("entries", entries, entries);
		}
	}
	
}
