package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 垂直滚动条track默认皮肤
	 * @author DOM
	 */
	public class VScrollBarTrackSkin extends VectorSkin
	{
		public function VScrollBarTrackSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			//绘制边框
			drawRoundRect(
				0, 0, w, h, 0,
				borderColors[0], 1,
				horizontalGradientMatrix(0, 0, w, h ),
				GradientType.LINEAR, null, 
				{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0}); 
			//绘制填充
			drawRoundRect(
				1, 1, w - 2, h - 2, 0,
				0xdddbdb, 1,
				horizontalGradientMatrix(1, 2, w - 2, h - 3)); 
			//绘制底线
			drawLine(1,1,1,h-1,0xbcbcbc);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}