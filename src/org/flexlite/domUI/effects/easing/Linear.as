package org.flexlite.domUI.effects.easing
{
	/**
	 * Linear 类使用三个阶段定义缓动：加速、匀速运动和减速。<br/>
	 * 在动画开始时，它会在由 easeInFraction 属性指定的时期内加速，它接着在下一个阶段中使用匀速（线性）运动，<br/>
	 * 最后在由 easeOutFraction 属性指定的时期内减速，直到结束。 <br/>
	 * 会计算这三个阶段的缓动值，以使恒定加速、线性运动和恒定减速的行为全部发生在动画的指定持续时间内。<br/>
	 * 通过将 easeInFraction 和 easeOutFraction 设置为 0.0 可以实现严格的线性运动。
	 * @author DOM
	 */	
	public class Linear implements IEaser
	{
		/**
		 * 构造函数
		 * @param easeInFraction 在加速阶段中持续时间占总时间的百分比，在 0.0 和 1.0 之间。
		 * @param easeOutFraction 在减速阶段中持续时间占总时间的百分比，在 0.0 和 1.0 之间。
		 */		
		public function Linear(easeInFraction:Number = 0, easeOutFraction:Number = 0)
		{
			this.easeInFraction = easeInFraction;
			this.easeOutFraction = easeOutFraction;
		}
		
		private var _easeInFraction:Number = 0;
		/**
		 * 在加速阶段中持续时间占总时间的百分比，在 0.0 和 1.0 之间。
		 */		
		public function get easeInFraction():Number
		{
			return _easeInFraction;
		}
		
		public function set easeInFraction(value:Number):void
		{
			_easeInFraction = value;
		}
		
		private var _easeOutFraction:Number = 0;
		/**
		 * 在减速阶段中持续时间占总时间的百分比，在 0.0 和 1.0 之间。
		 */		
		public function get easeOutFraction():Number
		{
			return _easeOutFraction;
		}
		
		public function set easeOutFraction(value:Number):void
		{
			_easeOutFraction = value;
		}
		
		public function ease(fraction:Number):Number
		{
			
			if (easeInFraction == 0 && easeOutFraction == 0)
				return fraction;
			
			var runRate:Number = 1 / (1 - easeInFraction/2 - easeOutFraction/2);
			if (fraction < easeInFraction)
				return fraction * runRate * (fraction / easeInFraction) / 2;
			if (fraction > (1 - easeOutFraction))
			{
				var decTime:Number = fraction - (1 - easeOutFraction);
				var decProportion:Number = decTime / easeOutFraction;
				return runRate * (1 - easeInFraction/2 - easeOutFraction +
					decTime * (2 - decProportion) / 2);
			}
			return runRate * (fraction - easeInFraction/2);
		}
	}
}
