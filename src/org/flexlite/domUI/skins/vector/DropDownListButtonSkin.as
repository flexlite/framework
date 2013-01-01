package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * DropDownList下拉按钮默认皮肤
	 * @author DOM
	 */
	public class DropDownListButtonSkin extends VectorSkin
	{
		public function DropDownListButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.minHeight = 25;
			this.minWidth = 22;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			var arrowColor:uint;
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawCurrentState(0,0,w,h,borderColors[0],bottomLineColors[0],
						[fillColors[0],fillColors[1]],cornerRadius);
					if(w>21&&h>2)
					{
						drawLine(w-21,1,w-21,h-1,0xe4e4e4);
						drawLine(w-20,1,w-20,h-1,0xf9f9f9);
					}
					arrowColor = themeColors[0];
					break;
				case "over":
					drawCurrentState(0,0,w,h,borderColors[1],bottomLineColors[1],
						[fillColors[2],fillColors[3]],cornerRadius);
					if(w>21&&h>2)
					{
						drawLine(w-21,1,w-21,h-1,0x3c74ab);
						drawLine(w-20,1,w-20,h-1,0x6a9fd3);
					}
					arrowColor = themeColors[1];
					break;
				case "down":
					drawCurrentState(0,0,w,h,borderColors[2],bottomLineColors[2],
						[fillColors[4],fillColors[5]],cornerRadius);
					if(w>21&&h>2)
					{
						drawLine(w-21,1,w-21,h-1,0x787878);
						drawLine(w-20,1,w-20,h-1,0xa4a4a4);
					}
					arrowColor = themeColors[1];
					break;
			}
			if(w>21)
			{
				g.lineStyle(0,0,0);
				g.beginFill(arrowColor);
				g.moveTo(w-10, h*0.5 + 3);
				g.lineTo(w-13.5, h*0.5 - 2);
				g.lineTo(w-6.5, h*0.5 - 2);
				g.lineTo(w-10, h*0.5 + 3);
				g.endFill();
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}