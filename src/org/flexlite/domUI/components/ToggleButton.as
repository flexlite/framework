package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.ToggleButtonBase;
	
	[DXML(show="true")]
	/**
	 * 切换按钮
	 * @author DOM
	 */	
	public class ToggleButton extends ToggleButtonBase
	{
		/**
		 * 构造函数
		 */		
		public function ToggleButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ToggleButton;
		}
	}
}
