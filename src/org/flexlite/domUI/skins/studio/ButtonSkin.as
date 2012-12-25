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
			states = ["up","over","down"];
			this.currentState = "up";
		}
		
		private var _hasDisabledState:Boolean;
		/**
		 * 是否含有disabled状态,默认为false。若设置为true，则皮肤里必须含有id为disabledSkind的素材。
		 */
		public function get hasDisabledState():Boolean
		{
			return _hasDisabledState;
		}
		public function set hasDisabledState(value:Boolean):void
		{
			if(_hasDisabledState==value)
				return;
			_hasDisabledState = value;
			if(value)
				states = ["up","over","down","disabled"];
			else
				states = ["up","over","down"];
		}

		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			if(hasOwnProperty("upSkin"))
				this["upSkin"]["visible"] = false;
			if(hasOwnProperty("overSkin"))
				this["overSkin"]["visible"] = false;
			if(hasOwnProperty("downSkin"))
				this["disabledSkin"]["visible"] = false;
			if(hasOwnProperty("disabledSkin"))
				this["disabledSkin"]["visible"] = false;
			
			
			var currentSkin:Object;
			if(_hasDisabledState&&currentSkin=="disabled")
			{
				if(hasOwnProperty("disabledSkin"))
					currentSkin = this["disabledSkin"];
				else
					currentSkin = this["upSkin"];
			}
			else
			{
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
						else if(hasOwnProperty("overSkin"))
							currentSkin = this["overSkin"];
						else if(hasOwnProperty("upSkin"))
							currentSkin = this["upSkin"];
						break;
					default:
						if(hasOwnProperty("upSkin"))
							currentSkin = this["upSkin"];
						break;
				}
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