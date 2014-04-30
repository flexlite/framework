package org.flexlite.domDisplay
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.flexlite.domCore.IBitmapAsset;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	/**
	 * DXR形状。
	 * 请根据实际需求选择最佳的IDxrDisplay呈现DxrData。
	 * DxrShape具有位图九宫格缩放功能，但不具有鼠标事件响应。
	 * @author DOM
	 */
	public class DxrShape extends Scale9GridBitmap implements IDxrDisplay,IBitmapAsset
	{
		/**
		 * 构造函数
		 * @param data 被引用的DxrData对象
		 * @param smoothing 在缩放时是否对位图进行平滑处理。
		 */
		public function DxrShape(data:DxrData=null,smoothing:Boolean=true)
		{
			super(null,null,smoothing);
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
				scale9Grid = dxrData._scale9Grid;
				_offsetPoint = dxrData.getFrameOffset(0);
				var sizeOffset:Point = dxrData.getFilterOffset(0);
				if(!sizeOffset)
					sizeOffset = new Point();
				filterWidth = sizeOffset.x;
				filterHeight = sizeOffset.y;
				super.bitmapData = dxrData.getBitmapData(0);
			}
			else
			{
				scale9Grid = null;
				_offsetPoint = null;
				filterWidth = 0;
				filterHeight = 0;
				super.bitmapData = null;
			}
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
	}
}