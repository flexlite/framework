package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Path;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.RadialGradient;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class DropDownListButtonSkin extends org.flexlite.domUI.skins.SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __DropDownListButtonSkin_GradientEntry1:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry11:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry12:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry2:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry20:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry21:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry22:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry23:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry3:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry4:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry8:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var __DropDownListButtonSkin_GradientEntry9:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var arrow:org.flexlite.domUI.primitives.Path;

		public var arrowFill1:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var arrowFill2:org.flexlite.domUI.primitives.graphic.GradientEntry;

		public var border:org.flexlite.domUI.primitives.Rect;

		public var fill:org.flexlite.domUI.primitives.Rect;

		public var highlight:org.flexlite.domUI.primitives.Rect;

		public var highlightStroke:org.flexlite.domUI.primitives.Rect;

		public var hldownstroke1:org.flexlite.domUI.primitives.Rect;

		public var hldownstroke2:org.flexlite.domUI.primitives.Rect;

		public var lowlight:org.flexlite.domUI.primitives.Rect;

		public var shadow:org.flexlite.domUI.primitives.Rect;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function DropDownListButtonSkin()
		{
			super();
			
			this.minWidth = 21;
			this.minHeight = 21;
			this.elementsContent = [shadow_i(),fill_i(),lowlight_i(),highlight_i(),border_i(),__DropDownListButtonSkin_Rect1_i(),arrow_i()];
			this.currentState = "up";
			
			var highlightStroke_factory:org.flexlite.domUI.core.DeferredInstanceFromFunction = new org.flexlite.domUI.core.DeferredInstanceFromFunction(highlightStroke_i);
			var hldownstroke1_factory:org.flexlite.domUI.core.DeferredInstanceFromFunction = new org.flexlite.domUI.core.DeferredInstanceFromFunction(hldownstroke1_i);
			var hldownstroke2_factory:org.flexlite.domUI.core.DeferredInstanceFromFunction = new org.flexlite.domUI.core.DeferredInstanceFromFunction(hldownstroke2_i);
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "over",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry3",
							name:"color",
							value:0xBBBDBD
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry4",
							name:"color",
							value:0x9FA0A1
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry8",
							name:"alpha",
							value:0.22
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.22
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.22
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry12",
							name:"alpha",
							value:0.22
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "down",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:hldownstroke1_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:hldownstroke2_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry1",
							name:"color",
							value:0xFFFFFF
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry1",
							name:"alpha",
							value:0
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry2",
							name:"color",
							value:0xFFFFFF
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry2",
							name:"alpha",
							value:0.5
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry3",
							name:"color",
							value:0xAAAAAA
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry4",
							name:"color",
							value:0x929496
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry8",
							name:"alpha",
							value:0.12
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.12
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry20",
							name:"alpha",
							value:0.6375
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry21",
							name:"alpha",
							value:0.85
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry22",
							name:"alpha",
							value:0.6375
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"__DropDownListButtonSkin_GradientEntry23",
							name:"alpha",
							value:0.85
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabled",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:highlightStroke_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __DropDownListButtonSkin_GradientEntry10_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry11_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry11 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry12_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry12 = temp;
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry13_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.0;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry14_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.001;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry15_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.0011;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry16_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.965;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry17_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.9651;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry18_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.09;
			temp.ratio = 0.0;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry19_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.0001;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry1_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry1 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.01;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry20_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry20 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry21_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry21 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry22_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry22 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry23_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry23 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry2_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry2 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.07;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry3_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry3 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.85;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry4_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry4 = temp;
			temp.color = 0xD8D8D8;
			temp.alpha = 0.85;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry5_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.0;
			temp.alpha = 0.0627;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry6_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48;
			temp.alpha = 0.0099;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry7_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry8_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry8 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.0;
			temp.alpha = 0.33;
			return temp;
		}

		private function __DropDownListButtonSkin_GradientEntry9_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			__DropDownListButtonSkin_GradientEntry9 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48;
			temp.alpha = 0.33;
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradient1_i():org.flexlite.domUI.primitives.graphic.LinearGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradient = new org.flexlite.domUI.primitives.graphic.LinearGradient();
			temp.rotation = 90;
			temp.entries = [__DropDownListButtonSkin_GradientEntry1_i(),__DropDownListButtonSkin_GradientEntry2_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradient2_i():org.flexlite.domUI.primitives.graphic.LinearGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradient = new org.flexlite.domUI.primitives.graphic.LinearGradient();
			temp.rotation = 90;
			temp.entries = [__DropDownListButtonSkin_GradientEntry3_i(),__DropDownListButtonSkin_GradientEntry4_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradient3_i():org.flexlite.domUI.primitives.graphic.LinearGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradient = new org.flexlite.domUI.primitives.graphic.LinearGradient();
			temp.rotation = 270;
			temp.entries = [__DropDownListButtonSkin_GradientEntry5_i(),__DropDownListButtonSkin_GradientEntry6_i(),__DropDownListButtonSkin_GradientEntry7_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradient4_i():org.flexlite.domUI.primitives.graphic.LinearGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradient = new org.flexlite.domUI.primitives.graphic.LinearGradient();
			temp.rotation = 90;
			temp.entries = [__DropDownListButtonSkin_GradientEntry8_i(),__DropDownListButtonSkin_GradientEntry9_i(),__DropDownListButtonSkin_GradientEntry10_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradient5_i():org.flexlite.domUI.primitives.graphic.LinearGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradient = new org.flexlite.domUI.primitives.graphic.LinearGradient();
			temp.rotation = 90;
			temp.entries = [__DropDownListButtonSkin_GradientEntry22_i(),__DropDownListButtonSkin_GradientEntry23_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradientStroke1_i():org.flexlite.domUI.primitives.graphic.LinearGradientStroke
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradientStroke = new org.flexlite.domUI.primitives.graphic.LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__DropDownListButtonSkin_GradientEntry11_i(),__DropDownListButtonSkin_GradientEntry12_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradientStroke2_i():org.flexlite.domUI.primitives.graphic.LinearGradientStroke
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradientStroke = new org.flexlite.domUI.primitives.graphic.LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__DropDownListButtonSkin_GradientEntry13_i(),__DropDownListButtonSkin_GradientEntry14_i(),__DropDownListButtonSkin_GradientEntry15_i(),__DropDownListButtonSkin_GradientEntry16_i(),__DropDownListButtonSkin_GradientEntry17_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradientStroke3_i():org.flexlite.domUI.primitives.graphic.LinearGradientStroke
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradientStroke = new org.flexlite.domUI.primitives.graphic.LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__DropDownListButtonSkin_GradientEntry18_i(),__DropDownListButtonSkin_GradientEntry19_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_LinearGradientStroke4_i():org.flexlite.domUI.primitives.graphic.LinearGradientStroke
		{
			var temp:org.flexlite.domUI.primitives.graphic.LinearGradientStroke = new org.flexlite.domUI.primitives.graphic.LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__DropDownListButtonSkin_GradientEntry20_i(),__DropDownListButtonSkin_GradientEntry21_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_RadialGradient1_i():org.flexlite.domUI.primitives.graphic.RadialGradient
		{
			var temp:org.flexlite.domUI.primitives.graphic.RadialGradient = new org.flexlite.domUI.primitives.graphic.RadialGradient();
			temp.rotation = 90;
			temp.focalPointRatio = 1;
			temp.entries = [arrowFill1_i(),arrowFill2_i()];
			return temp;
		}

		private function __DropDownListButtonSkin_Rect1_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			temp.right = 18;
			temp.top = 1;
			temp.bottom = 1;
			temp.width = 1;
			temp.fill = __DropDownListButtonSkin_LinearGradient5_i();
			return temp;
		}

		private function arrowFill1_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			arrowFill1 = temp;
			temp.color = 0;
			temp.alpha = 0.6;
			return temp;
		}

		private function arrowFill2_i():org.flexlite.domUI.primitives.graphic.GradientEntry
		{
			var temp:org.flexlite.domUI.primitives.graphic.GradientEntry = new org.flexlite.domUI.primitives.graphic.GradientEntry();
			arrowFill2 = temp;
			temp.color = 0;
			temp.alpha = 0.8;
			return temp;
		}

		private function arrow_i():org.flexlite.domUI.primitives.Path
		{
			var temp:org.flexlite.domUI.primitives.Path = new org.flexlite.domUI.primitives.Path();
			arrow = temp;
			temp.right = 6;
			temp.verticalCenter = 0;
			temp.data = "M 4.0 4.0 L 4.0 3.0 L 5.0 3.0 L 5.0 2.0 L 6.0 2.0 L 6.0 1.0 L 7.0 1.0 L 7.0 0.0 L 0.0 0.0 L 0.0 1.0 L 1.0 1.0 L 1.0 2.0 L 2.0 2.0 L 2.0 3.0 L 3.0 3.0 L 3.0 4.0 L 4.0 4.0";
			temp.fill = __DropDownListButtonSkin_RadialGradient1_i();
			return temp;
		}

		private function border_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			border = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.width = 69;
			temp.height = 20;
			temp.radiusX = 2;
			temp.stroke = __DropDownListButtonSkin_LinearGradientStroke4_i();
			return temp;
		}

		private function fill_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			fill = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.fill = __DropDownListButtonSkin_LinearGradient2_i();
			return temp;
		}

		private function highlightStroke_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			highlightStroke = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.stroke = __DropDownListButtonSkin_LinearGradientStroke1_i();
			return temp;
		}

		private function highlight_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			highlight = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.fill = __DropDownListButtonSkin_LinearGradient4_i();
			return temp;
		}

		private function hldownstroke1_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			hldownstroke1 = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.stroke = __DropDownListButtonSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function hldownstroke2_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			hldownstroke2 = temp;
			temp.left = 2;
			temp.right = 2;
			temp.top = 2;
			temp.bottom = 2;
			temp.radiusX = 2;
			temp.stroke = __DropDownListButtonSkin_LinearGradientStroke3_i();
			return temp;
		}

		private function lowlight_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			lowlight = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 2;
			temp.fill = __DropDownListButtonSkin_LinearGradient3_i();
			return temp;
		}

		private function shadow_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			shadow = temp;
			temp.left = -1;
			temp.right = -1;
			temp.top = -1;
			temp.bottom = -1;
			temp.radiusX = 2;
			temp.fill = __DropDownListButtonSkin_LinearGradient1_i();
			return temp;
		}

	}
}