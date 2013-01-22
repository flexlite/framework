package org.flexlite.domUI.skins.studio
{
	import org.flexlite.domUI.components.PopUpAnchor;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	/**
	 * 弹出框皮肤基类。此类在FlexLiteStudio中使用。
	 * @author DOM
	 */
	public class PopUpSkin extends Skin
	{
		public function PopUpSkin()
		{
			super();
			this.states = ["open","normal","disabled"];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			var popUp:* = hasOwnProperty("popUp")?this["popUp"]:null;
			if(popUp&&popUp is PopUpAnchor)
			{
				if(!(popUp as PopUpAnchor).parent)
					addElement((popUp as PopUpAnchor));
				(popUp as PopUpAnchor).displayPopUp = (currentState=="open");
			}
		}
	}
}