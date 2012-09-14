<<<<<<< HEAD
package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.geom.CompoundTransform;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 定义使用位图或其他 DisplayObject 填充屏幕上的区域时使用的一组值。
	 * @author DOM
	 */	
	public class BitmapFill extends EventDispatcher implements IFill
	{
		/**
		 * 构造函数
		 */		
		public function BitmapFill()
		{
			super();
		}
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		private static var transformMatrix:Matrix = new Matrix();
		private var nonRepeatAlphaSource:BitmapData;
		private var _bitmapData:BitmapData;
		
		private var regenerateNonRepeatSource:Boolean = true;
		private var lastBoundsWidth:Number = 0;
		private var lastBoundsHeight:Number = 0;
		private var applyAlphaMultiplier:Boolean = false;
		private var nonRepeatSourceCreated:Boolean = false;
		private var bitmapDataCreated:Boolean = false;
		
		
		private var _alpha:Number = 1;
		/**
		 * 填充的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。
		 */		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (_alpha == value)
				return;
			
			var oldValue:Number = _alpha;
			
			_alpha = value;
			
			applyAlphaMultiplier = true;
			
			if (_bitmapData && !_bitmapData.transparent && _alpha < 1 && oldValue == 1)
			{
				var s:Object = _source;
				_source = null;
				source = s;
			}
			
			dispatchFillChangedEvent("alpha", oldValue, value);
		}
		
		protected var compoundTransform:CompoundTransform; 
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
			var oldScaleX:Number = scaleX;
			var oldScaleY:Number = scaleY;
			
			if (value == null)
			{
				compoundTransform = null;
			}   
			else
			{
				
				if (compoundTransform == null)
					compoundTransform = new CompoundTransform();
				compoundTransform.matrix = value; 
				
				dispatchFillChangedEvent("x", oldX, compoundTransform.x);
				dispatchFillChangedEvent("y", oldY, compoundTransform.y);
				dispatchFillChangedEvent("scaleX", oldScaleX, compoundTransform.scaleX);
				dispatchFillChangedEvent("scaleY", oldScaleY, compoundTransform.scaleY);
				dispatchFillChangedEvent("rotation", oldRotation, compoundTransform.rotationZ);
			}
		}
		
		protected var _fillMode:String = BitmapFillMode.SCALE;
		/**
		 * 确定位图填充尺寸的方式。请使用BitmapFillMode中定义的值。
		 */		
		public function get fillMode():String 
		{
			return _fillMode; 
		}
		
		public function set fillMode(value:String):void
		{
			var oldValue:String = _fillMode; 
			if (value != _fillMode)
			{
				_fillMode = value;
				dispatchFillChangedEvent("fillMode", oldValue, value);
			}
		}
		
		private var _rotation:Number = 0;
		/**
		 * 将旋转位图的度数。有效值范围是 0.0 到 360.0。
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
				dispatchFillChangedEvent("rotation", oldValue, value);
			}
		}
		
		private var _scaleX:Number;
		/**
		 * 在填充时对位图进行水平缩放的百分比，范围介于 0.0 到 1.0 之间。如果为 1.0，则将填充实际大小的位图。
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
				dispatchFillChangedEvent("scaleX", oldValue, value);
			}
		}
		
		private var _scaleY:Number;
		/**
		 * 在填充时对位图进行水平缩放的百分比，范围介于 0.0 到 1.0 之间。如果为 1.0，则将填充实际大小的位图。
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
				dispatchFillChangedEvent("scaleY", oldValue, value);
			}
		}
		
		private var _source:Object;
		
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#source
		 */		
		public function get source():Object 
		{
			return _source;
		}
		
		public function set source(value:Object):void
		{
			if (value != _source)
			{
				var tmpSprite:DisplayObject;
				var oldValue:Object = _source;
				_source = value;
				
				var bitmapData:BitmapData;    
				var bitmapCreated:Boolean = false; 
				
				if (value is Class)
				{
					var cls:Class = Class(value);
					value = new cls();
					bitmapCreated = true;
				} 
				
				if (value is BitmapData)
				{
					bitmapData = BitmapData(value);
				}
				else if (value is Bitmap)
				{
					bitmapData = value.bitmapData;
				}
				else if (value is DisplayObject)
				{
					tmpSprite = value as DisplayObject;
				}
				else if (value == null)
				{
					
				}
				else
				{
					return;
				}
				
				if (!bitmapData && tmpSprite)
				{
					bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
					bitmapData.draw(tmpSprite, new Matrix());
					bitmapCreated = true;
				}
				if (bitmapData && !bitmapData.transparent && alpha != 1)
				{
					var transparentBitmap:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true);
					transparentBitmap.draw(bitmapData);
					bitmapCreated = true;
					bitmapData = transparentBitmap;
				}
				
				setBitmapData(bitmapData, bitmapCreated);
				
				dispatchFillChangedEvent("source", oldValue, value);
			}
		}
		
		private var _smooth:Boolean = false;
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#smooth
		 */		
		public function get smooth():Boolean
		{
			return _smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			var oldValue:Boolean = _smooth;
			if (value != oldValue)
			{
				_smooth = value;
				dispatchFillChangedEvent("smooth", oldValue, value);
			}
		}
		
		private var _transformX:Number = 0;
		/**
		 * 填充的 x 位置转换点。
		 */		
		public function get transformX():Number
		{
			return compoundTransform ? compoundTransform.transformX : _transformX;
		}
		
		public function set transformX(value:Number):void
		{
			if (transformX == value)
				return;
			
			var oldValue:Number = transformX;   
			
			if (compoundTransform)
				compoundTransform.transformX = value;
			else
				_transformX = value;
			
			dispatchFillChangedEvent("transformX", oldValue, value);
		}
		
		private var _transformY:Number = 0;
		/**
		 * 填充的 y 位置转换点。
		 */		
		public function get transformY():Number
		{
			return compoundTransform ? compoundTransform.transformY : _transformY;
		}
		
		public function set transformY(value:Number):void
		{
			if (transformY == value)
				return;
			
			var oldValue:Number = transformY;    
			
			if (compoundTransform)
				compoundTransform.transformY = value;
			else
				_transformY = value;
			
			dispatchFillChangedEvent("transformY", oldValue, value);
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
				dispatchFillChangedEvent("x", oldValue, value);
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
				
				dispatchFillChangedEvent("y", oldValue, value);
			}
		}
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{       
			var sourceAsBitmapData:BitmapData = _bitmapData;
			
			if (!sourceAsBitmapData)
				return;        
			
			var repeatFill:Boolean = (fillMode == BitmapFillMode.REPEAT); 
			if (nonRepeatAlphaSource && applyAlphaMultiplier)
			{
				nonRepeatAlphaSource.dispose();
				nonRepeatAlphaSource = null;
			}
			
			if (compoundTransform)
			{
				transformMatrix = compoundTransform.matrix;
				transformMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			else
			{
				
				var defaultScaleX:Number = scaleX;
				var defaultScaleY:Number = scaleY;
				if (fillMode == BitmapFillMode.SCALE)
				{
					
					if (isNaN(scaleX) && sourceAsBitmapData.width > 0)
						defaultScaleX = targetBounds.width / sourceAsBitmapData.width;
					if (isNaN(scaleY) && sourceAsBitmapData.height > 0)
						defaultScaleY = targetBounds.height / sourceAsBitmapData.height;
				}
				
				if (isNaN(defaultScaleX))
					defaultScaleX = 1;
				if (isNaN(defaultScaleY))
					defaultScaleY = 1;
				var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left;
				var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top;
				
				transformMatrix.identity();
				transformMatrix.translate(-transformX, -transformY);
				transformMatrix.scale(defaultScaleX, defaultScaleY);
				transformMatrix.rotate(rotation * RADIANS_PER_DEGREES);
				transformMatrix.translate(regX + transformX, regY + transformY);
			}
			if (repeatFill || 
				(MatrixUtil.isDeltaIdentity(transformMatrix) && 
					transformMatrix.tx == targetBounds.left &&
					transformMatrix.ty == targetBounds.top &&
					targetBounds.width <= sourceAsBitmapData.width && 
					targetBounds.height <= sourceAsBitmapData.height))
			{
				if (nonRepeatAlphaSource && nonRepeatSourceCreated)
				{
					nonRepeatAlphaSource.dispose();
					nonRepeatAlphaSource = null;
					applyAlphaMultiplier = alpha != 1;
				}
				
				nonRepeatSourceCreated = false;
			}
			else if (fillMode == BitmapFillMode.CLIP)
			{
				if (regenerateNonRepeatSource || 
					lastBoundsWidth != targetBounds.width || 
					lastBoundsHeight != targetBounds.height)
				{
					
					if (nonRepeatAlphaSource)
						nonRepeatAlphaSource.dispose();
					
					var bitmapTopLeft:Point = new Point();
					var tx:Number = transformMatrix.tx;
					var ty:Number = transformMatrix.ty; 
					
					transformMatrix.tx = 0;
					transformMatrix.ty = 0;
					var bitmapSize:Point = MatrixUtil.transformBounds(
						sourceAsBitmapData.width, sourceAsBitmapData.height, 
						transformMatrix, 
						bitmapTopLeft);
					var newW:Number = Math.ceil(bitmapSize.x) + 2;
					var newY:Number = Math.ceil(bitmapSize.y) + 2;
					transformMatrix.translate(1 - bitmapTopLeft.x, 1 - bitmapTopLeft.y);
					nonRepeatAlphaSource = new BitmapData(newW, newY, true, 0xFFFFFF);
					nonRepeatAlphaSource.draw(sourceAsBitmapData, transformMatrix, null, null, null, smooth);
					transformMatrix.identity();
					
					transformMatrix.translate(tx + bitmapTopLeft.x - 1, ty + bitmapTopLeft.y - 1);
					
					lastBoundsWidth = targetBounds.width;
					lastBoundsHeight = targetBounds.height;
					
					nonRepeatSourceCreated = true;
					applyAlphaMultiplier = alpha != 1;
				}   
			}
			if (applyAlphaMultiplier)
			{
				
				if (!nonRepeatAlphaSource)
					nonRepeatAlphaSource = sourceAsBitmapData.clone();
				
				var ct:ColorTransform = new ColorTransform();
				ct.alphaMultiplier = alpha;
				
				nonRepeatAlphaSource.colorTransform(new Rectangle(0, 0, nonRepeatAlphaSource.width, nonRepeatAlphaSource.height), ct);
				applyAlphaMultiplier = false;
			}
			if (nonRepeatAlphaSource)
				sourceAsBitmapData = nonRepeatAlphaSource;
			
			target.beginBitmapFill(sourceAsBitmapData, transformMatrix, repeatFill, smooth);
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
		
		private function dispatchFillChangedEvent(prop:String, oldValue:*,
												  value:*):void
		{
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
				oldValue, value));
			regenerateNonRepeatSource = true;
		}
		/**
		 * 设置位图数据
		 */		
		private function setBitmapData(bitmapData:BitmapData, internallyCreated:Boolean = false):void
		{         
			
			if (_bitmapData)
			{
				if (bitmapDataCreated) 
					_bitmapData.dispose();
				_bitmapData = null;
			}
			
			bitmapDataCreated = internallyCreated;         
			applyAlphaMultiplier = alpha != 1;
			_bitmapData = bitmapData;
			
			dispatchFillChangedEvent("bitmapData", null, null);
		}
	}
	
}
=======
package org.flexlite.domUI.primitives.graphic
{
	
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.primitives.geom.CompoundTransform;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 定义使用位图或其他 DisplayObject 填充屏幕上的区域时使用的一组值。
	 * @author DOM
	 */	
	public class BitmapFill extends EventDispatcher implements IFill
	{
		/**
		 * 构造函数
		 */		
		public function BitmapFill()
		{
			super();
		}
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		private static var transformMatrix:Matrix = new Matrix();
		private var nonRepeatAlphaSource:BitmapData;
		private var _bitmapData:BitmapData;
		
		private var regenerateNonRepeatSource:Boolean = true;
		private var lastBoundsWidth:Number = 0;
		private var lastBoundsHeight:Number = 0;
		private var applyAlphaMultiplier:Boolean = false;
		private var nonRepeatSourceCreated:Boolean = false;
		private var bitmapDataCreated:Boolean = false;
		
		
		private var _alpha:Number = 1;
		/**
		 * 填充的透明度。可能的值为 0.0（不可见）到 1.0（不透明）。
		 */		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (_alpha == value)
				return;
			
			var oldValue:Number = _alpha;
			
			_alpha = value;
			
			applyAlphaMultiplier = true;
			
			if (_bitmapData && !_bitmapData.transparent && _alpha < 1 && oldValue == 1)
			{
				var s:Object = _source;
				_source = null;
				source = s;
			}
			
			dispatchFillChangedEvent("alpha", oldValue, value);
		}
		
		protected var compoundTransform:CompoundTransform; 
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
			var oldScaleX:Number = scaleX;
			var oldScaleY:Number = scaleY;
			
			if (value == null)
			{
				compoundTransform = null;
			}   
			else
			{
				
				if (compoundTransform == null)
					compoundTransform = new CompoundTransform();
				compoundTransform.matrix = value; 
				
				dispatchFillChangedEvent("x", oldX, compoundTransform.x);
				dispatchFillChangedEvent("y", oldY, compoundTransform.y);
				dispatchFillChangedEvent("scaleX", oldScaleX, compoundTransform.scaleX);
				dispatchFillChangedEvent("scaleY", oldScaleY, compoundTransform.scaleY);
				dispatchFillChangedEvent("rotation", oldRotation, compoundTransform.rotationZ);
			}
		}
		
		protected var _fillMode:String = BitmapFillMode.SCALE;
		/**
		 * 确定位图填充尺寸的方式。请使用BitmapFillMode中定义的值。
		 */		
		public function get fillMode():String 
		{
			return _fillMode; 
		}
		
		public function set fillMode(value:String):void
		{
			var oldValue:String = _fillMode; 
			if (value != _fillMode)
			{
				_fillMode = value;
				dispatchFillChangedEvent("fillMode", oldValue, value);
			}
		}
		
		private var _rotation:Number = 0;
		/**
		 * 将旋转位图的度数。有效值范围是 0.0 到 360.0。
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
				dispatchFillChangedEvent("rotation", oldValue, value);
			}
		}
		
		private var _scaleX:Number;
		/**
		 * 在填充时对位图进行水平缩放的百分比，范围介于 0.0 到 1.0 之间。如果为 1.0，则将填充实际大小的位图。
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
				dispatchFillChangedEvent("scaleX", oldValue, value);
			}
		}
		
		private var _scaleY:Number;
		/**
		 * 在填充时对位图进行水平缩放的百分比，范围介于 0.0 到 1.0 之间。如果为 1.0，则将填充实际大小的位图。
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
				dispatchFillChangedEvent("scaleY", oldValue, value);
			}
		}
		
		private var _source:Object;
		
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#source
		 */		
		public function get source():Object 
		{
			return _source;
		}
		
		public function set source(value:Object):void
		{
			if (value != _source)
			{
				var tmpSprite:DisplayObject;
				var oldValue:Object = _source;
				_source = value;
				
				var bitmapData:BitmapData;    
				var bitmapCreated:Boolean = false; 
				
				if (value is Class)
				{
					var cls:Class = Class(value);
					value = new cls();
					bitmapCreated = true;
				} 
				
				if (value is BitmapData)
				{
					bitmapData = BitmapData(value);
				}
				else if (value is Bitmap)
				{
					bitmapData = value.bitmapData;
				}
				else if (value is DisplayObject)
				{
					tmpSprite = value as DisplayObject;
				}
				else if (value == null)
				{
					
				}
				else
				{
					return;
				}
				
				if (!bitmapData && tmpSprite)
				{
					bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
					bitmapData.draw(tmpSprite, new Matrix());
					bitmapCreated = true;
				}
				if (bitmapData && !bitmapData.transparent && alpha != 1)
				{
					var transparentBitmap:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true);
					transparentBitmap.draw(bitmapData);
					bitmapCreated = true;
					bitmapData = transparentBitmap;
				}
				
				setBitmapData(bitmapData, bitmapCreated);
				
				dispatchFillChangedEvent("source", oldValue, value);
			}
		}
		
		private var _smooth:Boolean = false;
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#smooth
		 */		
		public function get smooth():Boolean
		{
			return _smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			var oldValue:Boolean = _smooth;
			if (value != oldValue)
			{
				_smooth = value;
				dispatchFillChangedEvent("smooth", oldValue, value);
			}
		}
		
		private var _transformX:Number = 0;
		/**
		 * 填充的 x 位置转换点。
		 */		
		public function get transformX():Number
		{
			return compoundTransform ? compoundTransform.transformX : _transformX;
		}
		
		public function set transformX(value:Number):void
		{
			if (transformX == value)
				return;
			
			var oldValue:Number = transformX;   
			
			if (compoundTransform)
				compoundTransform.transformX = value;
			else
				_transformX = value;
			
			dispatchFillChangedEvent("transformX", oldValue, value);
		}
		
		private var _transformY:Number = 0;
		/**
		 * 填充的 y 位置转换点。
		 */		
		public function get transformY():Number
		{
			return compoundTransform ? compoundTransform.transformY : _transformY;
		}
		
		public function set transformY(value:Number):void
		{
			if (transformY == value)
				return;
			
			var oldValue:Number = transformY;    
			
			if (compoundTransform)
				compoundTransform.transformY = value;
			else
				_transformY = value;
			
			dispatchFillChangedEvent("transformY", oldValue, value);
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
				dispatchFillChangedEvent("x", oldValue, value);
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
				
				dispatchFillChangedEvent("y", oldValue, value);
			}
		}
		
		public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void
		{       
			var sourceAsBitmapData:BitmapData = _bitmapData;
			
			if (!sourceAsBitmapData)
				return;        
			
			var repeatFill:Boolean = (fillMode == BitmapFillMode.REPEAT); 
			if (nonRepeatAlphaSource && applyAlphaMultiplier)
			{
				nonRepeatAlphaSource.dispose();
				nonRepeatAlphaSource = null;
			}
			
			if (compoundTransform)
			{
				transformMatrix = compoundTransform.matrix;
				transformMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			else
			{
				
				var defaultScaleX:Number = scaleX;
				var defaultScaleY:Number = scaleY;
				if (fillMode == BitmapFillMode.SCALE)
				{
					
					if (isNaN(scaleX) && sourceAsBitmapData.width > 0)
						defaultScaleX = targetBounds.width / sourceAsBitmapData.width;
					if (isNaN(scaleY) && sourceAsBitmapData.height > 0)
						defaultScaleY = targetBounds.height / sourceAsBitmapData.height;
				}
				
				if (isNaN(defaultScaleX))
					defaultScaleX = 1;
				if (isNaN(defaultScaleY))
					defaultScaleY = 1;
				var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left;
				var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top;
				
				transformMatrix.identity();
				transformMatrix.translate(-transformX, -transformY);
				transformMatrix.scale(defaultScaleX, defaultScaleY);
				transformMatrix.rotate(rotation * RADIANS_PER_DEGREES);
				transformMatrix.translate(regX + transformX, regY + transformY);
			}
			if (repeatFill || 
				(MatrixUtil.isDeltaIdentity(transformMatrix) && 
					transformMatrix.tx == targetBounds.left &&
					transformMatrix.ty == targetBounds.top &&
					targetBounds.width <= sourceAsBitmapData.width && 
					targetBounds.height <= sourceAsBitmapData.height))
			{
				if (nonRepeatAlphaSource && nonRepeatSourceCreated)
				{
					nonRepeatAlphaSource.dispose();
					nonRepeatAlphaSource = null;
					applyAlphaMultiplier = alpha != 1;
				}
				
				nonRepeatSourceCreated = false;
			}
			else if (fillMode == BitmapFillMode.CLIP)
			{
				if (regenerateNonRepeatSource || 
					lastBoundsWidth != targetBounds.width || 
					lastBoundsHeight != targetBounds.height)
				{
					
					if (nonRepeatAlphaSource)
						nonRepeatAlphaSource.dispose();
					
					var bitmapTopLeft:Point = new Point();
					var tx:Number = transformMatrix.tx;
					var ty:Number = transformMatrix.ty; 
					
					transformMatrix.tx = 0;
					transformMatrix.ty = 0;
					var bitmapSize:Point = MatrixUtil.transformBounds(
						sourceAsBitmapData.width, sourceAsBitmapData.height, 
						transformMatrix, 
						bitmapTopLeft);
					var newW:Number = Math.ceil(bitmapSize.x) + 2;
					var newY:Number = Math.ceil(bitmapSize.y) + 2;
					transformMatrix.translate(1 - bitmapTopLeft.x, 1 - bitmapTopLeft.y);
					nonRepeatAlphaSource = new BitmapData(newW, newY, true, 0xFFFFFF);
					nonRepeatAlphaSource.draw(sourceAsBitmapData, transformMatrix, null, null, null, smooth);
					transformMatrix.identity();
					
					transformMatrix.translate(tx + bitmapTopLeft.x - 1, ty + bitmapTopLeft.y - 1);
					
					lastBoundsWidth = targetBounds.width;
					lastBoundsHeight = targetBounds.height;
					
					nonRepeatSourceCreated = true;
					applyAlphaMultiplier = alpha != 1;
				}   
			}
			if (applyAlphaMultiplier)
			{
				
				if (!nonRepeatAlphaSource)
					nonRepeatAlphaSource = sourceAsBitmapData.clone();
				
				var ct:ColorTransform = new ColorTransform();
				ct.alphaMultiplier = alpha;
				
				nonRepeatAlphaSource.colorTransform(new Rectangle(0, 0, nonRepeatAlphaSource.width, nonRepeatAlphaSource.height), ct);
				applyAlphaMultiplier = false;
			}
			if (nonRepeatAlphaSource)
				sourceAsBitmapData = nonRepeatAlphaSource;
			
			target.beginBitmapFill(sourceAsBitmapData, transformMatrix, repeatFill, smooth);
		}
		
		public function end(target:Graphics):void
		{
			target.endFill();
		}
		
		private function dispatchFillChangedEvent(prop:String, oldValue:*,
												  value:*):void
		{
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop,
				oldValue, value));
			regenerateNonRepeatSource = true;
		}
		/**
		 * 设置位图数据
		 */		
		private function setBitmapData(bitmapData:BitmapData, internallyCreated:Boolean = false):void
		{         
			
			if (_bitmapData)
			{
				if (bitmapDataCreated) 
					_bitmapData.dispose();
				_bitmapData = null;
			}
			
			bitmapDataCreated = internallyCreated;         
			applyAlphaMultiplier = alpha != 1;
			_bitmapData = bitmapData;
			
			dispatchFillChangedEvent("bitmapData", null, null);
		}
	}
	
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
