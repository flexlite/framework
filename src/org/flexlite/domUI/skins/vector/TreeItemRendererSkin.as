package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;

	/**
	 * TreeItemRenderer默认皮肤
	 * @author DOM
	 */
	public class TreeItemRendererSkin extends ItemRendererSkin
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
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay.left = NaN;
			labelDisplay.right = NaN;
			
			iconDisplay = new UIAsset();
			iconDisplay.verticalCenter = 0;
			addElement(iconDisplay);
			
			disclosureButton = new ToggleButton();
			disclosureButton.verticalCenter = 0;
			addElement(disclosureButton);
		}
	}
}