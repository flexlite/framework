package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.VectorSkin;

	/**
	 * TreeItemRenderer默认皮肤
	 * @author DOM
	 */
	public class TreeItemRendererSkin extends VectorSkin
	{
		/**
		 * 构造函数
		 */		
		public function TreeItemRendererSkin()
		{
			super();
		}
		
		/**
		 * [SkinPart]图标显示对象
		 */
		public var iconDisplay:UIAsset;
		/**
		 * [SkinPart]子节点开启按钮
		 */
		public var disclosureButton:ToggleButton;
		
		public var labelDisplay:Label;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			addElement(labelDisplay);
			
			iconDisplay = new UIAsset();
			iconDisplay.verticalCenter = 0;
			addElement(iconDisplay);
			
			disclosureButton = new ToggleButton();
			disclosureButton.skinName = TreeDisclosureButtonSkin;
			disclosureButton.verticalCenter = 0;
			addElement(disclosureButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,w,h);
			g.endFill();
		}
	}
}