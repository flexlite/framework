package org.flexlite.domUI.effects.animation
{
	/**
	 * RepeatBehavior类定义用于 Animation类的repeatBehavior属性的常量。
	 * @author DOM
	 */	
	public class RepeatBehavior
	{
		/**
		 * 始终重复正向播放动画
		 */		
		public static const LOOP:String = "loop";
		
		/**
		 * 每个奇数采用正向播放，偶数次采用逆向播放，交替进行。
		 */		
		public static const REVERSE:String = "reverse";
	}
}