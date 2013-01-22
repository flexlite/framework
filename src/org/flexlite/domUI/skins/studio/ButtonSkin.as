package org.flexlite.domUI.skins.studio
{
	import org.flexlite.domCore.IMovieClip;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
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
			hasDisabledState = hasOwnProperty("disabledSkin");
			if(hasDisabledState)
				states = ["up","over","down","disabled"];
			else
				states = ["up","over","down"];
			this.currentState = "up";
		}
		
		protected var hasDisabledState:Boolean;

		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			var upSkin:* = hasOwnProperty("upSkin")?this["upSkin"]:null;
			var overSkin:* = hasOwnProperty("overSkin")?this["overSkin"]:null;
			var downSkin:* = hasOwnProperty("downSkin")?this["downSkin"]:null;
			var disabledSkin:* = hasOwnProperty("disabledSkin")?this["disabledSkin"]:null;
			if(upSkin)
				upSkin.visible = false;
			if(overSkin)
				overSkin.visible = false;
			if(downSkin)
				downSkin.visible = false;
			if(disabledSkin)
				disabledSkin.visible = false;
			
			
			var currentSkin:*;
			if(hasDisabledState&&_currentState=="disabled")
			{
				if(disabledSkin)
					currentSkin = disabledSkin;
				else
					currentSkin = upSkin;
			}
			else
			{
				switch(_currentState)
				{
					case "up":
						if(upSkin)
							currentSkin = upSkin;
						break;
					case "over":
						if(overSkin)
							currentSkin = overSkin;
						else if(upSkin)
							currentSkin = upSkin;
						break;
					case "down":
						if(downSkin)
							currentSkin = downSkin;
						else if(overSkin)
							currentSkin = overSkin;
						else if(upSkin)
							currentSkin = upSkin;
						break;
					default:
						if(upSkin)
							currentSkin = upSkin;
						break;
				}
			}
			
			if(currentSkin)
			{
				currentSkin.visible = true;
				if(currentSkin is UIAsset&&currentSkin.skin is IMovieClip)
				{
					(currentSkin.skin as IMovieClip).repeatPlay = false;
					(currentSkin.skin as IMovieClip).gotoAndPlay(0);
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