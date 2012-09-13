package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.SkinnableElement;
	import org.flexlite.domUI.components.supportClasses.Skin;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	[DXML(show="false")]
	
	/**
	 * TitleWindow皮肤
	 * @author DOM
	 */
	public class TitleWindowSkin extends Skin
	{
		public function TitleWindowSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new Group;
			contentGroup.top = 30;
			contentGroup.bottom = 0;
			contentGroup.left = 0;
			contentGroup.right = 0;
			addElement(contentGroup);
			
			closeButton = new Button;
			var buttonSkin:ButtonSkin = new ButtonSkin;
			buttonSkin.upSkin = closeButtonUpSkin;
			buttonSkin.overSkin = closeButtonOverSkin;
			buttonSkin.downSkin = closeButtonDownSkin;
			closeButton.skinName = buttonSkin;
			closeButton.right = 0;
			closeButton.top = 0;
			addElement(closeButton);
			
			titleDisplay = new Label;
			titleDisplay.bold = true;
			titleDisplay.minHeight = 30;
			titleDisplay.verticalAlign = VerticalAlign.MIDDLE;
			titleDisplay.left = 5;
			titleDisplay.right = 40;
			addElement(titleDisplay);
			
			if(borderSkin)
			{
				var border:SkinnableElement = new SkinnableElement;
				border.left = border.right = border.top = border.bottom = 0;
				border.skinName = borderSkin;
				addElement(border);
			}
		}
		
		public var closeButton:Button;
		
		public var contentGroup:Group;
		
		public var moveArea:Group;
		
		public var titleDisplay:Label;
		
		public var closeButtonUpSkin:Object;
		public var closeButtonOverSkin:Object;
		public var closeButtonDownSkin:Object;
		/**
		 * 背景皮肤
		 */		
		public var borderSkin:Object;
	}
}