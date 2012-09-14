package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class VSliderThumbSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __VSliderThumbSkin_GradientEntry10:GradientEntry;

		public var __VSliderThumbSkin_GradientEntry8:GradientEntry;

		public var __VSliderThumbSkin_GradientEntry9:GradientEntry;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VSliderThumbSkin()
		{
			super();
			
			this.elementsContent = [_VSliderThumbSkin_Rect1_i(),_VSliderThumbSkin_Rect2_i(),_VSliderThumbSkin_Rect3_i(),_VSliderThumbSkin_Rect4_i(),_VSliderThumbSkin_Rect5_i()];
			this.currentState = "up";
			
			states = [
				new State ({name: "up",
					overrides: [
					]
				})
				,
				new State ({name: "over",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry8",
							name:"color",
							value:0xE5E5E5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry9",
							name:"color",
							value:0x7D7D7D
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry10",
							name:"alpha",
							value:0
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry8",
							name:"color",
							value:0x999999
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry9",
							name:"color",
							value:0x555555
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VSliderThumbSkin_GradientEntry10",
							name:"alpha",
							value:0
						})
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
		private function _VSliderThumbSkin_GradientEntry10_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VSliderThumbSkin_GradientEntry10 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry11_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry12_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.03;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.011;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.121;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.33;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VSliderThumbSkin_GradientEntry8 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _VSliderThumbSkin_GradientEntry9_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VSliderThumbSkin_GradientEntry9 = temp;
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function _VSliderThumbSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_VSliderThumbSkin_GradientEntry8_i(),_VSliderThumbSkin_GradientEntry9_i()];
			return temp;
		}

		private function _VSliderThumbSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_VSliderThumbSkin_GradientEntry10_i(),_VSliderThumbSkin_GradientEntry11_i(),_VSliderThumbSkin_GradientEntry12_i()];
			return temp;
		}

		private function _VSliderThumbSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_VSliderThumbSkin_GradientEntry1_i(),_VSliderThumbSkin_GradientEntry2_i(),_VSliderThumbSkin_GradientEntry3_i()];
			return temp;
		}

		private function _VSliderThumbSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_VSliderThumbSkin_GradientEntry4_i(),_VSliderThumbSkin_GradientEntry5_i()];
			return temp;
		}

		private function _VSliderThumbSkin_LinearGradientStroke3_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_VSliderThumbSkin_GradientEntry6_i(),_VSliderThumbSkin_GradientEntry7_i()];
			return temp;
		}

		private function _VSliderThumbSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = -2;
			temp.top = -2;
			temp.right = -2;
			temp.bottom = -2;
			temp.radiusX = 8.5;
			temp.radiusY = 8.5;
			temp.stroke = _VSliderThumbSkin_LinearGradientStroke1_i();
			return temp;
		}

		private function _VSliderThumbSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = -1;
			temp.top = -1;
			temp.right = -1;
			temp.bottom = -1;
			temp.radiusX = 7.5;
			temp.radiusY = 7.5;
			temp.stroke = _VSliderThumbSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function _VSliderThumbSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.radiusX = 7;
			temp.radiusY = 7;
			temp.fill = _VSliderThumbSkin_SolidColor1_i();
			return temp;
		}

		private function _VSliderThumbSkin_Rect4_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0.5;
			temp.right = 0.5;
			temp.top = 0.5;
			temp.bottom = 0.5;
			temp.radiusX = 6;
			temp.radiusY = 6;
			temp.stroke = _VSliderThumbSkin_LinearGradientStroke3_i();
			temp.fill = _VSliderThumbSkin_LinearGradient1_i();
			return temp;
		}

		private function _VSliderThumbSkin_Rect5_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 3;
			temp.radiusY = 3;
			temp.fill = _VSliderThumbSkin_LinearGradient2_i();
			return temp;
		}

		private function _VSliderThumbSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x4F4F4F;
			return temp;
		}

	}
}