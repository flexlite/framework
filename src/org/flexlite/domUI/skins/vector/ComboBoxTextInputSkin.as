package org.flexlite.domUI.skins.vector
{

	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Label;
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
			this.states = ["normal","disabled","normalWithPrompt","disabledWithPrompt"];
		}
		
		public var textDisplay:EditableText;
		/**
		 * [SkinPart]当text属性为空字符串时要显示的文本。
		 */		
		public var promptDisplay:Label;
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
			textDisplay.verticalCenter = 0;
			addElement(textDisplay);
		}
		
		override protected function commitCurrentState():void
		{
			this.alpha = currentState=="disabled"||
				currentState=="disabledWithPrompt"?0.5:1;
			if(currentState=="disabledWithPrompt"||currentState=="normalWithPrompt")
			{
				if(!promptDisplay)
				{
					createPromptDisplay();
				}
				if(!contains(promptDisplay))
					addElement(promptDisplay);
			}
			else if(promptDisplay&&contains(promptDisplay))
			{
				removeElement(promptDisplay);
			}
		}
		
		private function createPromptDisplay():void
		{
			promptDisplay = new Label();
			promptDisplay.maxDisplayedLines = 1;
			promptDisplay.verticalCenter = 0;
			promptDisplay.x = 1;
			promptDisplay.textColor = 0xa9a9a9;
			promptDisplay.mouseChildren = false;
			promptDisplay.mouseEnabled = false;
			if(hostComponent)
				hostComponent.findSkinParts();
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
		}
	}
}