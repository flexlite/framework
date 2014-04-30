package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.PopUpAnchor;
	import org.flexlite.domUI.components.RectangularDropShadow;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.core.PopUpPosition;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * ComboBox默认皮肤
	 * @author DOM
	 */
	public class ComboBoxSkin extends VectorSkin
	{
		public function ComboBoxSkin()
		{
			super();
			this.states = ["normal","open","disabled"];
		}
		
		public var dataGroup:DataGroup;
		
		public var dropDown:Group;
		
		public var openButton:Button;
		
		public var popUp:PopUpAnchor;
		
		public var scroller:Scroller;
		
		public var textInput:TextInput;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();

			openButton = new Button();
			openButton.width = 20;
			openButton.right = 0;
			openButton.top = 0;
			openButton.bottom = 0;
			openButton.skinName = ComboBoxButtonSkin;
			addElement(openButton);

			textInput = new TextInput();
			textInput.skinName = ComboBoxTextInputSkin;
			textInput.left = 0;
			textInput.right = 19;
			textInput.top = 0;
			textInput.bottom = 0;
			addElement(textInput);
		}
		
		private var backgroud:UIComponent;
		/**
		 * dropDown尺寸发生改变
		 */		
		private function onResize(event:ResizeEvent=null):void
		{
			var w:Number = isNaN(dropDown.width)?0:dropDown.width;
			var h:Number = isNaN(dropDown.height)?0:dropDown.height;
			var g:Graphics = backgroud.graphics;
			g.clear();
			var crr1:Number = cornerRadius>0?cornerRadius-1:0;
			drawRoundRect(
				0, 0, w, h, cornerRadius,
				borderColors[0], 1,
				verticalGradientMatrix(0,0, w, h ),
				GradientType.LINEAR, null, 
				{ x: 1, y: 1, w: w - 2, h: h - 2, r: crr1},g); 
			//绘制填充
			drawRoundRect(
				1, 1, w - 2, h - 2, crr1,
				0xFFFFFF, 1,
				verticalGradientMatrix(1, 1, w - 2, h - 2),"linear",null,null,g); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			switch(currentState)
			{
				case "open":
					if(!popUp)
					{
						createPopUp();
					}
					popUp.displayPopUp = true;
					break;
				case "normal":
					if(popUp)
						popUp.displayPopUp = false;
					break;
				case "disabled":
					
					break;
			}
		}
		/**
		 * 创建popUp
		 */		
		private function createPopUp():void
		{
			//dataGroup
			dataGroup = new DataGroup();
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			//scroller
			scroller = new Scroller();
			scroller.left = 2;
			scroller.top = 2;
			scroller.right = 2;
			scroller.bottom = 2;
			scroller.minViewportInset = 1;
			scroller.viewport = dataGroup;
			//dropShadow
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
			//dropDown
			dropDown = new Group();
			dropDown.addEventListener(ResizeEvent.RESIZE,onResize);
			dropDown.addElement(dropShadow);
			backgroud = new UIComponent;
			dropDown.addElement(backgroud);
			dropDown.addElement(scroller);
			onResize();
			//popUp
			popUp = new PopUpAnchor();
			popUp.left = 0;
			popUp.right = 0;
			popUp.top = 0;
			popUp.bottom = 0;
			popUp.popUpPosition = PopUpPosition.BELOW;
			popUp.popUpWidthMatchesAnchorWidth = true;
			popUp.popUp = dropDown;
			addElement(popUp);
			if(hostComponent)
				hostComponent.findSkinParts();
		}
		
	}
}