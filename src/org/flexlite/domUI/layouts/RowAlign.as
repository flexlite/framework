package org.flexlite.domUI.layouts
{
	/**
	 * RowAlign 类为 TileLayout 类的 rowAlign 属性定义可能的值。
	 * @author DOM
	 */
	public class RowAlign
	{
		/**
		 * 不进行两端对齐。
		 */
		public static const TOP:String = "top";
		/**
		 * 通过增大垂直间隙将行两端对齐。 
		 */		
		public static const JUSTIFY_USING_GAP:String = "justifyUsingGap";
		
		/**
		 * 通过增大行高度将行两端对齐。
		 */
		public static const JUSTIFY_USING_HEIGHT:String = "justifyUsingHeight";
	}
}