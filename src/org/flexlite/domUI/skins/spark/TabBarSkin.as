package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.TabBarButton;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class TabBarSkin extends SparkSkin
	{
		public var dataGroup:DataGroup;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function TabBarSkin()
		{
			super();
			
			this.elementsContent = [dataGroup_i()];
			this.currentState = "normal";
			
			states = [
				new State ({name: "normal",
					overrides: [
					]
				})
				,
				new State ({name: "disabled",
					overrides: [
						new SetProperty().initializeFromObject({
							target:"",
							name:"alpha",
							value:0.5
						})
					]
				})
			];
		}


		private function dataGroup_i():DataGroup
		{
			var temp:DataGroup = new DataGroup();
			dataGroup = temp;
			temp.percentWidth = 100;
			temp.percentHeight = 100;
			temp.itemRenderer = TabBarButton;
			return temp;
		}

	}
}