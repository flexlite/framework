package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.primitives.Path;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.RectangularDropShadow;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.states.SetProperty;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class TitleWindowCloseButtonSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __TitleWindowCloseButtonSkin_SolidColor1:SolidColor;

		public var __TitleWindowCloseButtonSkin_SolidColor2:SolidColor;

		public var __TitleWindowCloseButtonSkin_SolidColorStroke1:SolidColorStroke;

		public var cbshad:Rect;

		public var dropShadow:RectangularDropShadow;

		public var xFill1:SolidColor;

		public var xFill2:SolidColor;

		public var xSymbol:Group;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TitleWindowCloseButtonSkin()
		{
			super();
			
			this.elementsContent = [dropShadow_i(),_TitleWindowCloseButtonSkin_Rect1_i(),cbshad_i(),xSymbol_i()];
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
							target:"dropShadow",
							name:"alpha",
							value:0.85
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.7
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColor2",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColor2",
							name:"alpha",
							value:.85
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"dropShadow",
							name:"alpha",
							value:.85
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.7
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColor1",
							name:"alpha",
							value:0.7
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TitleWindowCloseButtonSkin_SolidColor2",
							name:"alpha",
							value:0.22
						})
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
		private function _TitleWindowCloseButtonSkin_Path1_i():Path
		{
			var temp:Path = new Path();
			temp.blendMode = "normal";
			temp.alpha = .85;
			temp.data = "M 3 5 L 4 5 L 4 6 L 5 6 L 5 7 L 4 7 L 4 8 L 3 8 L 3 9 L 4 9 L 4 10 L 5 10 L 5 9 L 6 9 L 6 8 L 7 8 L 7 9 L 8 9 L 8 10 L 9 10 L 9 9 L 10 9 L 10 8 L 9 8 L 9 7 L 8 7 L 8 6 L 9 6 L 9 5 L 10 5 L 10 4 L 9 4 L 9 3 L 8 3 L 8 4 L 7 4 L 7 5 L 6 5 L 6 4 L 5 4 L 5 3 L 4 3 L 4 4 L 3 4 L 3 5 Z";
			temp.fill = xFill1_i();
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_Path2_i():Path
		{
			var temp:Path = new Path();
			temp.blendMode = "normal";
			temp.alpha = .75;
			temp.data = "M 3 3 L 4 3 L 4 4 L 3 4 L 3 3 M 3 9 L 4 9 L 4 10 L 3 10 L 3 9 M 9 3 L 10 3 L 10 4 L 9 4 L 9 3 M 9 9 L 10 9 L 10 10 L 9 10 L 9 9 Z";
			temp.fill = xFill2_i();
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_Path3_i():Path
		{
			var temp:Path = new Path();
			temp.blendMode = "normal";
			temp.alpha = .85;
			temp.data = "M 3 5 L 3 6 L 4 6 L 4 7 L 5 7 L 5 6 L 4 6 L 4 5 L 3 5 M 8 6 L 8 7 L 9 7 L 9 6 L 10 6 L 10 5 L 9 5 L 9 6 L 8 6 M 3 10 L 3 11 L 5 11 5 10 L 6 10 L 6 9 L 7 9 L 7 10 L 8 10 L 8 11 L 10 11 L 10 10 L 8 10 L 8 9 L 7 9 L 7 8 L 6 8 L 6 9 L 5 9 L 5 10 L 3 10 Z";
			temp.fill = _TitleWindowCloseButtonSkin_SolidColor3_i();
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.stroke = _TitleWindowCloseButtonSkin_SolidColorStroke1_i();
			temp.fill = _TitleWindowCloseButtonSkin_SolidColor1_i();
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__TitleWindowCloseButtonSkin_SolidColor1 = temp;
			temp.color = 0xCCCCCC;
			temp.alpha = 0;
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__TitleWindowCloseButtonSkin_SolidColor2 = temp;
			temp.color = 0x000000;
			temp.alpha = 0;
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _TitleWindowCloseButtonSkin_SolidColorStroke1_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			__TitleWindowCloseButtonSkin_SolidColorStroke1 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.0;
			temp.weight = 1;
			return temp;
		}

		private function cbshad_i():Rect
		{
			var temp:Rect = new Rect();
			cbshad = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.height = 1;
			temp.fill = _TitleWindowCloseButtonSkin_SolidColor2_i();
			return temp;
		}

		private function dropShadow_i():RectangularDropShadow
		{
			var temp:RectangularDropShadow = new RectangularDropShadow();
			dropShadow = temp;
			temp.blurX = 0;
			temp.blurY = 0;
			temp.alpha = 0;
			temp.distance = 1;
			temp.angle = 90;
			temp.color = 0xFFFFFF;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			return temp;
		}

		private function xFill1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			xFill1 = temp;
			temp.color = 0x000000;
			return temp;
		}

		private function xFill2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			xFill2 = temp;
			temp.color = 0x000000;
			return temp;
		}

		private function xSymbol_i():Group
		{
			var temp:Group = new Group();
			xSymbol = temp;
			temp.top = 1;
			temp.left = 1;
			temp.elementsContent = [_TitleWindowCloseButtonSkin_Path1_i(),_TitleWindowCloseButtonSkin_Path2_i(),_TitleWindowCloseButtonSkin_Path3_i()];
			return temp;
		}

	}
}