package org.flexlite.domUI.effects
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.supportClasses.Effect;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 缩放特效,此动画作用于对象的scaleX,scaleY以及x,y属性。
	 * @author DOM
	 */
	public class Scale extends Effect
	{
		/**
		 * 构造函数
		 * @param target 要应用此动画特效的对象
		 */		
		public function Scale(target:Object=null)
		{
			super(target);
		}
		
		/**
		 * 缩放中心点x坐标(相对于scaleX为1时的位置)。若不设置，默认为target.width/2。 
		 */		
		public var originX:Number;
		/**
		 * 缩放中心点y坐标(相对于scaleY为1时的位置),若不设置，默认为target.height/2。
		 */		
		public var originY:Number;
		
		/**
		 *  y方向上起始的scale值。若不设置，则使用目标对象的当前scaleY或根据其他值计算出此值。
		 */		
		public var scaleYFrom:Number;
		/**
		 * y方向上结束的scale值。若不设置，则使用目标对象的当前scaleY或根据其他值计算出此值。
		 */		
		public var scaleYTo:Number;
		/**
		 * 在y方向上要缩放的量，负值代表缩小。
		 */		
		public var scaleYBy:Number;
		/**
		 *  x方向上起始的scale值。若不设置，则使用目标对象的当前scaleX或根据其他值计算出此值。
		 */	
		public var scaleXFrom:Number;
		/**
		 * x方向上结束的scale值。若不设置，则使用目标对象的当前scaleX或根据其他值计算出此值。
		 */
		public var scaleXTo:Number;
		/**
		 * 在x方向上要缩放的量，负值代表缩小。
		 */	
		public var scaleXBy:Number;
		/**
		 * @inheritDoc
		 */		
		override public function reset():void
		{
			super.reset();
			originX = originY = scaleYFrom = scaleYTo = scaleYBy = scaleXFrom = scaleXTo = scaleXBy = NaN;
		}
		/**
		 * @inheritDoc
		 */
		override protected function createMotionPath():Vector.<MotionPath>
		{
			var motionPath:Vector.<MotionPath> = new Vector.<MotionPath>();
			var scaleXFromSet:Boolean = !isNaN(scaleXFrom);
			var scaleXToSet:Boolean = !isNaN(scaleXTo);
			var scaleYFromSet:Boolean = !isNaN(scaleYFrom);
			var scaleYToSet:Boolean = !isNaN(scaleYTo);
			var originXSet:Boolean = !isNaN(originX);
			var originYSet:Boolean = !isNaN(originY);
			
			var scaleXFromUseTarget:Boolean = !scaleXFromSet&&(isNaN(scaleXTo)||isNaN(scaleXBy));
			var scaleXToUseTarget:Boolean = !scaleXToSet&&isNaN(scaleXBy);
			var scaleYFromUseTarget:Boolean = !scaleYFromSet&&(isNaN(scaleYTo)||isNaN(scaleYBy));
			var scaleYToUseTarget:Boolean = !scaleYToSet&&isNaN(scaleYBy);
			
			var scaleXStart:Number = scaleXFromSet?scaleXFrom:scaleXTo - scaleXBy;
			var scaleYStart:Number = scaleYFromSet?scaleYFrom:scaleYTo - scaleYBy;
			var scaleXEnd:Number;
			var scaleYEnd:Number;
			var orgX:Number;
			var orgY:Number;
			var index:int = 0;
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>;
			for each(var target:Object in _targets)
			{
				if(scaleXFromUseTarget)
					scaleXStart = target["scaleX"];
				if(scaleXToUseTarget)
					scaleXEnd = target["scaleX"];
				else if(scaleXToSet)
					scaleXEnd = scaleXTo;
				else
					scaleXEnd = scaleXStart+scaleXBy;
				motionPaths.push(new MotionPath("scaleX"+index,scaleXStart,scaleXEnd));
				
				if(scaleYFromUseTarget)
					scaleYStart = target["scaleY"];
				if(scaleYToUseTarget)
					scaleYEnd = target["scaleY"];
				else if(scaleYToSet)
					scaleYEnd = scaleYTo;
				else
					scaleYEnd = scaleYStart+scaleYBy;
				motionPaths.push(new MotionPath("scaleY"+index,scaleYStart,scaleYEnd));
				
				if(originXSet)
					orgX = originX;
				else
					orgX = target["width"]*0.5;
				var targetX:Number = target["x"]+(target["scaleX"]-1)*orgX;
				var xStart:Number = targetX+(1-scaleXStart)*orgX;
				var xEnd:Number = targetX+(1-scaleXEnd)*orgX;
				motionPaths.push(new MotionPath("x"+index,xStart,xEnd));
				
				if(originYSet)
					orgY = originY;
				else
					orgY = target["height"]*0.5;
				var targetY:Number = target["y"]+(target["scaleY"]-1)*orgY;
				var yStart:Number = targetY+(1-scaleYStart)*orgY;
				var yEnd:Number = targetY+(1-scaleYEnd)*orgY;
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
				target["scaleX"] = animation.currentValue["scaleX"+index];
				target["scaleY"] = animation.currentValue["scaleY"+index];
				index++;
			}
		}
	}
}