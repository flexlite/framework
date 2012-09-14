package org.flexlite.domUI.primitives.supportClasses
{
    import org.flexlite.domUI.core.dx_internal;
    import org.flexlite.domUI.primitives.geom.CompoundTransform;
    import org.flexlite.domUI.primitives.geom.TransformOffsets;
    
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.system.Capabilities;
	
	use namespace dx_internal;
    

    public class AdvancedLayoutFeatures
    {
        public function AdvancedLayoutFeatures()
        {
            layout = new CompoundTransform();
        }
    
    public var updatePending:Boolean = false;
    public var depth:Number = 0;
    protected var _computedMatrix:Matrix;
    protected var _computedMatrix3D:Matrix3D;
    protected var layout:CompoundTransform;
    private var _postLayoutTransformOffsets:TransformOffsets;
    private static const COMPUTED_MATRIX_VALID:uint     = 0x1;
    private static const COMPUTED_MATRIX3D_VALID:uint   = 0x2;
    private var _flags:uint = 0;
    private static var reVT:Vector3D = new Vector3D(0,0,0);
    private static var reVR:Vector3D = new Vector3D(0,0,0);
    private static var reVS:Vector3D = new Vector3D(1,1,1);
    
    private static var reV:Vector.<Vector3D> = new Vector.<Vector3D>();
    reV.push(reVT);
    reV.push(reVR);
    reV.push(reVS);
    private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;

    private static const ZERO_REPLACEMENT_IN_3D:Number = .00000000000001;
    
    private static var tempLocalPosition:Vector3D;
    private static var transformVector:Function = initTransformVectorFunction;
    private static function pre10_0_22_87_transformVector(m:Matrix3D,v:Vector3D):Vector3D
    {
        var r:Vector.<Number> = m.rawData;
        return new Vector3D(
            r[0] * v.x + r[4] * v.y + r[8] * v.z + r[12], 
            r[1] * v.x + r[5] * v.y + r[9] * v.z + r[13], 
            r[2] * v.x + r[6] * v.y + r[10] * v.z + r[14],
            1); 
    }
    private static function nativeTransformVector(m:Matrix3D,v:Vector3D):Vector3D
    {
        return m.transformVector(v);
    }
    private static function initTransformVectorFunction(m:Matrix3D,v:Vector3D):Vector3D
    {
        var canUseNative:Boolean = false;
        var version:Array = Capabilities.version.split(' ')[1].split(',');
        if (parseFloat(version[0]) > 10)
            canUseNative  = true;
        else if (parseFloat(version[1]) > 0)
            canUseNative  = true;
        else if (parseFloat(version[2]) > 22)
            canUseNative  = true;
        else if (parseFloat(version[3]) >= 87)
            canUseNative  = true;
        if (canUseNative)
            transformVector = nativeTransformVector;
        else
            transformVector = pre10_0_22_87_transformVector;
        
        return transformVector(m,v);
    }
    public function set layoutX(value:Number):void
    {
        layout.x = value;
        invalidate();
    }
    public function get layoutX():Number
    {
        return layout.x;
    }
    
    public function set layoutY(value:Number):void
    {
        layout.y = value;
        invalidate();
    }
    public function get layoutY():Number
    {
        return layout.y;
    }
    public function set layoutZ(value:Number):void
    {
        layout.z = value;
        invalidate();
    }
    public function get layoutZ():Number
    {
        return layout.z;
    }
	private var _layoutWidth:Number = 0;
	public function get layoutWidth():Number
	{
		return _layoutWidth;
	}
	public function set layoutWidth(value:Number):void
	{
		if (value == _layoutWidth)
			return;
		_layoutWidth = value;
		invalidate();
	}
    public function set transformX(value:Number):void
    {
        layout.transformX = value;
        invalidate();
    }
    
    public function get transformX():Number
    {
        return layout.transformX;
    }
    public function set transformY(value:Number):void
    {
        layout.transformY = value;
        invalidate();
    }
    public function get transformY():Number
    {
        return layout.transformY;
    }
    public function set transformZ(value:Number):void
    {
        layout.transformZ = value;  
        invalidate();
    }
    public function get transformZ():Number
    {
        return layout.transformZ;
    }
    public function set layoutRotationX(value:Number):void
    {
        layout.rotationX= value;
        invalidate();
    }
    public function get layoutRotationX():Number
    {
        return layout.rotationX;
    }
    public function set layoutRotationY(value:Number):void
    {
        layout.rotationY= value;
        invalidate();
    }
    public function get layoutRotationY():Number
    {
        return layout.rotationY;
    }
    public function set layoutRotationZ(value:Number):void
    {
        layout.rotationZ= value;
        invalidate();
    }
    public function get layoutRotationZ():Number
    {
        return layout.rotationZ;
    }
    public function set layoutScaleX(value:Number):void
    {
        layout.scaleX = value;
        invalidate();
    }
    public function get layoutScaleX():Number
    {
        return layout.scaleX;
    }
    public function set layoutScaleY(value:Number):void
    {
        layout.scaleY= value;
        invalidate();
    }
    public function get layoutScaleY():Number
    {
        return layout.scaleY;
    }
    
    public function set layoutScaleZ(value:Number):void
    {
        layout.scaleZ= value;
        invalidate();
    }
    public function get layoutScaleZ():Number
    {
        return layout.scaleZ;
    }
    public function set layoutMatrix(value:Matrix):void
    {
        layout.matrix = value;
        invalidate();
    }
    
    public function get layoutMatrix():Matrix
    {
        return layout.matrix;
                            
    }
    
    public function set layoutMatrix3D(value:Matrix3D):void
    {
        layout.matrix3D = value;
        invalidate();
    }
    public function get layoutMatrix3D():Matrix3D
    {
        return layout.matrix3D;
    }
    public function get is3D():Boolean
    {
        return (layout.is3D || (postLayoutTransformOffsets != null && postLayoutTransformOffsets.is3D));
    }
    public function get layoutIs3D():Boolean
    {
        return layout.is3D;
    }
    public function set postLayoutTransformOffsets(value:TransformOffsets):void
    {
        if (_postLayoutTransformOffsets != null)
        {
            _postLayoutTransformOffsets.removeEventListener(Event.CHANGE,postLayoutTransformOffsetsChangedHandler);
            _postLayoutTransformOffsets.owner = null;
        }
        _postLayoutTransformOffsets = value;
        if (_postLayoutTransformOffsets != null)
        {
            _postLayoutTransformOffsets.addEventListener(Event.CHANGE,postLayoutTransformOffsetsChangedHandler);
            _postLayoutTransformOffsets.owner = this;
        }
        invalidate();       
    }
    
    public function get postLayoutTransformOffsets():TransformOffsets
    {
        return _postLayoutTransformOffsets;
    }
    
    private function postLayoutTransformOffsetsChangedHandler(e:Event):void
    {
        invalidate();       
    }
	private var _mirror:Boolean = false;
	public function get mirror():Boolean
	{
		return _mirror;
	}
	public function set mirror(value:Boolean):void
	{
		_mirror = value;
		invalidate();
	}
    private var _stretchX:Number = 1;
    public function get stretchX():Number
    {
        return _stretchX;
    }
    public function set stretchX(value:Number):void
    {
        if (value == _stretchX)
            return;         
        _stretchX = value;
        invalidate();
    }
    private var _stretchY:Number = 1;
    public function get stretchY():Number
    {
        return _stretchY;
    }
    public function set stretchY(value:Number):void
    {
        if (value == _stretchY)
            return;         
        _stretchY = value;
        invalidate();
    }
    private function invalidate():void
    {                       
        _flags &= ~COMPUTED_MATRIX_VALID;
        _flags &= ~COMPUTED_MATRIX3D_VALID;
    }
    
    public function get computedMatrix():Matrix
    {
        if (_flags & COMPUTED_MATRIX_VALID)
            return _computedMatrix;
    
        if (!postLayoutTransformOffsets && !mirror && stretchX == 1 && stretchY == 1)
        {
            return layout.matrix;
        }           
        
        var m:Matrix = _computedMatrix;
        if (m == null)
            m = _computedMatrix = new Matrix();
        else
            m.identity();
            
        var tx:Number = layout.transformX;
        var ty:Number = layout.transformY;
        var sx:Number = layout.scaleX;
        var sy:Number = layout.scaleY;
        var rz:Number = layout.rotationZ;
        var x:Number = layout.x;
        var y:Number = layout.y;
		
		if (mirror)
		{
			sx *= -1;
			x += layoutWidth;
		}
		
        if (postLayoutTransformOffsets)
        {
            sx *= postLayoutTransformOffsets.scaleX;
            sy *= postLayoutTransformOffsets.scaleY;
            rz += postLayoutTransformOffsets.rotationZ;
            x += postLayoutTransformOffsets.x;
            y += postLayoutTransformOffsets.y;
        }
        
        if (stretchX != 1 || stretchY != 1)
            m.scale(stretchX, stretchY);
        build2DMatrix(m, tx, ty, sx, sy, rz, x, y);
        
        _flags |= COMPUTED_MATRIX_VALID;
        return m;
    }
    public function get computedMatrix3D():Matrix3D
    {
        if (_flags & COMPUTED_MATRIX3D_VALID)
            return _computedMatrix3D;
        if (!postLayoutTransformOffsets && !mirror && stretchX == 1 && stretchY == 1)
        {
            return layout.matrix3D;
        }

        var m:Matrix3D = _computedMatrix3D;
        if (m == null)
            m = _computedMatrix3D = new Matrix3D();
        else
            m.identity();
            
        var tx:Number = layout.transformX;
        var ty:Number = layout.transformY;
        var tz:Number = layout.transformZ;
        var sx:Number = layout.scaleX;
        var sy:Number = layout.scaleY;
        var sz:Number = layout.scaleZ;
        var rx:Number = layout.rotationX;
        var ry:Number = layout.rotationY;
        var rz:Number = layout.rotationZ;
        var x:Number = layout.x;
        var y:Number = layout.y;
        var z:Number = layout.z;
		
		if (mirror)
		{
			sx *= -1;
			x += layoutWidth;
		}
		
        if (postLayoutTransformOffsets)
        {
            sx *= postLayoutTransformOffsets.scaleX;
            sy *= postLayoutTransformOffsets.scaleY;
            sz *= postLayoutTransformOffsets.scaleZ;
            rx += postLayoutTransformOffsets.rotationX;
            ry += postLayoutTransformOffsets.rotationY;
            rz += postLayoutTransformOffsets.rotationZ;
            x += postLayoutTransformOffsets.x;
            y += postLayoutTransformOffsets.y;
            z += postLayoutTransformOffsets.z;
        }
            
        build3DMatrix(m, tx, ty, tz, sx, sy, sz, rx, ry, rz, x, y, z);
        
        if (stretchX != 1 || stretchY != 1)
            m.prependScale(stretchX, stretchY, 1);  

        _flags |= COMPUTED_MATRIX3D_VALID;
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
    
    public function transformPointToParent(propertyIs3D:Boolean,
        localPosition:Vector3D, position:Vector3D,
        postLayoutPosition:Vector3D):void
    {
        var transformedV:Vector3D;
        var transformedP:Point;
        tempLocalPosition = 
            localPosition ?
            localPosition.clone() :
            new Vector3D();
                
        if (is3D || propertyIs3D) 
        {
            if (position != null)
            {
                transformedV = transformVector(layoutMatrix3D, tempLocalPosition); 
                position.x = transformedV.x;
                position.y = transformedV.y;
                position.z = transformedV.z;
            } 
            
            if (postLayoutPosition != null)
            {           
                
                tempLocalPosition.x /= stretchX;
                tempLocalPosition.y /= stretchY;
                transformedV = transformVector(computedMatrix3D, tempLocalPosition);
                postLayoutPosition.x = transformedV.x;
                postLayoutPosition.y = transformedV.y;
                postLayoutPosition.z = transformedV.z;
            }
        }
        else
        {
            var localP:Point = new Point(tempLocalPosition.x, 
                tempLocalPosition.y);
            if (position != null)
            {
                transformedP = layoutMatrix.transformPoint(localP);
                position.x = transformedP.x;
                position.y = transformedP.y;
                position.z = 0;
            }
            
            if (postLayoutPosition != null)
            {
                
                localP.x /= stretchX;
                localP.y /= stretchY;
                transformedP = computedMatrix.transformPoint(localP);
                postLayoutPosition.x = transformedP.x;
                postLayoutPosition.y = transformedP.y;
                postLayoutPosition.z = 0;
            }
        }
    }
    private function completeTransformCenterAdjustment(changeIs3D:Boolean, 
        transformCenter:Vector3D, targetPosition:Vector3D,
        targetPostLayoutPosition:Vector3D):void
    {
        
        if (is3D || changeIs3D)
        {
            if (targetPosition != null)
            {
                var adjustedLayoutCenterV:Vector3D = transformVector(layoutMatrix3D, transformCenter); 
                if (adjustedLayoutCenterV.equals(targetPosition) == false)
                {
                    layout.translateBy(targetPosition.x - adjustedLayoutCenterV.x,
                        targetPosition.y - adjustedLayoutCenterV.y, 
                        targetPosition.z - adjustedLayoutCenterV.z);
                    invalidate(); 
                }       
            }
            if (targetPostLayoutPosition != null && _postLayoutTransformOffsets != null)
            {
                
                var tmpPos:Vector3D = new Vector3D(transformCenter.x, transformCenter.y, transformCenter.z);
                tmpPos.x /= stretchX;
                tmpPos.y /= stretchY;
                var adjustedComputedCenterV:Vector3D = transformVector(computedMatrix3D, tmpPos);
                if (adjustedComputedCenterV.equals(targetPostLayoutPosition) == false)
                {
                    postLayoutTransformOffsets.x +=targetPostLayoutPosition.x - adjustedComputedCenterV.x;
                    postLayoutTransformOffsets.y += targetPostLayoutPosition.y - adjustedComputedCenterV.y;
                    postLayoutTransformOffsets.z += targetPostLayoutPosition.z - adjustedComputedCenterV.z;
                    invalidate(); 
                }       
            }
        }
        else
        {
            var transformCenterP:Point = new Point(transformCenter.x,transformCenter.y);
            if (targetPosition != null)
            {
                var currentPositionP:Point = layoutMatrix.transformPoint(transformCenterP);
                if (currentPositionP.x != targetPosition.x || 
                    currentPositionP.y != targetPosition.y)
                {
                    layout.translateBy(targetPosition.x - currentPositionP.x,
                        targetPosition.y - currentPositionP.y, 0);
                    invalidate(); 
                }       
            }
            
            if (targetPostLayoutPosition != null && _postLayoutTransformOffsets != null)
            {           
                
                transformCenterP.x /= stretchX;
                transformCenterP.y /= stretchY;
                var currentPostLayoutPosition:Point = 
                    computedMatrix.transformPoint(transformCenterP);
                if (currentPostLayoutPosition.x != targetPostLayoutPosition.x || 
                    currentPostLayoutPosition.y != targetPostLayoutPosition.y)
                {
                    _postLayoutTransformOffsets.x += targetPostLayoutPosition.x - currentPostLayoutPosition.x;
                    _postLayoutTransformOffsets.y += targetPostLayoutPosition.y - currentPostLayoutPosition.y;
                    invalidate(); 
                }       
            }
        }
    }   
    
    private static var staticTranslation:Vector3D = new Vector3D();
    private static var staticOffsetTranslation:Vector3D = new Vector3D();
    public function transformAround(transformCenter:Vector3D,
                                    scale:Vector3D,
                                    rotation:Vector3D,
                                    transformCenterPosition:Vector3D,
                                    postLayoutScale:Vector3D = null,
                                    postLayoutRotation:Vector3D = null,
                                    postLayoutTransformCenterPosition:Vector3D = null):void
    {
        var is3D:Boolean = (scale != null && scale.z != 1) ||
            (rotation != null && ((rotation.x != 0 ) || (rotation.y != 0))) || 
            (transformCenterPosition != null && transformCenterPosition.z != 0) ||
            (postLayoutScale != null && postLayoutScale.z != 1) ||
            (postLayoutRotation != null && 
                (postLayoutRotation.x != 0 || postLayoutRotation.y != 0)) || 
            (postLayoutTransformCenterPosition != null && postLayoutTransformCenterPosition.z != 0);

        var needOffsets:Boolean = _postLayoutTransformOffsets == null && 
            (postLayoutScale != null || postLayoutRotation != null || 
                postLayoutTransformCenterPosition != null);
        if (needOffsets)
            _postLayoutTransformOffsets = new TransformOffsets();                                               
        if (transformCenter != null && 
            (transformCenterPosition == null || postLayoutTransformCenterPosition == null))
        {           
            transformPointToParent(is3D, transformCenter, staticTranslation,
                staticOffsetTranslation);
            if (postLayoutTransformCenterPosition == null && transformCenterPosition != null)
            {
                staticOffsetTranslation.x = transformCenterPosition.x + staticOffsetTranslation.x - staticTranslation.x;
                staticOffsetTranslation.y = transformCenterPosition.y + staticOffsetTranslation.y - staticTranslation.y;
                staticOffsetTranslation.z = transformCenterPosition.z + staticOffsetTranslation.z - staticTranslation.z;
            }
                     
        }
        var targetPosition:Vector3D = (transformCenterPosition == null)? staticTranslation:transformCenterPosition;
        var postLayoutTargetPosition:Vector3D = (postLayoutTransformCenterPosition == null)? staticOffsetTranslation:postLayoutTransformCenterPosition;
        if (rotation != null)
        {
            if (!isNaN(rotation.x))
                layout.rotationX = rotation.x;
            if (!isNaN(rotation.y))
                layout.rotationY = rotation.y;
            if (!isNaN(rotation.z))
                layout.rotationZ = rotation.z;
        }
        if (scale != null)
        {           
            if (!isNaN(scale.x))
                layout.scaleX = scale.x;
            if (!isNaN(scale.y))
                layout.scaleY = scale.y;
            if (!isNaN(scale.z))
                layout.scaleZ = scale.z;
        }

        if (postLayoutRotation != null)
        {           
            _postLayoutTransformOffsets.rotationX = postLayoutRotation.x;
            _postLayoutTransformOffsets.rotationY = postLayoutRotation.y;
            _postLayoutTransformOffsets.rotationZ = postLayoutRotation.z;
        }
        if (postLayoutScale != null)
        {           
            _postLayoutTransformOffsets.scaleX = postLayoutScale.x;
            _postLayoutTransformOffsets.scaleY = postLayoutScale.y;
            _postLayoutTransformOffsets.scaleZ = postLayoutScale.z;
        }
        if (transformCenter == null)
        {
            if (transformCenterPosition != null)
            {
                layout.x = transformCenterPosition.x;
                layout.y = transformCenterPosition.y;
                layout.z = transformCenterPosition.z;
            }
            if (postLayoutTransformCenterPosition != null)
            {
                _postLayoutTransformOffsets.x = postLayoutTransformCenterPosition.x - layout.x;
                _postLayoutTransformOffsets.y = postLayoutTransformCenterPosition.y - layout.y;
                _postLayoutTransformOffsets.z = postLayoutTransformCenterPosition.z - layout.z;
            }
        }
        invalidate();
        if (transformCenter != null)
            completeTransformCenterAdjustment(is3D, transformCenter, 
                targetPosition, postLayoutTargetPosition);
    }
        
}
}

