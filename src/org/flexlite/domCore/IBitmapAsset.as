package org.flexlite.domCore
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
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
	}
}