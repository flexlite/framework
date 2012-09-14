package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;
	
	/**
	 * 垂直滚动条滑块按钮默认皮肤
	 * @author DOM
	 */
	public class VScrollBarThumbSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __VScrollBarThumbSkin_GradientEntry1:GradientEntry;
		
		public var __VScrollBarThumbSkin_GradientEntry2:GradientEntry;
		
		public var __VScrollBarThumbSkin_GradientEntry3:GradientEntry;
		
		public var __VScrollBarThumbSkin_GradientEntry4:GradientEntry;
		
		public var __VScrollBarThumbSkin_SolidColor2:SolidColor;
		
		
		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VScrollBarThumbSkin()
		{
			super();
			
			this.elementsContent = [_VScrollBarThumbSkin_Rect1_i(),_VScrollBarThumbSkin_Rect2_i(),_VScrollBarThumbSkin_Rect3_i(),_VScrollBarThumbSkin_Rect4_i(),_VScrollBarThumbSkin_Rect5_i(),_VScrollBarThumbSkin_Rect6_i(),_VScrollBarThumbSkin_Rect7_i()];
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
							target:"__VScrollBarThumbSkin_GradientEntry1",
							name:"color",
							value:0xC7C7C7
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry2",
							name:"color",
							value:0xB2B2B2
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_SolidColor2",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry3",
							name:"alpha",
							value:0.55
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry4",
							name:"alpha",
							value:0.121
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry1",
							name:"color",
							value:0xBBBBBB
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry2",
							name:"color",
							value:0x8B8B8B
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_SolidColor2",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry3",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__VScrollBarThumbSkin_GradientEntry4",
							name:"alpha",
							value:0.0264
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
		private function _VScrollBarThumbSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VScrollBarThumbSkin_GradientEntry1 = temp;
			temp.color = 0xFAFAFA;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VScrollBarThumbSkin_GradientEntry2 = temp;
			temp.color = 0xF0F0F0;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VScrollBarThumbSkin_GradientEntry3 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 1;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__VScrollBarThumbSkin_GradientEntry4 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.22;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_VScrollBarThumbSkin_GradientEntry1_i(),_VScrollBarThumbSkin_GradientEntry2_i()];
			return temp;
		}
		
		private function _VScrollBarThumbSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_VScrollBarThumbSkin_GradientEntry3_i(),_VScrollBarThumbSkin_GradientEntry4_i()];
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.top = 1;
			temp.right = 0;
			temp.bottom = 2;
			temp.minWidth = 14;
			temp.minHeight = 14;
			temp.stroke = _VScrollBarThumbSkin_SolidColorStroke1_i();
			temp.fill = _VScrollBarThumbSkin_SolidColor1_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 2;
			temp.right = 1;
			temp.bottom = 3;
			temp.fill = _VScrollBarThumbSkin_LinearGradient1_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 2;
			temp.bottom = 3;
			temp.width = 6;
			temp.fill = _VScrollBarThumbSkin_SolidColor2_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect4_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 2;
			temp.right = 1;
			temp.bottom = 3;
			temp.stroke = _VScrollBarThumbSkin_LinearGradientStroke1_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect5_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 0;
			temp.right = 1;
			temp.height = 1;
			temp.fill = _VScrollBarThumbSkin_SolidColor3_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect6_i():Rect
		{
			var temp:Rect = new Rect();
			temp.bottom = 0;
			temp.left = 1;
			temp.right = 1;
			temp.height = 2;
			temp.fill = _VScrollBarThumbSkin_SolidColor4_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_Rect7_i():Rect
		{
			var temp:Rect = new Rect();
			temp.bottom = 1;
			temp.left = 1;
			temp.right = 1;
			temp.height = 1;
			temp.fill = _VScrollBarThumbSkin_SolidColor5_i();
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0xFFFFFF;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__VScrollBarThumbSkin_SolidColor2 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.75;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.12;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColor4_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.12;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColor5_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.12;
			return temp;
		}
		
		private function _VScrollBarThumbSkin_SolidColorStroke1_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			temp.color = 0x5C5C5C;
			temp.weight = 1;
			return temp;
		}
		
	}
}