package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.ILayoutElement;

	/**
	 * 皮肤简单布局类。当SkinnableComponent的皮肤不是ISkinPartHost对象时启用。以提供子项的简单布局。
	 * @author DOM
	 */
	public class SkinBasicLayout
	{
		public function SkinBasicLayout()
		{
			super();
		}
		
		private var _target:SkinnableComponent;

		/**
		 * 目标布局对象
		 */		
		public function get target():SkinnableComponent
		{
			return _target;
		}

		public function set target(value:SkinnableComponent):void
		{
			_target = value;
		}

		
		/**
		 * 测量组件尺寸大小
		 */		
		public function measure():void
		{
			if (target==null)
				return;
			
			var measureW:Number = 0;
			var measureH:Number = 0;
			
			var count:int = target.numChildren;
			for(var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getChildAt(i) as ILayoutElement;
				if (!layoutElement||layoutElement==target.skin||!layoutElement.includeInLayout)
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
				
				measureW = Math.ceil(Math.max(measureW, extX + preferredWidth));
				measureH = Math.ceil(Math.max(measureH, extY + preferredHeight));
			}
			
			target.measuredWidth = Math.max(measureW,target.measuredWidth);
			target.measuredHeight = Math.max(measureH,target.measuredHeight);
		}
		
		/**
		 * 更新显示列表
		 */	
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (target==null)
				return;
			
			var count:int = target.numChildren;
			
			for(var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getChildAt(i) as ILayoutElement;
				if (layoutElement==null||layoutElement==target.skin||!layoutElement.includeInLayout)
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
			}
		}
		
	}
}