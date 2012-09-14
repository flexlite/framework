<<<<<<< HEAD
package org.flexlite.domUI.primitives.geom
{
	import org.flexlite.domUI.core.IGraphicElement;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	use namespace dx_internal;
	
	public class Transform extends flash.geom.Transform
	{
		
		public function Transform(src:DisplayObject = null)
		{        
			if (src == null)
				src = new Shape();
			super(src);        
		}
		
		dx_internal var applyColorTransformAlpha:Boolean = false;
		
		dx_internal var applyMatrix:Boolean = false;
		
		dx_internal var applyMatrix3D:Boolean = false;
		
		override public function set colorTransform(value:ColorTransform):void
		{   
			if (target && "$transform" in target) 
				target["$transform"]["colorTransform"] = value;
			else if (target && "setColorTransform" in target)
				target["setColorTransform"](value);            
			else
				super.colorTransform = value;
			
			applyColorTransformAlpha = true;
		}
		
		override public function get colorTransform():ColorTransform
		{
			if (target && "$transform" in target) 
				return target["$transform"]["colorTransform"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["colorTransform"];
			else
				return super.colorTransform;    
		}
		
		override public function get concatenatedColorTransform():ColorTransform
		{
			if (target && "$transform" in target) 
				return target["$transform"]["concatenatedColorTransform"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["concatenatedColorTransform"];
			else
				return super.concatenatedColorTransform;    
		}
		
		override public function get concatenatedMatrix():Matrix
		{
			if (target && "$transform" in target) 
				return target["$transform"]["concatenatedMatrix"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["concatenatedMatrix"];
			else
				return super.concatenatedMatrix;
		}
		
		override public function set matrix(value:Matrix):void
		{
			super.matrix = value;
			
			applyMatrix = value != null;
			applyMatrix3D = false;
		}
		
		override public function get matrix():Matrix
		{
			return super.matrix;
		}
		
		override public function set matrix3D(value:Matrix3D):* 
		{
			super.matrix3D = value;
			
			applyMatrix3D = value != null;
			applyMatrix = false;
		}
		
		override public function get matrix3D():Matrix3D
		{
			return super.matrix3D;
		}
		
		override public function set perspectiveProjection(value:PerspectiveProjection):void
		{
			
			var oldValue:PerspectiveProjection = super.perspectiveProjection;
			super.perspectiveProjection = value;    
			
		}
		
		override public function get perspectiveProjection():PerspectiveProjection
		{
			if (target && "$transform" in target) 
				return target["$transform"]["perspectiveProjection"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["perspectiveProjection"];
			else
				return super.perspectiveProjection;    
		}
		
		override public function get pixelBounds():Rectangle
		{
			if (target && "$transform" in target) 
				return target["$transform"]["pixelBounds"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["pixelBounds"];
			else
				return super.pixelBounds;
		}
		
		private var _target:IGraphicElement;
		
		public function set target(value:IGraphicElement):void
		{
			if (value !== _target)
				_target = value;
		}
		
		public function get target():IGraphicElement
		{
			return _target;
		}
		
		override public function getRelativeMatrix3D(relativeTo:DisplayObject):Matrix3D
		{
			if (target && "$transform" in target) 
				return target["$transform"]["getRelativeMatrix3D"](relativeTo);
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["getRelativeMatrix3D"](relativeTo);
			else
				return super.getRelativeMatrix3D(relativeTo);
		}
	}
=======
package org.flexlite.domUI.primitives.geom
{
	import org.flexlite.domUI.core.IGraphicElement;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	use namespace dx_internal;
	
	public class Transform extends flash.geom.Transform
	{
		
		public function Transform(src:DisplayObject = null)
		{        
			if (src == null)
				src = new Shape();
			super(src);        
		}
		
		dx_internal var applyColorTransformAlpha:Boolean = false;
		
		dx_internal var applyMatrix:Boolean = false;
		
		dx_internal var applyMatrix3D:Boolean = false;
		
		override public function set colorTransform(value:ColorTransform):void
		{   
			if (target && "$transform" in target) 
				target["$transform"]["colorTransform"] = value;
			else if (target && "setColorTransform" in target)
				target["setColorTransform"](value);            
			else
				super.colorTransform = value;
			
			applyColorTransformAlpha = true;
		}
		
		override public function get colorTransform():ColorTransform
		{
			if (target && "$transform" in target) 
				return target["$transform"]["colorTransform"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["colorTransform"];
			else
				return super.colorTransform;    
		}
		
		override public function get concatenatedColorTransform():ColorTransform
		{
			if (target && "$transform" in target) 
				return target["$transform"]["concatenatedColorTransform"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["concatenatedColorTransform"];
			else
				return super.concatenatedColorTransform;    
		}
		
		override public function get concatenatedMatrix():Matrix
		{
			if (target && "$transform" in target) 
				return target["$transform"]["concatenatedMatrix"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["concatenatedMatrix"];
			else
				return super.concatenatedMatrix;
		}
		
		override public function set matrix(value:Matrix):void
		{
			super.matrix = value;
			
			applyMatrix = value != null;
			applyMatrix3D = false;
		}
		
		override public function get matrix():Matrix
		{
			return super.matrix;
		}
		
		override public function set matrix3D(value:Matrix3D):* 
		{
			super.matrix3D = value;
			
			applyMatrix3D = value != null;
			applyMatrix = false;
		}
		
		override public function get matrix3D():Matrix3D
		{
			return super.matrix3D;
		}
		
		override public function set perspectiveProjection(value:PerspectiveProjection):void
		{
			
			var oldValue:PerspectiveProjection = super.perspectiveProjection;
			super.perspectiveProjection = value;    
			
		}
		
		override public function get perspectiveProjection():PerspectiveProjection
		{
			if (target && "$transform" in target) 
				return target["$transform"]["perspectiveProjection"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["perspectiveProjection"];
			else
				return super.perspectiveProjection;    
		}
		
		override public function get pixelBounds():Rectangle
		{
			if (target && "$transform" in target) 
				return target["$transform"]["pixelBounds"];
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["pixelBounds"];
			else
				return super.pixelBounds;
		}
		
		private var _target:IGraphicElement;
		
		public function set target(value:IGraphicElement):void
		{
			if (value !== _target)
				_target = value;
		}
		
		public function get target():IGraphicElement
		{
			return _target;
		}
		
		override public function getRelativeMatrix3D(relativeTo:DisplayObject):Matrix3D
		{
			if (target && "$transform" in target) 
				return target["$transform"]["getRelativeMatrix3D"](relativeTo);
			else if (target && "displayObject" in target && target["displayObject"] != null)
				return target["displayObject"]["transform"]["getRelativeMatrix3D"](relativeTo);
			else
				return super.getRelativeMatrix3D(relativeTo);
		}
	}
>>>>>>> master
}