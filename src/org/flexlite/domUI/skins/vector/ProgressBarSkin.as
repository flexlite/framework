package org.flexlite.domUI.skins.vector
{

	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.VectorSkin;
	
	
	/**
	 * 进度条默认皮肤
	 * @author DOM
	 */
	public class ProgressBarSkin extends VectorSkin
	{
		public function ProgressBarSkin()
		{
			super();
			this.minHeight = 24;
			this.minWidth = 30;
		}
		
		public var thumb:UIAsset;
		public var track:UIAsset;
		public var labelDisplay:Label;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			track = new UIAsset();
			track.skinName = ProgressBarTrackSkin;
			track.left = 0;
			track.right = 0;
			addElement(track);
			
			thumb = new UIAsset();
			thumb.skinName = ProgressBarThumbSkin;
			addElement(thumb);
			
			labelDisplay = new Label();
			labelDisplay.y = 14;
			labelDisplay.horizontalCenter = 0;
			addElement(labelDisplay);
		}
	}
}