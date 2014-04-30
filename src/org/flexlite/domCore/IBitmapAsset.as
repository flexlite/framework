package org.flexlite.domCore
{
	import flash.display.BitmapData;

	
	/**
	 * 位图素材显示对象接口
	 * @author DOM
	 */
	public interface IBitmapAsset
	{
		/**
		 * 当前显示的BitmapData对象
		 */		
		function get bitmapData():BitmapData;
		/**
		 * 素材的默认宽度（以像素为单位）。
		 */		
		function get measuredWidth():Number;
		/**
		 * 素材的默认高度（以像素为单位）。
		 */
		function get measuredHeight():Number;
	}
}