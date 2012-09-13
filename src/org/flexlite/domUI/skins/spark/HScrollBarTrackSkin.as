package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.states.State;
	
	/**
	 * 水平滚动条轨道默认皮肤
	 * @author DOM
	 */
	public class HScrollBarTrackSkin extends SparkSkin
	{
		
		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function HScrollBarTrackSkin()
		{
			super();
			
			this.elementsContent = [_HScrollBarTrackSkin_Rect1_i(),_HScrollBarTrackSkin_Rect2_i(),_HScrollBarTrackSkin_Rect3_i(),_HScrollBarTrackSkin_Rect4_i(),_HScrollBarTrackSkin_Rect5_i()];
			this.currentState = "up";
			
			states = [
				new State ({name: "up",
					overrides: [
					]
				})
				,
				new State ({name: "down",
					overrides: [
					]
				})
				,
				new State ({name: "over",
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
		
		
		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function _HScrollBarTrackSkin_Rect1_i():Rect
		{
			var temp:Rect = new Rect();
			temp.top = 0;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.minWidth = 14;
			temp.minHeight = 14;
			temp.stroke = _HScrollBarTrackSkin_SolidColorStroke1_i();
			temp.fill = _HScrollBarTrackSkin_SolidColor1_i();
			return temp;
		}
		
		private function _HScrollBarTrackSkin_Rect2_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.right = 1;
			temp.top = 1;
			temp.height = 1;
			temp.fill = _HScrollBarTrackSkin_SolidColor2_i();
			return temp;
		}
		
		private function _HScrollBarTrackSkin_Rect3_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.right = 1;
			temp.top = 2;
			temp.height = 1;
			temp.fill = _HScrollBarTrackSkin_SolidColor3_i();
			return temp;
		}
		
		private function _HScrollBarTrackSkin_Rect4_i():Rect
		{
			var temp:Rect = new Rect();
			temp.left = 1;
			temp.top = 2;
			temp.bottom = 1;
			temp.width = 2;
			temp.fill = _HScrollBarTrackSkin_SolidColor4_i();
			return temp;
		}
		
		private function _HScrollBarTrackSkin_Rect5_i():Rect
		{
			var temp:Rect = new Rect();
			temp.right = 1;
			temp.top = 2;
			temp.bottom = 1;
			temp.width = 3;
			temp.fill = _HScrollBarTrackSkin_SolidColor5_i();
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColor1_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0xCACACA;
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColor2_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x989898;
			temp.alpha = 0.5;
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColor3_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x989898;
			temp.alpha = 0.25;
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColor4_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x989898;
			temp.alpha = 0.25;
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColor5_i():SolidColor
		{
			var temp:SolidColor = new SolidColor();
			temp.color = 0x989898;
			temp.alpha = 0.25;
			return temp;
		}
		
		private function _HScrollBarTrackSkin_SolidColorStroke1_i():SolidColorStroke
		{
			var temp:SolidColorStroke = new SolidColorStroke();
			temp.color = 0x686868;
			temp.weight = 1;
			return temp;
		}
		
	}
}