package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 垂直滑块track默认皮肤
	 * @author DOM
	 */
	public class VSliderTrackSkin extends VectorSkin
	{
		public function VSliderTrackSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 4;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetX:Number = Math.round(w*0.5-2);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			w=4;
			graphics.lineStyle();
			drawRoundRect(
				offsetX,0, w, h, 1,
				0xdddbdb, 1,
				verticalGradientMatrix(offsetX,0,w,h)); 
			if(h>4)
				drawLine(offsetX,1,offsetX,h-1,0xbcbcbc);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}