package org.flexlite.domUI.effects.supportClasses
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.utils.LayoutUtil;
	
	use namespace dx_internal;
	
	/**
	 * 能够造成目标对象位置发生改变的动画特效基类。
	 * 此动画在播放期间忽略对象的所有相对位置属性，
	 * 并在结束时调整它们，以保证当前位置不会被布局改变。
	 * @author DOM
	 */
	public class MovableEffect extends Effect
	{
		public function MovableEffect(target:Object=null)
		{
			super(target);
		}
		
		/**
		 * 记录的旧的布局属性值列表
		 */		
		private var includeInLayoutList:Vector.<Boolean>;
		/**
		 * @inheritDoc
		 */
		override protected function animationStartHandler(animation:Animation):void
		{
			includeInLayoutList = new Vector.<Boolean>();
			for each(var target:* in _targets)
			{
				var includeInLayout:Boolean = false;
				if(target is IVisualElement)
				{
					includeInLayout = (target as IVisualElement).includeInLayout;
					(target as IVisualElement).includeInLayout = false;
				}
				includeInLayoutList.push(includeInLayout);
			}
			super.animationStartHandler(animation);
		}
		/**
		 * @inheritDoc
		 */
		override protected function animationEndHandler(animation:Animation):void
		{
			var element:IVisualElement;
			var index:int = 0;
			for each(var target:Object in _targets)
			{
				element = target as IVisualElement;
				if(element)
				{
					LayoutUtil.adjustRelativeByXY(element);
					element.includeInLayout = includeInLayoutList[index];
				}
				index++;
			}
			super.animationEndHandler(animation);
		}
	}
}