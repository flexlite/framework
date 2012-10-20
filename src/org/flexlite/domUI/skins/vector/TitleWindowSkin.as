package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	/**
	 * TitleWindow默认皮肤
	 * @author DOM
	 */
	public class TitleWindowSkin extends PanelSkin
	{
		public function TitleWindowSkin()
		{
			super();
		}
		
		public var closeButton:Button;
		
		public var moveArea:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			moveArea = new Group();
			moveArea.left = 0;
			moveArea.right = 0;
			moveArea.top = 0;
			moveArea.height = 30;
			addElement(moveArea);
			
			closeButton = new Button();
			closeButton.skinName = TitleWindowCloseButtonSkin;
			closeButton.right = 7;
			closeButton.top = 7;
			addElement(closeButton);
		}
	}
}