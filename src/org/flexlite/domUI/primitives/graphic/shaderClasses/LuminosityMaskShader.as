package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	
	public class LuminosityMaskShader extends Shader
	{
		[Embed(source="LuminosityMaskFilter.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function LuminosityMaskShader()
		{
			super(new ShaderClass());
		}
		public function get mode():int
		{
			return this.data.mode.value;
		}
		
		public function set mode(v:int):void
		{
			if (mode ==-1)
				return; 
			this.data.mode.value=[v];
		}
	}
}
