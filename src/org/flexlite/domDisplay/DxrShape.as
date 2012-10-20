package org.flexlite.domDisplay
{
	import flash.geom.Point;
	
	import org.flexlite.domCore.IBitmapAsset;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	/**
	 * DXR形状。
	 * 请根据实际需求选择最佳的IBitmapAsset呈现DxrData。
	 * DxrShape具有位图九宫格缩放功能，但不具有鼠标事件响应。
	 * @author DOM
	 */
	public class DxrShape extends Scale9GridBitmap implements IBitmapAsset
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
				_offsetPoint = dxrData.frameOffsetList[0];
				bitmapData = dxrData.frameList[0];
			}
			else
			{
				scale9Grid = null;
				_offsetPoint = null;
				bitmapData = null;
			}
		}
		
		private static var zeroPoint:Point = new Point;
		/**
		 * 当前的位图素材起始偏移量
		 */
		public function get offsetPoint():Point
		{
			return _dxrData?_dxrData.frameOffsetList[0]:zeroPoint;
		}
	}
}