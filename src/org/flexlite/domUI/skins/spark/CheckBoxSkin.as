package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Path;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.formats.TextAlign;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class CheckBoxSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __CheckBoxSkin_GradientEntry1:GradientEntry;

		public var __CheckBoxSkin_GradientEntry2:GradientEntry;

		public var __CheckBoxSkin_GradientEntry3:GradientEntry;

		public var __CheckBoxSkin_GradientEntry4:GradientEntry;

		public var __CheckBoxSkin_GradientEntry5:GradientEntry;

		public var __CheckBoxSkin_GradientEntry6:GradientEntry;

		public var __CheckBoxSkin_GradientEntry7:GradientEntry;

		public var __CheckBoxSkin_GradientEntry8:GradientEntry;

		public var __CheckBoxSkin_Group1:Group;

		public var __CheckBoxSkin_Rect3:Rect;

		public var __CheckBoxSkin_Rect4:Rect;

		public var __CheckBoxSkin_Rect5:Rect;

		public var __CheckBoxSkin_Rect6:Rect;

		public var __CheckBoxSkin_Rect7:Rect;

		public var __CheckBoxSkin_Rect8:Rect;

		public var __CheckBoxSkin_SolidColor1:SolidColor;

		public var check:Path;

		public var checkMarkFill:SolidColor;

		public var labelDisplay:Label;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function CheckBoxSkin()
		{
			super();
			
			this.elementsContent = [__CheckBoxSkin_Group1_i(),labelDisplay_i()];
			this.currentState = "up";
			
			var __CheckBoxSkin_Rect4_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(__CheckBoxSkin_Rect4_i);
			var __CheckBoxSkin_Rect5_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(__CheckBoxSkin_Rect5_i);
			var __CheckBoxSkin_Rect6_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(__CheckBoxSkin_Rect6_i);
			var __CheckBoxSkin_Rect7_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(__CheckBoxSkin_Rect7_i);
			var __CheckBoxSkin_Rect8_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(__CheckBoxSkin_Rect8_i);
			var check_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(check_i);
			
			states = [
				new State ({name: "up",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
					]
				})
				,
				new State ({name: "over",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry3",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry4",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry5",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry6",
							name:"alpha",
							value:0.0396
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect5_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect6_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect7_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect8_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry1",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry1",
							name:"alpha",
							value:0
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry2",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry2",
							name:"alpha",
							value:0.57
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry3",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry4",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_SolidColor1",
							name:"alpha",
							value:0
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry7",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry8",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
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
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:check_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new State ({name: "overAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:check_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"last",
							relativeTo:""
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry3",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry4",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry5",
							name:"alpha",
							value:0.33
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry6",
							name:"alpha",
							value:0.0396
						})
					]
				})
				,
				new State ({name: "downAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect5_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect6_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect7_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect8_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:check_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"last",
							relativeTo:""
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry1",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry1",
							name:"alpha",
							value:0
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry2",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry2",
							name:"alpha",
							value:0.57
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry3",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry4",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_SolidColor1",
							name:"alpha",
							value:0
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry7",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__CheckBoxSkin_GradientEntry8",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new State ({name: "disabledAndSelected",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:__CheckBoxSkin_Rect4_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"after",
							relativeTo:"__CheckBoxSkin_Rect3"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:check_factory,
							propertyName:"__CheckBoxSkin_Group1",
							position:"last",
							relativeTo:""
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
		private function __CheckBoxSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry1 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.011;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry2 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.121;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry3 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.85;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry4 = temp;
			temp.color = 0xD8D8D8;
			temp.alpha = 0.85;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry5 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry6 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.12;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry7 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function __CheckBoxSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__CheckBoxSkin_GradientEntry8 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function __CheckBoxSkin_Group1_i():Group
		{
			var temp:Group = new Group();
			__CheckBoxSkin_Group1 = temp;
			temp.verticalCenter = 0;
			temp.width = 13;
			temp.height = 13;
			temp.elementsContent = [__CheckBoxSkin_Rect1_i(),__CheckBoxSkin_Rect2_i(),__CheckBoxSkin_Rect3_i(),__CheckBoxSkin_Rect9_i()];
			return temp;
		}

		private function __CheckBoxSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [__CheckBoxSkin_GradientEntry3_i(),__CheckBoxSkin_GradientEntry4_i()];
			return temp;
		}

		private function __CheckBoxSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__CheckBoxSkin_GradientEntry1_i(),__CheckBoxSkin_GradientEntry2_i()];
			return temp;
		}

		private function __CheckBoxSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__CheckBoxSkin_GradientEntry5_i(),__CheckBoxSkin_GradientEntry6_i()];
			return temp;
		}

		private function __CheckBoxSkin_LinearGradientStroke3_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__CheckBoxSkin_GradientEntry7_i(),__CheckBoxSkin_GradientEntry8_i()];
			return temp;
		}

		private function __CheckBoxSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = -1;
			temp.top = -1;
			temp.right = -1;
			temp.bottom = -1;
			temp.stroke = __CheckBoxSkin_LinearGradientStroke1_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.bottom = 1;
			temp.fill = __CheckBoxSkin_LinearGradient1_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect3 = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.height = 5;
			temp.fill = __CheckBoxSkin_SolidColor1_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect4_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect4 = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.stroke = __CheckBoxSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect5_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect5 = temp;
			temp.left = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.width = 1;
			temp.fill = __CheckBoxSkin_SolidColor2_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect6_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect6 = temp;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.width = 1;
			temp.fill = __CheckBoxSkin_SolidColor3_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect7_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect7 = temp;
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.height = 1;
			temp.fill = __CheckBoxSkin_SolidColor4_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect8_i():Rect
		{
			var temp:Rect = new Rect();
			__CheckBoxSkin_Rect8 = temp;
			temp.left = 1;
			temp.top = 2;
			temp.right = 1;
			temp.height = 1;
			temp.fill = __CheckBoxSkin_SolidColor5_i();
			return temp;
		}

		private function __CheckBoxSkin_Rect9_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.stroke = __CheckBoxSkin_LinearGradientStroke3_i();
			return temp;
		}

		private function __CheckBoxSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			__CheckBoxSkin_SolidColor1 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.33;
			return temp;
		}

		private function __CheckBoxSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			return temp;
		}

		private function __CheckBoxSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			return temp;
		}

		private function __CheckBoxSkin_SolidColor4_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			return temp;
		}

		private function __CheckBoxSkin_SolidColor5_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.09;
			return temp;
		}

		private function checkMarkFill_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			checkMarkFill = temp;
			temp.color = 0;
			temp.alpha = 0.8;
			return temp;
		}

		private function check_i():Path
		{
			var temp:Path = new Path();
			check = temp;
			temp.left = 2;
			temp.top = 0;
			temp.data = "M 9.2 0.1 L 4.05 6.55 L 3.15 5.0 L 0.05 5.0 L 4.6 9.7 L 12.05 0.1 L 9.2 0.1";
			temp.fill = checkMarkFill_i();
			return temp;
		}

		private function labelDisplay_i():Label
		{
			var temp:Label = new Label();
			labelDisplay = temp;
			var tf:TextFormat;
			temp.textAlign = "left";
			temp.verticalAlign = "middle";
			temp.maxDisplayedLines = 1;
			temp.left = 18;
			temp.right = 0;
			temp.top = 3;
			temp.bottom = 3;
			temp.verticalCenter = 2;
			return temp;
		}

	}
}