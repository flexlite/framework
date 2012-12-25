package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	

	[DXML(show="false")]
	
	/**
	 * 选项卡水平布局
	 * @author DOM
	 */	
	public class TabBarHorizontalLayout extends LayoutBase
	{
		/**
		 * 构造函数
		 */		
		public function TabBarHorizontalLayout():void
		{
			super();
		}
		
		private var _gap:int = -1;
		/**
		 * 布局元素之间的水平空间。
		 */		
		public function get gap():int
		{
			return _gap;
		}
		
		public function set gap(value:int):void
		{
			if (_gap == value) 
				return;
			
			_gap = value;
			
			if (target)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			super.measure();
			
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			var elementCount:int = 0;
			var gap:Number = this.gap;
			
			var width:Number = 0;
			var height:Number = 0;
			
			var count:int = layoutTarget.numElements;
			for (var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
				if (!layoutElement)
					continue;
				
				width += layoutElement.preferredWidth;
				elementCount++;
				height = Math.max(height, layoutElement.preferredHeight);
				
			}
			
			if (elementCount > 1)
				width += gap * (elementCount - 1);
			
			layoutTarget.measuredWidth = width;
			layoutTarget.measuredHeight = height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(width:Number, height:Number):void
		{
			var gap:Number = this.gap;
			super.updateDisplayList(width, height);
			
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			var totalPreferredWidth:Number = 0;            
			var count:int = layoutTarget.numElements;
			var elementCount:int = count;
			var layoutElement:ILayoutElement;
			for (var i:int = 0; i < count; i++)
			{
				layoutElement = layoutTarget.getElementAt(i);
				if (!layoutElement)
				{
					elementCount--;
					continue;
				}
				totalPreferredWidth += layoutElement.preferredWidth;
			}
			if (elementCount == 0)
			{
				layoutTarget.setContentSize(0, 0);
				return;
			}
			layoutTarget.setContentSize(width, height);
			if (width == 0)
				gap = 0;
			var excessSpace:Number = width - totalPreferredWidth - gap * (elementCount - 1);
			var widthToDistribute:Number = width - gap * (elementCount - 1);
			var averageWidth:Number;
			var largeChildrenCount:int = elementCount;
			if (excessSpace < 0)
			{
				averageWidth = width / elementCount;
				for (i = 0; i < count; i++)
				{
					layoutElement = layoutTarget.getElementAt(i);
					if (!layoutElement)
						continue;
					
					var preferredWidth:Number = layoutElement.preferredWidth;
					if (preferredWidth <= averageWidth)
					{
						widthToDistribute -= preferredWidth;
						largeChildrenCount--;
						continue;
					}
				}
				widthToDistribute = Math.max(0, widthToDistribute);
			}
			var x:Number = 0;
			var childWidth:Number = NaN;
			var childWidthRounded:Number = NaN;
			var roundOff:Number = 0;
			for (i = 0; i < count; i++)
			{
				layoutElement = layoutTarget.getElementAt(i);
				if (!layoutElement)
					continue;
				
				if (excessSpace > 0)
				{
					childWidth = widthToDistribute * layoutElement.preferredWidth / totalPreferredWidth;
				}
				else if (excessSpace < 0)
				{
					childWidth = (averageWidth < layoutElement.preferredWidth) ? widthToDistribute / largeChildrenCount : NaN;  
				}
				
				if (!isNaN(childWidth))
				{
					
					childWidthRounded = Math.round(childWidth + roundOff);
					roundOff += childWidth - childWidthRounded;
				}
				
				layoutElement.setLayoutBoundsSize(childWidthRounded, height);
				layoutElement.setLayoutBoundsPosition(x, 0);
				x += gap + layoutElement.layoutBoundsWidth; 
				childWidthRounded = NaN;
			}
		}
	}
	
}
