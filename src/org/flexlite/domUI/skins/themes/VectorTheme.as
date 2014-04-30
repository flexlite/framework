package org.flexlite.domUI.skins.themes
{
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.skins.vector.AlertSkin;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.CheckBoxSkin;
	import org.flexlite.domUI.skins.vector.ComboBoxSkin;
	import org.flexlite.domUI.skins.vector.DropDownListSkin;
	import org.flexlite.domUI.skins.vector.HScrollBarSkin;
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	import org.flexlite.domUI.skins.vector.ItemRendererSkin;
	import org.flexlite.domUI.skins.vector.ListSkin;
	import org.flexlite.domUI.skins.vector.PageNavigatorSkin;
	import org.flexlite.domUI.skins.vector.PanelSkin;
	import org.flexlite.domUI.skins.vector.ProgressBarSkin;
	import org.flexlite.domUI.skins.vector.RadioButtonSkin;
	import org.flexlite.domUI.skins.vector.ScrollerSkin;
	import org.flexlite.domUI.skins.vector.TabBarButtonSkin;
	import org.flexlite.domUI.skins.vector.TabBarSkin;
	import org.flexlite.domUI.skins.vector.TabNavigatorSkin;
	import org.flexlite.domUI.skins.vector.TextAreaSkin;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import org.flexlite.domUI.skins.vector.TitleWindowSkin;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.domUI.skins.vector.TreeItemRendererSkin;
	import org.flexlite.domUI.skins.vector.VScrollBarSkin;
	import org.flexlite.domUI.skins.vector.VSliderSkin;
	
	
	/**
	 * Vector主题皮肤默认配置
	 * @author DOM
	 */
	public class VectorTheme extends Theme
	{
		public function VectorTheme()
		{
			super();
			apply();
		}
		
		private function apply():void
		{
			mapSkin("org.flexlite.domUI.components::Alert",AlertSkin);
			mapSkin("org.flexlite.domUI.components::Button",ButtonSkin);
			mapSkin("org.flexlite.domUI.components::CheckBox",CheckBoxSkin);
			mapSkin("org.flexlite.domUI.components::ComboBox",ComboBoxSkin);
			mapSkin("org.flexlite.domUI.components::DropDownList",DropDownListSkin);
			mapSkin("org.flexlite.domUI.components::HScrollBar",HScrollBarSkin);
			mapSkin("org.flexlite.domUI.components::HSlider",HSliderSkin);
			mapSkin("org.flexlite.domUI.components::List",ListSkin);
			mapSkin("org.flexlite.domUI.components::PageNavigator",PageNavigatorSkin);
			mapSkin("org.flexlite.domUI.components::Panel",PanelSkin);
			mapSkin("org.flexlite.domUI.components::ProgressBar",ProgressBarSkin);
			mapSkin("org.flexlite.domUI.components::RadioButton",RadioButtonSkin);
			mapSkin("org.flexlite.domUI.components::Scroller",ScrollerSkin);
			mapSkin("org.flexlite.domUI.components::TabBar",TabBarSkin);
			mapSkin("org.flexlite.domUI.components::TabBarButton",TabBarButtonSkin);
			mapSkin("org.flexlite.domUI.components::TabNavigator",TabNavigatorSkin);
			mapSkin("org.flexlite.domUI.components::TextArea",TextAreaSkin);
			mapSkin("org.flexlite.domUI.components::TextInput",TextInputSkin);
			mapSkin("org.flexlite.domUI.components::TitleWindow",TitleWindowSkin);
			mapSkin("org.flexlite.domUI.components::ToggleButton",ToggleButtonSkin);
			mapSkin("org.flexlite.domUI.components::Tree",ListSkin);
			mapSkin("org.flexlite.domUI.components.supportClasses::TreeItemRenderer",TreeItemRendererSkin);
			mapSkin("org.flexlite.domUI.components::VScrollBar",VScrollBarSkin);
			mapSkin("org.flexlite.domUI.components::VSlider",VSliderSkin);
			mapSkin("org.flexlite.domUI.components.supportClasses::ItemRenderer",ItemRendererSkin);
		}
	}
}