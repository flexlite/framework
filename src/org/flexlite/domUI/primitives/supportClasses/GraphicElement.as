package org.flexlite.domUI.primitives.supportClasses
{
	
	import org.flexlite.domUI.core.DisplayObjectSharingMode;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IGraphicElement;
	import org.flexlite.domUI.core.IGraphicElementContainer;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.MaskType;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.primitives.geom.Transform;
	import org.flexlite.domUI.primitives.geom.TransformOffsets;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.ColorBurnShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.ColorDodgeShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.ColorShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.ExclusionShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.HueShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.LuminosityShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.SaturationShader;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.SoftLightShader;
	import org.flexlite.domUI.utils.MaskUtil;
	import org.flexlite.domUI.utils.MatrixUtil;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 用于定义各个图形元素的基类。
	 * @author DOM
	 */	
	public class GraphicElement extends EventDispatcher
		implements IGraphicElement, IInvalidating, ILayoutElement
	{
		private static const DEFAULT_MAX_WIDTH:Number = 10000;
		
		private static const DEFAULT_MAX_HEIGHT:Number = 10000;
		
		private static const DEFAULT_MIN_WIDTH:Number = 0;
		
		private static const DEFAULT_MIN_HEIGHT:Number = 0;
		
		public function GraphicElement()
		{
			super();
		}
		
		private var displayObjectChanged:Boolean;
		
		private var _colorTransform:ColorTransform;
		
		private var colorTransformChanged:Boolean;
		
		private var _drawnDisplayObject:InvalidatingSprite;
		
		private var invalidatePropertiesFlag:Boolean = false;
		
		private var invalidateSizeFlag:Boolean = false;
		
		private var invalidateDisplayListFlag:Boolean = false;
		
		protected var layoutFeatures:AdvancedLayoutFeatures;
		
		private var _x:Number = 0;
		
		private var _y:Number = 0;
		
		
		private function allocateLayoutFeatures():void
		{
			if (layoutFeatures != null)
				return;
			layoutFeatures = new AdvancedLayoutFeatures();
			layoutFeatures.layoutX = _x;
			layoutFeatures.layoutY = _y;
			layoutFeatures.layoutWidth = _width;  
		}
		
		private function invalidateTransform(changeInvalidatesLayering:Boolean = true,
											 invalidateLayout:Boolean = true):void
		{
			if (changeInvalidatesLayering)
				invalidateDisplayObjectSharing();
			if (layoutFeatures != null)
				layoutFeatures.updatePending = true;
			if (displayObjectSharingMode != DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				invalidateDisplayList();
			else
				invalidateProperties(); 
			if (invalidateLayout)
				invalidateParentSizeAndDisplayList();
		}
		
		private function transformOffsetsChangedHandler(e:Event):void
		{
			invalidateTransform();
		}
		
		private var _alpha:Number = 1.0;
		
		private var _effectiveAlpha:Number = 1.0;
		
		private var alphaChanged:Boolean = false;
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{    
			if (_alpha == value)
				return;
			
			var previous:Boolean = needsDisplayObject;
			_alpha = value;
			
			if (_blendMode == "auto")
			{
				if ((value > 0 && value < 1 && (_effectiveAlpha == 0 || _effectiveAlpha == 1)) ||
					((value == 0 || value == 1) && (_effectiveAlpha > 0 && _effectiveAlpha < 1)))
				{
					blendModeChanged = true;
				}
			}
			
			_effectiveAlpha = value;
			var mxTransform:org.flexlite.domUI.primitives.geom.Transform = _transform as org.flexlite.domUI.primitives.geom.Transform;
			if (mxTransform)
				mxTransform.applyColorTransformAlpha = false;        
			
			if (previous != needsDisplayObject)
				invalidateDisplayObjectSharing();    
			
			alphaChanged = true;
			invalidateProperties();
		}
		
		private var _alwaysCreateDisplayObject:Boolean;
		/**
		 * 指定此 GraphicElement 是否与其 DisplayObject 相关联，并呈示于 DisplayObject。
		 */		
		public function get alwaysCreateDisplayObject():Boolean
		{
			return _alwaysCreateDisplayObject;
		}
		
		public function set alwaysCreateDisplayObject(value:Boolean):void
		{
			if (value != _alwaysCreateDisplayObject)
			{
				var previous:Boolean = needsDisplayObject;
				_alwaysCreateDisplayObject = value;
				if (previous != needsDisplayObject)
					invalidateDisplayObjectSharing();
			}
		}

		
		private var _blendMode:String = "auto"; 
		
		private var blendModeChanged:Boolean;
		
		private var blendShaderChanged:Boolean; 
		
		private var blendModeExplicitlySet:Boolean = false;
		
		/**
		 * BlendMode 类中的一个值，用于指定要使用的混合模式。
		 * @see flash.display.DisplayObject#blendMode
    	 * @see flash.display.BlendMode
		 */		
		public function get blendMode():String
		{
			return _blendMode;
		}
		
		public function set blendMode(value:String):void
		{
			if (value == _blendMode)
				return;
			
			var oldValue:String = _blendMode;
			
			_blendMode = value;
			blendModeChanged = true; 
			if (isAIMBlendMode(value))
			{
				blendShaderChanged = true;
			}
			if ((oldValue == BlendMode.NORMAL || value == BlendMode.NORMAL) && 
				!(oldValue == BlendMode.NORMAL && value == BlendMode.NORMAL))
			{
				invalidateDisplayObjectSharing();
			}
			
			invalidateProperties(); 
		}
		
		private var _bottom:Number;
		
		public function get bottom():Number
		{
			return _bottom;
		}
		
		public function set bottom(value:Number):void
		{
			if (_bottom == value)
				return;
			
			_bottom = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _owner:DisplayObjectContainer;
		
		public function get owner():DisplayObjectContainer
		{
			return _owner ? _owner : parent;
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
			_owner = value;
		}

		private var _parent:IGraphicElementContainer;
		
		public function get parent():DisplayObjectContainer
		{
			return _parent as DisplayObjectContainer;
		}
		
		public function parentChanged(value:IGraphicElementContainer):void
		{
			_parent = value;
			if (parent)
			{
				if (invalidatePropertiesFlag)
					IGraphicElementContainer(parent).invalidateGraphicElementProperties(this);
				if (invalidateSizeFlag)
					IGraphicElementContainer(parent).invalidateGraphicElementSize(this);
				if (invalidateDisplayListFlag)
					IGraphicElementContainer(parent).invalidateGraphicElementDisplayList(this);
			}
		}
		
		private var _explicitHeight:Number;
		
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		private var _explicitWidth:Number;
		
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}

		private var _filters:Array = [];
		
		private var filtersChanged:Boolean;
		
		private var _clonedFilters:Array;  
		/**
		 * 包含当前与图形元素关联的每个滤镜对象的索引数组。mx.filters 包中的类定义了可使用的特定滤镜。 
		 * getter 返回滤镜数组的副本。filters 属性值仅可以通过 setter 进行更改。
		 */		
		public function get filters():Array
		{
			return _filters.slice();
		}
		
		public function set filters(value:Array):void
		{
			var i:int = 0;
			var len:int = _filters ? _filters.length : 0;
			var newLen:int = value ? value.length : 0; 
			var edFilter:IEventDispatcher;
			
			if (len == 0 && newLen == 0)
				return;
			
			var previous:Boolean = needsDisplayObject;
			_filters = value;
			if (previous != needsDisplayObject)
				invalidateDisplayObjectSharing();
			
			_clonedFilters = [];
			
			for (i = 0; i < newLen; i++)
			{
				_clonedFilters.push(value[i]);
			}
			
			filtersChanged = true;
			invalidateProperties();
		}
		
		private var _height:Number = 0;

		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			_explicitHeight = value;
			
			if (_height == value)
				return;
			
			var oldValue:Number = _height;
			_height = value;
			dispatchPropertyChangeEvent("height", oldValue, value);
			invalidateDisplayList();
		}
		
		private var _horizontalCenter:Number;
		
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		public function set horizontalCenter(value:Number):void
		{
			if (_horizontalCenter == value)
				return;
			
			_horizontalCenter = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _left:Number;
		
		public function get left():Number
		{
			return _left;
		}
		
		public function set left(value:Number):void
		{
			if (_left == value)
				return;
			
			_left = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _mask:DisplayObject;
		
		private var maskChanged:Boolean;
		/**
		 * 调用显示对象被指定的 mask 对象遮罩。
		 * 如果遮罩显示对象不在显示列表上，则会将其作为 displayObject 
		 * 的子项添加到显示列表中。但不绘制 mask 对象本身。
		 * 将 mask 设置为 null 可删除遮罩。
		 */		
		public function get mask():DisplayObject
		{
			return _mask;
		}
		
		public function set mask(value:DisplayObject):void
		{
			if (_mask == value)
				return;
			
			var oldMask:UIComponent = _mask as UIComponent;
			
			var previous:Boolean = needsDisplayObject;
			_mask = value;      
			if (oldMask && oldMask.parent === displayObject)
			{       
				oldMask.parent.removeChild(oldMask);
			}     
			if (!_mask || _mask.parent)
			{
				if (drawnDisplayObject)
					drawnDisplayObject.mask = null; 
				
				if (_drawnDisplayObject)
				{
					if (_drawnDisplayObject.parent)
						_drawnDisplayObject.parent.removeChild(_drawnDisplayObject);
					_drawnDisplayObject = null;
				}
			}
			
			maskChanged = true;
			maskTypeChanged = true;
			if (previous != needsDisplayObject)
				invalidateDisplayObjectSharing();
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		private var _maskType:String = MaskType.CLIP;
		
		private var maskTypeChanged:Boolean;
		
		/**
		 * 定义将遮罩应用到 GraphicElement 的方式。
		 * 可能的值为 MaskType.CLIP、MaskType.ALPHA 和 MaskType.LUMINOSITY。
		 */		
		public function get maskType():String
		{
			return _maskType;
		}
		
		public function set maskType(value:String):void
		{
			if (_maskType == value)
				return;
			
			_maskType = value;
			maskTypeChanged = true;
			invalidateProperties();
		}
		
		private var _luminosityInvert:Boolean = false; 
		
		private var luminositySettingsChanged:Boolean;
		/**
		 * 控制计算由发光度遮罩设置遮罩的图形元素的 RGB 颜色值的属性。
		 * 如果为 true，则遮罩中的相应区域将反转并乘以源内容中像素的 RGB 颜色值。
		 * 如果为 false，则直接使用源内容中像素的 RGB 颜色值。
		 */		
		public function get luminosityInvert():Boolean
		{
			return _luminosityInvert;
		}
		
		public function set luminosityInvert(value:Boolean):void
		{
			if (_luminosityInvert == value)
				return;
			
			_luminosityInvert = value;
			luminositySettingsChanged = true; 
		}
		
		private var _luminosityClip:Boolean = false; 
		/**
		 * 控制发光度遮罩是否剪辑设置了遮罩的内容的属性。
		 * 只有图形元素应用了类型为 MaskType.LUMINOSITY 的遮罩，此属性才会起作用。
		 */		
		public function get luminosityClip():Boolean
		{
			return _luminosityClip;
		}
		
		public function set luminosityClip(value:Boolean):void
		{
			if (_luminosityClip == value)
				return;
			
			_luminosityClip = value;
			luminositySettingsChanged = true; 
		}
		
		private var _maxHeight:Number;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#maxHeight
		 */		
		public function get maxHeight():Number
		{
			return !isNaN(_maxHeight) ? _maxHeight : DEFAULT_MAX_HEIGHT;
		}
		
		public function set maxHeight(value:Number):void
		{
			if (_maxHeight == value)
				return;
			
			_maxHeight = value;
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _maxWidth:Number;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#maxWidth
		 */		
		public function get maxWidth():Number
		{
			return !isNaN(_maxWidth) ? _maxWidth : DEFAULT_MAX_WIDTH;
		}
		
		public function set maxWidth(value:Number):void
		{
			if (_maxWidth == value)
				return;
			
			_maxWidth = value;
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _measuredHeight:Number = 0;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#measuredHeight
		 */		
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		
		private var _measuredWidth:Number = 0;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#measuredWidth
		 */		
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		
		private var _measuredX:Number = 0;
		/**
		 * 相对于元素的原点的默认测量界限左上角。
		 */		
		public function get measuredX():Number
		{
			return _measuredX;
		}
		
		public function set measuredX(value:Number):void
		{
			_measuredX = value;
		}
		
		private var _measuredY:Number = 0;
		/**
		 * 相对于元素的原点的默认测量界限左上角。
		 */		
		public function get measuredY():Number
		{
			return _measuredY;
		}
		
		public function set measuredY(value:Number):void
		{
			_measuredY = value;
		}
		
		private var _minHeight:Number;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#minHeight
		 */
		public function get minHeight():Number
		{
			return !isNaN(_minHeight) ? _minHeight : DEFAULT_MIN_HEIGHT;
		}
		
		public function set minHeight(value:Number):void
		{
			if (_minHeight == value)
				return;
			
			_minHeight = value;
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _minWidth:Number;
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#minWidth
		 */	
		public function get minWidth():Number
		{
			return !isNaN(_minWidth) ? _minWidth : DEFAULT_MIN_WIDTH;
		}
		
		public function set minWidth(value:Number):void
		{
			if (_minWidth == value)
				return;
			
			_minWidth = value;
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _percentHeight:Number;
		
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		public function set percentHeight(value:Number):void
		{
			if (_percentHeight == value)
				return;
			
			if (!isNaN(value))
				_explicitHeight = NaN;
			
			_percentHeight = value;
			
			invalidateParentSizeAndDisplayList();
		}
		
		private var _percentWidth:Number;
		
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		
		public function set percentWidth(value:Number):void
		{
			if (_percentWidth == value)
				return;
			
			if (!isNaN(value))
				_explicitWidth = NaN;
			
			_percentWidth = value;
			
			invalidateParentSizeAndDisplayList();
		}
		
		private var _right:Number;
		
		public function get right():Number
		{
			return _right;
		}
		
		public function set right(value:Number):void
		{
			if (_right == value)
				return;
			
			_right = value;
			invalidateParentSizeAndDisplayList();
		}
		
		public function get rotationX():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.layoutRotationX;
		}
		
		public function set rotationX(value:Number):void
		{
			if (rotationX == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutRotationX = value;
			invalidateTransform(previous != needsDisplayObject); 
		}
		
		public function get rotationY():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.layoutRotationY;
		}
		
		public function set rotationY(value:Number):void
		{
			if (rotationY == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutRotationY = value;
			invalidateTransform(previous != needsDisplayObject);
		}
		public function get rotationZ():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.layoutRotationZ;
		}
		public function set rotationZ(value:Number):void
		{
			if (rotationZ == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutRotationZ = value;
			invalidateTransform(previous != needsDisplayObject);
		}
		/**
		 * 指示元素从转换点的旋转（以度为单位）。
		 */		
		public function get rotation():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.layoutRotationZ;
		}
		
		public function set rotation(value:Number):void
		{
			rotationZ = value;
		}
		
		public function get scaleX():Number
		{
			return (layoutFeatures == null)? 1:layoutFeatures.layoutScaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if (scaleX == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutScaleX = value;
			invalidateTransform(previous != needsDisplayObject);
		}
		
		public function get scaleY():Number
		{
			return (layoutFeatures == null)? 1:layoutFeatures.layoutScaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if (scaleY == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutScaleY = value;
			invalidateTransform(previous != needsDisplayObject);
		}
		/**
		 * 从转换点开始应用的元素的 z 缩放比例（百分比）。
		 */		
		public function get scaleZ():Number
		{
			return (layoutFeatures == null)? 1:layoutFeatures.layoutScaleZ;
		}
		
		public function set scaleZ(value:Number):void
		{
			if (scaleZ == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.layoutScaleZ = value;
			invalidateTransform(previous != needsDisplayObject);    
		}
		
		private var _includeInLayout:Boolean = true;

		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}
		public function set includeInLayout(value:Boolean):void
		{
			_includeInLayout = value;
		}
		
		private var _top:Number;
		
		public function get top():Number
		{
			return _top;
		}
		
		public function set top(value:Number):void
		{
			if (_top == value)
				return;
			
			_top = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _transform:flash.geom.Transform;
		/**
		 * 一个对象，具有与显示对象的矩阵、颜色转换和像素范围有关的属性。
		 */		
		public function get transform():flash.geom.Transform
		{
			if (!_transform) 
				setTransform(new org.flexlite.domUI.primitives.geom.Transform());
			
			return _transform;
		}
		
		public function set transform(value:flash.geom.Transform):void
		{
			
			var matrix:Matrix = value && value.matrix ? value.matrix.clone() : null;
			var matrix3D:Matrix3D = value && value.matrix3D ? value.matrix3D.clone() : null;
			var colorTransform:ColorTransform = value ? value.colorTransform : null;
			
			var mxTransform:org.flexlite.domUI.primitives.geom.Transform = value as org.flexlite.domUI.primitives.geom.Transform; 
			if (mxTransform)
			{
				if (!mxTransform.applyMatrix)
					matrix = null;
				
				if (!mxTransform.applyMatrix3D)
					matrix3D = null;
			}
			
			setTransform(value);
			
			var previous:Boolean = needsDisplayObject;
			
			if (_transform)
			{
				allocateLayoutFeatures();
				
				if (matrix != null)
				{
					layoutFeatures.layoutMatrix = matrix;
				}
				else if (matrix3D != null)
				{    
					layoutFeatures.layoutMatrix3D = matrix3D;
				}          
			}
			applyColorTransform(colorTransform, mxTransform && mxTransform.applyColorTransformAlpha);
			
			invalidateTransform(previous != needsDisplayObject);
		}
		
		private function setTransform(value:flash.geom.Transform):void
		{
			
			var oldTransform:org.flexlite.domUI.primitives.geom.Transform = _transform as org.flexlite.domUI.primitives.geom.Transform;
			if (oldTransform)
				oldTransform.target = null;
			
			var newTransform:org.flexlite.domUI.primitives.geom.Transform = value as org.flexlite.domUI.primitives.geom.Transform;
			
			if (newTransform)
				newTransform.target = this;
			
			_transform = value;
		}
		
		public function setColorTransform(value:ColorTransform):void
		{
			applyColorTransform(value, true);
		}
		private function applyColorTransform(value:ColorTransform, updateAlpha:Boolean):void
		{
			if (_colorTransform != value)
			{
				var previous:Boolean = needsDisplayObject;
				
				_colorTransform = new ColorTransform(value.redMultiplier, value.greenMultiplier, value.blueMultiplier, value.alphaMultiplier,
					value.redOffset, value.greenOffset, value.blueOffset, value.alphaOffset);
				
				if (updateAlpha)
				{
					_alpha = value.alphaMultiplier;
					_effectiveAlpha = _alpha;
				}
				
				if (displayObject && displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				{
					displayObject.transform.colorTransform = _colorTransform;
				}
				else
				{
					colorTransformChanged = true;
					invalidateProperties();
					if (previous != needsDisplayObject)
						invalidateDisplayObjectSharing();       
				}
			}
		}
		
		private function isAIMBlendMode(value:String):Boolean
		{
			if (value == "colordodge" || 
				value =="colorburn" || value =="exclusion" || 
				value =="softlight" || value =="hue" || 
				value =="saturation" || value =="color" ||
				value =="luminosity")
				return true; 
			else return false; 
		}
		
		/**
		 * 一种实用程序方法，用于将以该对象的本地坐标指定的点转换为在该对象父坐标中的相应位置。
		 * 如果 position 和 postLayoutPosition 参数为非 null，
		 * 将对这两个参数设置布局前和布局后结果。
		 */		
		public function transformPointToParent(localPosition:Vector3D,
											   position:Vector3D, 
											   postLayoutPosition:Vector3D):void
		{
			if (layoutFeatures != null)
			{
				layoutFeatures.transformPointToParent(true, localPosition, position,
					postLayoutPosition);
			}
			else
			{
				var xformPt:Point = new Point();
				if (localPosition)
				{
					xformPt.x = localPosition.x;
					xformPt.y = localPosition.y;
				}
				if (position != null)
				{            
					position.x = xformPt.x + _x;
					position.y = xformPt.y + _y;
					position.z = 0;
				}
				if (postLayoutPosition != null)
				{
					postLayoutPosition.x = xformPt.x + _x;
					postLayoutPosition.y = xformPt.y + _y;
					postLayoutPosition.z = 0;
				}
			}
		}
		
		public function get transformX():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.transformX;
		}
		
		public function set transformX(value:Number):void
		{
			if (transformX  == value)
				return;
			
			allocateLayoutFeatures();
			layoutFeatures.transformX = value;
			invalidateTransform(false);
		}
		
		public function get transformY():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.transformY;
		}
		
		public function set transformY(value:Number):void
		{
			if (transformY == value)
				return;
			
			allocateLayoutFeatures();
			layoutFeatures.transformY = value;
			invalidateTransform(false);
		}
		/**
		 * 元素的 z 位置转换点。
		 */		
		public function get transformZ():Number
		{
			return (layoutFeatures == null)? 0:layoutFeatures.transformZ;
		}
		
		public function set transformZ(value:Number):void
		{
			if (transformZ == value)
				return;
			
			allocateLayoutFeatures();
			var previous:Boolean = needsDisplayObject;
			layoutFeatures.transformZ = value;
			invalidateTransform(previous != needsDisplayObject);
		}
		
		private var _verticalCenter:Number;
		
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		public function set verticalCenter(value:Number):void
		{
			if (_verticalCenter == value)
				return;
			
			_verticalCenter = value;
			invalidateParentSizeAndDisplayList();
		}
		private var _width:Number = 0;

		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			_explicitWidth = value;
			
			if (_width == value)
				return;
			
			var oldValue:Number = _width;
			_width = value;
			if (layoutFeatures)
			{
				layoutFeatures.layoutWidth = value;
				invalidateTransform();
			}        
			
			dispatchPropertyChangeEvent("width", oldValue, value);
			invalidateDisplayList();
		}

		public function get x():Number
		{
			return (layoutFeatures == null)? _x:layoutFeatures.layoutX;
		}
		public function set x(value:Number):void
		{
			var oldValue:Number = x;
			if (oldValue == value)
				return;
			
			if (layoutFeatures != null)
				layoutFeatures.layoutX = value;
			else
				_x = value;
			
			dispatchPropertyChangeEvent("x", oldValue, value);
			invalidateTransform(false);
		}
		
		public function get y():Number
		{
			return (layoutFeatures == null)? _y:layoutFeatures.layoutY;
		}
		public function set y(value:Number):void
		{
			var oldValue:Number = y;
			if (oldValue == value)
				return;
			
			if (layoutFeatures != null)
				layoutFeatures.layoutY = value;
			else
				_y = value;
			dispatchPropertyChangeEvent("y", oldValue, value);
			invalidateTransform(false);
		}

		private var _visible:Boolean = true;
		
		protected var _effectiveVisibility:Boolean = true;
		
		private var visibleChanged:Boolean;
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
			
			if (_effectiveVisibility == value)
				return;
			
			_effectiveVisibility = value;
			visibleChanged = true;
			invalidateProperties();
		}
		
		private var _displayObject:DisplayObject;
		
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		protected function setDisplayObject(value:DisplayObject):void
		{
			if (_displayObject == value)
				return;
			
			var oldValue:DisplayObject = _displayObject;
			if (oldValue && displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				oldValue.transform.matrix3D = null;
			
			_displayObject = value;
			dispatchPropertyChangeEvent("displayObject", oldValue, value);
			displayObjectChanged = true;
			invalidateProperties();
		}
		
		protected function get drawX():Number
		{
			if (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				return 0;
			if (layoutFeatures != null && layoutFeatures.postLayoutTransformOffsets != null)
				return x + layoutFeatures.postLayoutTransformOffsets.x;
			
			return x;
		} 
		
		protected function get drawY():Number
		{
			if (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				return 0;
			if (layoutFeatures != null && layoutFeatures.postLayoutTransformOffsets != null)
				return y + layoutFeatures.postLayoutTransformOffsets.y;
			
			return y;
		}
		
		protected function get hasComplexLayoutMatrix():Boolean
		{
			return (layoutFeatures == null ? false : !MatrixUtil.isDeltaIdentity(layoutFeatures.layoutMatrix));
		}
		
		private var _displayObjectSharingMode:String;
		
		public function set displayObjectSharingMode(value:String):void
		{
			if (value == _displayObjectSharingMode)
				return;
			
			if (value != DisplayObjectSharingMode.USES_SHARED_OBJECT ||
				_displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT) 
			{
				displayObjectChanged = true;
				invalidateProperties();            
			}
			_displayObjectSharingMode = value;
		}
		
		public function get displayObjectSharingMode():String
		{
			return _displayObjectSharingMode;    
		}

		public function localToGlobal(point:Point):Point
		{
			if (!displayObject || !displayObject.parent)
				return new Point(x, y);
			
			var returnVal:Point = displayObject.localToGlobal(point);
			
			if (!needsDisplayObject)
			{
				
				returnVal.x += drawX;
				returnVal.y += drawY;
			}
			
			return returnVal;
		}
		
		public function createDisplayObject():DisplayObject
		{
			setDisplayObject(new InvalidatingSprite());
			return displayObject;
		}
		
		protected function get needsDisplayObject():Boolean
		{
			var result:Boolean = (alwaysCreateDisplayObject ||
				(_filters && _filters.length > 0) || 
				(_blendMode != BlendMode.NORMAL && _blendMode != "auto") || _mask ||
				(layoutFeatures != null && (layoutFeatures.layoutScaleX != 1 || layoutFeatures.layoutScaleY != 1 || layoutFeatures.layoutScaleZ != 1 ||
					layoutFeatures.layoutRotationX != 0 || layoutFeatures.layoutRotationY != 0 || layoutFeatures.layoutRotationZ != 0 ||
					layoutFeatures.layoutZ  != 0 || layoutFeatures.mirror)) ||  
				_colorTransform != null ||
				_effectiveAlpha != 1);
			
			if (layoutFeatures != null && layoutFeatures.postLayoutTransformOffsets != null)
			{
				var o:TransformOffsets = layoutFeatures.postLayoutTransformOffsets;
				result = result || (o.scaleX != 1 || o.scaleY != 1 || o.scaleZ != 1 ||
					o.rotationX != 0 || o.rotationY != 0 || o.rotationZ != 0 || o.z  != 0);       
			}
			
			return result;
		}
		
		public function setSharedDisplayObject(sharedDisplayObject:DisplayObject):Boolean
		{
			if (!(sharedDisplayObject is Sprite) || _alwaysCreateDisplayObject || needsDisplayObject)
				return false;
			setDisplayObject(sharedDisplayObject);
			return true;
		}
		
		public function canShareWithPrevious(element:IGraphicElement):Boolean
		{
			return element is GraphicElement;
		}
		
		public function canShareWithNext(element:IGraphicElement):Boolean
		{
			return element is GraphicElement && !_alwaysCreateDisplayObject && !needsDisplayObject;
		}
		
		protected function get drawnDisplayObject():DisplayObject
		{
			
			return _drawnDisplayObject ? _drawnDisplayObject : displayObject; 
		}

		protected function layer_PropertyChange(event:PropertyChangeEvent):void
		{
			switch (event.property)
			{
				case "effectiveVisibility":
				{
					var newValue:Boolean = (event.newValue && _visible);
					
					if (newValue != _effectiveVisibility)
					{
						_effectiveVisibility = newValue;
						visibleChanged = true;
						invalidateProperties();
					}
					break;
				}
				case "effectiveAlpha":
				{
					var newAlpha:Number = Number(event.newValue) * _alpha;
					if (newAlpha != _effectiveAlpha)
					{
						_effectiveAlpha = newAlpha;
						alphaChanged = true;
						
						var mxTransform:org.flexlite.domUI.primitives.geom.Transform = _transform as org.flexlite.domUI.primitives.geom.Transform;
						if (mxTransform)
							mxTransform.applyColorTransformAlpha = false;        
						
						invalidateDisplayObjectSharing(); 
						invalidateProperties();
					}
					break;
				}
			}
		}
		
		protected function dispatchPropertyChangeEvent(prop:String, oldValue:*,
														 value:*):void
		{
			if (hasEventListener("propertyChange"))
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(
					this, prop, oldValue, value));
			
		}
		protected function invalidateDisplayObjectSharing():void
		{
			if (parent)
				IGraphicElementContainer(parent).invalidateGraphicElementSharing(this);
		}
		
		public function invalidateProperties():void
		{
			if (invalidatePropertiesFlag)
				return;
			invalidatePropertiesFlag = true;
			
			if (parent)
				IGraphicElementContainer(parent).invalidateGraphicElementProperties(this);
		}
		
		public function invalidateSize():void
		{
			if (invalidateSizeFlag)
				return;
			invalidateSizeFlag = true;
			
			if (parent)
				IGraphicElementContainer(parent).invalidateGraphicElementSize(this);
		}
		
		protected function invalidateParentSizeAndDisplayList():void
		{
			if (parent && parent is IInvalidating)
			{
				IInvalidating(parent).invalidateSize();
				IInvalidating(parent).invalidateDisplayList();
			}
		}
		
		public function invalidateDisplayList():void
		{
			if (invalidateDisplayListFlag)
				return;
			invalidateDisplayListFlag = true;
			if (parent)
				IGraphicElementContainer(parent).invalidateGraphicElementDisplayList(this);
		}
		
		public function validateNow(skipDisplayList:Boolean = false):void
		{
			if (parent!=null&&parent is IInvalidating)
			{
				IInvalidating(parent).validateNow(skipDisplayList);
			}
		}
		
		public function validateProperties():void
		{
			if (!invalidatePropertiesFlag)
				return;
			commitProperties();
			invalidatePropertiesFlag = false;
			if (!invalidatePropertiesFlag && !invalidateSizeFlag && !invalidateDisplayListFlag)
				dispatchUpdateComplete();        
		}
		
		protected function commitProperties():void
		{
			
			var updateTransform:Boolean = false;
			var mxTransform:org.flexlite.domUI.primitives.geom.Transform;
			if (displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT && displayObject)
			{
				if (colorTransformChanged || displayObjectChanged)
				{
					colorTransformChanged = false;
					if (_colorTransform)
						displayObject.transform.colorTransform = _colorTransform;
				}
				
				if (alphaChanged || displayObjectChanged)
				{
					alphaChanged = false;
					
					mxTransform = _transform as org.flexlite.domUI.primitives.geom.Transform;
					if (!mxTransform || !mxTransform.applyColorTransformAlpha)
						displayObject.alpha = _effectiveAlpha;
				}  
				
				if (blendModeChanged || displayObjectChanged)
				{
					blendModeChanged = false;
					if (_blendMode == "auto")
					{
						if (alpha == 0 || alpha == 1) 
							displayObject.blendMode = BlendMode.NORMAL;
						else
							displayObject.blendMode = BlendMode.LAYER;
					}
						
					else if (!isAIMBlendMode(_blendMode))
					{
						displayObject.blendMode = _blendMode;
					}
					else
					{
						displayObject.blendMode = "normal"; 
					}
					
					if (blendShaderChanged) 
					{
						blendShaderChanged = false; 
						
						switch(_blendMode)
						{
							case "color": 
							{
								displayObject.blendShader = new ColorShader();
								break; 
							}
							case "colordodge":
							{
								displayObject.blendShader = new ColorDodgeShader();
								break; 
							}
							case "colorburn":
							{
								displayObject.blendShader = new ColorBurnShader();
								break; 
							}
							case "exclusion":
							{
								displayObject.blendShader = new ExclusionShader();
								break; 
							}
							case "hue":
							{
								displayObject.blendShader = new HueShader();
								break; 
							}
							case "luminosity":
							{
								displayObject.blendShader = new LuminosityShader();
								break; 
							}
							case "saturation": 
							{
								displayObject.blendShader = new SaturationShader();
								break; 
							}
							case "softlight":
							{
								displayObject.blendShader = new SoftLightShader();
								break; 
							}
						}
					}
				}
				
				if (filtersChanged || displayObjectChanged)
				{
					filtersChanged = false;
					if (filtersChanged || _clonedFilters)
						displayObject.filters = _clonedFilters;
				}
				
				if (maskChanged || displayObjectChanged)
				{
					maskChanged = false;
					
					if (_mask)
					{
						if (!_mask.parent)
						{
							Sprite(displayObject).addChild(_mask);  
							
							MaskUtil.applyMask(_mask, parent);
							
							if (!_drawnDisplayObject)
							{
								if (displayObject is Sprite)
									Sprite(displayObject).graphics.clear();
								else if (displayObject is Shape)
									Shape(displayObject).graphics.clear();
								_drawnDisplayObject = new InvalidatingSprite();
								Sprite(displayObject).addChild(_drawnDisplayObject);
							}       
						}
						
						drawnDisplayObject.mask = _mask;
					}
				}
				
				if (luminositySettingsChanged)
				{
					luminositySettingsChanged = false; 
					
					MaskUtil.applyLuminositySettings(
						_mask, _maskType, _luminosityInvert, _luminosityClip);
				}
				
				if (maskTypeChanged || displayObjectChanged)
				{
					maskTypeChanged = false;
					MaskUtil.applyMaskType(
						_mask, _maskType, _luminosityInvert, _luminosityClip, 
						drawnDisplayObject);
				}
				if (displayObjectChanged)
					displayObject.visible = (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT) ? _effectiveVisibility : true;
				
				updateTransform = true;
				displayObjectChanged = false;
			}
			
			if (visibleChanged)
			{
				visibleChanged = false;
				if (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				{
					displayObject.visible = _effectiveVisibility;
				}
				else
					invalidateDisplayList();
			}
			
			if ((layoutFeatures == null || layoutFeatures.updatePending) ||
				updateTransform)
			{
				applyComputedTransform();
			}
		}
		
		public function validateSize():void
		{
			if (!invalidateSizeFlag)
				return;
			invalidateSizeFlag = false;
			
			var sizeChanging:Boolean = measureSizes();
			
			if (!sizeChanging)
			{
				
				if (!invalidatePropertiesFlag && !invalidateSizeFlag && !invalidateDisplayListFlag)
					dispatchUpdateComplete();
				return;
			}
			invalidateParentSizeAndDisplayList();
		}
		
		protected function canSkipMeasurement():Boolean
		{
			return !isNaN(explicitWidth) && !isNaN(explicitHeight);
		}
		
		private function measureSizes():Boolean
		{
			var oldWidth:Number = preferredWidthPreTransform();
			var oldHeight:Number = preferredHeightPreTransform();
			var oldX:Number = measuredX;
			var oldY:Number = measuredY;
			
			if (!canSkipMeasurement())
				measure();
			
			if (!isNaN(minWidth) && measuredWidth < minWidth)
				measuredWidth = minWidth;
			
			if (!isNaN(maxWidth) && measuredWidth > maxWidth)
				measuredWidth = maxWidth;
			
			if (!isNaN(minHeight) && measuredHeight < minHeight)
				measuredHeight = minHeight;
			
			if (!isNaN(maxHeight) && measuredHeight > maxHeight)
				measuredHeight = maxHeight;
			if (oldWidth != preferredWidthPreTransform() ||
				oldHeight != preferredHeightPreTransform() ||
				oldX != measuredX ||
				oldY != measuredY)
			{
				
				return true;
			}
			
			return false;
		}
		
		protected function measure():void
		{
			measuredWidth = 0;
			measuredHeight = 0;
			measuredX = 0;
			measuredY = 0;
		}
		
		public function validateDisplayList():void
		{
			var wasInvalid:Boolean = invalidateDisplayListFlag; 
			invalidateDisplayListFlag = false;
			if (layoutFeatures == null || layoutFeatures.updatePending)
			{
				applyComputedTransform();
			}
			if (displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT)
			{
				if (drawnDisplayObject is Sprite)
					Sprite(drawnDisplayObject).graphics.clear();
			}
			
			doUpdateDisplayList();
			if (!invalidatePropertiesFlag && !invalidateSizeFlag && !invalidateDisplayListFlag && wasInvalid)
				dispatchUpdateComplete();
		}
		
		protected function doUpdateDisplayList():void
		{
			if (_effectiveVisibility || displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
				updateDisplayList(_width, _height);
		}
		
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
		}
		
		private function dispatchUpdateComplete():void
		{
			if (hasEventListener(UIEvent.UPDATE_COMPLETE))
				dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
		}
		
		protected function preferredWidthPreTransform():Number
		{
			return isNaN(explicitWidth) ? measuredWidth : explicitWidth;
		}
		
		protected function preferredHeightPreTransform():Number
		{
			return isNaN(explicitHeight) ? measuredHeight: explicitHeight;
		}
		
		/**
		 * 组件的首选宽度,常用于父级的measure()方法中
		 * 按照：外部显式设置宽度>测量宽度 的优先级顺序返回宽度
		 */		
		public function get preferredWidth():Number
		{
			return transformWidthForLayout(preferredWidthPreTransform(),
				preferredHeightPreTransform());
		}
		
		/**
		 * 组件的首选高度,常用于父级的measure()方法中
		 * 按照：外部显式设置高度>测量高度 的优先级顺序返回高度
		 */
		public function get preferredHeight():Number
		{
			return transformHeightForLayout(preferredWidthPreTransform(),
				preferredHeightPreTransform());
		}
		
		/**
		 * 组件的布局宽度,常用于父级的updateDisplayList()方法中
		 * 按照：布局宽度>外部显式设置宽度>测量宽度 的优先级顺序返回宽度
		 */		
		public function get layoutBoundsWidth():Number
		{
			return transformWidthForLayout(_width, _height);
		}
		/**
		 * 组件的布局高度,常用于父级的updateDisplayList()方法中
		 * 按照：布局高度>外部显式设置高度>测量高度 的优先级顺序返回高度
		 */		
		public function get layoutBoundsHeight():Number
		{
			return transformHeightForLayout(_width, _height);
		}
		
		/**
		 * 组件的首选x坐标,常用于父级的measure()方法中
		 */		
		public function get preferredX():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix(); 
			if (!m)
				return strokeExtents.left + this.measuredX + this.x;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN, NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			var topLeft:Point = new Point(measuredX, measuredY);
			MatrixUtil.transformBounds(newSize.x, newSize.y, m, topLeft);
			return strokeExtents.left + topLeft.x;
		}
		
		/**
		 * 组件的首选y坐标,常用于父级的measure()方法中
		 */
		public function get preferredY():Number
		{
			var strokeExtents:Rectangle = getStrokeExtents();
			var m:Matrix = getComplexMatrix();
			if (!m)
				return strokeExtents.top + this.measuredY + this.y;
			
			var newSize:Point = MatrixUtil.fitBounds(NaN,NaN, m,
				explicitWidth, explicitHeight,
				preferredWidthPreTransform(),
				preferredHeightPreTransform(),
				minWidth, minHeight,
				maxWidth, maxHeight);
			if (!newSize)
				newSize = new Point(minWidth, minHeight);
			
			var topLeft:Point = new Point(measuredX, measuredY);
			MatrixUtil.transformBounds(newSize.x, newSize.y, m, topLeft);
			return strokeExtents.top + topLeft.y;
		}
		/**
		 * 组件水平方向起始坐标
		 */	
		public function get layoutBoundsX():Number
		{
			var stroke:Number = getStrokeExtents().left;
			
			var m:Matrix = getComplexMatrix();
			if (!m)
				return stroke + this.measuredX + this.x;
			
			var topLeft:Point = new Point(measuredX, measuredY);
			MatrixUtil.transformBounds(_width, _height, m, topLeft);
			return stroke + topLeft.x;
		}
		/**
		 * 组件竖直方向起始坐标
		 */	
		public function get layoutBoundsY():Number
		{
			var stroke:Number = getStrokeExtents().top;
			
			var m:Matrix = getComplexMatrix();
			if (!m)
				return stroke + this.measuredY + this.y;
			
			var topLeft:Point = new Point(measuredX, measuredY);
			MatrixUtil.transformBounds(_width, _height, m, topLeft);
			return stroke + topLeft.y;
		}
		/**
		 * 设置组件的布局位置
		 */		
		public function setLayoutBoundsPosition(newBoundsX:Number,newBoundsY:Number):void
		{
			var currentBoundsX:Number = layoutBoundsX;
			var currentBoundsY:Number = layoutBoundsY;
			
			var currentX:Number = this.x;
			var currentY:Number = this.y;
			
			var newX:Number = currentX + newBoundsX - currentBoundsX;
			var newY:Number = currentY + newBoundsY - currentBoundsY;
			
			if (newX != currentX || newY != currentY)
			{
				if (layoutFeatures != null)
				{
					layoutFeatures.layoutX = newX;
					layoutFeatures.layoutY = newY;           
					
					layoutFeatures.updatePending = true;
				}
				else
				{
					_x = newX;
					_y = newY;
				}
				if (newX != currentX)
					dispatchPropertyChangeEvent("x", currentX, newX);
				if (newY != currentY)
					dispatchPropertyChangeEvent("y", currentY, newY);
				
				invalidateDisplayList();
			}
		}
		
		
		private var _layoutWidthExplicitlySet:Boolean = false;
		
		/**
		 * 父级布局管理器设置了组件的宽度标志，尺寸设置优先级：自动布局>显式设置>自动测量
		 */
		protected function get layoutWidthExplicitlySet():Boolean
		{
			return _layoutWidthExplicitlySet;
		}
		
		private var _layoutHeightExplicitlySet:Boolean = false;
		
		/**
		 * 父级布局管理器设置了组件的高度标志，尺寸设置优先级：自动布局>显式设置>自动测量
		 */
		protected function get layoutHeightExplicitlySet():Boolean
		{
			return _layoutHeightExplicitlySet;
		}
		
		public function setLayoutBoundsSize(width:Number,
											height:Number):void
		{
			if (!isNaN(width) || !isNaN(height))
			{
				var strokeExtents:Rectangle = getStrokeExtents();
				
				if (!isNaN(width))
					width -= strokeExtents.width;
				if (!isNaN(height))
					height -= strokeExtents.height;
			}
			
			var m:Matrix;
			if (hasComplexLayoutMatrix)
				m = layoutFeatures.layoutMatrix;
			if (!m)
			{
				if (isNaN(width))
					width = preferredWidthPreTransform();
				if (isNaN(height))
					height = preferredHeightPreTransform();
			}
			else
			{
				var newSize:Point = MatrixUtil.fitBounds(width, height, m,
					explicitWidth, explicitHeight,
					preferredWidthPreTransform(),
					preferredHeightPreTransform(),
					minWidth, minHeight,
					maxWidth, maxHeight);
				
				if (newSize)
				{
					width = newSize.x;
					height = newSize.y;
				}
				else
				{
					width = minWidth;
					height = minHeight;
				}
			}
			
			setActualSize(width, height);
		}
		
		public function setActualSize(width:Number, height:Number):void
		{
			if (_width != width || _height != height)
			{
				var oldWidth:Number = _width;
				var oldHeight:Number = _height;
				
				_width = width;
				_height = height;
				
				if (layoutFeatures)  
				{
					layoutFeatures.layoutWidth = width;
					invalidateTransform(false , false );
				}
				
				if (width != oldWidth)
					dispatchPropertyChangeEvent("width", oldWidth, width);
				if (height != oldHeight)
					dispatchPropertyChangeEvent("height", oldHeight, height);
				
				invalidateDisplayList();
			}
		}
		
		protected function transformWidthForLayout(width:Number,
												   height:Number,
												   postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				width = MatrixUtil.transformSize(width, height, 
					layoutFeatures.layoutMatrix).x;
			
			width += getStrokeExtents(postLayoutTransform).width;
			return width;
		}
		
		protected function transformHeightForLayout(width:Number,
													height:Number,
													postLayoutTransform:Boolean = true):Number
		{
			if (postLayoutTransform && hasComplexLayoutMatrix)
				height = MatrixUtil.transformSize(width, height, 
					layoutFeatures.layoutMatrix).y;
			
			height += getStrokeExtents(postLayoutTransform).height;
			return height;
		}
		
		private function applyComputedTransform():void
		{   
			if (layoutFeatures != null)
				layoutFeatures.updatePending = false;
			if (displayObjectSharingMode == DisplayObjectSharingMode.USES_SHARED_OBJECT || !displayObject)
				return;
			
			if (layoutFeatures != null)
			{           
				if (layoutFeatures.is3D)
				{
					displayObject.transform.matrix3D = layoutFeatures.computedMatrix3D;             
				}
				else
				{
					var m:Matrix = layoutFeatures.computedMatrix.clone();
					
					if (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_SHARED_OBJECT)
					{
						m.tx = 0;
						m.ty = 0;
					}
					displayObject.transform.matrix = m;
				}
			}
			else 
			{
				
				if (displayObjectSharingMode == DisplayObjectSharingMode.OWNS_SHARED_OBJECT)
				{
					displayObject.x = 0;
					displayObject.y = 0;
				}
				else
				{
					displayObject.x = _x;
					displayObject.y = _y;
				}
			}
		}
		
		static protected var _strokeExtents:Rectangle = new Rectangle();
		/**
		 * 返回元素界限每一侧上的笔触所占据的像素数。
		 */		
		protected function getStrokeExtents(postLayoutTransform:Boolean = true):Rectangle
		{
			_strokeExtents.x = 0;
			_strokeExtents.y = 0;
			_strokeExtents.width = 0;
			_strokeExtents.height = 0;
			return _strokeExtents;
		}
		
		protected function getComplexMatrix(performCheck:Boolean = true):Matrix
		{
			return performCheck && hasComplexLayoutMatrix ? layoutFeatures.layoutMatrix : null;
		}
		
		public function get invalidateFlag():Boolean
		{
			return invalidatePropertiesFlag||invalidateSizeFlag||invalidateDisplayListFlag;
		}
		
		/**
		 * 延迟函数队列 
		 */		
		private var methodQueue:Vector.<MethodQueueElement>;
		/**
		 * 是否添加过事件监听标志 
		 */		
		private var listeningForRender:Boolean = false;
		/**
		 * 为callLater()添加 事件监听
		 */		
		private function addRenderListener():void
		{
			if(!listeningForRender&&methodQueue&&methodQueue.length>0
				&&DomGlobals.stage&&parent)
			{
				DomGlobals.layoutManager.addEventListener(UIEvent.UPDATE_COMPLETE,onCallBack);
				listeningForRender = true;
			}
		}
		
		/**
		 * 延迟函数到下一次组件重绘后执行。由于组件使用了延迟渲染的优化机制，
		 * 在改变组件某些属性后，并不立即应用，而是延迟一帧统一处理，避免了重复的渲染。
		 * 若组件的某些属性会影响到它的尺寸位置，在属性发生改变后，请调用此方法,
		 * 延迟执行函数以获取正确的组件尺寸位置。
		 * @param method 要延迟执行的函数
		 * @param args 函数参数列表
		 */		
		public function callLater(method:Function,args:Array=null):void
		{
			var p:IInvalidating = parent as IInvalidating;
			var parentInvalidateFlag:Boolean = p&&p.invalidateFlag;
			if(invalidateFlag||parentInvalidateFlag)
			{
				if(methodQueue==null)
				{
					methodQueue = new Vector.<MethodQueueElement>();
				}
				methodQueue.push(new MethodQueueElement(method,args));
				addRenderListener();
				return;
			}
			if(args==null)
			{
				method();
			}
			else
			{
				method.apply(null,args);
			}
		}
		/**
		 * 执行延迟函数
		 */		
		private function onCallBack(event:Event):void
		{
			DomGlobals.layoutManager.removeEventListener(UIEvent.UPDATE_COMPLETE,onCallBack);
			listeningForRender = false;
			var queue:Vector.<MethodQueueElement> = methodQueue;
			if(!queue||queue.length==0)
				return;
			methodQueue = null;
			for each(var element:MethodQueueElement in queue)
			{
				if(element.args==null)
				{
					element.method();
				}
				else
				{
					element.method.apply(null,element.args);
				}
			}
		}
	}
	
}

/**
 *  延迟执行函数元素
 */
class MethodQueueElement
{
	
	public function MethodQueueElement(method:Function,args:Array = null)
	{
		this.method = method;
		this.args = args;
	}
	
	public var method:Function;
	
	public var args:Array;
}
