package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class SpinnerSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var decrementButton:Button;

		public var incrementButton:Button;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function SpinnerSkin()
		{
			super();
			
			this.minHeight = 23;
			this.minWidth = 12;
			this.elementsContent = [incrementButton_i(),decrementButton_i()];
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


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function decrementButton_i():Button
		{
			var temp:Button = new Button();
			decrementButton = temp;
			temp.left = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.percentHeight = 50;
			temp.tabEnabled = false;
			temp.skinName = SpinnerDecrementButtonSkin;
			return temp;
		}

		private function incrementButton_i():Button
		{
			var temp:Button = new Button();
			incrementButton = temp;
			temp.left = 0;
			temp.right = 0;
			temp.top = 0;
			temp.percentHeight = 50;
			temp.tabEnabled = false;
			temp.skinName = SpinnerIncrementButtonSkin;
			return temp;
		}

	}
}