package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.RectangularDropShadow;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * Panel默认皮肤
	 * @author DOM
	 */
	public class PanelSkin extends VectorSkin
	{
		public function PanelSkin()
		{
			super();
			this.minHeight = 60;
			this.minWidth = 80;
		}
		
		public var titleDisplay:Label;
		
		public var contentGroup:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var dropShadow:RectangularDropShadow = new RectangularDropShadow();
			dropShadow.tlRadius=dropShadow.tlRadius=dropShadow.trRadius=dropShadow.blRadius=dropShadow.brRadius = cornerRadius;
			dropShadow.blurX = 20;
			dropShadow.blurY = 20;
			dropShadow.alpha = 0.45;
			dropShadow.distance = 7;
			dropShadow.angle = 90;
			dropShadow.color = 0x000000;
			dropShadow.left = 0;
			dropShadow.top = 0;
			dropShadow.right = 0;
			dropShadow.bottom = 0;
			addElement(dropShadow);
			
			contentGroup = new Group();
			contentGroup.top = 30;
			contentGroup.left = 1;
			contentGroup.right = 1;
			contentGroup.bottom = 1;
			contentGroup.clipAndEnableScrolling = true;
			addElement(contentGroup);
			
			titleDisplay = new Label();
			titleDisplay.maxDisplayedLines = 1;
			titleDisplay.left = 5;
			titleDisplay.right = 5;
			titleDisplay.top = 1;
			titleDisplay.minHeight = 28;
			titleDisplay.verticalAlign = VerticalAlign.MIDDLE;
			titleDisplay.textAlign = TextFormatAlign.CENTER;
			addElement(titleDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			var g:Graphics = graphics;
			g.lineStyle(1,borderColors[0]);
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0,0,w,h,cornerRadius+2,cornerRadius+2);
			g.endFill();
			g.lineStyle();
			drawRoundRect(
				1, 1, w-1, 28,{tl:cornerRadius-1,tr:cornerRadius-1,bl:0,br:0},
				[0xf6f8f8,0xe9eeee], 1,
				verticalGradientMatrix(1, 1, w - 1, 28)); 
			drawLine(1,29,w,29,0xdddddd);
			drawLine(1,30,w,30,0xeeeeee);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}