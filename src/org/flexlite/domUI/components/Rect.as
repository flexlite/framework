package org.flexlite.domUI.components
{
	import flash.display.Graphics;
	
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.utils.GraphicsUtil;
	
	[DXML(show="false")]
	/**
	 * 矩形绘图元素。矩形的角可以是圆角,此组件可响应鼠标事件。
	 * @author DOM
	 */
	public class Rect extends UIComponent
	{
		/**
		 * 构造函数
		 */		
		public function Rect()
		{
			super();
			mouseChildren = false;
		}
		
		private var _color:uint = 0xFFFFFF;
		/**
		 * 填充的颜色
		 */
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			if(_color==value)
				return;
			_color = value;
			invalidateDisplayList();
		}
		
		private var _radius:Number = 0;
		/**
		 * 设置四个角的为相同的圆角半径。您也可以分别对每个角设置半径，
		 * 但若此属性不为0，则分别设置每个角的半径无效。默认值为0。
		 */
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(value:Number):void
		{
			if(value<0)
				value=0;
			if(_radius==value)
				return;
			_radius = value;
			invalidateDisplayList();
		}

		private var _topLeftRadius:Number = 0;
		/**
		 * 左上角圆角半径，若设置了radius不为0，则此属性无效。
		 */
		public function get topLeftRadius():Number
		{
			return _topLeftRadius;
		}
		public function set topLeftRadius(value:Number):void
		{
			if(value<0)
				value=0;
			if(_topLeftRadius==value)
				return;
			_topLeftRadius = value;
			invalidateDisplayList();
		}

		private var _topRightRadius:Number = 0;
		/**
		 * 右上角圆角半径，若设置了radius不为0，则此属性无效。
		 */
		public function get topRightRadius():Number
		{
			return _topRightRadius;
		}
		public function set topRightRadius(value:Number):void
		{
			if(value<0)
				value=0;
			if(_topRightRadius==value)
				return;
			_topRightRadius = value;
			invalidateDisplayList();
		}

		private var _bottomLeftRadius:Number = 0;
		/**
		 * 左下角圆角半径，若设置了radius不为0，则此属性无效。
		 */
		public function get bottomLeftRadius():Number
		{
			return _bottomLeftRadius;
		}
		public function set bottomLeftRadius(value:Number):void
		{
			if(value<0)
				value=0;
			if(_bottomLeftRadius==value)
				return;
			_bottomLeftRadius = value;
			invalidateDisplayList();
		}

		private var _bottomRightRadius:Number = 0;
		/**
		 * 右下角圆角半径，若设置了radius不为0，则此属性无效。
		 */
		public function get bottomRightRadius():Number
		{
			return _bottomRightRadius;
		}
		public function set bottomRightRadius(value:Number):void
		{
			if(value<0)
				value=0;
			if(_bottomRightRadius==value)
				return;
			_bottomRightRadius = value;
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredWidth = 50;
			measuredHeight = 50;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledWidth);
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(_color,1);
			if(_radius>0)
			{
				var ellipseSize:Number = _radius * 2;
				g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 
					ellipseSize, ellipseSize);
			}
			else if(_topLeftRadius>0||_topRightRadius>0||_bottomLeftRadius>0||_bottomRightRadius>0)
			{
				GraphicsUtil.drawRoundRectComplex(g,
					0, 0, unscaledWidth, unscaledHeight,
					_topLeftRadius,_topRightRadius,
					_bottomLeftRadius,_bottomRightRadius);
			}
			else
			{
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			}
			g.endFill();
		}
	}
}