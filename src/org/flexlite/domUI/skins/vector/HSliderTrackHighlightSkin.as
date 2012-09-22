package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 水平滑块track默认皮肤
	 * @author DOM
	 */
	public class HSliderTrackHighlightSkin extends VectorSkin
	{
		public function HSliderTrackHighlightSkin()
		{
			super();
			this.minHeight = 4;
			this.minWidth = 15;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetY:Number = Math.round(h*0.5-2);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			h=4;
			graphics.lineStyle();
			drawRoundRect(
				0, offsetY, w, h, 1,
				fillColors[2], 1,
				verticalGradientMatrix(0, offsetY, w, h)); 
			if(w>5)
				drawLine(1,offsetY,w-1,offsetY,0x457cb2);
		}
	}
}