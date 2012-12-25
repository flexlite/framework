package org.flexlite.domUI.effects.easing
{
	/**
	 * 
	 * @author DOM
	 */	
	public final class EasingFraction
	{
		/**
		 * 指定easing实例花费整个动画进行缓入。这等效于将 easeInFraction 属性设置为 1.0。
		 */		
		public static const IN:Number = 1;
		
		/**
		 * 指定 easing 实例花费整个动画进行缓出。这等效于将 easeInFraction 属性设置为 0.0。 
		 */		
		public static const OUT:Number = 0;
		
		/**
		 * 指定 easing 实例缓入前半部分并缓出剩余的一半。这等效于将 easeInFraction 属性设置为 0.5。
		 */		
		public static const IN_OUT:Number = 0.5;
	}
}