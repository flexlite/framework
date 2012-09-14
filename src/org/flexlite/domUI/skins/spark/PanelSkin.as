package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.RectangularDropShadow;
	import org.flexlite.domUI.primitives.graphic.GradientEntry;
	import org.flexlite.domUI.primitives.graphic.LinearGradient;
	import org.flexlite.domUI.primitives.graphic.LinearGradientStroke;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class PanelSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var background:Rect;

		public var backgroundFill:SolidColor;

		public var border:Rect;

		public var borderStroke:SolidColorStroke;

		public var bottomGroup:Group;

		public var bottomGroupMask:Group;

		public var bottomMaskRect:Rect;

		public var contentGroup:Group;

		public var contents:Group;

		public var controlBarGroup:Group;

		public var dropShadow:RectangularDropShadow;

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
		public function PanelSkin()
		{
			super();
			
			this.blendMode = "normal";
			this.mouseEnabled = false;
			this.minWidth = 131;
			this.minHeight = 127;
			this.elementsContent = [dropShadow_i(),__PanelSkin_Group1_i()];
			this.currentState = "normal";
			
			var bottomGroupMask_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(bottomGroupMask_i);
			var bottomGroup_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(bottomGroup_i);
			
			states = [
				new State ({name: "normal",
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
		private function __PanelSkin_GradientEntry1_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xE2E2E2;
			return temp;
		}

		private function __PanelSkin_GradientEntry2_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xD9D9D9;
			return temp;
		}

		private function __PanelSkin_GradientEntry3_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xEAEAEA;
			return temp;
		}

		private function __PanelSkin_GradientEntry4_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xD9D9D9;
			return temp;
		}

		private function __PanelSkin_GradientEntry5_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xE5E5E5;
			return temp;
		}

		private function __PanelSkin_GradientEntry6_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xD8D8D8;
			return temp;
		}

		private function __PanelSkin_GradientEntry7_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xDADADA;
			return temp;
		}

		private function __PanelSkin_GradientEntry8_i():GradientEntry
		{
			var temp:GradientEntry = new GradientEntry();
			temp.color = 0xC5C5C5;
			return temp;
		}

		private function __PanelSkin_Group1_i():Group
		{
			var temp:Group = new Group();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.elementsContent = [topGroupMask_i(),border_i(),background_i(),contents_i()];
			return temp;
		}

		private function __PanelSkin_Group2_i():Group
		{
			var temp:Group = new Group();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.mask = bottomGroupMask;
			temp.elementsContent = [__PanelSkin_Rect1_i(),__PanelSkin_Rect2_i(),__PanelSkin_Rect3_i()];
			return temp;
		}

		private function __PanelSkin_HorizontalLayout1_i():HorizontalLayout
		{
			var temp:HorizontalLayout = new HorizontalLayout();
			temp.paddingLeft = 10;
			temp.paddingRight = 10;
			temp.paddingTop = 7;
			temp.paddingBottom = 7;
			temp.gap = 10;
			return temp;
		}

		private function __PanelSkin_LinearGradient1_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [__PanelSkin_GradientEntry1_i(),__PanelSkin_GradientEntry2_i()];
			return temp;
		}

		private function __PanelSkin_LinearGradient2_i():LinearGradient
		{
			var temp:LinearGradient = new LinearGradient();
			temp.rotation = 90;
			temp.entries = [__PanelSkin_GradientEntry7_i(),__PanelSkin_GradientEntry8_i()];
			return temp;
		}

		private function __PanelSkin_LinearGradientStroke1_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__PanelSkin_GradientEntry3_i(),__PanelSkin_GradientEntry4_i()];
			return temp;
		}

		private function __PanelSkin_LinearGradientStroke2_i():LinearGradientStroke
		{
			var temp:LinearGradientStroke = new LinearGradientStroke();
			temp.rotation = 90;
			temp.weight = 1;
			temp.entries = [__PanelSkin_GradientEntry5_i(),__PanelSkin_GradientEntry6_i()];
			return temp;
		}

		private function __PanelSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.height = 1;
			temp.alpha = 0.22;
			temp.fill = __PanelSkin_SolidColor4_i();
			return temp;
		}

		private function __PanelSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 0;
			temp.right = 0;
			temp.top = 1;
			temp.bottom = 0;
			temp.stroke = __PanelSkin_LinearGradientStroke2_i();
			return temp;
		}

		private function __PanelSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.right = 1;
			temp.top = 2;
			temp.bottom = 1;
			temp.fill = __PanelSkin_LinearGradient2_i();
			return temp;
		}

		private function __PanelSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.alpha = 0;
			return temp;
		}

		private function __PanelSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.alpha = 0;
			return temp;
		}

		private function __PanelSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0xC0C0C0;
			return temp;
		}

		private function __PanelSkin_SolidColor4_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x000000;
			return temp;
		}

		private function __PanelSkin_VerticalLayout1_i():VerticalLayout
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
			temp.elementsContent = [__PanelSkin_Group2_i(),controlBarGroup_i()];
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
			temp.fill = __PanelSkin_SolidColor2_i();
			return temp;
		}

		private function contentGroup_i():Group
		{
			var temp:Group = new Group();
			contentGroup = temp;
			temp.percentWidth = 100;
			temp.percentHeight = 100;
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
			temp.layout = __PanelSkin_VerticalLayout1_i();
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
			temp.layout = __PanelSkin_HorizontalLayout1_i();
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

		private function tbDiv_i():Rect
		{
			var temp:Rect = new Rect();
			tbDiv = temp;
			temp.left = 0;
			temp.right = 0;
			temp.height = 1;
			temp.bottom = 0;
			temp.fill = __PanelSkin_SolidColor3_i();
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
			temp.fill = __PanelSkin_LinearGradient1_i();
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
			temp.stroke = __PanelSkin_LinearGradientStroke1_i();
			return temp;
		}

		private function titleDisplay_i():Label
		{
			var temp:Label = new Label();
			titleDisplay = temp;
			temp.maxDisplayedLines = 1;
			temp.left = 9;
			temp.right = 3;
			temp.top = 1;
			temp.bottom = 0;
			temp.minHeight = 30;
			temp.verticalAlign = "middle";
			temp.textAlign = "left";
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
			temp.elementsContent = [tbFill_i(),tbHilite_i(),tbDiv_i(),titleDisplay_i()];
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
			temp.fill = __PanelSkin_SolidColor1_i();
			return temp;
		}

	}
}