package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 水平滑块默认皮肤
	 * @author DOM
	 */
	public class HSliderSkin extends VectorSkin
	{
		public function HSliderSkin()
		{
			super();
			this.minWidth = 50;
			this.minHeight = 11;
		}
		
		public var thumb:Button;
		
		public var track:Button;
		
		public var trackHighlight:UIAsset;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new Button;
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			track.minWidth = 33;
			track.width = 100;
			track.tabEnabled = false;
			track.skinName = HSliderTrackSkin;
			addElement(track);
			
			trackHighlight = new UIAsset;
			trackHighlight.top = 0;
			trackHighlight.bottom = 0;
			trackHighlight.minWidth = 33;
			trackHighlight.width = 100;
			trackHighlight.tabEnabled = false;
			trackHighlight.skinName = HSliderTrackHighlightSkin;
			addElement(trackHighlight);
			
			thumb = new Button();
			thumb.top = 0;
			thumb.bottom = 0;
			thumb.width = 11;
			thumb.height = 11;
			thumb.tabEnabled = false;
			thumb.skinName = SliderThumbSkin;
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