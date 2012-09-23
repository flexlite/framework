package org.flexlite.domUI.skins.studio
{
	import org.flexlite.domUI.core.IMovieClip;

	[DXML(show="false")]
	/**
	 * 有选中状态的皮肤基类。此类在FlexLiteStudio中使用。
	 * @author chenglong
	 */
	public class ToggleButtonSkin extends ButtonSkin
	{
		public function ToggleButtonSkin()
		{
			super();
			states = ["up","over","down","upAndSelected","overAndSelected","downAndSelected"];
		}
		
		override protected function commitCurrentState():void
		{
			if(hasOwnProperty("upSkin"))
				this["upSkin"]["visible"] = false;
			if(hasOwnProperty("overSkin"))
				this["overSkin"]["visible"] = false;
			if(hasOwnProperty("downSkin"))
				this["downSkin"]["visible"] = false;
			if(hasOwnProperty("selectedSkin"))
				this["selectedSkin"]["visible"] = false;
			var currentSkin:Object;
			switch(currentState)
			{
				case "up":
					if(hasOwnProperty("upSkin"))
						currentSkin = this["upSkin"];
					break;
				case "over":
					if(hasOwnProperty("overSkin"))
						currentSkin = this["overSkin"];
					else if(hasOwnProperty("upSkin"))
						currentSkin = this["upSkin"];
					break;
				case "down":
				case "upAndSelected":
				case "overAndSelected":
				case "downAndSelected":
					if(hasOwnProperty("downSkin"))
						currentSkin = this["downSkin"];
					else if(hasOwnProperty("upSkin"))
						currentSkin = this["upSkin"];
					break;
				default:
					if(hasOwnProperty("upSkin"))
						currentSkin = this["upSkin"];
					break;
			}
			if(currentSkin)
			{
				currentSkin["visible"] = true;
				if(currentSkin is IMovieClip)
				{
					(currentSkin as IMovieClip).repeatPlay = false;
					(currentSkin as IMovieClip).gotoAndPlay(0);
				}
			}
		}
	}
}