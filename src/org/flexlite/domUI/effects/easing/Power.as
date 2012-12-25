package org.flexlite.domUI.effects.easing
{
	/**
	 * Power 类通过使用多项式表达式定义缓动功能。<br/>
	 * 缓动包括两个阶段：加速，或缓入阶段，接着是减速，或缓出阶段。<br/>
	 * 加速和减速的速率基于 exponent 属性。exponent 属性的值越大，加速和减速的速率越快。<br/>
	 * 使用 easeInFraction 属性指定动画加速的百分比。
	 * @author DOM
	 */	
	public class Power extends EaseInOutBase
	{
		
		private var _exponent:Number;
		/**
		 * 在缓动计算中使用的指数。exponent 属性的值越大，加速和减速的速率越快。
		 */		
		public function get exponent():Number
		{
			return _exponent;
		}
		
		public function set exponent(value:Number):void
		{
			_exponent = value;
		}
		
		/**
		 * 构造函数
		 * @param easeInFraction 在加速阶段中整个持续时间的部分，在 0.0 和 1.0 之间。
		 * @param exponent 在缓动计算中使用的指数。exponent 属性的值越大，加速和减速的速率越快。
		 * 
		 */		
		public function Power(easeInFraction:Number = 0.5, exponent:Number = 2)
		{
			super(easeInFraction);
			this.exponent = exponent;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function easeIn(fraction:Number):Number
		{
			return Math.pow(fraction, _exponent);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function easeOut(fraction:Number):Number
		{
			return 1 - Math.pow((1 - fraction), _exponent);
		}
	}
}
