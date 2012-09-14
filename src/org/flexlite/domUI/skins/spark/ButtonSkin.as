package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> master

	/**
	 * 按钮组件默认皮肤
	 * @author DOM
	 */
	public class ButtonSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __ButtonSkin_GradientEntry1:GradientEntry;

		public var __ButtonSkin_GradientEntry11:GradientEntry;

		public var __ButtonSkin_GradientEntry12:GradientEntry;

		public var __ButtonSkin_GradientEntry2:GradientEntry;

		public var __ButtonSkin_GradientEntry20:GradientEntry;

		public var __ButtonSkin_GradientEntry21:GradientEntry;

		public var __ButtonSkin_GradientEntry3:GradientEntry;

		public var __ButtonSkin_GradientEntry4:GradientEntry;

		public var __ButtonSkin_GradientEntry8:GradientEntry;

		public var __ButtonSkin_GradientEntry9:GradientEntry;

		public var border:Rect;

		public var fill:Rect;

		public var highlight:Rect;

		public var highlightStroke:Rect;

		public var hldownstroke1:Rect;

		public var hldownstroke2:Rect;

		public var labelDisplay:Label;

		public var lowlight:Rect;

		public var shadow:Rect;


		/**
		 * 构造函数
		 */		
		public function ButtonSkin()
		{
			super();
			
			this.minWidth = 21;
			this.minHeight = 21;
			this.elementsContent = [shadow_i(),fill_i(),lowlight_i(),highlight_i(),border_i(),labelDisplay_i()];
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
							target:"__ButtonSkin_GradientEntry3",
							name:"color",
							value:0xBBBDBD
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry4",
							name:"color",
							value:0x9FA0A1
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry8",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry11",
							name:"alpha",
							value:0.22
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry12",
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
							target:"__ButtonSkin_GradientEntry1",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry1",
							name:"alpha",
							value:0
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry2",
							name:"color",
							value:0xFFFFFF
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry2",
							name:"alpha",
							value:0.5
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry3",
							name:"color",
							value:0xAAAAAA
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry4",
							name:"color",
							value:0x929496
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry8",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry9",
							name:"alpha",
							value:0.12
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry20",
							name:"alpha",
							value:0.6375
						})
						,
						new SetProperty().initializeFromObject({
							target:"__ButtonSkin_GradientEntry21",
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
			];
		}


		private function _ButtonSkin_GradientEntry10_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function _ButtonSkin_GradientEntry11_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry11 = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _ButtonSkin_GradientEntry12_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry12 = temp;
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function _ButtonSkin_GradientEntry13_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.0;
			return temp;
		}

		private function _ButtonSkin_GradientEntry14_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.25;
			temp.ratio = 0.001;
			return temp;
		}

		private function _ButtonSkin_GradientEntry15_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.0011;
			return temp;
		}

		private function _ButtonSkin_GradientEntry16_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.07;
			temp.ratio = 0.965;
			return temp;
		}

		private function _ButtonSkin_GradientEntry17_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.9651;
			return temp;
		}

		private function _ButtonSkin_GradientEntry18_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.09;
			temp.ratio = 0.0;
			return temp;
		}

		private function _ButtonSkin_GradientEntry19_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.alpha = 0.00;
			temp.ratio = 0.0001;
			return temp;
		}

		private function _ButtonSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry1 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.01;
			return temp;
		}

		private function _ButtonSkin_GradientEntry20_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry20 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.5625;
			return temp;
		}

		private function _ButtonSkin_GradientEntry21_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry21 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function _ButtonSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry2 = temp;
			temp.color = 0x000000;
			temp.alpha = 0.07;
			return temp;
		}

		private function _ButtonSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry3 = temp;
			temp.color = 0xFFFFFF;
			temp.alpha = 0.85;
			return temp;
		}

		private function _ButtonSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry4 = temp;
			temp.color = 0xD8D8D8;
			temp.alpha = 0.85;
			return temp;
		}

		private function _ButtonSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.0;
			temp.alpha = 0.0627;
			return temp;
		}

		private function _ButtonSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48;
			temp.alpha = 0.0099;
			return temp;
		}

		private function _ButtonSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0x000000;
			temp.ratio = 0.48001;
			temp.alpha = 0;
			return temp;
		}

		private function _ButtonSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry8 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.0;
			temp.alpha = 0.33;
			return temp;
		}

		private function _ButtonSkin_GradientEntry9_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__ButtonSkin_GradientEntry9 = temp;
			temp.color = 0xFFFFFF;
			temp.ratio = 0.48;
			temp.alpha = 0.33;
			return temp;
		}

		private function _ButtonSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_ButtonSkin_GradientEntry1_i(),_ButtonSkin_GradientEntry2_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_ButtonSkin_GradientEntry3_i(),_ButtonSkin_GradientEntry4_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradient3_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 270;
			temp.entries = [_ButtonSkin_GradientEntry5_i(),_ButtonSkin_GradientEntry6_i(),_ButtonSkin_GradientEntry7_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradient4_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_ButtonSkin_GradientEntry8_i(),_ButtonSkin_GradientEntry9_i(),_ButtonSkin_GradientEntry10_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ButtonSkin_GradientEntry11_i(),_ButtonSkin_GradientEntry12_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ButtonSkin_GradientEntry13_i(),_ButtonSkin_GradientEntry14_i(),_ButtonSkin_GradientEntry15_i(),_ButtonSkin_GradientEntry16_i(),_ButtonSkin_GradientEntry17_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradientStroke3_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ButtonSkin_GradientEntry18_i(),_ButtonSkin_GradientEntry19_i()];
			return temp;
		}

		private function _ButtonSkin_LinearGradientStroke4_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_ButtonSkin_GradientEntry20_i(),_ButtonSkin_GradientEntry21_i()];
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
			temp.width = 69;
			temp.height = 20;
			temp.radiusX = 2;
			temp.stroke = _ButtonSkin_LinearGradientStroke4_i();
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
			temp.radiusX = 2;
			temp.fill = _ButtonSkin_LinearGradient2_i();
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
			temp.radiusX = 2;
			temp.stroke = _ButtonSkin_LinearGradientStroke1_i();
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
			temp.radiusX = 2;
			temp.fill = _ButtonSkin_LinearGradient4_i();
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
			temp.radiusX = 2;
			temp.stroke = _ButtonSkin_LinearGradientStroke2_i();
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
			temp.radiusX = 2;
			temp.stroke = _ButtonSkin_LinearGradientStroke3_i();
			return temp;
		}

		private function labelDisplay_i():Label
		{
			var temp:Label = new Label();
			labelDisplay = temp;
			temp.textAlign = "center";
			temp.verticalAlign = "middle";
			temp.maxDisplayedLines = 1;
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
			temp.radiusX = 2;
			temp.fill = _ButtonSkin_LinearGradient3_i();
			return temp;
		}

		private function shadow_i():Rect
		{
			var temp:Rect = new Rect();
			shadow = temp;
			temp.left = -1;
			temp.right = -1;
			temp.top = -1;
			temp.bottom = -1;
			temp.radiusX = 2;
			temp.fill = _ButtonSkin_LinearGradient1_i();
			return temp;
		}

	}
}