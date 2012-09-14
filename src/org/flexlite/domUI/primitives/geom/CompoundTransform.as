package org.flexlite.domUI.primitives.geom
{
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * CompoundTransform 表示 2D 或 3D 矩阵转换。
	 * 复合转换表示可以作为 2D/3D 矩阵或各个简便转换属性（如 x、y、scaleX 和 rotationZ 等）进行查询或设置的矩阵。 
	 * @author DOM
	 */	
	public class CompoundTransform
	{
		public function CompoundTransform()
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
		
		private var _transformX:Number = 0;
		private var _transformY:Number = 0;
		private var _transformZ:Number = 0;
		
		private var _matrix:Matrix;
		private var _matrix3D:Matrix3D;
		
		
		private static const MATRIX_VALID:uint      = 0x20;
		private static const MATRIX3D_VALID:uint        = 0x40;
		private static const PROPERTIES_VALID:uint  = 0x80;
		
		private static const IS_3D:uint                 = 0x200;
		private static const M3D_FLAGS_VALID:uint           = 0x400;
		
		public static const SOURCE_PROPERTIES:uint          = 1;

		public static const SOURCE_MATRIX:uint          = 2;

		public static const SOURCE_MATRIX3D:uint            = 3;
		
		public var sourceOfTruth:uint = SOURCE_PROPERTIES;
		
		private var _flags:uint =  PROPERTIES_VALID;
		
		private static const INVALIDATE_FROM_NONE:uint =            0;                      
		private static const INVALIDATE_FROM_PROPERTY:uint =        4;                      
		private static const INVALIDATE_FROM_MATRIX:uint =          5;                      
		private static const INVALIDATE_FROM_MATRIX3D:uint =        6;                      
		
		private static var decomposition:Vector.<Number> = new Vector.<Number>();
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		
		public function set x(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _x)
				return;
			translateBy(value-_x,0,0);
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}

		public function get x():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _x;
		}
		
		public function set y(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _y)
				return;
			translateBy(0,value-_y,0);
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		
		public function get y():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _y;
		}
		
		public function set z(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _z)
				return;
			translateBy(0,0,value-_z);
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		public function get z():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _z;
		}
		
		public function set rotationX(value:Number):void
		{
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationX)
				return;
			_rotationX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get rotationX():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationY)
				return;
			_rotationY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get rotationY():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationZ)
				return;
			_rotationZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false);
		}
		
		public function get rotationZ():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationZ;
		}
		
		public function set scaleX(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleX)
				return;
			_scaleX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false);
		}
		
		public function get scaleX():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleX;
		}
		
		public function set scaleY(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleY)
				return;
			_scaleY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false);
		}
		
		public function get scaleY():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleY;
		}
		
		
		public function set scaleZ(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleZ)
				return;
			_scaleZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get scaleZ():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleZ;
		}
		
		
		public function get is3D():Boolean
		{
			if ((_flags & M3D_FLAGS_VALID) == 0)
				update3DFlags();
			return ((_flags & IS_3D) != 0);
		}
		
		public function set transformX(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformX)
				return;
			_transformX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get transformX():Number
		{
			return _transformX;
		}
		
		public function set transformY(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformY)
				return;
			_transformY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get transformY():Number
		{
			return _transformY;
		}

		public function set transformZ(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformZ)
				return;
			_transformZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true);
		}
		
		public function get transformZ():Number
		{
			return _transformZ;
		}
		
		private function invalidate(reason:uint, affects3D:Boolean):void
		{
			switch(reason)
			{
				case INVALIDATE_FROM_PROPERTY:
					sourceOfTruth = SOURCE_PROPERTIES;
					_flags |= PROPERTIES_VALID;
					_flags &= ~MATRIX_VALID;
					_flags &= ~MATRIX3D_VALID;
					break;
				case INVALIDATE_FROM_MATRIX:
					sourceOfTruth = SOURCE_MATRIX;
					_flags |= MATRIX_VALID;
					_flags &= ~PROPERTIES_VALID;
					_flags &= ~MATRIX3D_VALID;
					break;
				case INVALIDATE_FROM_MATRIX3D:
					sourceOfTruth = SOURCE_MATRIX3D;
					_flags |= MATRIX3D_VALID;
					_flags &= ~PROPERTIES_VALID;
					_flags &= ~MATRIX_VALID;
					break;
			}                       
			if (affects3D)
				_flags &= ~M3D_FLAGS_VALID;
			
		}
		
		private static const EPSILON:Number = .001;

		private function update3DFlags():void
		{           
			if ((_flags & M3D_FLAGS_VALID) == 0)
			{
				var matrixIs3D:Boolean = false;
				
				switch(sourceOfTruth)
				{
					case SOURCE_PROPERTIES:
						matrixIs3D = ( 
							(Math.abs(_scaleZ-1) > EPSILON) ||  
							((Math.abs(_rotationX)+EPSILON)%360) > 2*EPSILON ||
							((Math.abs(_rotationY)+EPSILON)%360) > 2*EPSILON ||
							Math.abs(_z) > EPSILON
						);
						break;
					case SOURCE_MATRIX:
						matrixIs3D = false;
						break;
					case SOURCE_MATRIX3D:
						var rawData:Vector.<Number> = _matrix3D.rawData;                    
						matrixIs3D = (rawData[2] != 0 ||       
							rawData[6] != 0 ||    
							rawData[8] !=0 ||      
							rawData[10] != 1 ||    
							rawData[14] != 0);     
						break;                              
				}
				
				if (matrixIs3D)
					_flags |= IS_3D;
				else
					_flags &= ~IS_3D;
				
				_flags |= M3D_FLAGS_VALID;
			}
		}
		
		
		public function translateBy(x:Number,y:Number,z:Number = 0):void
		{
			if (_flags & MATRIX_VALID)
			{
				_matrix.tx += x;
				_matrix.ty += y;
			}
			if (_flags & PROPERTIES_VALID)
			{
				_x += x;
				_y += y;
				_z += z;
			}
			if (_flags & MATRIX3D_VALID)
			{
				var data:Vector.<Number> = _matrix3D.rawData;
				data[12] += x;
				data[13] += y;
				data[14] += z;
				_matrix3D.rawData = data;           
			}   
			invalidate(INVALIDATE_FROM_NONE, z != 0);
		}
		
		
		public function get matrix():Matrix
		{
			
			if (_flags & MATRIX_VALID)
				return _matrix;
			
			if ((_flags & PROPERTIES_VALID) == false)
				validatePropertiesFromMatrix();
			
			var m:Matrix = _matrix;
			if (m == null)
				m = _matrix = new Matrix();
			else
				m.identity();
			
			build2DMatrix(m,_transformX,_transformY,
				_scaleX,_scaleY,
				_rotationZ,
				_x,_y);   
			_flags |= MATRIX_VALID;
			return m;       
		}
		
		public static function build2DMatrix(m:Matrix,
											 tx:Number,ty:Number,
											 sx:Number,sy:Number,
											 rz:Number,
											 x:Number,y:Number):void
		{
			m.translate(-tx,-ty);
			m.scale(sx,sy);
			m.rotate(rz* RADIANS_PER_DEGREES);
			m.translate(x+tx,y+ty);         
		}
		
		public function set matrix(v:Matrix):void
		{
			if (_matrix== null)
			{
				_matrix = v.clone();
			}
			else
			{
				_matrix.identity(); 
				_matrix.concat(v);          
			}
			
			invalidate(INVALIDATE_FROM_MATRIX, true);
		}
		
		private function validatePropertiesFromMatrix():void
		{       
			if (sourceOfTruth == SOURCE_MATRIX3D)
			{
				var result:Vector.<Vector3D> = _matrix3D.decompose();
				_rotationX = result[1].x / RADIANS_PER_DEGREES;
				_rotationY = result[1].y / RADIANS_PER_DEGREES;
				_rotationZ = result[1].z / RADIANS_PER_DEGREES;
				_scaleX = result[2].x;
				_scaleY = result[2].y;
				_scaleZ = result[2].z;
				
				if (_transformX != 0 || _transformY != 0 || _transformZ != 0)
				{
					var postTransformTCenter:Vector3D = _matrix3D.transformVector(new Vector3D(_transformX,_transformY,_transformZ));
					_x = postTransformTCenter.x - _transformX;
					_y = postTransformTCenter.y - _transformY;
					_z = postTransformTCenter.z - _transformZ;
				}
				else
				{
					_x = result[0].x;
					_y = result[0].y;
					_z = result[0].z;
				}
			}                        
			else if (sourceOfTruth == SOURCE_MATRIX)
			{
				MatrixUtil.decomposeMatrix(decomposition,_matrix,_transformX,_transformY);
				_x = decomposition[0];
				_y = decomposition[1];
				_z = 0;
				_rotationX = 0;
				_rotationY = 0;
				_rotationZ = decomposition[2];
				_scaleX = decomposition[3];
				_scaleY = decomposition[4];
				_scaleZ = 1;
			}
			_flags |= PROPERTIES_VALID;
			
		}
		
		
		
		public function get matrix3D():Matrix3D
		{
			if (_flags & MATRIX3D_VALID)
				return _matrix3D;
			
			if ((_flags & PROPERTIES_VALID) == false)
				validatePropertiesFromMatrix();
			
			var m:Matrix3D = _matrix3D;
			if (m == null)
				m =  _matrix3D = new Matrix3D();
			else
				m.identity();
			
			build3DMatrix(m,transformX,transformY,transformZ,
				_scaleX,_scaleY,_scaleZ,
				_rotationX,_rotationY,_rotationZ,                       
				_x,_y,_z);
			_flags |= MATRIX3D_VALID;
			return m;
			
		}
		
		private static var reVT:Vector3D = new Vector3D(0,0,0);
		private static var reVR:Vector3D = new Vector3D(0,0,0);
		private static var reVS:Vector3D = new Vector3D(1,1,1);
		
		private static var reV:Vector.<Vector3D> = new Vector.<Vector3D>();
		reV.push(reVT);
		reV.push(reVR);
		reV.push(reVS);
		
		
		private static const ZERO_REPLACEMENT_IN_3D:Number = .00000000000001;
		
		public static function build3DMatrix(m:Matrix3D,
											 tx:Number,ty:Number,tz:Number,
											 sx:Number,sy:Number,sz:Number,
											 rx:Number,ry:Number,rz:Number,
											 x:Number,y:Number,z:Number):void
		{
			reVR.x = rx * RADIANS_PER_DEGREES;
			reVR.y = ry * RADIANS_PER_DEGREES;
			reVR.z = rz * RADIANS_PER_DEGREES;
			m.recompose(reV);
			if (sx == 0)
				sx = ZERO_REPLACEMENT_IN_3D;
			if (sy == 0)
				sy = ZERO_REPLACEMENT_IN_3D;
			if (sz == 0)
				sz = ZERO_REPLACEMENT_IN_3D;
			m.prependScale(sx,sy,sz);
			m.prependTranslation(-tx,-ty,-tz);
			m.appendTranslation(tx+x,ty+y,tz+z);
		}      
		
		public function set matrix3D(v:Matrix3D):void
		{
			if (_matrix3D == null)
			{
				_matrix3D = v.clone();
			}
			else
			{
				_matrix3D.identity();
				if (v)
					_matrix3D.append(v);            
			}
			invalidate(INVALIDATE_FROM_MATRIX3D, true /*affects3D*/);
		}
		
	}
}