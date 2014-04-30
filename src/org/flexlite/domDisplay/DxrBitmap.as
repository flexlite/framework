package org.flexlite.domDisplay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.flexlite.domCore.IBitmapAsset;
	import org.flexlite.domCore.dx_internal;
	
	/**
	 * DXR位图显示对象。
	 * 请根据实际需求选择最佳的IDxrDisplay呈现DxrData。
	 * DxrBitmap为最轻量级的IDxrDisplay。不具有位图九宫格缩放和鼠标事件响应功能。
	 * 注意：DxrBitmap需要在外部手动添加起始坐标偏移量。
	 * @author DOM
	 */
	public class DxrBitmap extends Bitmap implements IBitmapAsset,IDxrDisplay
	{
		/**
		 * 构造函数,注意：DxrBitmap需要在外部手动添加起始坐标偏移量。
		 * @param data 被引用的DxrData对象
		 */		
		public function DxrBitmap(data:DxrData=null)
		{
			super();
			if(data)
				dxrData = data;
		}
		
		private var _dxrData:DxrData;
		/**
		 * 被引用的DxrData对象
		 */
		public function get dxrData():DxrData
		{
			return _dxrData;
		}
		
		public function set dxrData(value:DxrData):void
		{
			if(value==_dxrData)
				return;
			_dxrData = value;
			if(value)
			{
				var sizeOffset:Point = dxrData.getFilterOffset(0);
				if(!sizeOffset)
					sizeOffset = new Point();
				filterWidth = sizeOffset.x;
				filterHeight = sizeOffset.y;
				super.bitmapData = dxrData.getBitmapData(0);
				smoothing = true;
				if(widthExplicitSet)
					super.width = _width==0?0:_width+filterWidth;
				else
					_width = super.bitmapData.width-filterWidth;
				if(heightExplicitSet)
					super.height = _height==0?0:_height+filterHeight;
				else
					_height = super.bitmapData.height-filterHeight;
			}
			else
			{
				filterWidth = 0;
				filterHeight = 0;
				if(!widthExplicitSet)
					_width = NaN;
				if(!heightExplicitSet)
					_height = NaN;
				super.bitmapData = null;
			}
		}
		/**
		 * 滤镜宽度
		 */		
		private var filterWidth:Number = 0;
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
			if(dxrData)
			{
				if(_width==0)
					super.width = 0;
				else
					super.width = escapeNaN(_width) + filterWidth;
			}
		}
		
		/**
		 * 素材的默认宽度（以像素为单位）。
		 */		
		public function get measuredWidth():Number
		{
			if(bitmapData)
				return bitmapData.width-filterWidth;
			return 0;
		}
		/**
		 * 素材的默认高度（以像素为单位）。
		 */
		public function get measuredHeight():Number
		{
			if(bitmapData)
				return bitmapData.height-filterHeight;
			return 0;
		}
		
		/**
		 * 滤镜高度
		 */		
		private var filterHeight:Number = 0;
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
			if(dxrData)
			{
				if(_height==0)
					super.height = 0;
				else
					super.height = escapeNaN(_height)+filterHeight;
			}
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
		/**
		 * 被引用的BitmapData对象。注意:此属性被改为只读，对其赋值无效。
		 * IDxrDisplay只能通过设置dxrData属性来显示位图数据。
		 */		
		override public function get bitmapData():BitmapData
		{
			return super.bitmapData;
		}
		override public function set bitmapData(value:BitmapData):void
		{
		}
	}
}