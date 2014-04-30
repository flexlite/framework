package org.flexlite.domUI.effects
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.effects.supportClasses.Effect;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 尺寸调整特效。此动画作用于对象的width，height以及x，y属性。
	 * @author DOM
	 */
	public class Resize extends Effect
	{
		/**
		 * 构造函数
		 * @param target 要应用此动画特效的对象
		 */		
		public function Resize(target:Object=null)
		{
			super(target);
		}
		
		/**
		 * 缩放中心点x坐标。默认值为0 
		 */		
		public var originX:Number = 0;
		/**
		 * 缩放中心点y坐标。默认值为0 
		 */		
		public var originY:Number = 0;
		
		/**
		 * height起始值。若不设置，则使用目标对象的当前height或根据其他值计算出此值。
		 */		
		public var heightFrom:Number;
		/**
		 * height结束值。若不设置，则使用目标对象的当前height或根据其他值计算出此值。
		 */		
		public var heightTo:Number;
		/**
		 * height要增加的量，负值代表减小。
		 */		
		public var heightBy:Number;
		/**
		 *  width起始值。若不设置，则使用目标对象的当前width或根据其他值计算出此值。
		 */	
		public var widthFrom:Number;
		/**
		 * width结束值。若不设置，则使用目标对象的当前width或根据其他值计算出此值。
		 */
		public var widthTo:Number;
		/**
		 * width要增加的量，负值代表减小。
		 */	
		public var widthBy:Number;
		/**
		 * @inheritDoc
		 */		
		override public function reset():void
		{
			super.reset();
			originX = originY = 0;
			heightFrom = heightTo = heightBy = widthFrom = widthTo = widthBy = NaN;
		}
		/**
		 * @inheritDoc
		 */
		override protected function createMotionPath():Vector.<MotionPath>
		{
			var motionPath:Vector.<MotionPath> = new Vector.<MotionPath>();
			var widthFromSet:Boolean = !isNaN(widthFrom);
			var widthToSet:Boolean = !isNaN(widthTo);
			var heightFromSet:Boolean = !isNaN(heightFrom);
			var heightToSet:Boolean = !isNaN(heightTo);
			
			var widthFromUseTarget:Boolean = !widthFromSet&&(isNaN(widthTo)||isNaN(widthBy));
			var widthToUseTarget:Boolean = !widthToSet&&isNaN(widthBy);
			var heightFromUseTarget:Boolean = !heightFromSet&&(isNaN(heightTo)||isNaN(heightBy));
			var heightToUseTarget:Boolean = !heightToSet&&isNaN(heightBy);
			
			var widthStart:Number = widthFromSet?widthFrom:widthTo - widthBy;
			var heightStart:Number = heightFromSet?heightFrom:heightTo - heightBy;
			var widthEnd:Number;
			var heightEnd:Number;
			var index:int = 0;
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>;
			for each(var target:Object in _targets)
			{
				if(widthFromUseTarget)
					widthStart = target["width"];
				if(widthToUseTarget)
					widthEnd = target["width"];
				else if(widthToSet)
					widthEnd = widthTo;
				else
					widthEnd = widthStart+widthBy;
				motionPaths.push(new MotionPath("width"+index,widthStart,widthEnd));
				
				if(heightFromUseTarget)
					heightStart = target["height"];
				if(heightToUseTarget)
					heightEnd = target["height"];
				else if(heightToSet)
					heightEnd = heightTo;
				else
					heightEnd = heightStart+heightBy;
				motionPaths.push(new MotionPath("height"+index,heightStart,heightEnd));
				
				var xStart:Number = target["x"]+(target["width"]-widthStart)*originX/target["width"];;
				var xEnd:Number = target["x"]+(widthEnd-target["width"])*originX/target["width"];
				motionPaths.push(new MotionPath("x"+index,xStart,xEnd));
				
				var yStart:Number = target["y"]+(target["height"]-heightStart)*originY/target["height"];
				var yEnd:Number = target["y"]+(heightEnd-target["height"])*originY/target["height"];
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
				var element:IUIComponent = target as IUIComponent;
				target["width"] = Math.ceil(animation.currentValue["width"+index]);
				target["height"] = Math.ceil(animation.currentValue["height"+index]);
				index++;
			}
		}
	}
}