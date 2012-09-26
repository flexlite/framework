package org.flexlite.domUI.skins.vector
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 按钮默认皮肤
	 * @author DOM
	 */
	public class TitleWindowCloseButtonSkin extends VectorSkin
	{
		public function TitleWindowCloseButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.minHeight = 16;
			this.minWidth = 16;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,w,h);
			g.endFill();
			var offsetX:Number = Math.round(w*0.5-8);
			var offsetY:Number = Math.round(h*0.5-8);
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawCloseIcon(0xcccccc,offsetX,offsetY);
					break;
				case "over":
					drawCloseIcon(0x555555,offsetX,offsetY);
					break;
				case "down":
					drawCloseIcon(0xcccccc,offsetX,offsetY+1);
					break;
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
		/**
		 * 绘制关闭图标
		 */		
		private function drawCloseIcon(color:uint,offsetX:Number,offsetY:Number):void
		{
			var g:Graphics = graphics;
			g.lineStyle(2,color,1,false,"normal",CapsStyle.SQUARE);
			g.moveTo(offsetX+6,offsetY+6);
			g.lineTo(offsetX+10,offsetY+10);
			g.endFill();
			g.moveTo(offsetX+10,offsetY+6);
			g.lineTo(offsetX+6,offsetY+10);
			g.endFill();
			g.lineStyle();
			g.beginFill(color);
			g.drawEllipse(offsetX+0,offsetY+0,16,16);
			g.drawEllipse(offsetX+2,offsetY+2,12,12);
			g.endFill();
		}
	}
}