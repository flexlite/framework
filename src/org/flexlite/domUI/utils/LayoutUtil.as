package org.flexlite.domUI.utils
{
	import flash.display.DisplayObjectContainer;
	
	import org.flexlite.domUI.core.IVisualElement;

	/**
	 * 布局工具类
	 * @author DOM
	 */
	public class LayoutUtil
	{
		/**
		 * 根据对象当前的xy坐标调整其相对位置属性，使其在下一次的父级布局中过程中保持当前位置不变。
		 * @param element 要调整相对位置属性的对象
		 * @param parent element的父级容器。若不设置，则取element.parent的值。若两者的值都为空，则放弃调整。
		 */		
		public static function adjustRelativeByXY(element:IVisualElement,parent:DisplayObjectContainer=null):void
		{
			if(!element)
				return;
			if(!parent)
				parent = element.parent;
			if(!parent)
				return;
			var x:Number = element.x;
			var y:Number = element.y;
			var h:Number = element.layoutBoundsHeight;
			var w:Number = element.layoutBoundsWidth;
			var parentW:Number = parent.width;
			var parentH:Number = parent.height;
			if(!isNaN(element.left))
			{
				element.left = x;
			}
			if(!isNaN(element.right))
			{
				element.right = parentW - x - w;
			}
			if(!isNaN(element.horizontalCenter))
			{
				element.horizontalCenter = x + w*0.5 - parentW*0.5;
			}
			
			if(!isNaN(element.top))
			{
				element.top = y;
			}
			if(!isNaN(element.bottom))
			{
				element.bottom = parentH - y - h;
			}
			if(!isNaN(element.verticalCenter))
			{
				element.verticalCenter = h*0.5-parentH*0.5+y;
			}
		}
	}
}