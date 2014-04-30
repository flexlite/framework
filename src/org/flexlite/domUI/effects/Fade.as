package org.flexlite.domUI.effects
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.supportClasses.Effect;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 淡入淡出特效，此动画作用于对象的alpha属性。
	 * @author DOM
	 */
	public class Fade extends Effect
	{
		/**
		 * 构造函数
		 * @param target 要应用此动画特效的对象
		 */	
		public function Fade(target:Object=null)
		{
			super(target);
		}
		/**
		 * alpha起始值。若不设置，则使用目标对象的当前alpha值。
		 */		
		public var alphaFrom:Number = NaN;
		/**
		 * alpha结束值。若不设置，则使用目标对象的当前alpha值。
		 */		
		public var alphaTo:Number = NaN;
		
		/**
		 * @inheritDoc
		 */		
		override public function reset():void
		{
			super.reset();
			alphaFrom = alphaTo = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createMotionPath():Vector.<MotionPath>
		{
			var alphaFromSet:Boolean = !isNaN(alphaFrom);
			var alphaToSet:Boolean = !isNaN(alphaTo);
			
			var index:int = 0;
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>;
			var alphaStart:Number = alphaFrom;
			var alphaEnd:Number = alphaTo;
			for each(var target:Object in _targets)
			{
				if(!alphaFromSet)
					alphaStart = target["alpha"];
				if(!alphaToSet)
					alphaEnd = target["alpha"];
				motionPaths.push(new MotionPath("alpha"+index,alphaStart,alphaEnd));
				index++;
			}
			return motionPaths;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function animationUpdateHandler(animation:Animation):void
		{
			var index:int = 0;
			for each(var target:Object in _targets)
			{
				target["alpha"] = animation.currentValue["alpha"+index];
				index++;
			}
		}
	}
}