package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.RectangularDropShadow;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
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
	public class TitleWindowSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __TitleWindowSkin_GradientEntry1:GradientEntry;

		public var __TitleWindowSkin_GradientEntry2:GradientEntry;

		public var background:Rect;

		public var backgroundFill:SolidColor;

		public var border:Rect;

		public var borderStroke:SolidColorStroke;

		public var bottomGroup:Group;

		public var bottomGroupMask:Group;

		public var bottomMaskRect:Rect;

		public var closeButton:Button;

		public var contentGroup:Group;

		public var contents:Group;

		public var controlBarGroup:Group;

		public var dropShadow:RectangularDropShadow;

		public var moveArea:Group;

		public var tbDiv:Rect;

		public var tbFill:Rect;

		public var tbHilite:Rect;

		public var titleDisplay:Label;

		public var topGroup:Group;

		public var topGroupMask:Group;

		public var topMaskRect:Rect;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TitleWindowSkin()
		{
			super();
			
			this.blendMode = "normal";
			this.mouseEnabled = false;
			this.minWidth = 76;
			this.minHeight = 76;
			this.elementsContent = [dropShadow_i(),_TitleWindowSkin_Group1_i()];
			this.currentState = "normal";
			
			states = [
				new State ({name: "normal",
					overrides: [
					]
				})
				,
				new State ({name: "inactive",
					overrides: [
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
				,
				new State ({name: "normalWithControlBar",
					overrides: [
					]
				})
				,
				new State ({name: "inactiveWithControlBar",
					overrides: [
					]
				})
				,
				new State ({name: "disabledWithControlBar",
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
		private function _TitleWindowSkin_GradientEntry10_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xEDEDED;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry11_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xCDCDCD;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TitleWindowSkin_GradientEntry1 = temp;
			temp.color = 0xD2D2D2;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			__TitleWindowSkin_GradientEntry2 = temp;
			temp.color = 0x9A9A9A;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xE6E6E6;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0.22;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0.15;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0.15;
			temp.ratio = 0.44;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			temp.alpha = 0;
			temp.ratio = 0.4401;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function _TitleWindowSkin_GradientEntry9_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function _TitleWindowSkin_Group1_i():Group
		{
			var temp:Group = new Group();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.elementsContent = [topGroupMask_i(),border_i(),background_i(),contents_i()];
			return temp;
		}

		private function _TitleWindowSkin_Group2_i():Group
		{
			var temp:Group = new Group();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.mask = bottomGroupMask;
			temp.elementsContent = [_TitleWindowSkin_Rect1_i(),_TitleWindowSkin_Rect2_i(),_TitleWindowSkin_Rect3_i()];
			return temp;
		}

		private function _TitleWindowSkin_HorizontalLayout1_i():HorizontalLayout
		{
			var temp:HorizontalLayout = new HorizontalLayout();
			temp.paddingLeft = 10;
			temp.paddingRight = 10;
			temp.paddingTop = 7;
			temp.paddingBottom = 7;
			temp.gap = 10;
			return temp;
		}

		private function _TitleWindowSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_TitleWindowSkin_GradientEntry1_i(),_TitleWindowSkin_GradientEntry2_i()];
			return temp;
		}

		private function _TitleWindowSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_TitleWindowSkin_GradientEntry5_i(),_TitleWindowSkin_GradientEntry6_i(),_TitleWindowSkin_GradientEntry7_i()];
			return temp;
		}

		private function _TitleWindowSkin_LinearGradient3_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [_TitleWindowSkin_GradientEntry10_i(),_TitleWindowSkin_GradientEntry11_i()];
			return temp;
		}

		private function _TitleWindowSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_TitleWindowSkin_GradientEntry3_i(),_TitleWindowSkin_GradientEntry4_i()];
			return temp;
		}

		private function _TitleWindowSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [_TitleWindowSkin_GradientEntry8_i(),_TitleWindowSkin_GradientEntry9_i()];
			return temp;
		}

		private function _TitleWindowSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.height = 1;
			temp.alpha = 0.22;
			temp.fill = _TitleWindowSkin_SolidColor4_i();
			return temp;
		}

		private function _TitleWindowSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 1;
			temp.bottom = 0;
			temp.stroke = _TitleWindowSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function _TitleWindowSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.right = 1;
			temp.top = 2;
			temp.bottom = 1;
			temp.fill = _TitleWindowSkin_LinearGradient3_i();
			return temp;
		}

		private function _TitleWindowSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.alpha = 0;
			return temp;
		}

		private function _TitleWindowSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.alpha = 0;
			return temp;
		}

		private function _TitleWindowSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			temp.alpha = 0.75;
			return temp;
		}

		private function _TitleWindowSkin_SolidColor4_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			return temp;
		}

		private function _TitleWindowSkin_VerticalLayout1_i():VerticalLayout
		{
			var temp:VerticalLayout = new VerticalLayout();
			temp.gap = 0;
			temp.horizontalAlign = "justify";
			return temp;
		}

		private function backgroundFill_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			backgroundFill = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function background_i():Rect
		{
			var temp:Rect = new Rect();
			background = temp;
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.bottom = 1;
			temp.fill = backgroundFill_i();
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

		private function bottomGroupMask_i():Group
		{
			var temp:Group = new Group();
			bottomGroupMask = temp;
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.bottom = 1;
			temp.elementsContent = [bottomMaskRect_i()];
			return temp;
		}

		private function bottomGroup_i():Group
		{
			var temp:Group = new Group();
			bottomGroup = temp;
			temp.minWidth = 0;
			temp.minHeight = 0;
			temp.elementsContent = [_TitleWindowSkin_Group2_i(),controlBarGroup_i()];
			return temp;
		}

		private function bottomMaskRect_i():Rect
		{
			var temp:Rect = new Rect();
			bottomMaskRect = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.fill = _TitleWindowSkin_SolidColor2_i();
			return temp;
		}

		private function closeButton_i():Button
		{
			var temp:Button = new Button();
			closeButton = temp;
			temp.skinName = TitleWindowCloseButtonSkin;
			temp.width = 15;
			temp.height = 15;
			temp.right = 7;
			temp.top = 7;
			return temp;
		}

		private function contentGroup_i():Group
		{
			var temp:Group = new Group();
			contentGroup = temp;
			temp.percentWidth = 1;
			temp.percentHeight = 1;
			temp.minWidth = 0;
			temp.minHeight = 0;
			return temp;
		}

		private function contents_i():Group
		{
			var temp:Group = new Group();
			contents = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.layout = _TitleWindowSkin_VerticalLayout1_i();
			temp.elementsContent = [topGroup_i(),contentGroup_i()];
			return temp;
		}

		private function controlBarGroup_i():Group
		{
			var temp:Group = new Group();
			controlBarGroup = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 1;
			temp.bottom = 1;
			temp.minWidth = 0;
			temp.minHeight = 0;
			temp.layout = _TitleWindowSkin_HorizontalLayout1_i();
			return temp;
		}

		private function dropShadow_i():RectangularDropShadow
		{
			var temp:RectangularDropShadow = new RectangularDropShadow();
			dropShadow = temp;
			temp.blurX = 20;
			temp.blurY = 20;
			temp.alpha = 0.32;
			temp.distance = 11;
			temp.angle = 90;
			temp.color = 0x000000;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			return temp;
		}

		private function moveArea_i():Group
		{
			var temp:Group = new Group();
			moveArea = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			return temp;
		}

		private function tbDiv_i():Rect
		{
			var temp:Rect = new Rect();
			tbDiv = temp;
			temp.left = 0;
			temp.right = 0;
			temp.height = 1;
			temp.bottom = 0;
			temp.fill = _TitleWindowSkin_SolidColor3_i();
			return temp;
		}

		private function tbFill_i():Rect
		{
			var temp:Rect = new Rect();
			tbFill = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 1;
			temp.fill = _TitleWindowSkin_LinearGradient1_i();
			return temp;
		}

		private function tbHilite_i():Rect
		{
			var temp:Rect = new Rect();
			tbHilite = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.stroke = _TitleWindowSkin_LinearGradientStroke1_i();
			temp.fill = _TitleWindowSkin_LinearGradient2_i();
			return temp;
		}

		private function titleDisplay_i():Label
		{
			var temp:Label = new Label();
			titleDisplay = temp;
			temp.maxDisplayedLines = 1;
			temp.left = 9;
			temp.right = 36;
			temp.top = 1;
			temp.bottom = 0;
			temp.minHeight = 30;
			temp.verticalAlign = "middle";
			temp.bold = true;
			return temp;
		}

		private function topGroupMask_i():Group
		{
			var temp:Group = new Group();
			topGroupMask = temp;
			temp.left = 1;
			temp.top = 1;
			temp.right = 1;
			temp.bottom = 1;
			temp.elementsContent = [topMaskRect_i()];
			return temp;
		}

		private function topGroup_i():Group
		{
			var temp:Group = new Group();
			topGroup = temp;
			temp.mask = topGroupMask;
			temp.elementsContent = [tbFill_i(),tbHilite_i(),tbDiv_i(),titleDisplay_i(),moveArea_i(),closeButton_i()];
			return temp;
		}

		private function topMaskRect_i():Rect
		{
			var temp:Rect = new Rect();
			topMaskRect = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.fill = _TitleWindowSkin_SolidColor1_i();
			return temp;
		}

	}
}