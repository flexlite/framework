package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 垂直滚动条默认皮肤
	 * @author DOM
	 */
	public class VScrollBarSkin extends VectorSkin
	{
		public function VScrollBarSkin()
		{
			super();
			this.minWidth = 15;
			this.minHeight = 50;
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
			track.top = 16;
			track.bottom = 16;
			track.height = 54;
			track.skinName = VScrollBarTrackSkin;
			addElement(track);
			
			decrementButton = new Button();
			decrementButton.top = 0;
			decrementButton.skinName = ScrollBarUpButtonSkin;
			addElement(decrementButton);
			
			incrementButton = new Button();
			incrementButton.bottom = 0;
			incrementButton.skinName = ScrollBarDownButtonSkin;
			addElement(incrementButton);
			
			thumb = new Button();
			thumb.skinName = VScrollBarThumbSkin;
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