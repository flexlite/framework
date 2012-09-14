<<<<<<< HEAD
package org.flexlite.domUI.primitives.geom
{
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.primitives.supportClasses.AdvancedLayoutFeatures;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	use namespace dx_internal;
	
	public class TransformOffsets extends EventDispatcher 
	{
		public function TransformOffsets()
		{
		}
		
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _scaleZ:Number = 1;		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private static const IS_3D:uint 				= 0x200;
		private static const M3D_FLAGS_VALID:uint			= 0x400;
		
		private var _flags:uint =  0;
		
		dx_internal var owner:AdvancedLayoutFeatures;
		
		public function set x(value:Number):void
		{		
			if (value == _x)
				return;
			_x = value;
			invalidate(false);
		}
		
		public function get x():Number
		{		
			return _x;
		}
		public function set y(value:Number):void
		{		
			if (value == _y)
				return;
			_y = value;
			invalidate(false);
		}
		public function get y():Number
		{		
			return _y;
		}
		public function set z(value:Number):void
		{		
			if (value == _z)
				return;
			_z = value;
			invalidate(true);
		}
		public function get z():Number
		{		
			return _z;
		}
		public function set rotationX(value:Number):void
		{		
			if (value == _rotationX)
				return;
			_rotationX = value;
			invalidate(true);
		}
		public function get rotationX():Number
		{		
			return _rotationX;
		}
		public function set rotationY(value:Number):void
		{		
			if (value == _rotationY)
				return;
			_rotationY = value;
			invalidate(true);
		}
		public function get rotationY():Number
		{		
			return _rotationY;
		}
		public function set rotationZ(value:Number):void
		{		
			if (value == _rotationZ)
				return;
			_rotationZ = value;
			invalidate(false);
		}
		public function get rotationZ():Number
		{		
			return _rotationZ;
		}
		public function set scaleX(value:Number):void
		{		
			if (value == _scaleX)
				return;
			_scaleX = value;
			invalidate(false);
		}
		public function get scaleX():Number
		{
			return _scaleX;
		}
		public function set scaleY(value:Number):void
		{		
			if (value == _scaleY)
				return;
			_scaleY = value;
			invalidate(false);
		}
		public function get scaleY():Number
		{		
			return _scaleY;
		}
		
		public function set scaleZ(value:Number):void
		{		
			if (value == _scaleZ)
				return;
			_scaleZ = value;
			invalidate(true);
		}
		public function get scaleZ():Number
		{		
			return _scaleZ;
		}
		
		dx_internal function get is3D():Boolean
		{
			if ((_flags & M3D_FLAGS_VALID) == 0)
				update3DFlags();
			return ((_flags & IS_3D) != 0);
		}
		private function invalidate(affects3D:Boolean,dispatchChangeEvent:Boolean = true):void
		{
			if (affects3D)
				_flags &= ~M3D_FLAGS_VALID;
			
			if (dispatchChangeEvent)
				dispatchEvent(new Event(Event.CHANGE));	
		}
		
		private static const EPSILON:Number = .001;
		
		private function update3DFlags():void
		{			
			if ((_flags & M3D_FLAGS_VALID) == 0)
			{
				var matrixIs3D:Boolean = ( 
					(Math.abs(_scaleZ-1) > EPSILON) ||  
					((Math.abs(_rotationX)+EPSILON)%360) > 2*EPSILON ||
					((Math.abs(_rotationY)+EPSILON)%360) > 2*EPSILON ||
					Math.abs(_z) > EPSILON
				);
				if (matrixIs3D)
					_flags |= IS_3D;
				else
					_flags &= ~IS_3D;				
				_flags |= M3D_FLAGS_VALID;
			}
		}
		
	}
}
=======
package org.flexlite.domUI.primitives.geom
{
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.primitives.supportClasses.AdvancedLayoutFeatures;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	use namespace dx_internal;
	
	public class TransformOffsets extends EventDispatcher 
	{
		public function TransformOffsets()
		{
		}
		
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _scaleZ:Number = 1;		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private static const IS_3D:uint 				= 0x200;
		private static const M3D_FLAGS_VALID:uint			= 0x400;
		
		private var _flags:uint =  0;
		
		dx_internal var owner:AdvancedLayoutFeatures;
		
		public function set x(value:Number):void
		{		
			if (value == _x)
				return;
			_x = value;
			invalidate(false);
		}
		
		public function get x():Number
		{		
			return _x;
		}
		public function set y(value:Number):void
		{		
			if (value == _y)
				return;
			_y = value;
			invalidate(false);
		}
		public function get y():Number
		{		
			return _y;
		}
		public function set z(value:Number):void
		{		
			if (value == _z)
				return;
			_z = value;
			invalidate(true);
		}
		public function get z():Number
		{		
			return _z;
		}
		public function set rotationX(value:Number):void
		{		
			if (value == _rotationX)
				return;
			_rotationX = value;
			invalidate(true);
		}
		public function get rotationX():Number
		{		
			return _rotationX;
		}
		public function set rotationY(value:Number):void
		{		
			if (value == _rotationY)
				return;
			_rotationY = value;
			invalidate(true);
		}
		public function get rotationY():Number
		{		
			return _rotationY;
		}
		public function set rotationZ(value:Number):void
		{		
			if (value == _rotationZ)
				return;
			_rotationZ = value;
			invalidate(false);
		}
		public function get rotationZ():Number
		{		
			return _rotationZ;
		}
		public function set scaleX(value:Number):void
		{		
			if (value == _scaleX)
				return;
			_scaleX = value;
			invalidate(false);
		}
		public function get scaleX():Number
		{
			return _scaleX;
		}
		public function set scaleY(value:Number):void
		{		
			if (value == _scaleY)
				return;
			_scaleY = value;
			invalidate(false);
		}
		public function get scaleY():Number
		{		
			return _scaleY;
		}
		
		public function set scaleZ(value:Number):void
		{		
			if (value == _scaleZ)
				return;
			_scaleZ = value;
			invalidate(true);
		}
		public function get scaleZ():Number
		{		
			return _scaleZ;
		}
		
		dx_internal function get is3D():Boolean
		{
			if ((_flags & M3D_FLAGS_VALID) == 0)
				update3DFlags();
			return ((_flags & IS_3D) != 0);
		}
		private function invalidate(affects3D:Boolean,dispatchChangeEvent:Boolean = true):void
		{
			if (affects3D)
				_flags &= ~M3D_FLAGS_VALID;
			
			if (dispatchChangeEvent)
				dispatchEvent(new Event(Event.CHANGE));	
		}
		
		private static const EPSILON:Number = .001;
		
		private function update3DFlags():void
		{			
			if ((_flags & M3D_FLAGS_VALID) == 0)
			{
				var matrixIs3D:Boolean = ( 
					(Math.abs(_scaleZ-1) > EPSILON) ||  
					((Math.abs(_rotationX)+EPSILON)%360) > 2*EPSILON ||
					((Math.abs(_rotationY)+EPSILON)%360) > 2*EPSILON ||
					Math.abs(_z) > EPSILON
				);
				if (matrixIs3D)
					_flags |= IS_3D;
				else
					_flags &= ~IS_3D;				
				_flags |= M3D_FLAGS_VALID;
			}
		}
		
	}
}
>>>>>>> master
