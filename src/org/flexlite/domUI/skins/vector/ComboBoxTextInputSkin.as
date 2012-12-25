package org.flexlite.domUI.skins.vector
{

	
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * ComboBox的textInput部件默认皮肤
	 * @author DOM
	 */
	public class ComboBoxTextInputSkin extends VectorSkin
	{
		public function ComboBoxTextInputSkin()
		{
			super();
			this.states = ["normal","disabled"];
		}
		
		public var textDisplay:EditableText;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.heightInLines = 1;
			textDisplay.multiline = false;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.verticalCenter = 1;
			addElement(textDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			var radius:Object = {tl:cornerRadius,tr:0,bl:cornerRadius,br:0};
			drawCurrentState(0,0,w,h,borderColors[0],bottomLineColors[0],
				0xFFFFFF,radius);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}