package org.flexlite.domUI.effects.easing
{
	/**
	 * EaseInOutBase 类是提供缓动功能的基类。<br/>
	 * EaseInOutBase 类将缓动定义为由两个阶段组成：加速，或缓入阶段，接着是减速，或缓出阶段。<br/>
	 * 此类的默认行为会为全部两个缓动阶段返回一个线性插值。
	 * @author DOM
	 */	
	public class EaseInOutBase implements IEaser
	{
		/**
		 * 构造函数
		 * @param easeInFraction 缓入过程所占动画播放时间的百分比。剩余即为缓出的时间。
		 * 默认值为 EasingFraction.IN_OUT，它会缓入前一半时间，并缓出剩余的一半时间。
		 */		
		public function EaseInOutBase(easeInFraction:Number = 0.5)
		{
			this.easeInFraction = easeInFraction;
		}
		
		private var _easeInFraction:Number = .5;
		/**
		 * 缓入过程所占动画播放时间的百分比。剩余即为缓出的时间。
		 * 有效值为 0.0 到 1.0。
		 */		
		public function get easeInFraction():Number
		{
			return _easeInFraction;
		}
		
		public function set easeInFraction(value:Number):void
		{
			_easeInFraction = value;
		}
		
		public function ease(fraction:Number):Number
		{
			var easeOutFraction:Number = 1 - _easeInFraction;
			
			if (fraction <= _easeInFraction && _easeInFraction > 0)
				return _easeInFraction * easeIn(fraction/_easeInFraction);
			else
				return _easeInFraction + easeOutFraction *
					easeOut((fraction - _easeInFraction)/easeOutFraction);
		}
		/**
		 * 在动画的缓入阶段期间计算已经缓动部分要映射到的值。
		 */		
		protected function easeIn(fraction:Number):Number
		{
			return fraction;
		}
		
		/**
		 * 在动画的缓出阶段期间计算已经缓动部分要映射到的值。
		 */		
		protected function easeOut(fraction:Number):Number
		{
			return fraction;
		}
		
	}
}
