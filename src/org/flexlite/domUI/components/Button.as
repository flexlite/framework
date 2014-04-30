package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.ButtonBase;
	
	use namespace dx_internal;
	
	
	[DXML(show="true")]
	
	/**
	 * 按钮控件
	 * @author DOM
	 */	
	public class Button extends ButtonBase
	{
		public function Button()
		{
			super();
		}   
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Button;
		}
	}
}
