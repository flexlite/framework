package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Path;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.RadialGradient;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> master

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class ComboBoxButtonSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __ComboBoxButtonSkin_GradientEntry1:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry10:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry18:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry19:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry2:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry6:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry7:GradientEntry;

		public var __ComboBoxButtonSkin_GradientEntry9:GradientEntry;

		public var arrow:Path;

		public var arrowFill1:GradientEntry;

		public var arrowFill2:GradientEntry;

		public var border:Rect;

		public var fill:Rect;

		public var highlight:Rect;

		public var highlightStroke:Rect;

		public var hldownstroke1:Rect;

		public var hldownstroke2:Rect;

		public var lowlight:Rect;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ComboBoxButtonSkin()
		{
			super();
			
			this.minWidth = 19;
			this.minHeight = 23;
			this.elementsContent = [fill_i(),lowlight_i(),highlight_i(),border_i(),arrow_i()];
			this.currentState = "up";
			
			var highlightStroke_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(highlightStroke_i);
			var hldownstroke1_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(hldownstroke1_i);
			var hldownstroke2_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(hldownstroke2_i);
			
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
							target:"__ComboBoxButtonSkin_GradientEntry1",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry2",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry10",
							name:"alpha",
							value:0.22
						})
					]
				})
				,
				new State ({name: "down",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:hldownstroke1_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new AddItems().initializeFromObject({
							targetFactory:hldownstroke2_factory,
							propertyName:"",
							position:"after",
							relativeTo:"highlight"
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry1",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry2",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry6",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry7",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry18",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ComboBoxButtonSkin_GradientEntry19",
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
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function _ComboBoxButtonSkin_GradientEntry10_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry10 = temp;
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry11_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.0;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry12_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.001;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry13_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.0011;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry14_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.965;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry15_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.9651;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry16_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.09;
			temp.ratio = 0.0;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry17_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.0001;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry18_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry18 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry19_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry19 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry1 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.85;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry2 = temp;
			temp.color = 0xD8D8D8;
			temp.alpha = 0.85;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.0;
			temp.alpha = 0.0627;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48;
			temp.alpha = 0.0099;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry6 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.0;
			temp.alpha = 0.33;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry7 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48;
			temp.alpha = 0.33;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function _ComboBoxButtonSkin_GradientEntry9_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ComboBoxButtonSkin_GradientEntry9 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry1_i(),_ComboBoxButtonSkin_GradientEntry2_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 270;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry3_i(),_ComboBoxButtonSkin_GradientEntry4_i(),_ComboBoxButtonSkin_GradientEntry5_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradient3_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry6_i(),_ComboBoxButtonSkin_GradientEntry7_i(),_ComboBoxButtonSkin_GradientEntry8_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry9_i(),_ComboBoxButtonSkin_GradientEntry10_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry11_i(),_ComboBoxButtonSkin_GradientEntry12_i(),_ComboBoxButtonSkin_GradientEntry13_i(),_ComboBoxButtonSkin_GradientEntry14_i(),_ComboBoxButtonSkin_GradientEntry15_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradientStroke3_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry16_i(),_ComboBoxButtonSkin_GradientEntry17_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_LinearGradientStroke4_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ComboBoxButtonSkin_GradientEntry18_i(),_ComboBoxButtonSkin_GradientEntry19_i()];
			return temp;
		}

		private function _ComboBoxButtonSkin_RadialGradient1_i():RadialGradient
		{
			var temp:RadialGradient = new RadialGradient();
			temp.rotation = 90;
			temp.focalPointRatio = 1;
			temp.entries = [arrowFill1_i(),arrowFill2_i()];
			return temp;
		}

		private function arrowFill1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			arrowFill1 = temp;
			temp.color = 0;
			temp.alpha = 0.6;
			return temp;
		}

		private function arrowFill2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			arrowFill2 = temp;
			temp.color = 0;
			temp.alpha = 0.8;
			return temp;
		}

		private function arrow_i():Path
		{
			var temp:Path = new Path();
			arrow = temp;
			temp.right = 6;
			temp.verticalCenter = 0;
			temp.data = "M 4.0 4.0 L 4.0 3.0 L 5.0 3.0 L 5.0 2.0 L 6.0 2.0 L 6.0 1.0 L 7.0 1.0 L 7.0 0.0 L 0.0 0.0 L 0.0 1.0 L 1.0 1.0 L 1.0 2.0 L 2.0 2.0 L 2.0 3.0 L 3.0 3.0 L 3.0 4.0 L 4.0 4.0";
			temp.fill = _ComboBoxButtonSkin_RadialGradient1_i();
			return temp;
		}

		private function border_i():Rect
		{
			var temp:Rect = new Rect();
			border = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.width = 18;
			temp.height = 21;
			temp.stroke = _ComboBoxButtonSkin_LinearGradientStroke4_i();
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
			temp.fill = _ComboBoxButtonSkin_LinearGradient1_i();
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
			temp.radiusX = 0;
			temp.radiusY = 0;
			temp.stroke = _ComboBoxButtonSkin_LinearGradientStroke1_i();
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
			temp.fill = _ComboBoxButtonSkin_LinearGradient3_i();
			return temp;
		}

		private function hldownstroke1_i():Rect
		{
			var temp:Rect = new Rect();
			hldownstroke1 = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.radiusX = 0;
			temp.radiusY = 0;
			temp.stroke = _ComboBoxButtonSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function hldownstroke2_i():Rect
		{
			var temp:Rect = new Rect();
			hldownstroke2 = temp;
			temp.left = 2;
			temp.right = 2;
			temp.top = 2;
			temp.bottom = 2;
			temp.radiusX = 0;
			temp.radiusY = 0;
			temp.stroke = _ComboBoxButtonSkin_LinearGradientStroke3_i();
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
			temp.fill = _ComboBoxButtonSkin_LinearGradient2_i();
			return temp;
		}

	}
}