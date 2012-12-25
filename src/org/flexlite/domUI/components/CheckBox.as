package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.ToggleButtonBase;
	
	[DXML(show="true")]	
	
	/**
	 * 复选框
	 * @author DOM
	 */	
	public class CheckBox extends ToggleButtonBase
	{
		/**
		 * 构造函数
		 */		
		public function CheckBox()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return CheckBox;
		}
	}
	
}
