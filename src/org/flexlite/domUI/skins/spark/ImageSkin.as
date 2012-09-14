package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.primitives.BitmapImage;
	import org.flexlite.domUI.states.SetProperty;
<<<<<<< HEAD
	import org.flexlite.domUI.states.State;
=======
	import org.flexlite.domUI.states.State;
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be

	/**
	 * 图片控件默认皮肤
	 * @author DOM
	 */
	public class ImageSkin extends SparkSkin
	{
		/**
		 * 实体图片显示对象 
		 */		
		public var imageDisplay:BitmapImage;

		/**
		 * 构造函数
		 */		
		public function ImageSkin()
		{
			super();
			
			this.elementsContent = [imageDisplay_i()];
			this.currentState = "ready";
			
			states = [
				new State ({name: "ready",
					overrides: [
					]
				})
				,
				new State ({name: "invalid",
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

		/**
		 * 初始化实体图片显示对象
		 */		
		private function imageDisplay_i():BitmapImage
		{
			var temp:BitmapImage = new BitmapImage();
			imageDisplay = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			return temp;
		}

	}
}