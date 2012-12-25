package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.RectangularDropShadow;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * PageNavigator默认皮肤
	 * @author DOM
	 */
	public class PageNavigatorSkin extends VectorSkin
	{
		public function PageNavigatorSkin()
		{
			super();
			this.minWidth = 150;
			this.minHeight = 30;
		}
		
		/**
		 * [SkinPart]上一页按钮
		 */	
		public var prevPageButton:Button;
		/**
		 * [SkinPart]下一页按钮
		 */	
		public var nextPageButton:Button;
		
		/**
		 * [SkinPart]第一页按钮
		 */	
		public var firstPageButton:Button;
		/**
		 * [SkinPart]最后一页按钮
		 */	
		public var lastPageButton:Button;
		/**
		 * [SkinPart]页码文本显示对象
		 */		
		public var labelDisplay:Label;
		/**
		 * [SkinPart]装载目标viewport的容器
		 */		
		public var contentGroup:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var dropShadow:RectangularDropShadow = new RectangularDropShadow();
			dropShadow.tlRadius=dropShadow.tlRadius=dropShadow.trRadius=dropShadow.blRadius=dropShadow.brRadius = cornerRadius;
			dropShadow.blurX = 10;
			dropShadow.blurY = 10;
			dropShadow.alpha = 0.45;
			dropShadow.distance = 3;
			dropShadow.angle = 90;
			dropShadow.color = 0x000000;
			dropShadow.left = 0;
			dropShadow.top = 0;
			dropShadow.right = 0;
			dropShadow.bottom = 0;
			addElement(dropShadow);
			
			contentGroup = new Group;
			contentGroup.left = 1;
			contentGroup.right = 1;
			contentGroup.top = 1;
			contentGroup.bottom = 30;
			addElement(contentGroup);
			
			firstPageButton = new Button;
			firstPageButton.label = "<<";
			firstPageButton.x = 2;
			firstPageButton.bottom = 2;
			addElement(firstPageButton);
			
			prevPageButton = new Button;
			prevPageButton.label = "<";
			prevPageButton.x = 31;
			prevPageButton.bottom = 2;
			addElement(prevPageButton);
			
			nextPageButton = new Button;
			nextPageButton.label = ">";
			nextPageButton.right = 31;
			nextPageButton.bottom = 2;
			addElement(nextPageButton);
			
			lastPageButton = new Button;
			lastPageButton.label = ">>";
			lastPageButton.right = 2;
			lastPageButton.bottom = 2;
			addElement(lastPageButton);
			
			labelDisplay = new Label();
			labelDisplay.horizontalCenter = 0;
			labelDisplay.bottom = 4;
			addElement(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			var g:Graphics = graphics;
			g.clear();
			drawRoundRect(
				0, 0, w, h, cornerRadius,
				borderColors[0], 1,
				verticalGradientMatrix(0, 0, w, h ),
				GradientType.LINEAR, null, 
				{ x: 1, y: 1, w: w - 2, h: h - 2, r: cornerRadius-1}); 
			drawRoundRect(
				1, 1, w - 2, h-2, cornerRadius-1,
				0xFFFFFF, 1,
				horizontalGradientMatrix(1, 1, w - 2, h-2));
			drawRoundRect(
				1, h-29, w - 2, 28, {tl:0,tr:0,bl:cornerRadius-1,br:cornerRadius-1},
				0xf8f8f8, 1,
				horizontalGradientMatrix(1, h-29, w - 2, 28)); 
			drawLine(1,h-29,w-1,h-29,borderColors[0]);
		}
	}
}