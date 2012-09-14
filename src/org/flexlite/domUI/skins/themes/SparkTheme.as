<<<<<<< HEAD
package org.flexlite.domUI.skins.themes
{
	import org.flexlite.domUI.managers.InjectorManager;
	import org.flexlite.domUI.managers.injectorClass.SkinInjector;
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
	import org.flexlite.domUI.skins.spark.PanelSkin;
	import org.flexlite.domUI.skins.spark.ScrollerSkin;
	import org.flexlite.domUI.skins.spark.SpinnerSkin;
	import org.flexlite.domUI.skins.spark.TabBarButtonSkin;
	import org.flexlite.domUI.skins.spark.TabBarSkin;
	import org.flexlite.domUI.skins.spark.TextAreaSkin;
	import org.flexlite.domUI.skins.spark.TextInputSkin;
	import org.flexlite.domUI.skins.spark.ToggleButtonSkin;
	import org.flexlite.domUI.skins.spark.VScrollBarSkin;
	import org.flexlite.domUI.skins.spark.VSliderSkin;
	
	/**
	 * Spark主题皮肤默认配置
	 * @author DOM
	 */
	public class SparkTheme
	{
		public function SparkTheme()
		{
		}
		
		public static function apply():void
		{
			var injector:SkinInjector = InjectorManager.skinInjector;
			injector.mapSkin("org.flexlite.domUI.components::Button",ButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::HScrollBar",HScrollBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::Image",ImageSkin);
			injector.mapSkin("org.flexlite.domUI.components::List",ListSkin);
			injector.mapSkin("org.flexlite.domUI.components::Scroller",ScrollerSkin);
			injector.mapSkin("org.flexlite.domUI.components::TextArea",TextAreaSkin);
			injector.mapSkin("org.flexlite.domUI.components::TextInput",TextInputSkin);
			injector.mapSkin("org.flexlite.domUI.components::VScrollBar",VScrollBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::ComboBox",ComboBoxSkin);
			injector.mapSkin("org.flexlite.domUI.components::DropDownList",DropDownListSkin);
			injector.mapSkin("org.flexlite.domUI.components::HSlider",HSliderSkin);
			injector.mapSkin("org.flexlite.domUI.components::VSlider",VSliderSkin);
			injector.mapSkin("org.flexlite.domUI.components::Spinner",SpinnerSkin);
			injector.mapSkin("org.flexlite.domUI.components::NumericStepper",NumericStepperSkin);
			injector.mapSkin("org.flexlite.domUI.components.supportClasses::ItemRenderer",ItemRendererSkin);
			injector.mapSkin("org.flexlite.domUI.components::TabBarButton",ToggleButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::ToggleButton",ToggleButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::CheckBox",CheckBoxSkin);
			injector.mapSkin("org.flexlite.domUI.components::TabBar",TabBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::Panel",PanelSkin);
		}
	}
=======
package org.flexlite.domUI.skins.themes
{
	import org.flexlite.domUI.managers.InjectorManager;
	import org.flexlite.domUI.managers.injectorClass.SkinInjector;
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
	import org.flexlite.domUI.skins.spark.PanelSkin;
	import org.flexlite.domUI.skins.spark.ScrollerSkin;
	import org.flexlite.domUI.skins.spark.SpinnerSkin;
	import org.flexlite.domUI.skins.spark.TabBarButtonSkin;
	import org.flexlite.domUI.skins.spark.TabBarSkin;
	import org.flexlite.domUI.skins.spark.TextAreaSkin;
	import org.flexlite.domUI.skins.spark.TextInputSkin;
	import org.flexlite.domUI.skins.spark.ToggleButtonSkin;
	import org.flexlite.domUI.skins.spark.VScrollBarSkin;
	import org.flexlite.domUI.skins.spark.VSliderSkin;
	
	/**
	 * Spark主题皮肤默认配置
	 * @author DOM
	 */
	public class SparkTheme
	{
		public function SparkTheme()
		{
		}
		
		public static function apply():void
		{
			var injector:SkinInjector = InjectorManager.skinInjector;
			injector.mapSkin("org.flexlite.domUI.components::Button",ButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::HScrollBar",HScrollBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::Image",ImageSkin);
			injector.mapSkin("org.flexlite.domUI.components::List",ListSkin);
			injector.mapSkin("org.flexlite.domUI.components::Scroller",ScrollerSkin);
			injector.mapSkin("org.flexlite.domUI.components::TextArea",TextAreaSkin);
			injector.mapSkin("org.flexlite.domUI.components::TextInput",TextInputSkin);
			injector.mapSkin("org.flexlite.domUI.components::VScrollBar",VScrollBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::ComboBox",ComboBoxSkin);
			injector.mapSkin("org.flexlite.domUI.components::DropDownList",DropDownListSkin);
			injector.mapSkin("org.flexlite.domUI.components::HSlider",HSliderSkin);
			injector.mapSkin("org.flexlite.domUI.components::VSlider",VSliderSkin);
			injector.mapSkin("org.flexlite.domUI.components::Spinner",SpinnerSkin);
			injector.mapSkin("org.flexlite.domUI.components::NumericStepper",NumericStepperSkin);
			injector.mapSkin("org.flexlite.domUI.components.supportClasses::ItemRenderer",ItemRendererSkin);
			injector.mapSkin("org.flexlite.domUI.components::TabBarButton",ToggleButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::ToggleButton",ToggleButtonSkin);
			injector.mapSkin("org.flexlite.domUI.components::CheckBox",CheckBoxSkin);
			injector.mapSkin("org.flexlite.domUI.components::TabBar",TabBarSkin);
			injector.mapSkin("org.flexlite.domUI.components::Panel",PanelSkin);
		}
	}
>>>>>>> master
}