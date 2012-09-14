package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class VSliderTrackSkin extends SparkSkin
	{

		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VSliderTrackSkin()
		{
			super();
			
			this.elementsContent = [_VSliderTrackSkin_Rect1_i(),_VSliderTrackSkin_Rect2_i(),_VSliderTrackSkin_Rect3_i(),_VSliderTrackSkin_Rect4_i()];
			this.currentState = "up";
			
			states = [
				new State ({name: "up",
					overrides: [
					]
				})
				,
				new State ({name: "down",
					overrides: [
					]
				})
				,
				new State ({name: "over",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function _VSliderTrackSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.55;
			return temp;
		}

		private function _VSliderTrackSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0.55;
			temp.ratio = 0.90;
			return temp;
		}

		private function _VSliderTrackSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.entries = [_VSliderTrackSkin_GradientEntry1_i(),_VSliderTrackSkin_GradientEntry2_i()];
			return temp;
		}

		private function _VSliderTrackSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 3;
			temp.right = 3;
			temp.top = 0;
			temp.bottom = 0;
			temp.radiusX = 2;
			temp.radiusY = 2;
			temp.width = 5;
			temp.fill = _VSliderTrackSkin_LinearGradient1_i();
			return temp;
		}

		private function _VSliderTrackSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 4;
			temp.right = 4;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.radiusY = 2;
			temp.fill = _VSliderTrackSkin_SolidColor1_i();
			return temp;
		}

		private function _VSliderTrackSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.top = 2;
			temp.bottom = 2;
			temp.left = 4;
			temp.width = 1;
			temp.fill = _VSliderTrackSkin_SolidColor2_i();
			return temp;
		}

		private function _VSliderTrackSkin_Rect4_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.fill = _VSliderTrackSkin_SolidColor3_i();
			return temp;
		}

		private function _VSliderTrackSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0xCACACA;
			return temp;
		}

		private function _VSliderTrackSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x9E9E9E;
			return temp;
		}

		private function _VSliderTrackSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.alpha = 0;
			return temp;
		}

	}
}