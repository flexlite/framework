package org.flexlite.domDisplay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.IInvalidateDisplay;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	/**
	 * 具有九宫格缩放功能的位图显示对象
	 * 注意：此类不具有鼠标事件
	 * @author DOM
	 */
	public class Scale9GridBitmap extends Shape implements IInvalidateDisplay
	{
		/**
		 * 构造函数
		 * @param bitmapData 被引用的BitmapData对象。
		 * @param target 要绘制到的目标Graphics对象，若不传入，则绘制到自身。
		 * @param smoothing 在缩放时是否对位图进行平滑处理。
		 */		
		public function Scale9GridBitmap(bitmapData:BitmapData=null,target:Graphics=null,smoothing:Boolean=false)
		{
			super();
			if(target)
				this.target = target;
			else 
				this.target = graphics;
			this._smoothing = smoothing;
			if(bitmapData)
				this.bitmapData = bitmapData;
		}
		/**
		 * smoothing改变标志
		 */		
		private var smoothingChanged:Boolean = false;
		
		private var _smoothing:Boolean;
		/**
		 * 在缩放时是否对位图进行平滑处理。
		 */
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void
		{
			if(_smoothing==value)
				return;
			_smoothing = value;
			smoothingChanged = true;
			invalidateProperties();
		}

		
		/**
		 * 要绘制到的目标Graphics对象。
		 */		
		private var target:Graphics;
		/**
		 * bitmapData发生改变
		 */		
		private var bitmapDataChanged:Boolean = false;
		
		private var _bitmapData:BitmapData;
		/**
		 * 被引用的BitmapData对象。
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			if(_bitmapData==value)
				return;
			_bitmapData = value;
			cachedSourceGrid = null;
			cachedDestGrid = null;
			if(value)
			{
				if(!widthExplicitSet)
					_width = _bitmapData.width-filterWidth;
				if(!heightExplicitSet)
					_height = _bitmapData.height-filterHeight;
				bitmapDataChanged = true;
				invalidateProperties();
			}
			else
			{
				target.clear();
				if(!widthExplicitSet)
					_width = NaN;
				if(!heightExplicitSet)
					_height = NaN;
			}
		}
		
		private var scale9GridChanged:Boolean = false;
		
		private var _scale9Grid:Rectangle;

		/**
		 * @inheritDoc
		 */
		override public function get scale9Grid():Rectangle
		{
			return _scale9Grid;
		}

		/**
		 * @inheritDoc
		 */
		override public function set scale9Grid(value:Rectangle):void
		{
			if(value&&_scale9Grid&&value.equals(_scale9Grid))
				return;
			cachedDestGrid = null;
			cachedSourceGrid = null;
			_scale9Grid = value;
			scale9GridChanged = true;
			invalidateProperties();
		}
		
		private var offsetPointChanged:Boolean = false;
		
		dx_internal var _offsetPoint:Point;

		/**
		 * 位图起始位置偏移量。
		 * 注意：如果同时设置了scale9Grid属性，将会影响九宫格绘制的结果。
		 * 这与直接设置xy效果不同，后者只是先应用了scale9Grid再平移一次。
		 */
		dx_internal function get offsetPoint():Point
		{
			return _offsetPoint;
		}

		/**
		 * @private
		 */
		dx_internal function set offsetPoint(value:Point):void
		{
			if(_offsetPoint==value)
				return;
			_offsetPoint = value;
			offsetPointChanged = true;
			invalidateProperties();
		}
		
		private var widthChanged:Boolean = false;
		/**
		 * 宽度显式设置标记
		 */		
		private var widthExplicitSet:Boolean = false;
		
		private var _width:Number;
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return escapeNaN(_width);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(value==_width)
				return;
			_width = value;
			widthExplicitSet = !isNaN(value);
			widthChanged = true;
			invalidateProperties();
		}
		
		private var heightChanged:Boolean = false;
		/**
		 * 高度显式设置标志
		 */		
		private var heightExplicitSet:Boolean = false;
		
		private var _height:Number;
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return escapeNaN(_height);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if(_height==value)
				return;
			_height = value;
			heightExplicitSet = !isNaN(value);
			widthChanged = true;
			invalidateProperties();
		}
		/**
		 * 过滤NaN数字
		 */		
		private function escapeNaN(number:Number):Number
		{
			if(isNaN(number))
				return 0;
			return number;
		}
		
		private var invalidateFlag:Boolean = false;
		/**
		 * 标记有属性变化需要延迟应用
		 */		
		protected function invalidateProperties():void
		{
			if(!invalidateFlag)
			{
				invalidateFlag = true;
				addEventListener(Event.ENTER_FRAME,validateProperties);
				if(stage)
				{
					addEventListener(Event.RENDER,validateProperties);
					stage.invalidate();
				}
			}
		}
		/**
		 * 延迟应用属性事件
		 */		
		private function validateProperties(event:Event=null):void
		{
			removeEventListener(Event.ENTER_FRAME,validateProperties);
			removeEventListener(Event.RENDER,validateProperties);
			commitProperties();
			invalidateFlag = false;
		}	
		
		/**
		 * 立即应用所有标记为延迟验证的属性
		 */		
		public function validateNow():void
		{
			if(invalidateFlag)
				validateProperties();
		}
		
		/**
		 * 延迟应用属性
		 */
		protected function commitProperties():void
		{
			if(bitmapDataChanged||widthChanged||heightChanged||
				scale9GridChanged||offsetPointChanged||smoothingChanged)
			{
				if(_bitmapData)
					applyBitmapData();
				scale9GridChanged = false;
				offsetPointChanged = false;
				smoothingChanged = false;
			}
		}

		/**
		 * 滤镜宽度,在子类中赋值
		 */		
		dx_internal var filterWidth:Number = 0;
		/**
		 * 滤镜高度,在子类中赋值
		 */		
		dx_internal var filterHeight:Number = 0;
		/**
		 * 缓存的源九宫格网格坐标数据
		 */		
		private var cachedSourceGrid:Array;
		/**
		 * 缓存的目标九宫格网格坐标数据
		 */		
		private var cachedDestGrid:Array;
		/**
		 * 应用bitmapData属性
		 */		
		private function applyBitmapData():void
		{
			target.clear();
			if(_scale9Grid)
			{
				if(widthChanged||heightChanged)
				{
					cachedDestGrid = null;
					widthChanged = false;
					heightChanged = false;
				}
				if(_height==0||_width==0)
					return;
				applyScaledBitmapData(this);
			}
			else
			{
				if(_height==0||_width==0)
					return;
				var offset:Point = _offsetPoint;
				if(!offset)
					offset = new Point();
				matrix.identity();
				matrix.scale((_width+filterWidth)/_bitmapData.width,(_height+filterHeight)/_bitmapData.height);
				matrix.translate(offset.x,offset.y);
				
				target.beginBitmapFill(bitmapData,matrix,false,_smoothing);
				target.drawRect(offset.x,offset.x,(_width+filterWidth),(_height+filterHeight));
				target.endFill();
			}
		}

		private static var matrix:Matrix = new Matrix();
		/**
		 * 应用具有九宫格缩放规则的位图数据
		 */		
		private static function applyScaledBitmapData(target:Scale9GridBitmap):void
		{
			var bitmapData:BitmapData = target.bitmapData;
			var width:Number = target.width+target.filterWidth;
			var height:Number = target.height+target.filterHeight;
			var offset:Point = target.offsetPoint;
			if(!offset)
			{
				offset = new Point();
			}
			var roundedDrawX:Number = Math.round(offset.x*width/bitmapData.width);
			var roundedDrawY:Number = Math.round(offset.y*height/bitmapData.height);
			var s9g:Rectangle = new Rectangle(
				target.scale9Grid.x-Math.round(offset.x),target.scale9Grid.y-Math.round(offset.y),
				target.scale9Grid.width,target.scale9Grid.height);
			//防止空心的情况出现。
			if(s9g.top==s9g.bottom)
			{
				if(s9g.bottom<bitmapData.height)
					s9g.bottom ++;
				else
					s9g.top --;
			}
			if(s9g.left==s9g.right)
			{
				if(s9g.right<bitmapData.width)
					s9g.right ++;
				else
					s9g.left --;
			}
			var cachedSourceGrid:Array = target.cachedSourceGrid;
			if (cachedSourceGrid == null)
			{
				cachedSourceGrid = target.cachedSourceGrid = [];
				cachedSourceGrid.push([new Point(0, 0), new Point(s9g.left, 0),
					new Point(s9g.right, 0), new Point(bitmapData.width, 0)]);
				cachedSourceGrid.push([new Point(0, s9g.top), new Point(s9g.left, s9g.top),
					new Point(s9g.right, s9g.top), new Point(bitmapData.width, s9g.top)]);
				cachedSourceGrid.push([new Point(0, s9g.bottom), new Point(s9g.left, s9g.bottom),
					new Point(s9g.right, s9g.bottom), new Point(bitmapData.width, s9g.bottom)]);
				cachedSourceGrid.push([new Point(0, bitmapData.height), new Point(s9g.left, bitmapData.height),
					new Point(s9g.right, bitmapData.height), new Point(bitmapData.width, bitmapData.height)]);
			}
			
			var cachedDestGrid:Array = target.cachedDestGrid;
			if (cachedDestGrid == null)
			{
				var destScaleGridBottom:Number = height - (bitmapData.height - s9g.bottom);
				var destScaleGridRight:Number = width - (bitmapData.width - s9g.right);
				if(bitmapData.width - s9g.width>width)
				{
					var a:Number = (bitmapData.width-s9g.right)/s9g.left;
					var center:Number = width/(1+a);
					destScaleGridRight = s9g.left = s9g.right = Math.round(isNaN(center)?0:center);
				}
				if(bitmapData.height - s9g.height>height)
				{
					var b:Number = (bitmapData.height-s9g.bottom)/s9g.top;
					var middle:Number = height/(1+b);
					destScaleGridBottom = s9g.top = s9g.bottom = Math.round(isNaN(middle)?0:middle);
				}
				cachedDestGrid = target.cachedDestGrid = [];
				cachedDestGrid.push([new Point(0, 0), new Point(s9g.left, 0),
					new Point(destScaleGridRight, 0), new Point(width, 0)]);
				cachedDestGrid.push([new Point(0, s9g.top), new Point(s9g.left, s9g.top),
					new Point(destScaleGridRight, s9g.top), new Point(width, s9g.top)]);
				cachedDestGrid.push([new Point(0, destScaleGridBottom), new Point(s9g.left, destScaleGridBottom),
					new Point(destScaleGridRight, destScaleGridBottom), new Point(width, destScaleGridBottom)]);
				cachedDestGrid.push([new Point(0, height), new Point(s9g.left, height),
					new Point(destScaleGridRight, height), new Point(width, height)]);
			}
			
			var sourceSection:Rectangle = new Rectangle();
			var destSection:Rectangle = new Rectangle();
			
			var g:Graphics = target.target;
			g.clear();
			
			for (var rowIndex:int=0; rowIndex < 3; rowIndex++)
			{
				for (var colIndex:int = 0; colIndex < 3; colIndex++)
				{
					sourceSection.topLeft = cachedSourceGrid[rowIndex][colIndex];
					sourceSection.bottomRight = cachedSourceGrid[rowIndex+1][colIndex+1];
					
					destSection.topLeft = cachedDestGrid[rowIndex][colIndex];
					destSection.bottomRight = cachedDestGrid[rowIndex+1][colIndex+1];
					if(destSection.width==0||destSection.height==0||
						sourceSection.width==0||sourceSection.height==0)
						continue;
					matrix.identity();
					matrix.scale(destSection.width / sourceSection.width,destSection.height / sourceSection.height);
					matrix.translate(destSection.x - sourceSection.x * matrix.a, destSection.y - sourceSection.y * matrix.d);
					matrix.translate(roundedDrawX, roundedDrawY);
					
					g.beginBitmapFill(bitmapData, matrix,false,target._smoothing);
					g.drawRect(destSection.x + roundedDrawX, destSection.y + roundedDrawY, destSection.width, destSection.height);
					g.endFill();
				}
			}
		}
	}
}