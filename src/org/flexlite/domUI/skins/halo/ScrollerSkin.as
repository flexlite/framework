<<<<<<< HEAD
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.HScrollBar;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	
	/**
	 * 滚动条皮肤
	 * @author DOM
	 */
	public class ScrollerSkin extends Skin
	{
		public function ScrollerSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			horizontalScrollBar = new HScrollBar;
			horizontalScrollBar.visible = false;
			horizontalScrollBar.skinName = hScrollBarSkin;
			horizontalScrollBar.fixedThumbSize = true;
			addElement(horizontalScrollBar);
			
			verticalScrollBar = new VScrollBar;
			verticalScrollBar.visible = false;
			verticalScrollBar.skinName = vScrollBarSkin;
			verticalScrollBar.fixedThumbSize = true;
			addElement(verticalScrollBar);
		}
		
		public var horizontalScrollBar:HScrollBar;
		
		public var verticalScrollBar:VScrollBar;
		
		public var hScrollBarSkin:Object;
		
		public var vScrollBarSkin:Object;
		
	}
=======
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.HScrollBar;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	
	/**
	 * 滚动条皮肤
	 * @author DOM
	 */
	public class ScrollerSkin extends Skin
	{
		public function ScrollerSkin()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			horizontalScrollBar = new HScrollBar;
			horizontalScrollBar.visible = false;
			horizontalScrollBar.skinName = hScrollBarSkin;
			horizontalScrollBar.fixedThumbSize = true;
			addElement(horizontalScrollBar);
			
			verticalScrollBar = new VScrollBar;
			verticalScrollBar.visible = false;
			verticalScrollBar.skinName = vScrollBarSkin;
			verticalScrollBar.fixedThumbSize = true;
			addElement(verticalScrollBar);
		}
		
		public var horizontalScrollBar:HScrollBar;
		
		public var verticalScrollBar:VScrollBar;
		
		public var hScrollBarSkin:Object;
		
		public var vScrollBarSkin:Object;
		
	}
>>>>>>> master
}