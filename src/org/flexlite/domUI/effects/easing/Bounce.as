package org.flexlite.domUI.effects.easing
{
	/**
	 * Bounce 类实现缓动功能，该功能模拟目标对象上的重力牵引和回弹目标对象。效果目标的移动会向着最终值加速，然后对着最终值回弹几次。
	 * @author DOM
	 */	
	public class Bounce implements IEaser
	{
		/**
		 * 构造函数
		 */	
		public function Bounce()
		{
		}
		
		public function ease(fraction:Number):Number
		{
			return easeOut(fraction, 0, 1, 1);
		}
		
		public function easeOut(t:Number, b:Number,
									   c:Number, d:Number):Number
		{
			if ((t /= d) < (1 / 2.75))
				return c * (7.5625 * t * t) + b;
				
			else if (t < (2 / 2.75))
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
				
			else if (t < (2.5 / 2.75))
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
				
			else
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
		}
	}
}