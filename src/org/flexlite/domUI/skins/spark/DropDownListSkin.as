package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.PopUpAnchor;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.RectangularDropShadow;
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
	public class DropDownListSkin extends org.flexlite.domUI.skins.SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var background:org.flexlite.domUI.primitives.Rect;

		public var bgFill:org.flexlite.domUI.primitives.graphic.SolidColor;

		public var border:org.flexlite.domUI.primitives.Rect;

		public var borderStroke:org.flexlite.domUI.primitives.graphic.SolidColorStroke;

		public var dataGroup:org.flexlite.domUI.components.DataGroup;

		public var dropDown:org.flexlite.domUI.components.Group;

		public var dropShadow:org.flexlite.domUI.primitives.RectangularDropShadow;

		public var labelDisplay:org.flexlite.domUI.components.Label;

		public var openButton:org.flexlite.domUI.components.Button;

		public var popUp:org.flexlite.domUI.components.PopUpAnchor;

		public var scroller:org.flexlite.domUI.components.Scroller;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function DropDownListSkin()
		{
			super();
			
			this.elementsContent = [openButton_i(),labelDisplay_i()];
			this.currentState = "normal";
			
			var popUp_factory:org.flexlite.domUI.core.DeferredInstanceFromFunction = new org.flexlite.domUI.core.DeferredInstanceFromFunction(popUp_i);
			
			states = [
				new org.flexlite.domUI.states.State ({name: "normal",
					overrides: [
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"popUp",
							name:"displayPopUp",
							value:false
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "open",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							targetFactory:popUp_factory,
							propertyName:"",
							position:"before",
							relativeTo:"openButton"
						})
						,
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"popUp",
							name:"displayPopUp",
							value:true
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabled",
					overrides: [
						new org.flexlite.domUI.states.SetProperty().initializeFromObject({
							target:"",
							name:"alpha",
							value:.5
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __DropDownListSkin_VerticalLayout1_i():org.flexlite.domUI.layouts.VerticalLayout
		{
			var temp:org.flexlite.domUI.layouts.VerticalLayout = new org.flexlite.domUI.layouts.VerticalLayout();
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			return temp;
		}

		private function background_i():org.flexlite.domUI.primitives.Rect
		{
			var temp:org.flexlite.domUI.primitives.Rect = new org.flexlite.domUI.primitives.Rect();
			background = temp;
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.bottom = 1;
			temp.fill = bgFill_i();
			return temp;
		}

		private function bgFill_i():org.flexlite.domUI.primitives.graphic.SolidColor
		{
			var temp:org.flexlite.domUI.primitives.graphic.SolidColor = new org.flexlite.domUI.primitives.graphic.SolidColor();
			bgFill = temp;
			temp.color = 0xFFFFFF;
			return temp;
		}

		private function borderStroke_i():org.flexlite.domUI.primitives.graphic.SolidColorStroke
		{
			var temp:org.flexlite.domUI.primitives.graphic.SolidColorStroke = new org.flexlite.domUI.primitives.graphic.SolidColorStroke();
			borderStroke = temp;
			temp.weight = 1;
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
			temp.stroke = borderStroke_i();
			return temp;
		}

		private function dataGroup_i():org.flexlite.domUI.components.DataGroup
		{
			var temp:org.flexlite.domUI.components.DataGroup = new org.flexlite.domUI.components.DataGroup();
			dataGroup = temp;
			temp.layout = __DropDownListSkin_VerticalLayout1_i();
			return temp;
		}

		private function dropDown_i():org.flexlite.domUI.components.Group
		{
			var temp:org.flexlite.domUI.components.Group = new org.flexlite.domUI.components.Group();
			dropDown = temp;
			temp.elementsContent = [dropShadow_i(),border_i(),background_i(),scroller_i()];
			return temp;
		}

		private function dropShadow_i():org.flexlite.domUI.primitives.RectangularDropShadow
		{
			var temp:org.flexlite.domUI.primitives.RectangularDropShadow = new org.flexlite.domUI.primitives.RectangularDropShadow();
			dropShadow = temp;
			temp.blurX = 20;
			temp.blurY = 20;
			temp.alpha = 0.45;
			temp.distance = 7;
			temp.angle = 90;
			temp.color = 0x000000;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			return temp;
		}

		private function labelDisplay_i():org.flexlite.domUI.components.Label
		{
			var temp:org.flexlite.domUI.components.Label = new org.flexlite.domUI.components.Label();
			labelDisplay = temp;
			temp.verticalAlign = "middle";
			temp.maxDisplayedLines = 1;
			temp.mouseEnabled = false;
			temp.mouseChildren = false;
			temp.left = 7;
			temp.right = 30;
			temp.top = 2;
			temp.bottom = 2;
			temp.width = 75;
			temp.verticalCenter = 1;
			return temp;
		}

		private function openButton_i():org.flexlite.domUI.components.Button
		{
			var temp:org.flexlite.domUI.components.Button = new org.flexlite.domUI.components.Button();
			openButton = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.tabEnabled = false;
			temp.skinName = DropDownListButtonSkin;
			return temp;
		}

		private function popUp_i():org.flexlite.domUI.components.PopUpAnchor
		{
			var temp:org.flexlite.domUI.components.PopUpAnchor = new org.flexlite.domUI.components.PopUpAnchor();
			popUp = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.popUpPosition = "below";
			temp.popUpWidthMatchesAnchorWidth = true;
			temp.popUp = dropDown_i();
			return temp;
		}

		private function scroller_i():org.flexlite.domUI.components.Scroller
		{
			var temp:org.flexlite.domUI.components.Scroller = new org.flexlite.domUI.components.Scroller();
			scroller = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.minViewportInset = 1;
			temp.viewport = dataGroup_i();
			return temp;
		}

	}
}