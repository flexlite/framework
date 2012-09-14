package org.flexlite.domUI.primitives
{
	
	import org.flexlite.domUI.core.DisplayObjectSharingMode;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.primitives.graphic.BitmapFillMode;
	import org.flexlite.domUI.primitives.graphic.BitmapScaleMode;
	import org.flexlite.domUI.primitives.graphic.BitmapSmoothingQuality;
	import org.flexlite.domUI.primitives.supportClasses.GraphicElement;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	use namespace dx_internal;
	
	/**
	 * 图像仅仅加载完成数据，还未显示 
	 */	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 * 图像源已完全加载完成并显示
	 */	
	[Event(name="ready", type="org.flexlite.domUI.events.UIEvent")]
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	[DXML(show="false")]
	
	/**
	 * BitmapImage 元素在其父元素的坐标空间内定义一个矩形区域，使用从源文件或源 URL 获取的位图数据填充。
	 * @author DOM
	 */	
	public class BitmapImage extends GraphicElement
	{
		/**
		 * 构造函数
		 */		
		public function BitmapImage()
		{
			super();
		}
		
		private var _scaleGridBottom:Number;
		private var _scaleGridLeft:Number;
		private var _scaleGridRight:Number;
		private var _scaleGridTop:Number;
		private var bitmapDataCreated:Boolean;
		private static var matrix:Matrix = new Matrix();
		private var cachedSourceGrid:Array;
		private var cachedDestGrid:Array;
		private var imageWidth:Number = NaN;
		private var imageHeight:Number = NaN;
		private var loadedContent:DisplayObject;
		private var loadingContent:Object;
		private var previousUnscaledWidth:Number;
		private var previousUnscaledHeight:Number;
		private var sourceInvalid:Boolean;
		private var loadFailed:Boolean;
		
		
		private var _bitmapData:BitmapData;
		/**
		 * 返回 BitmapData 对象的副本，该对象表示当前加载的图像内容（未缩放）。
		 * 对于不受信任的跨域内容，此属性为 null。
		 */		
		public function get bitmapData():BitmapData
		{
			return _bitmapData ? _bitmapData.clone() : _bitmapData;
		}
		
		private var _bytesLoaded:Number = NaN;
		/**
		 * 已加载的图像的字节数。仅与由请求 URL 加载的图像相关。
		 */		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		private var _bytesTotal:Number = NaN;
		
		/**
		 * 已加载的或待加载的总图像数据（以字节为单位）。
		 * 仅与由请求 URL 加载的图像相关。
		 */		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		private var _clearOnLoad:Boolean = true;
		/**
		 * 是否在加载新内容之前清除以前的图像内容。
		 */		
		public function get clearOnLoad():Boolean
		{
			return _clearOnLoad;
		}
		
		public function set clearOnLoad(value:Boolean):void
		{
			_clearOnLoad = value;
		}
		
		
		protected var _fillMode:String = BitmapFillMode.SCALE;
		/**
		 * 确定位图填充尺寸的方式。<br/>
		 * 当设置为BitmapFillMode.CLIP时,将在区域的边缘处剪裁位图。<br/>
		 * 当设置为BitmapFillMode.REPEAT时,将重复位图以填充区域。 <br/>
		 * 当设置为BitmapFillMode.SCALE时,将拉伸位图以填充区域。<br/>
		 * 默认值为：BitmapFillMode.SCALE;
		 */		
		public function get fillMode():String
		{
			return _fillMode;
		}
		
		public function set fillMode(value:String):void
		{
			if (value != _fillMode)
			{
				_fillMode = value;
				invalidateDisplayList();
			}
		}
		
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		/**
		 * 内容的水平对齐方式。 请使用HorizontalAlign中定义的值。
		 */		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if (value == _horizontalAlign)
				return;
			
			_horizontalAlign = value;
			invalidateDisplayList();
		}
		
		private function getHorizontalAlignValue():Number
		{
			if (_horizontalAlign == HorizontalAlign.LEFT)
				return 0;
			else if (_horizontalAlign == HorizontalAlign.RIGHT)
				return 1;
			else
				return 0.5;
		}
		
		private var _preliminaryHeight:Number = NaN;
		/**
		 * 当布局请求图像的“测量”范围，但图像数据尚未完成加载时，提供要使用的高度的估计值。
		 * 如果为 NaN，则在图像完成加载之前，测量高度将一直是 0。
		 */	
		public function get preliminaryHeight():Number
		{
			return _preliminaryHeight;
		}
		
		
		public function set preliminaryHeight(value:Number):void
		{
			if (value != _preliminaryHeight)
			{
				_preliminaryHeight = value;
				invalidateSize();
			}
		}
		
		private var _preliminaryWidth:Number = NaN;
		/**
		 * 当布局请求图像的“测量”范围，但图像数据尚未完成加载时，提供要使用的宽度的估计值。
		 * 如果为 NaN，则在图像完成加载之前，测量宽度将一直是 0。
		 */		
		public function get preliminaryWidth():Number
		{
			return _preliminaryWidth;
		}
		
		public function set preliminaryWidth(value:Number):void
		{
			if (value != _preliminaryWidth)
			{
				_preliminaryWidth = value;
				invalidateSize();
			}
		}
		
		private var _scaleMode:String = BitmapScaleMode.STRETCH;
		/**
		 * 缩放图像方式。仅当fillMode为BitmapFillMode.SCALE时此属性有效<br/>
		 * 当设置为BitmapScaleMode.STRETCH时,将拉伸位图以填充区域。<br/>
		 * 当设置为BitmapScaleMode.LETTERBOX时,将在保持原始高宽比的情况下拉伸位图<br/>
		 * 当设置为BitmapScaleMode.ZOOM时,将缩放和裁剪位图，以使原始内容的高宽比保持不变并且不显示空白或突出的边界。<br/>
		 * 默认值为：BitmapScaleMode.STRETCH
		 */		
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void
		{
			if (value == _scaleMode)
				return;
			
			_scaleMode = value;
			invalidateDisplayList();
		}
		
		private var _smooth:Boolean = false;
		/**
		 * @copy flash.display.GraphicsBitmapFill#smooth
		 */		
		public function set smooth(value:Boolean):void
		{
			if (value != _smooth)
			{
				_smooth = value;
				invalidateDisplayList();
			}
		}
		
		public function get smooth():Boolean
		{
			return _smooth;
		}
		
		private var _smoothingQuality:String = BitmapSmoothingQuality.DEFAULT;
		/**
		 * 确定如何缩小图像。<br/>
		 * 当设置为BitmapSmoothingQuality.HIGH时，将重新采样图像（如果数据来源受信任），以达到更高质量的结果。<br/>
		 * 如果设置为BitmapSmoothingQuality.DEFAULT时，则使用缩放的位图填充的默认舞台品质。<br/>
		 * 默认值为:BitmapSmoothingQuality.DEFAULT。
		 */		
		public function set smoothingQuality(value:String):void
		{
			if (value != _smoothingQuality)
			{
				_smoothingQuality = value;
				invalidateDisplayList();
			}
		}
		
		public function get smoothingQuality():String
		{
			return _smoothingQuality;
		}
		
		private var _source:Object;
		/**
		 * 用于位图填充的源。
		 * 可以呈示基于各种图形源的填充，其中包括： 
		 * 1.Bitmap 或 BitmapData 实例。 
		 * 2.DisplayObject的子类Class。
		 * 3.DisplayObject的实例。
		 * 4.图片的字节流对象。
		 * 5.外部图像文件的路径。 
		 */		
		public function get source():Object
		{
			return _source;
		}
		
		public function set source(value:Object):void
		{
			if (value != _source)
			{
				clearLoadingContent();
				removeAddedToStageHandler(_source);
				
				_source = value;
				sourceInvalid = true;
				loadFailed = false;
				invalidateProperties();
				dispatchEvent(new Event("sourceChanged"));
			}
		}
		/**
		 * 提供原始图像数据的未缩放高度。
		 */		
		public function get sourceHeight():Number
		{
			return imageHeight;
		}
		/**
		 * 提供原始图像数据的未缩放宽度。
		 */	
		public function get sourceWidth():Number
		{
			return imageWidth;
		}
		
		private var _trustedSource:Boolean = true;
		/**
		 * 一个只读标志，指示是否将当前加载的内容视为是从其安全策略允许跨域图像访问的源加载的。
		 * 为 false 时，不允许执行高级位图操作，如高品质缩放和拼贴。在全部加载图像后设置此标志。
		 */		
		public function get trustedSource():Boolean
		{
			return _trustedSource;
		}
		
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		/**
		 * 内容的垂直对齐方式,请使用VerticalAlign中定义的值。
		 */		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (value == _verticalAlign)
				return;
			
			_verticalAlign = value;
			invalidateDisplayList();
		}
		
		private function getVerticalAlignValue():Number
		{
			if (_verticalAlign == VerticalAlign.TOP)
				return 0;
			else if (_verticalAlign == VerticalAlign.BOTTOM)
				return 1;
			else
				return 0.5;
		}
		
		
		override protected function commitProperties():void
		{
			validateSource();
			super.commitProperties();
		}
		
		
		override protected function measure():void
		{
			var dpiScale:Number = 1;
			if (loadedContent)
			{
				
				measuredWidth = imageWidth;
				measuredHeight = imageHeight;
				if (dpiScale != 1) 
				{
					measuredWidth /= dpiScale;
					measuredHeight /= dpiScale;
				}
			}
			else if (_bitmapData)
			{
				
				measuredWidth = _bitmapData.width;
				measuredHeight = _bitmapData.height;
				if (dpiScale != 1) 
				{
					measuredWidth /= dpiScale;
					measuredHeight /= dpiScale;
				}
			}
			else
			{
				var usePreviousSize:Boolean = !(_source == null || _source == "" || loadFailed);
				var previousWidth:Number = usePreviousSize ? measuredWidth : 0;
				var previousHeight:Number = usePreviousSize ? measuredHeight : 0;
				
				measuredWidth = !isNaN(_preliminaryWidth) && (previousWidth == 0) ?
					_preliminaryWidth : previousWidth;
				measuredHeight = !isNaN(_preliminaryHeight) && (previousHeight == 0) ?
					_preliminaryHeight : previousHeight;
				
				return;
			}
			if (maintainAspectRatio && measuredWidth > 0 && measuredHeight > 0)
			{
				if(!isNaN(explicitWidth) && isNaN(explicitHeight) &&
					isNaN(percentHeight))
				{
					measuredHeight = explicitWidth/measuredWidth * measuredHeight;
				}
				else if (!isNaN(explicitHeight) && isNaN(explicitWidth) &&
					isNaN(percentWidth))
				{
					measuredWidth = explicitHeight/measuredHeight * measuredWidth;
				}
				else if (!isNaN(percentWidth) && isNaN(explicitHeight) &&
					isNaN(percentHeight) && width > 0)
				{
					measuredHeight = width/measuredWidth * measuredHeight;
				}
				else if (!isNaN(percentHeight) && isNaN(explicitWidth) &&
					isNaN(percentWidth) && height > 0)
				{
					measuredWidth = height/measuredHeight * measuredWidth;
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var adjustedHeight:Number = unscaledHeight;
			var adjustedWidth:Number = unscaledWidth;
			var isZoom:Boolean = (_fillMode == BitmapFillMode.SCALE) && 
				(_scaleMode == BitmapScaleMode.ZOOM);
			var aspectRatio:Number = unscaledWidth/unscaledHeight;
			var imageAspectRatio:Number = imageWidth/imageHeight;
			if (maintainAspectRatio)
			{
				if (!isNaN(imageAspectRatio))
				{
					if (imageAspectRatio > aspectRatio)
						adjustedHeight = unscaledWidth / imageAspectRatio;
					else
						adjustedWidth = unscaledHeight * imageAspectRatio;
					
					if ((!isNaN(percentWidth) && isNaN(percentHeight) && isNaN(explicitHeight)) ||
						(!isNaN(percentHeight) && isNaN(percentWidth) && isNaN(explicitWidth)))
					{
						if (aspectRatio != imageAspectRatio)
						{
							invalidateSize();
							return;
						}
					}
				}
			}
			
			if (!_bitmapData || !drawnDisplayObject || !(drawnDisplayObject is Sprite))
			{
				if (loadedContent)
				{
					if (_fillMode == BitmapFillMode.SCALE)
					{
						loadedContent.width = adjustedWidth;
						loadedContent.height = adjustedHeight;
					}
					
					loadedContent.y = loadedContent.x = 0;
					if (maintainAspectRatio || _fillMode == BitmapFillMode.CLIP || isZoom)
					{
						var contentWidth:Number = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
							imageWidth : adjustedWidth;
						var contentHeight:Number = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
							imageHeight : adjustedHeight;
						
						if (unscaledHeight > contentHeight)
							loadedContent.y = Math.floor((unscaledHeight - contentHeight)
								* getVerticalAlignValue());
						
						if (unscaledWidth > contentWidth)
							loadedContent.x = Math.floor((unscaledWidth - contentWidth)
								* getHorizontalAlignValue());
					}
					loadedContent.scrollRect = (_fillMode == BitmapFillMode.CLIP || isZoom) ?
						new Rectangle(0, 0, unscaledWidth, unscaledHeight) : null;
					
				}
				return;
			}
			var g:Graphics = Sprite(drawnDisplayObject).graphics;
			
			g.lineStyle();
			var repeatBitmap:Boolean = false;
			var fillScaleX:Number = 1;
			var fillScaleY:Number = 1;
			var roundedDrawX:Number = Math.round(drawX);
			var roundedDrawY:Number = Math.round(drawY);
			var fillWidth:Number = adjustedWidth;
			var fillHeight:Number = adjustedHeight;
			
			if (_bitmapData)
			{
				switch(_fillMode)
				{
					case BitmapFillMode.REPEAT:
					{
						repeatBitmap = true;
						break;
					}
					case BitmapFillMode.SCALE:
					{
						if (isZoom)
						{
							var widthRatio:Number = adjustedWidth / _bitmapData.width;
							var heightRatio:Number = adjustedHeight / _bitmapData.height;
							
							if (widthRatio < heightRatio)
								fillScaleX = fillScaleY = (adjustedHeight / _bitmapData.height);
							else
								fillScaleX = fillScaleY = (adjustedWidth / _bitmapData.width);
						}
						else
						{
							fillScaleX = adjustedWidth / _bitmapData.width;
							fillScaleY = adjustedHeight / _bitmapData.height;
						}
						break;
					}
					case BitmapFillMode.CLIP:
					{
						fillWidth = Math.min(adjustedWidth, _bitmapData.width);
						fillHeight = Math.min(adjustedHeight, _bitmapData.height);
						break;
					}
				}
			}
			if (_fillMode != BitmapFillMode.SCALE ||
				isNaN(_scaleGridTop) ||
				isNaN(_scaleGridBottom) ||
				isNaN(_scaleGridLeft) ||
				isNaN(_scaleGridRight))
			{
				var sampledScale:Boolean = _smooth &&
					(_smoothingQuality == BitmapSmoothingQuality.HIGH) &&
					(_fillMode == BitmapFillMode.SCALE);
				var sampleWidth:Number = fillWidth;
				var sampleHeight:Number = fillHeight;
				
				if (isZoom)
				{
					sampleWidth = _bitmapData.width * fillScaleX;
					sampleHeight = _bitmapData.height * fillScaleY;
				}
				
				var b:BitmapData = sampledScale ? resample(_bitmapData, sampleWidth, sampleHeight) : _bitmapData;
				
				if (sampledScale && (_fillMode == BitmapFillMode.SCALE))
				{
					if (isZoom)
					{
						fillScaleX = fillScaleY = 1;
					}
					else if (_fillMode == BitmapFillMode.SCALE)
					{
						fillScaleX = adjustedWidth / b.width;
						fillScaleY = adjustedHeight / b.height;
					}
				}
				
				var cHeight:Number = b.height * fillScaleX;
				var cWidth:Number = b.width * fillScaleY;
				if (maintainAspectRatio || _fillMode == BitmapFillMode.CLIP || isZoom)
				{
					if (unscaledHeight > cHeight)
						roundedDrawY = roundedDrawY + Math.floor((unscaledHeight - cHeight)
							* getVerticalAlignValue());
					
					if (unscaledWidth > cWidth)
						roundedDrawX = roundedDrawX + Math.floor((unscaledWidth - cWidth)
							* getHorizontalAlignValue());
				}
				
				var translateX:Number = roundedDrawX;
				var translateY:Number = roundedDrawY;
				
				if (isZoom)
				{
					if (cWidth > unscaledWidth)
						translateX = translateX + ((unscaledWidth - cWidth) * getHorizontalAlignValue());
					else if (cHeight > unscaledHeight)
						translateY = translateY + ((unscaledHeight - cHeight) * getVerticalAlignValue());
				}
				
				matrix.identity();
				if (!(sampledScale && (maintainAspectRatio || isZoom))) 
					matrix.scale(fillScaleX, fillScaleY);
				matrix.translate(translateX, translateY);
				g.beginBitmapFill(b, matrix, repeatBitmap, _smooth);
				g.drawRect(roundedDrawX, roundedDrawY, fillWidth, fillHeight);
				g.endFill();
			}
			else
			{
				if (cachedSourceGrid == null)
				{
					
					cachedSourceGrid = [];
					cachedSourceGrid.push([new Point(0, 0), new Point(_scaleGridLeft, 0),
						new Point(_scaleGridRight, 0), new Point(_bitmapData.width, 0)]);
					cachedSourceGrid.push([new Point(0, _scaleGridTop), new Point(_scaleGridLeft, _scaleGridTop),
						new Point(_scaleGridRight, _scaleGridTop), new Point(_bitmapData.width, _scaleGridTop)]);
					cachedSourceGrid.push([new Point(0, _scaleGridBottom), new Point(_scaleGridLeft, _scaleGridBottom),
						new Point(_scaleGridRight, _scaleGridBottom), new Point(_bitmapData.width, _scaleGridBottom)]);
					cachedSourceGrid.push([new Point(0, _bitmapData.height), new Point(_scaleGridLeft, _bitmapData.height),
						new Point(_scaleGridRight, _bitmapData.height), new Point(_bitmapData.width, _bitmapData.height)]);
				}
				
				if (cachedDestGrid == null ||
					previousUnscaledWidth != unscaledWidth ||
					previousUnscaledHeight != unscaledHeight)
				{
					
					var destScaleGridBottom:Number = unscaledHeight - (_bitmapData.height - _scaleGridBottom);
					var destScaleGridRight:Number = unscaledWidth - (_bitmapData.width - _scaleGridRight);
					cachedDestGrid = [];
					cachedDestGrid.push([new Point(0, 0), new Point(_scaleGridLeft, 0),
						new Point(destScaleGridRight, 0), new Point(unscaledWidth, 0)]);
					cachedDestGrid.push([new Point(0, _scaleGridTop), new Point(_scaleGridLeft, _scaleGridTop),
						new Point(destScaleGridRight, _scaleGridTop), new Point(unscaledWidth, _scaleGridTop)]);
					cachedDestGrid.push([new Point(0, destScaleGridBottom), new Point(_scaleGridLeft, destScaleGridBottom),
						new Point(destScaleGridRight, destScaleGridBottom), new Point(unscaledWidth, destScaleGridBottom)]);
					cachedDestGrid.push([new Point(0, unscaledHeight), new Point(_scaleGridLeft, unscaledHeight),
						new Point(destScaleGridRight, unscaledHeight), new Point(unscaledWidth, unscaledHeight)]);
				}
				
				var sourceSection:Rectangle = new Rectangle();
				var destSection:Rectangle = new Rectangle();
				for (var rowIndex:int=0; rowIndex < 3; rowIndex++)
				{
					for (var colIndex:int = 0; colIndex < 3; colIndex++)
					{
						
						sourceSection.topLeft = cachedSourceGrid[rowIndex][colIndex];
						sourceSection.bottomRight = cachedSourceGrid[rowIndex+1][colIndex+1];
						
						destSection.topLeft = cachedDestGrid[rowIndex][colIndex];
						destSection.bottomRight = cachedDestGrid[rowIndex+1][colIndex+1];
						
						matrix.identity();
						
						matrix.scale(destSection.width / sourceSection.width, destSection.height / sourceSection.height);
						matrix.translate(destSection.x - sourceSection.x * matrix.a, destSection.y - sourceSection.y * matrix.d);
						matrix.translate(roundedDrawX, roundedDrawY);
						g.beginBitmapFill(_bitmapData, matrix);
						g.drawRect(destSection.x + roundedDrawX, destSection.y + roundedDrawY, destSection.width, destSection.height);
						g.endFill();
					}
				}
			}
			
			previousUnscaledWidth = unscaledWidth;
			previousUnscaledHeight = unscaledHeight;
		}
		
		
		override protected function get needsDisplayObject():Boolean
		{
			return !trustedSource || super.needsDisplayObject;
		}
		
		/**
		 * 设置位图数据源
		 */		
		protected function setBitmapData(bitmapData:BitmapData,
										 internallyCreated:Boolean = false):void
		{
			
			clearBitmapData();
			imageWidth = imageHeight = NaN;
			clearLoadingContent();
			
			if (bitmapData)
			{
				bitmapDataCreated = internallyCreated;
				
				_bitmapData = bitmapData;
				
				imageWidth = bitmapData.width;
				imageHeight = bitmapData.height;
				cachedSourceGrid = null;
				cachedDestGrid = null;
				dispatchEvent(new UIEvent(UIEvent.READY));
			}
			
			if (!explicitHeight || !explicitWidth)
				invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 应用数据源
		 */		
		private function applySource():void
		{
			var value:Object = _source;
			var bitmapData:BitmapData;
			var tmpSprite:DisplayObject;
			
			_scaleGridLeft = NaN;
			_scaleGridRight = NaN;
			_scaleGridTop = NaN;
			_scaleGridBottom = NaN;
			var currentBitmapCreated:Boolean = false;
			_bytesLoaded = NaN;
			_bytesTotal = NaN;
			_trustedSource = true;
			invalidateDisplayObjectSharing();
			invalidateDisplayList();
			if (_clearOnLoad)
				removePreviousContent();
			
			if (value is Class)
			{
				var cls:Class = Class(value);
				value = new cls();
				currentBitmapCreated = true;
			}
			else if (value is String || value is URLRequest)
			{
				loadExternal(value);
			}
			else if (value is ByteArray)
			{
				loadFromBytes(value as ByteArray);
			}
			
			if (value is BitmapData)
			{
				bitmapData = value as BitmapData;
			}
			else if (value is Bitmap)
			{
				bitmapData = value.bitmapData;
			}
			else if (value is DisplayObject)
			{
				tmpSprite = value as DisplayObject;
				
				if ((tmpSprite.width == 0 || tmpSprite.height == 0) && !tmpSprite.stage )
				{
					tmpSprite.addEventListener(Event.ADDED_TO_STAGE, source_addedToStageHandler);
					return;
				}
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
				if (tmpSprite is IInvalidating)
					IInvalidating(tmpSprite).validateNow();
				if (tmpSprite.width == 0 || tmpSprite.height == 0)
					return;
				
				bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
				bitmapData.draw(tmpSprite, new Matrix(), tmpSprite.transform.colorTransform);
				currentBitmapCreated = true;
				
				if (tmpSprite.scale9Grid)
				{
					_scaleGridLeft = tmpSprite.scale9Grid.left;
					_scaleGridRight = tmpSprite.scale9Grid.right;
					_scaleGridTop = tmpSprite.scale9Grid.top;
					_scaleGridBottom = tmpSprite.scale9Grid.bottom;
				}
			}
			if (!_clearOnLoad)
				removePreviousContent();
			
			setBitmapData(bitmapData, currentBitmapCreated);
		}
		/**
		 * 从外部加载图像
		 */		
		private function loadExternal(source:Object):void
		{
			
			if (source is String)
			{
				var url:String = source as String;
				source = OSToPlayerURI(url);
			}
			
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loadingContent = loader.contentLoaderInfo;
			attachLoadingListeners();
			
			try
			{
				loaderContext.checkPolicyFile = true;
				var urlRequest:URLRequest = source is URLRequest ?
					source as URLRequest : new URLRequest(source as String);
				loader.load(urlRequest, loaderContext);
			}
			catch (error:SecurityError)
			{
				handleSecurityError(error);
			}
		}
		/**
		 * 转换url编码
		 */		
		private static function OSToPlayerURI(url:String):String 
		{
			var local:Boolean = (url.indexOf("file:") == 0 || url.indexOf(":") == 1);
			var searchStringIndex:int;
			var fragmentUrlIndex:int;
			var decoded:String = url;
			
			if ((searchStringIndex = decoded.indexOf("?")) != -1 )
			{
				decoded = decoded.substring(0, searchStringIndex);
			}
			
			if ((fragmentUrlIndex = decoded.indexOf("#")) != -1 )
				decoded = decoded.substring(0, fragmentUrlIndex);
			
			try
			{
				decoded = decodeURI(decoded);
			}
			catch (e:Error)
			{
			}
			
			var extraString:String = null;
			if (searchStringIndex != -1 || fragmentUrlIndex != -1)
			{
				var index:int = searchStringIndex;
				
				if (searchStringIndex == -1 || 
					(fragmentUrlIndex != -1 && fragmentUrlIndex < searchStringIndex))
				{
					index = fragmentUrlIndex;
				}
				
				extraString = url.substr(index);
			}
			
			if (local && flash.system.Capabilities.playerType == "ActiveX")
			{
				if (extraString)
					return decoded + extraString;
				else 
					return decoded;
			}
			
			if (extraString)
				return encodeURI(decoded) + extraString;
			else
				return encodeURI(decoded);            
		}
		/**
		 * 从字节流加载图像
		 */		
		private function loadFromBytes(source:ByteArray):void
		{
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loadingContent = loader.contentLoaderInfo;
			attachLoadingListeners();
			
			try
			{
				loader.loadBytes(source as ByteArray, loaderContext);
			}
			catch (error:SecurityError)
			{
				handleSecurityError(error);
			}
		}
		
		protected static function resample(bitmapData:BitmapData, newWidth:uint,
										   newHeight:uint):BitmapData
		{
			var finalScale:Number = Math.max(newWidth/bitmapData.width,
				newHeight/bitmapData.height);
			
			var finalData:BitmapData = bitmapData;
			
			if (finalScale > 1)
			{
				finalData = new BitmapData(bitmapData.width * finalScale,
					bitmapData.height * finalScale, true, 0);
				
				finalData.draw(bitmapData, new Matrix(finalScale, 0, 0,
					finalScale), null, null, null, true);
				
				return finalData;
			}
			
			var drop:Number = .5;
			var initialScale:Number = finalScale;
			
			while (initialScale/drop < 1)
				initialScale /= drop;
			
			var w:Number = Math.floor(bitmapData.width * initialScale);
			var h:Number = Math.floor(bitmapData.height * initialScale);
			var bd:BitmapData = new BitmapData(w, h, bitmapData.transparent, 0);
			
			bd.draw(finalData, new Matrix(initialScale, 0, 0, initialScale),
				null, null, null, true);
			finalData = bd;
			
			for (var scale:Number = initialScale * drop;
				Math.round(scale * 1000) >= Math.round(finalScale * 1000);
				scale *= drop)
			{
				w = Math.floor(bitmapData.width * scale);
				h = Math.floor(bitmapData.height * scale);
				bd = new BitmapData(w, h, bitmapData.transparent, 0);
				
				bd.draw(finalData, new Matrix(drop, 0, 0, drop), null, null, null, true);
				finalData.dispose();
				finalData = bd;
			}
			
			return finalData;
		}
		
		protected function contentComplete(content:Object):void
		{
			if (content is LoaderInfo)
			{
				
				setBitmapData(null);
				removePreviousContent();
				
				var loaderInfo:LoaderInfo = content as LoaderInfo;
				
				if (loaderInfo.childAllowsParent)
				{
					
					var image:Bitmap = Bitmap(loaderInfo.content);
					setBitmapData(image.bitmapData);
				}
				else
				{
					displayObjectSharingMode = DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT;
					invalidateDisplayObjectSharing();
					var contentHolder:Sprite = new Sprite();
					setDisplayObject(contentHolder);
					loadedContent = loaderInfo.loader;
					contentHolder.addChild(loadedContent);
					imageWidth = loaderInfo.width;
					imageHeight = loaderInfo.height ;
					if (!explicitHeight || !explicitWidth)
						invalidateSize();
					invalidateDisplayList();
					_trustedSource = false;
					dispatchEvent(new UIEvent(UIEvent.READY));
				}
			}
			else
			{
				if (content is BitmapData)
					setBitmapData(content as BitmapData);
			}
		}
		
		private function get maintainAspectRatio():Boolean
		{
			return (_scaleMode == BitmapScaleMode.LETTERBOX && _fillMode == BitmapFillMode.SCALE);
		}
		
		private function removePreviousContent():void
		{
			if (loadedContent && loadedContent.parent)
			{
				displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
				invalidateDisplayObjectSharing();
				loadedContent.parent.removeChild(loadedContent);
				loadedContent = null;
				setDisplayObject(null);
				imageWidth = imageHeight = NaN;
			}
			else if (drawnDisplayObject)
			{
				Sprite(drawnDisplayObject).graphics.clear();
				clearBitmapData();
			}
		}
		
		private function clearLoadingContent():void
		{
			if (loadingContent is LoaderInfo && LoaderInfo(loadingContent).loader)
			{
				try
				{
					LoaderInfo(loadingContent).loader.close();
				}
				catch (e:Error)
				{
					
				}
			}
			
			removeLoadingListeners();
			loadingContent = null;
		}
		/**
		 * 清除BitmapData
		 */		
		private function clearBitmapData():void
		{
			if (_bitmapData)
			{
				
				if (bitmapDataCreated)
					_bitmapData.dispose();
				_bitmapData = null;
			}
		}
		
		private function attachLoadingListeners():void
		{
			if (loadingContent)
			{
				loadingContent.addEventListener(Event.COMPLETE,
					loader_completeHandler, false, 0, true);
				loadingContent.addEventListener(IOErrorEvent.IO_ERROR,
					loader_ioErrorHandler, false, 0, true);
				loadingContent.addEventListener(ProgressEvent.PROGRESS,
					loader_progressHandler, false, 0, true);
				loadingContent.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
					loader_securityErrorHandler, false, 0, true);
				loadingContent.addEventListener(HTTPStatusEvent.HTTP_STATUS,
					dispatchEvent, false, 0, true);
			}
		}
		
		private function removeLoadingListeners():void
		{
			if (loadingContent)
			{
				loadingContent.removeEventListener(Event.COMPLETE,
					loader_completeHandler);
				loadingContent.removeEventListener(IOErrorEvent.IO_ERROR,
					loader_ioErrorHandler);
				loadingContent.removeEventListener(ProgressEvent.PROGRESS,
					loader_progressHandler);
				loadingContent.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
					loader_securityErrorHandler);
				loadingContent.removeEventListener(HTTPStatusEvent.HTTP_STATUS,
					dispatchEvent);
			}
		}
		/**
		 * 应用数据源
		 */		
		dx_internal function validateSource():void
		{
			if (sourceInvalid)
			{
				applySource();
				sourceInvalid = false;
			}
		}
		
		private function loader_completeHandler(event:Event):void
		{
			try
			{
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;
				
				if (loaderInfo.bytesLoaded)
				{
					_bytesLoaded = _bytesTotal;
					contentComplete(loaderInfo);
				}
			}
			catch (error:SecurityError)
			{
				handleSecurityError(error);
			}
			
			dispatchEvent(event);
			clearLoadingContent();
		}

		private function loader_ioErrorHandler(error:IOErrorEvent):void
		{
			if (hasEventListener(error.type))
				dispatchEvent(error);
			setBitmapData(null);
			loadFailed = true;
		}
		
		private function loader_securityErrorHandler(error:SecurityErrorEvent):void
		{
			dispatchEvent(error);
			setBitmapData(null);
			loadFailed = true;
		}
		
		private function loader_progressHandler(progressEvent:ProgressEvent):void
		{
			_bytesLoaded = progressEvent.bytesLoaded;
			_bytesTotal = progressEvent.bytesTotal;
			dispatchEvent(progressEvent);
		}
		
		private function handleSecurityError(error:SecurityError):void
		{
			dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,
				false, false, error.message));
			setBitmapData(null);
			loadFailed = true;
		}
		
		private function source_addedToStageHandler(event:Event):void
		{
			removeAddedToStageHandler(event.target);
			applySource();
		}
		
		private function removeAddedToStageHandler(target:Object):void
		{
			if (target && target is DisplayObject)
				target.removeEventListener(Event.ADDED_TO_STAGE, source_addedToStageHandler);
		}
	}
}
