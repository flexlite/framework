package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> master

	/**
	 * 多行文本输入控件默认皮肤
	 * @author DOM
	 */
	public class TextAreaSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var background:Rect;

		public var bgFill:SolidColor;

		public var border:Rect;

		public var borderStroke:SolidColorStroke;

		public var scroller:Scroller;

		public var shadow:Rect;

		public var textDisplay:EditableText;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TextAreaSkin()
		{
			super();
			
			this.blendMode = "normal";
			this.elementsContent = [border_i(),background_i(),shadow_i(),scroller_i()];
			this.currentState = "normal";
			
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
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function _TextAreaSkin_SolidColor1_i():SolidColor
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

		private function scroller_i():Scroller
		{
			var temp:Scroller = new Scroller();
			scroller = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.minViewportInset = 1;
			temp.measuredSizeIncludesScrollBars = false;
			temp.viewport = textDisplay_i();
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
			temp.fill = _TextAreaSkin_SolidColor1_i();
			return temp;
		}

		private function textDisplay_i():EditableText
		{
			var temp:EditableText = new EditableText();
			temp.widthInChars = 15;
			temp.heightInLines = 10;
			textDisplay = temp;
			return temp;
		}

	}
}