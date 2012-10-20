package org.flexlite.domUI.effects
{
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;

	use namespace dx_internal;
	/**
	 * 缩放特效
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
		 * 缩放中心点x坐标。若并不设置，默认为target.width/2。 
		 */		
		public var originX:Number;
		/**
		 * 缩放中心点y坐标,若不设置，默认为target.height/2。
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
				var result:Array = checkCanScale(target);
				if(result[1])
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
				}
				
				if(result[3])
				{
					if(scaleYFromUseTarget)
						scaleYStart = target["scaleY"];
					if(scaleXToUseTarget)
						scaleYEnd = target["scaleY"];
					else if(scaleYToSet)
						scaleYEnd = scaleYTo;
					else
						scaleYEnd = scaleYStart+scaleYBy;
					motionPaths.push(new MotionPath("scaleY"+index,scaleYStart,scaleYEnd));
				}
				
				if(result[0])
				{
					if(originXSet)
						orgX = originX;
					else
						orgX = target["width"]*0.5;
					if(orgX!=0&&!isNaN(orgX))
					{
						var targetX:Number = target["x"]+(target["scaleX"]-1)*orgX;
						var xStart:Number = targetX+(1-scaleXStart)*orgX;
						var xEnd:Number = targetX+(1-scaleXEnd)*orgX;
						motionPaths.push(new MotionPath("x"+index,xStart,xEnd));
					}
				}
				
				if(result[3])
				{
					if(originYSet)
						orgY = originY;
					else
						orgY = target["height"]*0.5;
					if(orgY!=0&&!isNaN(orgY))
					{
						var targetY:Number = target["y"]+(target["scaleY"]-1)*orgY;
						var yStart:Number = targetY+(1-scaleYStart)*orgY;
						var yEnd:Number = targetY+(1-scaleYEnd)*orgY;
						motionPaths.push(new MotionPath("y"+index,yStart,yEnd));
					}
				}
				index++;
			}
			return motionPaths;
		}
		/**
		 * 检查对象是否可以缩放,返回一个数组:[x是否可以移动，x是否可以缩放，y是否可以移动，y是否可以缩放]
		 */		
		private function checkCanScale(target:Object):Array
		{
			var result:Array = [true,true,true,true];
			
			if(target is ILayoutElement)
			{
				var element:ILayoutElement = target as ILayoutElement;
				result[0] = (isNaN(element.left)&&isNaN(element.right));
				result[1] = (isNaN(element.left)||isNaN(element.right));
				result[2] = (isNaN(element.top)&&isNaN(element.bottom));
				result[3] = (isNaN(element.top)||isNaN(element.bottom));
			}
			if(!result[0]&&!result[2])
				return result;
			if(target.hasOwnProperty("parent")&&target["parent"]&&
				target["parent"].hasOwnProperty("layout"))
			{
				var layout:Object = target["parent"]["layout"];
				if(layout is HorizontalLayout||layout is VerticalLayout)
				{
					result[0] = false;
					result[2] = false;
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function animationUpdateHandler(animation:Animation):void
		{
			var index:int = 0;
			for each(var target:Object in _targets)
			{
				var x:Number = animation.currentValue["x"+index];
				if(!isNaN(x))
					target["x"] = x;
				var y:Number = animation.currentValue["y"+index];
				if(!isNaN(y))
					target["y"] = y;
				var scaleX:Number = animation.currentValue["scaleX"+index];
				if(!isNaN(scaleX))
					target["scaleX"] = scaleX;
				var scaleY:Number = animation.currentValue["scaleY"+index];
				if(!isNaN(scaleY))
					target["scaleY"] = scaleY;
				index++;
			}
		}
	}
}