package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 水平滚动条默认皮肤
	 * @author DOM
	 */
	public class HScrollBarSkin extends VectorSkin
	{
		public function HScrollBarSkin()
		{
			super();
			this.minWidth = 50;
			this.minHeight = 15;
		}
		
		public var decrementButton:Button;
		
		public var incrementButton:Button;
		
		public var thumb:Button;
		
		public var track:Button;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new Button();
			track.left = 16;
			track.right = 16;
			track.width = 54;
			track.skinName = HScrollBarTrackSkin;
			addElement(track);
			
			decrementButton = new Button();
			decrementButton.left = 0;
			decrementButton.skinName = ScrollBarLeftButtonSkin;
			addElement(decrementButton);
			
			incrementButton = new Button();
			incrementButton.right = 0;
			incrementButton.skinName = ScrollBarRightButtonSkin;
			addElement(incrementButton);
			
			thumb = new Button();
			thumb.skinName = HScrollBarThumbSkin;
			addElement(thumb);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			this.alpha = currentState=="disabled"?0.5:1;
		}
		
	}
}