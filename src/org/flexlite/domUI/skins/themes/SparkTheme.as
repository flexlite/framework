package org.flexlite.domUI.skins.themes
{
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.skins.spark.ButtonSkin;
	import org.flexlite.domUI.skins.spark.CheckBoxSkin;
	import org.flexlite.domUI.skins.spark.ComboBoxSkin;
	import org.flexlite.domUI.skins.spark.DropDownListSkin;
	import org.flexlite.domUI.skins.spark.HScrollBarSkin;
	import org.flexlite.domUI.skins.spark.HSliderSkin;
	import org.flexlite.domUI.skins.spark.ImageSkin;
	import org.flexlite.domUI.skins.spark.ItemRendererSkin;
	import org.flexlite.domUI.skins.spark.ListSkin;
	import org.flexlite.domUI.skins.spark.NumericStepperSkin;
	import org.flexlite.domUI.skins.spark.PageNavigatorSkin;
	import org.flexlite.domUI.skins.spark.PanelSkin;
	import org.flexlite.domUI.skins.spark.ScrollerSkin;
	import org.flexlite.domUI.skins.spark.SpinnerSkin;
	import org.flexlite.domUI.skins.spark.TabBarButtonSkin;
	import org.flexlite.domUI.skins.spark.TabBarSkin;
	import org.flexlite.domUI.skins.spark.TextAreaSkin;
	import org.flexlite.domUI.skins.spark.TextInputSkin;
	import org.flexlite.domUI.skins.spark.TitleWindowSkin;
	import org.flexlite.domUI.skins.spark.ToggleButtonSkin;
	import org.flexlite.domUI.skins.spark.VScrollBarSkin;
	import org.flexlite.domUI.skins.spark.VSliderSkin;
	
	/**
	 * Spark主题皮肤默认配置
	 * @author DOM
	 */
	public class SparkTheme extends Theme
	{
		public function SparkTheme()
		{
			super();
			apply();
		}
		
		public function apply():void
		{
			mapSkin("org.flexlite.domUI.components::Button",ButtonSkin);
			mapSkin("org.flexlite.domUI.components::HScrollBar",HScrollBarSkin);
			mapSkin("org.flexlite.domUI.components::Image",ImageSkin);
			mapSkin("org.flexlite.domUI.components::List",ListSkin);
			mapSkin("org.flexlite.domUI.components::Scroller",ScrollerSkin);
			mapSkin("org.flexlite.domUI.components::PageNavigator",PageNavigatorSkin);
			mapSkin("org.flexlite.domUI.components::TextArea",TextAreaSkin);
			mapSkin("org.flexlite.domUI.components::TextInput",TextInputSkin);
			mapSkin("org.flexlite.domUI.components::VScrollBar",VScrollBarSkin);
			mapSkin("org.flexlite.domUI.components::ComboBox",ComboBoxSkin);
			mapSkin("org.flexlite.domUI.components::DropDownList",DropDownListSkin);
			mapSkin("org.flexlite.domUI.components::HSlider",HSliderSkin);
			mapSkin("org.flexlite.domUI.components::VSlider",VSliderSkin);
			mapSkin("org.flexlite.domUI.components::Spinner",SpinnerSkin);
			mapSkin("org.flexlite.domUI.components::NumericStepper",NumericStepperSkin);
			mapSkin("org.flexlite.domUI.components.supportClasses::ItemRenderer",ItemRendererSkin);
			mapSkin("org.flexlite.domUI.components::TabBarButton",TabBarButtonSkin);
			mapSkin("org.flexlite.domUI.components::ToggleButton",ToggleButtonSkin);
			mapSkin("org.flexlite.domUI.components::CheckBox",CheckBoxSkin);
			mapSkin("org.flexlite.domUI.components::TabBar",TabBarSkin);
			mapSkin("org.flexlite.domUI.components::Panel",PanelSkin);
			mapSkin("org.flexlite.domUI.components::TitleWindow",TitleWindowSkin);
		}
	}
}