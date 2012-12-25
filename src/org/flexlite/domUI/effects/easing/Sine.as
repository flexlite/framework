package  org.flexlite.domUI.effects.easing
{
	/**
	 * Sine 类使用 Sine 函数定义缓动功能。<br/>
	 * 缓动包括两个阶段：加速，或缓入阶段，接着是减速，或缓出阶段。使用 easeInFraction 属性指定动画加速的百分比。
	 * @author DOM
	 */	
	public class Sine extends EaseInOutBase
	{
		/**
		 * 构造函数
		 * @param easeInFraction 缓入过程所占动画播放时间的百分比。剩余即为缓出的时间。
		 */		
		public function Sine(easeInFraction:Number = 0.5)
		{
			super(easeInFraction);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function easeIn(fraction:Number):Number
		{
			return 1 - Math.cos(fraction * Math.PI/2);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function easeOut(fraction:Number):Number
		{
			return Math.sin(fraction * Math.PI/2);
		}
	}
}
