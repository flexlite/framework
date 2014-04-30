package org.flexlite.domUI.layouts
{
	import flash.geom.Rectangle;
	
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	[DXML(show="false")]
	
	/**
	 * 基本布局
	 * @author DOM
	 */
	public class BasicLayout extends LayoutBase
	{
		public function BasicLayout()
		{
			super();
		}
		
		/**
		 * 此布局不支持虚拟布局，设置这个属性无效
		 */		
		override public function set useVirtualLayout(value:Boolean):void
		{
		}
		
		private var _mouseWheelSpeed:uint = 20;
		/**
		 * 鼠标滚轮每次滚动时目标容器的verticalScrollPosition
		 * 或horizontalScrollPosition改变的像素距离。必须大于0， 默认值20。
		 */
		public function get mouseWheelSpeed():uint
		{
			return _mouseWheelSpeed;
		}
		public function set mouseWheelSpeed(value:uint):void
		{
			if(value==0)
				value = 1;
			_mouseWheelSpeed = value;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.left - _mouseWheelSpeed;
			bounds.right = scrollRect.left; 
			return bounds;
		} 
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.right;
			bounds.right = scrollRect.right + _mouseWheelSpeed;
			return bounds;
		} 
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.top - _mouseWheelSpeed;
			bounds.bottom = scrollRect.top;
			return bounds;
		} 
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.bottom;
			bounds.bottom = scrollRect.bottom + _mouseWheelSpeed;
			return bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			super.measure();

			if (target==null)
				return;
			
			var width:Number = 0;
			var height:Number = 0;
			
			var count:int = target.numElements;
			for (var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (!layoutElement||!layoutElement.includeInLayout)
					continue;
				
				var hCenter:Number   = layoutElement.horizontalCenter;
				var vCenter:Number   = layoutElement.verticalCenter;
				var left:Number      = layoutElement.left;
				var right:Number     = layoutElement.right;
				var top:Number       = layoutElement.top;
				var bottom:Number    = layoutElement.bottom;
				
				var extX:Number;
				var extY:Number;
				
				if (!isNaN(left) && !isNaN(right))
				{
					extX = left + right;                
				}
				else if (!isNaN(hCenter))
				{
					extX = Math.abs(hCenter) * 2;
				}
				else if (!isNaN(left) || !isNaN(right))
				{
					extX = isNaN(left) ? 0 : left;
					extX += isNaN(right) ? 0 : right;
				}
				else
				{
					extX = layoutElement.preferredX;
				}
				
				if (!isNaN(top) && !isNaN(bottom))
				{
					extY = top + bottom;                
				}
				else if (!isNaN(vCenter))
				{
					extY = Math.abs(vCenter) * 2;
				}
				else if (!isNaN(top) || !isNaN(bottom))
				{
					extY = isNaN(top) ? 0 : top;
					extY += isNaN(bottom) ? 0 : bottom;
				}
				else
				{
					extY = layoutElement.preferredY;
				}
				
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				
				width = Math.ceil(Math.max(width, extX + preferredWidth));
				height = Math.ceil(Math.max(height, extY + preferredHeight));
			}
			
			target.measuredWidth = width;
			target.measuredHeight = height;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (target==null)
				return;
			
			var count:int = target.numElements;
			
			var maxX:Number = 0;
			var maxY:Number = 0;
			for (var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement==null||!layoutElement.includeInLayout)
					continue;
				
				var hCenter:Number          = layoutElement.horizontalCenter;
				var vCenter:Number          = layoutElement.verticalCenter;
				var left:Number             = layoutElement.left;
				var right:Number            = layoutElement.right;
				var top:Number              = layoutElement.top;
				var bottom:Number           = layoutElement.bottom;
				var percentWidth:Number     = layoutElement.percentWidth;
				var percentHeight:Number    = layoutElement.percentHeight;
				
				var childWidth:Number = NaN;
				var childHeight:Number = NaN;
				
				
				if(!isNaN(left) && !isNaN(right))
				{
					childWidth = unscaledWidth - right - left;
				}
				else if (!isNaN(percentWidth))
				{
					childWidth = Math.round(unscaledWidth * Math.min(percentWidth * 0.01, 1));
				}
				
				if (!isNaN(top) && !isNaN(bottom))
				{
					childHeight = unscaledHeight - bottom - top;
				}
				else if (!isNaN(percentHeight))
				{
					childHeight = Math.round(unscaledHeight * Math.min(percentHeight * 0.01, 1));
				}
				
				layoutElement.setLayoutBoundsSize(childWidth, childHeight);
				
				var elementWidth:Number = layoutElement.layoutBoundsWidth;
				var elementHeight:Number = layoutElement.layoutBoundsHeight;
				
				
				var childX:Number = NaN;
				var childY:Number = NaN;
				
				if (!isNaN(hCenter))
					childX = Math.round((unscaledWidth - elementWidth) / 2 + hCenter);
				else if (!isNaN(left))
					childX = left;
				else if (!isNaN(right))
					childX = unscaledWidth - elementWidth - right;
				else
					childX = layoutElement.layoutBoundsX;
				
				if (!isNaN(vCenter))
					childY = Math.round((unscaledHeight - elementHeight) / 2 + vCenter);
				else if (!isNaN(top))
					childY = top;
				else if (!isNaN(bottom))
					childY = unscaledHeight - elementHeight - bottom;
				else
					childY = layoutElement.layoutBoundsY;
				
				layoutElement.setLayoutBoundsPosition(childX, childY);
				
				maxX = Math.max(maxX,childX+elementWidth);
				maxY = Math.max(maxY,childY+elementHeight);
			}
			target.setContentSize(maxX,maxY);
		}
	}
}