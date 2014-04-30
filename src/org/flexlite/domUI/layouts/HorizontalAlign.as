package org.flexlite.domUI.layouts
{
	/**
	 * 水平布局策略常量
	 * @author DOM
	 */
	public class HorizontalAlign
	{
		/**
		 * 将子项与容器的左侧对齐。 
		 */		
		public static const LEFT:String = "left";
		/**
		 * 在容器的中心对齐子项。 
		 */		
		public static const CENTER:String = "center";
		/**
		 * 将子项与容器的右侧对齐。 
		 */		
		public static const RIGHT:String = "right";
		
		/**
		 * 相对于容器对齐子项。这将会以容器宽度为标准，调整所有子项的宽度，使其始终填满容器。
		 */	
		public static const JUSTIFY:String = "justify";
		/**
		 * 相对于容器对子项进行内容对齐。这会将所有子项的大小统一调整为容器的内容宽度contentWidth。
		 * 容器的内容宽度是最大子项的大小。如果所有子项都小于容器的宽度，则会将所有子项的大小调整为容器的宽度。 
		 */		
		public static const CONTENT_JUSTIFY:String = "contentJustify";
	}
}