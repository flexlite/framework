package org.flexlite.domUI.primitives.graphic
{
	public final class BitmapScaleMode
	{
		/**
		 * 拉伸位图以填充区域。
		 */		
		public static const STRETCH:String = "stretch";
		
		/**
		 * 在保持原始高宽比的情况下拉伸位图
		 */		
		public static const LETTERBOX:String = "letterbox";
		
		/**
		 * 缩放和裁剪位图，以使原始内容的高宽比保持不变并且不显示空白或突出的边界。
		 */		
		public static const ZOOM:String = "zoom";
	}
}
