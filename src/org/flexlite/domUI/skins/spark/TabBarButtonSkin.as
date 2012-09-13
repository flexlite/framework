package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Line;
	import org.flexlite.domUI.primitives.Path;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class TabBarButtonSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __TabBarButtonSkin_GradientEntry1:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry10:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry11:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry12:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry2:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry6:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry7:GradientEntry;

		public var __TabBarButtonSkin_GradientEntry9:GradientEntry;

		public var __TabBarButtonSkin_SolidColor1:SolidColor;

		public var __TabBarButtonSkin_SolidColor2:SolidColor;

		public var __TabBarButtonSkin_SolidColorStroke1:SolidColorStroke;

		public var __TabBarButtonSkin_SolidColorStroke2:SolidColorStroke;

		public var borderBottom:Line;

		public var borderTop:Path;

		public var fill:Rect;

		public var highlight:Rect;

		public var highlightStroke:Rect;

		public var labelDisplay:Label;

		public var lowlight:Rect;

		public var selectedHighlightH1:Rect;

		public var selectedHighlightH2:Rect;

		public var selectedHighlightV:Path;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TabBarButtonSkin()
		{
			super();
			
			this.minWidth = 21;
			this.minHeight = 21;
			this.elementsContent = [fill_i(),lowlight_i(),highlight_i(),selectedHighlightV_i(),selectedHighlightH1_i(),selectedHighlightH2_i(),borderBottom_i(),borderTop_i(),labelDisplay_i()];
			this.currentState = "up";
			
			var highlightStroke_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(highlightStroke_i);
			
			states = [
				new State ({name: "up",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
					]
				})
				,
				new State ({name: "over",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry10",
							name:"alpha",
							value:0.22
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor1",
							name:"alpha",
							value:0.25
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor2",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"alpha",
							value:0.85
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"",
							name:"alpha",
							value:0.5
						})
					]
				})
				,
				new State ({name: "upAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry10",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor1",
							name:"alpha",
							value:0.25
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor2",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"color",
							value:0x434343
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"alpha",
							value:0.5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "overAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"alpha",
							value:1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x8E8F90
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"alpha",
							value:1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry10",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor1",
							name:"alpha",
							value:0.25
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor2",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"color",
							value:0x434343
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"alpha",
							value:0.5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "downAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor1",
							name:"alpha",
							value:0.25
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor2",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"color",
							value:0x434343
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"alpha",
							value:0.5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "disabledAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry1",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry2",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry10",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke1",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor1",
							name:"alpha",
							value:0.25
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColor2",
							name:"alpha",
							value:0.15
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"color",
							value:0x434343
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_SolidColorStroke2",
							name:"alpha",
							value:0.5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__TabBarButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.85
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __TabBarButtonSkin_GradientEntry10_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry10 = temp;
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry11_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry11 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry12_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry12 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry1 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.85;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry2 = temp;
			temp.color = 0xD8D8D8;
			temp.alpha = 0.85;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.0;
			temp.alpha = 0.0627;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48;
			temp.alpha = 0.0099;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry6 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.0;
			temp.alpha = 0.33;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry7 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48;
			temp.alpha = 0.33;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function __TabBarButtonSkin_GradientEntry9_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TabBarButtonSkin_GradientEntry9 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function __TabBarButtonSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [__TabBarButtonSkin_GradientEntry1_i(),__TabBarButtonSkin_GradientEntry2_i()];
			return temp;
		}

		private function __TabBarButtonSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 270;
			temp.entries = [__TabBarButtonSkin_GradientEntry3_i(),__TabBarButtonSkin_GradientEntry4_i(),__TabBarButtonSkin_GradientEntry5_i()];
			return temp;
		}

		private function __TabBarButtonSkin_LinearGradient3_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [__TabBarButtonSkin_GradientEntry6_i(),__TabBarButtonSkin_GradientEntry7_i(),__TabBarButtonSkin_GradientEntry8_i()];
			return temp;
		}

		private function __TabBarButtonSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__TabBarButtonSkin_GradientEntry9_i(),__TabBarButtonSkin_GradientEntry10_i()];
			return temp;
		}

		private function __TabBarButtonSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__TabBarButtonSkin_GradientEntry11_i(),__TabBarButtonSkin_GradientEntry12_i()];
			return temp;
		}

		private function __TabBarButtonSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__TabBarButtonSkin_SolidColor1 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.0;
			return temp;
		}

		private function __TabBarButtonSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__TabBarButtonSkin_SolidColor2 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.0;
			return temp;
		}

		private function __TabBarButtonSkin_SolidColorStroke1_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			__TabBarButtonSkin_SolidColorStroke1 = temp;
			temp.weight = 1;
			temp.color = 0x000000;
			temp.alpha = 0.0;
			return temp;
		}

		private function __TabBarButtonSkin_SolidColorStroke2_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			__TabBarButtonSkin_SolidColorStroke2 = temp;
			temp.weight = 1;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function borderBottom_i():Line
		{
			var temp:Line = new Line();
			borderBottom = temp;
			temp.left = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.stroke = __TabBarButtonSkin_SolidColorStroke2_i();
			return temp;
		}

		private function borderTop_i():Path
		{
			var temp:Path = new Path();
			borderTop = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.stroke = __TabBarButtonSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function fill_i():Rect
		{
			var temp:Rect = new Rect();
			fill = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.topLeftRadiusX = 4;
			temp.topRightRadiusX = 4;
			temp.width = 70;
			temp.height = 22;
			temp.fill = __TabBarButtonSkin_LinearGradient1_i();
			return temp;
		}

		private function highlightStroke_i():Rect
		{
			var temp:Rect = new Rect();
			highlightStroke = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.topLeftRadiusX = 4;
			temp.topRightRadiusX = 4;
			temp.stroke = __TabBarButtonSkin_LinearGradientStroke1_i();
			return temp;
		}

		private function highlight_i():Rect
		{
			var temp:Rect = new Rect();
			highlight = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.topLeftRadiusX = 4;
			temp.topRightRadiusX = 4;
			temp.fill = __TabBarButtonSkin_LinearGradient3_i();
			return temp;
		}

		private function labelDisplay_i():Label
		{
			var temp:Label = new Label();
			labelDisplay = temp;
			temp.textAlign = "center";
			temp.verticalAlign = "middle";
			temp.maxDisplayedLines = 1;
			temp.horizontalCenter = 0;
			temp.verticalCenter = 1;
			temp.left = 10;
			temp.right = 10;
			temp.top = 2;
			temp.bottom = 2;
			return temp;
		}

		private function lowlight_i():Rect
		{
			var temp:Rect = new Rect();
			lowlight = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.topLeftRadiusX = 4;
			temp.topRightRadiusX = 4;
			temp.fill = __TabBarButtonSkin_LinearGradient2_i();
			return temp;
		}

		private function selectedHighlightH1_i():Rect
		{
			var temp:Rect = new Rect();
			selectedHighlightH1 = temp;
			temp.top = 1;
			temp.height = 1;
			temp.fill = __TabBarButtonSkin_SolidColor1_i();
			return temp;
		}

		private function selectedHighlightH2_i():Rect
		{
			var temp:Rect = new Rect();
			selectedHighlightH2 = temp;
			temp.top = 2;
			temp.height = 1;
			temp.fill = __TabBarButtonSkin_SolidColor2_i();
			return temp;
		}

		private function selectedHighlightV_i():Path
		{
			var temp:Path = new Path();
			selectedHighlightV = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.stroke = __TabBarButtonSkin_SolidColorStroke1_i();
			return temp;
		}

	}
}