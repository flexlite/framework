package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;
	import flash.filters.DropShadowFilter;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class VSliderSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var labelDisplay:Label;

		public var thumb:Button;

		public var track:Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VSliderSkin()
		{
			super();
			
			this.minWidth = 11;
			this.elementsContent = [track_i(),thumb_i()];
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
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function thumb_i():Button
		{
			var temp:Button = new Button();
			thumb = temp;
			temp.left = 0;
			temp.right = 0;
			temp.width = 11;
			temp.height = 11;
			temp.tabEnabled = false;
			temp.skinName = VSliderThumbSkin;
			return temp;
		}

		private function track_i():Button
		{
			var temp:Button = new Button();
			track = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.minHeight = 33;
			temp.height = 100;
			temp.tabEnabled = false;
			temp.skinName = VSliderTrackSkin;
			return temp;
		}

	}
}