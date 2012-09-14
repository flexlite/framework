<<<<<<< HEAD
package org.flexlite.domUI.primitives
{
    import org.flexlite.domUI.core.UIComponent;
    import org.flexlite.domUI.primitives.graphic.RectangularDropShadow;
   	
	[DXML(show="false")]
	
	/**
	 * 此类通常用于优化投影。如果要对其边缘位于像素边界上的 rectangularly-shaped 对象应用投影，
	 * 则应使用此类，而不应直接使用 DropShadowFilter。此类接受传递到 DropShadowFilter 的前四个参数：
	 * alpha、angle、color 和 distance。此外，此类接受投射阴影的 rectangularly-shaped 对象每个角（共四个角）的角半径。
	 * 如果已经设置了这 8 个值，则此类会预先计算在屏幕外 Bitmap 中的投影。
	 * 调用 drawShadow() 方法时，则会将预先计算的投影复制到传入的 Graphics 对象。
	 * @author DOM
	 */	
    public class RectangularDropShadow extends UIComponent
    {
        public function RectangularDropShadow()
        {
            mouseEnabled = false;
            super();
        }
		
        private var dropShadow:org.flexlite.domUI.primitives.graphic.RectangularDropShadow;
		
        private var _alpha:Number = 0.4;
		/**
		 * @copy spark.filters.DropShadowFilter#alpha
		 */		
        override public function get alpha():Number
        {
            return _alpha;
        }
		
        override public function set alpha(value:Number):void
        {
            if (_alpha != value)
            {
                _alpha = value;
                invalidateDisplayList();
            }
        }
		
        private var _angle:Number = 45.0;
		/**
		 * @copy spark.filters.DropShadowFilter#angle
		 */		
        public function get angle():Number
        {
            return _angle;
        }
		
        public function set angle(value:Number):void
        {
            if (_angle != value)
            {
                _angle = value;
                invalidateDisplayList();
            }
        }
		
        private var _color:int = 0;
		/**
		 * @copy spark.filters.DropShadowFilter#color
		 */		
        public function get color():int
        {
            return _color;
        }
		
        public function set color(value:int):void
        {
            if (_color != value)
            {
                _color = value;
                invalidateDisplayList();
            }
        }
		
        private var _distance:Number = 4.0;
		/**
		 * @copy flash.filters.DropShadowFilter#distance
		 */		
        public function get distance():Number
        {
            return _distance;
        }
		
        public function set distance(value:Number):void
        {
            if (_distance != value)
            {
                _distance = value;
                invalidateDisplayList();
            }
        }
		
        private var _tlRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get tlRadius():Number
        {
            return _tlRadius;
        }
		
        public function set tlRadius(value:Number):void
        {
            if (_tlRadius != value)
            {
                _tlRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _trRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get trRadius():Number
        {
            return _trRadius;
        }
		
        public function set trRadius(value:Number):void
        {
            if (_trRadius != value)
            {
                _trRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _blRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get blRadius():Number
        {
            return _blRadius;
        }
		
        public function set blRadius(value:Number):void
        {
            if (_blRadius != value)
            {
                _blRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _brRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get brRadius():Number
        {
            return _brRadius;
        }
		
        public function set brRadius(value:Number):void
        {
            if (_brRadius != value)
            {
                _brRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _blurX:Number = 4;
		/**
		 * 水平模糊量。
		 */		
        public function get blurX():Number
        {
            return _blurX;
        }
		
        public function set blurX(value:Number):void
        {
            if (_blurX != value)
            {
                _blurX = value;
                invalidateDisplayList();
            }
        }
		
        private var _blurY:Number = 4;
		/**
		 * 垂直模糊量。
		 */		
        public function get blurY():Number
        {
            return _blurY;
        }
		
        public function set blurY(value:Number):void
        {
            if (_blurY != value)
            {
                _blurY = value;
                invalidateDisplayList();
            }
        }
		
        override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            graphics.clear();

            if (!dropShadow)
                dropShadow = new org.flexlite.domUI.primitives.graphic.RectangularDropShadow();

            dropShadow.distance = _distance;
            dropShadow.angle = _angle;
            dropShadow.color = _color;
            dropShadow.blurX = _blurX;
            dropShadow.blurY = _blurY;
            dropShadow.alpha = _alpha;

            dropShadow.tlRadius = isNaN(_tlRadius) ? 0 : _tlRadius;
            dropShadow.trRadius = isNaN(_trRadius) ? 0 : _trRadius;
            dropShadow.blRadius = isNaN(_blRadius) ? 0 : _blRadius;
            dropShadow.brRadius = isNaN(_brRadius) ? 0 : _brRadius;

            dropShadow.drawShadow(graphics, 0, 0, unscaledWidth, unscaledHeight);
        }
    
    }
=======
package org.flexlite.domUI.primitives
{
    import org.flexlite.domUI.core.UIComponent;
    import org.flexlite.domUI.primitives.graphic.RectangularDropShadow;
   	
	[DXML(show="false")]
	
	/**
	 * 此类通常用于优化投影。如果要对其边缘位于像素边界上的 rectangularly-shaped 对象应用投影，
	 * 则应使用此类，而不应直接使用 DropShadowFilter。此类接受传递到 DropShadowFilter 的前四个参数：
	 * alpha、angle、color 和 distance。此外，此类接受投射阴影的 rectangularly-shaped 对象每个角（共四个角）的角半径。
	 * 如果已经设置了这 8 个值，则此类会预先计算在屏幕外 Bitmap 中的投影。
	 * 调用 drawShadow() 方法时，则会将预先计算的投影复制到传入的 Graphics 对象。
	 * @author DOM
	 */	
    public class RectangularDropShadow extends UIComponent
    {
        public function RectangularDropShadow()
        {
            mouseEnabled = false;
            super();
        }
		
        private var dropShadow:org.flexlite.domUI.primitives.graphic.RectangularDropShadow;
		
        private var _alpha:Number = 0.4;
		/**
		 * @copy spark.filters.DropShadowFilter#alpha
		 */		
        override public function get alpha():Number
        {
            return _alpha;
        }
		
        override public function set alpha(value:Number):void
        {
            if (_alpha != value)
            {
                _alpha = value;
                invalidateDisplayList();
            }
        }
		
        private var _angle:Number = 45.0;
		/**
		 * @copy spark.filters.DropShadowFilter#angle
		 */		
        public function get angle():Number
        {
            return _angle;
        }
		
        public function set angle(value:Number):void
        {
            if (_angle != value)
            {
                _angle = value;
                invalidateDisplayList();
            }
        }
		
        private var _color:int = 0;
		/**
		 * @copy spark.filters.DropShadowFilter#color
		 */		
        public function get color():int
        {
            return _color;
        }
		
        public function set color(value:int):void
        {
            if (_color != value)
            {
                _color = value;
                invalidateDisplayList();
            }
        }
		
        private var _distance:Number = 4.0;
		/**
		 * @copy flash.filters.DropShadowFilter#distance
		 */		
        public function get distance():Number
        {
            return _distance;
        }
		
        public function set distance(value:Number):void
        {
            if (_distance != value)
            {
                _distance = value;
                invalidateDisplayList();
            }
        }
		
        private var _tlRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get tlRadius():Number
        {
            return _tlRadius;
        }
		
        public function set tlRadius(value:Number):void
        {
            if (_tlRadius != value)
            {
                _tlRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _trRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右上角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get trRadius():Number
        {
            return _trRadius;
        }
		
        public function set trRadius(value:Number):void
        {
            if (_trRadius != value)
            {
                _trRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _blRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形左下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get blRadius():Number
        {
            return _blRadius;
        }
		
        public function set blRadius(value:Number):void
        {
            if (_blRadius != value)
            {
                _blRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _brRadius:Number = 0;
		/**
		 * 投射阴影的圆角矩形右下角的顶点半径。对于非圆角矩形，可能为零。
		 */		
        public function get brRadius():Number
        {
            return _brRadius;
        }
		
        public function set brRadius(value:Number):void
        {
            if (_brRadius != value)
            {
                _brRadius = value;
                invalidateDisplayList();
            }
        }
		
        private var _blurX:Number = 4;
		/**
		 * 水平模糊量。
		 */		
        public function get blurX():Number
        {
            return _blurX;
        }
		
        public function set blurX(value:Number):void
        {
            if (_blurX != value)
            {
                _blurX = value;
                invalidateDisplayList();
            }
        }
		
        private var _blurY:Number = 4;
		/**
		 * 垂直模糊量。
		 */		
        public function get blurY():Number
        {
            return _blurY;
        }
		
        public function set blurY(value:Number):void
        {
            if (_blurY != value)
            {
                _blurY = value;
                invalidateDisplayList();
            }
        }
		
        override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            graphics.clear();

            if (!dropShadow)
                dropShadow = new org.flexlite.domUI.primitives.graphic.RectangularDropShadow();

            dropShadow.distance = _distance;
            dropShadow.angle = _angle;
            dropShadow.color = _color;
            dropShadow.blurX = _blurX;
            dropShadow.blurY = _blurY;
            dropShadow.alpha = _alpha;

            dropShadow.tlRadius = isNaN(_tlRadius) ? 0 : _tlRadius;
            dropShadow.trRadius = isNaN(_trRadius) ? 0 : _trRadius;
            dropShadow.blRadius = isNaN(_blRadius) ? 0 : _blRadius;
            dropShadow.brRadius = isNaN(_brRadius) ? 0 : _brRadius;

            dropShadow.drawShadow(graphics, 0, 0, unscaledWidth, unscaledHeight);
        }
    
    }
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}