package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class ComboBoxTextInputSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var background:Rect;

		public var bgFill:SolidColor;

		public var border:Rect;

		public var borderStroke:SolidColorStroke;

		public var promptDisplay:Label;

		public var shadow:Rect;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ComboBoxTextInputSkin()
		{
			super();
			
			this.blendMode = "normal";
			this.elementsContent = [border_i(),background_i(),shadow_i()];
			this.currentState = "normal";
			
			var promptDisplay_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(promptDisplay_i);
			
			states = [
				new State ({name: "normal",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
					]
				})
				,
				new State ({name: "normalWithPrompt",
					overrides: [
					]
				})
				,
				new State ({name: "disabledWithPrompt",
					overrides: [
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function _ComboBoxTextInputSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.12;
			return temp;
		}

		private function background_i():Rect
		{
			var temp:Rect = new Rect();
			background = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.fill = bgFill_i();
			return temp;
		}

		private function bgFill_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			bgFill = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function borderStroke_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			borderStroke = temp;
			temp.weight = 1;
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
			temp.stroke = borderStroke_i();
			return temp;
		}

		private function promptDisplay_i():Label
		{
			var temp:Label = new Label();
			promptDisplay = temp;
			temp.maxDisplayedLines = 1;
			temp.verticalAlign = "middle";
			temp.mouseEnabled = false;
			temp.mouseChildren = false;
			return temp;
		}

		private function shadow_i():Rect
		{
			var temp:Rect = new Rect();
			shadow = temp;
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.height = 1;
			temp.fill = _ComboBoxTextInputSkin_SolidColor1_i();
			return temp;
		}

	}
}