package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.PopUpAnchor;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.core.DeferredInstanceFromFunction;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.RectangularDropShadow;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;
	

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class ComboBoxSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var background:Rect;

		public var bgFill:SolidColor;

		public var border:Rect;

		public var borderStroke:SolidColorStroke;

		public var dataGroup:DataGroup;

		public var dropDown:Group;

		public var dropShadow:RectangularDropShadow;

		public var openButton:Button;

		public var popUp:PopUpAnchor;

		public var scroller:Scroller;

		public var textInput:TextInput;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ComboBoxSkin()
		{
			super();
			
			this.elementsContent = [openButton_i(),textInput_i()];
			this.currentState = "normal";
			
			var popUp_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(popUp_i);
			
			states = [
				new State ({name: "normal",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"popUp",
							name:"displayPopUp",
							value:false
						})
					]
				})
				,
				new State ({name: "open",
					overrides: [
						new AddItems().initializeFromObject({
							targetFactory:popUp_factory,
							propertyName:"",
							position:"before",
							relativeTo:"openButton"
						})
						,
						new SetProperty().initializeFromObject({
							target:"popUp",
							name:"displayPopUp",
							value:true
						})
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"textInput",
							name:"enabled",
							value:false
						})
						,
						new SetProperty().initializeFromObject({
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
		private function _ComboBoxSkin_VerticalLayout1_i():VerticalLayout
		{
			var temp:VerticalLayout = new VerticalLayout();
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
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

		private function dataGroup_i():DataGroup
		{
			var temp:DataGroup = new DataGroup();
			dataGroup = temp;
			temp.itemRenderer = ItemRenderer;
			temp.layout = _ComboBoxSkin_VerticalLayout1_i();
			return temp;
		}

		private function dropDown_i():Group
		{
			var temp:Group = new Group();
			dropDown = temp;
			temp.elementsContent = [dropShadow_i(),border_i(),background_i(),scroller_i()];
			return temp;
		}

		private function dropShadow_i():RectangularDropShadow
		{
			var temp:RectangularDropShadow = new RectangularDropShadow();
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

		private function openButton_i():Button
		{
			var temp:Button = new Button();
			openButton = temp;
			temp.width = 19;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.skinName = ComboBoxButtonSkin;
			temp.tabEnabled = false;
			return temp;
		}

		private function popUp_i():PopUpAnchor
		{
			var temp:PopUpAnchor = new PopUpAnchor();
			popUp = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.bottom = 0;
			temp.popUpPosition = "above";
			temp.popUpWidthMatchesAnchorWidth = true;
			temp.popUp = dropDown_i();
			return temp;
		}

		private function scroller_i():Scroller
		{
			var temp:Scroller = new Scroller();
			scroller = temp;
			temp.left = 0;
//			temp.top = 0;
			temp.right = 0;
//			temp.bottom = 0;
			temp.height = 100;
			temp.minViewportInset = 1;
			temp.viewport = dataGroup_i();
			return temp;
		}

		private function textInput_i():TextInput
		{
			var temp:TextInput = new TextInput();
			textInput = temp;
			temp.left = 0;
			temp.right = 18;
			temp.top = 0;
			temp.bottom = 0;
			return temp;
		}

	}
}