package org.flexlite.domUI.layouts
{
	/**
	 * 水平布局策略常量
	 * @author DOM
	 */
	public class HorizontalAlign
	{
		/**
		 * 将子代与容器的左侧对齐。 
		 */		
		public static const LEFT:String = "left";
		/**
		 * 在容器的中心对齐子代。 
		 */		
		public static const CENTER:String = "center";
		/**
		 * 将子代与容器的右侧对齐。 
		 */		
		public static const RIGHT:String = "right";
		
		/**
		 * 相对于容器对齐子代。这会将所有子代的大小统一调整为与容器相同的宽度。
		 */	
		public static const JUSTIFY:String = "justify";
		/**
		 * 相对于容器对子代进行内容对齐。这会将所有子代的大小统一调整为容器的内容宽度contentWidth。
		 * 容器的内容宽度是最大子代的大小。如果所有子代都小于容器的宽度，则会将所有子代的大小调整为容器的宽度。 
		 */		
		public static const CONTENT_JUSTIFY:String = "contentJustify";
	}
}