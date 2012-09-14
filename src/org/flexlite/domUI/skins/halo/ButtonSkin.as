package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.skins.InvisibleSkin;
	
	
	
	/**
	 * 按钮默认皮肤
	 * @author DOM
	 */
	public class ButtonSkin extends InvisibleSkin
	{
		public function ButtonSkin()
		{
			super();
			states = ["up","over","down"];
		}
		
		
		public function get overSkin():Object
		{
			return getSkinForState("over");
		}

		public function set overSkin(value:Object):void
		{
			setSkinForState("over",value);
		}

		
		public function get upSkin():Object
		{
			return getSkinForState("up");
		}

		public function set upSkin(value:Object):void
		{
			setSkinForState("up",value);
		}

		
		public function get downSkin():Object
		{
			return getSkinForState("down");
		}

		public function set downSkin(value:Object):void
		{
			setSkinForState("down",value);
		}

		
	}
}