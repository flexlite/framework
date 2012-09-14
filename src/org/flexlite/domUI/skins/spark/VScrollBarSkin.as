package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> master

	/**
	 * 垂直滚动条默认皮肤
	 * @author DXMLCompiler
	 */
	public class VScrollBarSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var decrementButton:Button;

		public var incrementButton:Button;

		public var thumb:Button;

		public var track:Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VScrollBarSkin()
		{
			super();
			
			this.minWidth = 15;
			this.minHeight = 35;
			this.elementsContent = [track_i(),thumb_i(),decrementButton_i(),incrementButton_i()];
			this.currentState = "normal";
			
			states = [
				new State ({name: "normal",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"",
							name:"alpha",
							value:0.5
						})
					]
				})
				,
				new State ({name: "inactive",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"thumb",
							name:"visible",
							value:false
						})
						,
						new SetProperty().initializeFromObject({
							target:"decrementButton",
							name:"enabled",
							value:false
						})
						,
						new SetProperty().initializeFromObject({
							target:"incrementButton",
							name:"enabled",
							value:false
						})
						,
						new SetProperty().initializeFromObject({
							target:"",
							name:"alpha",
							value:0.5
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function decrementButton_i():Button
		{
			var temp:Button = new Button();
			decrementButton = temp;
			temp.top = 0;
			temp.skinName = org.flexlite.domUI.skins.spark.ScrollBarUpButtonSkin;
			return temp;
		}

		private function incrementButton_i():Button
		{
			var temp:Button = new Button();
			incrementButton = temp;
			temp.bottom = 0;
			temp.skinName = org.flexlite.domUI.skins.spark.ScrollBarDownButtonSkin;
			return temp;
		}

		private function thumb_i():Button
		{
			var temp:Button = new Button();
			thumb = temp;
			temp.skinName = org.flexlite.domUI.skins.spark.VScrollBarThumbSkin;
			return temp;
		}

		private function track_i():Button
		{
			var temp:Button = new Button();
			track = temp;
			temp.top = 16;
			temp.bottom = 15;
			temp.height = 54;
			temp.skinName = org.flexlite.domUI.skins.spark.VScrollBarTrackSkin;
			return temp;
		}

	}
}