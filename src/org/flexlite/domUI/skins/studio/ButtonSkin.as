package org.flexlite.domUI.skins.studio
{
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.supportClasses.Skin;
	import org.flexlite.domCore.IMovieClip;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	/**
	 * 具有三个状态的按钮皮肤基类。此类在FlexLiteStudio中使用。
	 * @author DOM
	 */
	public class ButtonSkin extends Skin
	{
		public function ButtonSkin()
		{
			super();
			states = ["up","over","down"];
			this.currentState = "up";
		}
		
		override protected function commitCurrentState():void
		{
			if(hasOwnProperty("upSkin"))
				this["upSkin"]["visible"] = false;
			if(hasOwnProperty("overSkin"))
				this["overSkin"]["visible"] = false;
			if(hasOwnProperty("downSkin"))
				this["downSkin"]["visible"] = false;
			
			var currentSkin:Object;
			switch(_currentState)
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
				if(currentSkin is UIAsset&&currentSkin["skin"] is IMovieClip)
				{
					(currentSkin["skin"] as IMovieClip).repeatPlay = false;
					(currentSkin["skin"] as IMovieClip).gotoAndPlay(0);
				}
				else if(currentSkin is IMovieClip)
				{
					(currentSkin as IMovieClip).repeatPlay = false;
					(currentSkin as IMovieClip).gotoAndPlay(0);
				}
			}
		}
		
		
	}
}