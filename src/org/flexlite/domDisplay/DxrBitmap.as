package org.flexlite.domDisplay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.core.IBitmapAsset;
	
	use namespace dx_internal;
	
	/**
	 * DXR位图显示对象。
	 * 请根据实际需求选择最佳的IDxrDisplayObject呈现DxrData。
	 * DxrBitmap为最轻量级的IDxrDisplayObject。不具有位图九宫格缩放和鼠标事件响应功能。
	 * 注意：DxrBitmap需要在外部手动添加起始坐标偏移量。
	 * @author DOM
	 */
	public class DxrBitmap extends Bitmap implements IBitmapAsset
	{
		/**
		 * 构造函数
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
				bitmapData = dxrData.frameList[0];
			}
			else
			{
				bitmapData = null;
			}
		}
		
		private static var zeroPoint:Point = new Point;
		
		public function get offsetPoint():Point
		{
			return _dxrData?_dxrData.frameOffsetList[0]:zeroPoint;
		}
	}
}