package org.flexlite.domUI.effects
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.supportClasses.Effect;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 移动特效
	 * @author DOM
	 */
	public class Move extends Effect
	{
		/**
		 * 构造函数
		 * @param target 要应用此动画特效的对象
		 */
		public function Move(target:Object=null)
		{
			super(target);
		}
		/**
		 * 要在y轴移动的距离，可以为负值。 
		 */		
		public var yBy:Number = NaN;
		/**
		 * 开始移动时y轴的起始坐标。若不设置，则使用目标对象的当前y坐标或根据其他值计算出此值。
		 */		
		public var yFrom:Number = NaN;
		/**
		 * 移动结束时y轴要到的坐标。若不设置，则使用目标对象的当前y坐标或根据其他值计算出此值。
		 */		
		public var yTo:Number = NaN;
		/**
		 * 要在x轴移动的距离，可以为负值。 
		 */		
		public var xBy:Number = NaN;
		/**
		 * 开始移动时x轴的起始坐标。若不设置，则使用目标对象的当前x坐标或根据其他值计算出此值。
		 */
		public var xFrom:Number = NaN;
		/**
		 * 移动结束时x轴要到的坐标。若不设置，则使用目标对象的当前x坐标或根据其他值计算出此值。
		 */	
		public var xTo:Number = NaN;
		/**
		 * @inheritDoc
		 */		
		override public function reset():void
		{
			super.reset();
			yBy = yFrom = yTo = xBy = xFrom = xTo = NaN;
		}
		/**
		 * @inheritDoc
		 */
		override protected function createMotionPath():Vector.<MotionPath>
		{
			var xFromSet:Boolean = !isNaN(xFrom);
			var xToSet:Boolean = !isNaN(xTo);
			var yFromSet:Boolean = !isNaN(yFrom);
			var yToSet:Boolean = !isNaN(yTo);
			
			var xFromUseTarget:Boolean = !xFromSet&&(isNaN(xTo)||isNaN(xBy));
			var xToUseTarget:Boolean = !xToSet&&isNaN(xBy);
			var yFromUseTarget:Boolean = !yFromSet&&(isNaN(yTo)||isNaN(yBy));
			var yToUseTarget:Boolean = !yToSet&&isNaN(yBy);
			
			var xStart:Number = xFromSet?xFrom:xTo - xBy;
			var yStart:Number = yFromSet?yFrom:yTo - yBy;
			var xEnd:Number;
			var yEnd:Number;
			var index:int = 0;
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>;
			for each(var target:Object in _targets)
			{
				if(xFromUseTarget)
					xStart = target["x"];
				if(xToUseTarget)
					xEnd = target["x"];
				else if(xToSet)
					xEnd = xTo;
				else
					xEnd = xStart+xBy;
				motionPaths.push(new MotionPath("x"+index,xStart,xEnd));
				
				if(yFromUseTarget)
					yStart = target["y"];
				if(yToUseTarget)
					yEnd = target["y"];
				else if(yToSet)
					yEnd = yTo;
				else
					yEnd = yStart+yBy;
				motionPaths.push(new MotionPath("y"+index,yStart,yEnd));
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
				target["x"] = Math.round(animation.currentValue["x"+index]);
				target["y"] = Math.round(animation.currentValue["y"+index]);
				index++;
			}
		}
	}
}