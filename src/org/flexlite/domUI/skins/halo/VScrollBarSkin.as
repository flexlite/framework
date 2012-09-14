<<<<<<< HEAD
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	
	/**
	 * 垂直滚动条皮肤
	 * @author DOM
	 */
	public class VScrollBarSkin extends Skin
	{
		public function VScrollBarSkin()
		{
			super();
		}
		
		public var decrementButton:Button;
		
		public var incrementButton:Button;
		
		public var thumb:Button;
		
		public var track:Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			track = new Button;
			track.createLabelIfNeed = false;
			track.skinName = getButtonSkin(trackUpSkin,trackOverSkin,trackDownSkin);
			track.top=16;
			track.bottom=15; 
			track.height=54;
			track.horizontalCenter = 0;
			addElement(track);
			
			thumb = new Button;
			thumb.createLabelIfNeed = false;
			thumb.horizontalCenter = 0;
			thumb.skinName = getButtonSkin(thumbUpSkin,thumbOverSkin,thumbDownSkin);
			addElement(thumb);
			
			decrementButton = new Button;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = getButtonSkin(decrementUpSkin,decrementOverSkin,decrementDownSkin);
			decrementButton.top = 0;
			addElement(decrementButton);
			
			incrementButton = new Button;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = getButtonSkin(incrementUpSkin,incrementOverSkin,incrementDownSkin);
			incrementButton.bottom = 0;
			addElement(incrementButton);
		}
		
		private function getButtonSkin(up:Object,over:Object,down:Object):ButtonSkin
		{
			var skin:ButtonSkin = new ButtonSkin;
			skin.upSkin = up;
			skin.overSkin = over;
			skin.downSkin = down;
			return skin;
		}
		
		public var decrementUpSkin:Object;
		public var decrementOverSkin:Object;
		public var decrementDownSkin:Object;
		
		public var incrementUpSkin:Object;
		public var incrementOverSkin:Object;
		public var incrementDownSkin:Object;
		
		public var thumbUpSkin:Object;
		public var thumbOverSkin:Object;
		public var thumbDownSkin:Object;
		
		public var trackUpSkin:Object;
		public var trackOverSkin:Object;
		public var trackDownSkin:Object;
	}
=======
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	
	/**
	 * 垂直滚动条皮肤
	 * @author DOM
	 */
	public class VScrollBarSkin extends Skin
	{
		public function VScrollBarSkin()
		{
			super();
		}
		
		public var decrementButton:Button;
		
		public var incrementButton:Button;
		
		public var thumb:Button;
		
		public var track:Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			track = new Button;
			track.createLabelIfNeed = false;
			track.skinName = getButtonSkin(trackUpSkin,trackOverSkin,trackDownSkin);
			track.top=16;
			track.bottom=15; 
			track.height=54;
			track.horizontalCenter = 0;
			addElement(track);
			
			thumb = new Button;
			thumb.createLabelIfNeed = false;
			thumb.horizontalCenter = 0;
			thumb.skinName = getButtonSkin(thumbUpSkin,thumbOverSkin,thumbDownSkin);
			addElement(thumb);
			
			decrementButton = new Button;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = getButtonSkin(decrementUpSkin,decrementOverSkin,decrementDownSkin);
			decrementButton.top = 0;
			addElement(decrementButton);
			
			incrementButton = new Button;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = getButtonSkin(incrementUpSkin,incrementOverSkin,incrementDownSkin);
			incrementButton.bottom = 0;
			addElement(incrementButton);
		}
		
		private function getButtonSkin(up:Object,over:Object,down:Object):ButtonSkin
		{
			var skin:ButtonSkin = new ButtonSkin;
			skin.upSkin = up;
			skin.overSkin = over;
			skin.downSkin = down;
			return skin;
		}
		
		public var decrementUpSkin:Object;
		public var decrementOverSkin:Object;
		public var decrementDownSkin:Object;
		
		public var incrementUpSkin:Object;
		public var incrementOverSkin:Object;
		public var incrementDownSkin:Object;
		
		public var thumbUpSkin:Object;
		public var thumbOverSkin:Object;
		public var thumbDownSkin:Object;
		
		public var trackUpSkin:Object;
		public var trackOverSkin:Object;
		public var trackDownSkin:Object;
	}
>>>>>>> master
}