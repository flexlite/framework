package org.flexlite.domUI.effects.easing
{
	/**
	 * Elastic 类实现缓动功能，此时目标对象移动是由一个指数衰减正弦波定义的。
	 * 效果目标向着最终值减速，然后继续通过最终值。接着它围绕最终值在越来越小的增量内振荡，最后达到最终值。
	 * @author DOM
	 */	
	public class Elastic implements IEaser
	{
		public function Elastic()
		{
		}
		
		public function ease(fraction:Number):Number
		{
			return easeOut(fraction, 0, 1, 1);
		}
		
		public function easeOut(t:Number, b:Number,
									   c:Number, d:Number,
									   a:Number = 0, p:Number = 0):Number
		{
			if (t == 0)
				return b;
			
			if ((t /= d) == 1)
				return b + c;
			
			if (!p)
				p = d * 0.3;
			
			var s:Number;
			if (!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			
			return a * Math.pow(2, -10 * t) *
				Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
		}

	}
}