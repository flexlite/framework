<<<<<<< HEAD
package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.State;
	
	/**
	 * 项呈示器基类皮肤
	 * @author DOM
	 */
	public class ItemRendererSkin extends SparkSkin
	{
		public function ItemRendererSkin()
		{
			super();
			states = [
				new State ({name: "up",
					overrides: [
					]
				})
				,
				new State ({name: "over",
					overrides: [
					]
				})
				,
				new State ({name: "down",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
					]
				})
			];
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label;
			this.addElement(labelDisplay);
		}
	}
=======
package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.State;
	
	/**
	 * 项呈示器基类皮肤
	 * @author DOM
	 */
	public class ItemRendererSkin extends SparkSkin
	{
		public function ItemRendererSkin()
		{
			super();
			states = [
				new State ({name: "up",
					overrides: [
					]
				})
				,
				new State ({name: "over",
					overrides: [
					]
				})
				,
				new State ({name: "down",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
					]
				})
			];
		}
		
		public var labelDisplay:Label;
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label;
			this.addElement(labelDisplay);
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}