package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.SliderBase;
	
	import flash.geom.Point;
	
	
	/**
	 * 水平滑块控件
	 * @author DOM
	 */	
	public class HSlider extends SliderBase
	{
		/**
		 * 构造函数
		 */	
		public function HSlider()
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return HSlider;
		}
		
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if (!thumb || !track)
				return 0;
			
			var range:Number = maximum - minimum;
			var thumbRange:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			return minimum + ((thumbRange != 0) ? (x / thumbRange) * range : 0); 
		}
		
		override protected function updateSkinDisplayList():void
		{
			if (!thumb || !track)
				return;
			
			var thumbRange:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			var range:Number = maximum - minimum;
			var thumbPosTrackX:Number = (range > 0) ? ((pendingValue - minimum) / range) * thumbRange : 0;
			var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX, 0));
			var thumbPosParentX:Number = thumb.parent.globalToLocal(thumbPos).x;
			
			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.layoutBoundsY);
		}
	}
	
}
