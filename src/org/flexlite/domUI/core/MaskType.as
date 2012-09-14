package org.flexlite.domUI.core
{
	/**
	 * MaskType 类为 GraphicElement 类的 maskType 属性定义可能的值。
	 * @author DOM
	 */	
	public final class MaskType
	{
		/**
		 * 遮罩显示或不显示像素。不使用笔触和位图过滤器。 
		 */		
		public static const CLIP:String = "clip";
		/**
		 * 遮罩重视不透明度，并使用遮罩的笔触和位图滤镜。 
		 */		
		public static const ALPHA:String = "alpha";
		/**
		 * 遮罩考虑不透明度和 RGB 颜色值并使用遮罩的笔触和位图过滤器。 
		 */		
		public static const LUMINOSITY:String = "luminosity";
	}
	
}
