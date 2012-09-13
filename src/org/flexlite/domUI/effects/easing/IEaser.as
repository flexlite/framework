package org.flexlite.domUI.effects.easing
{
	/**
	 * 为Animation类提供时间缓动功能的接口
	 * @author DOM
	 */	
	public interface IEaser
	{
		/**
		 * 输入动画播放的当前时刻点，返回转换过后映射的时刻点。
		 * @param fraction 动画播放的当前时刻点，从 0.0 到 1.0。
		 */		
		function ease(fraction:Number):Number;
	}
}
