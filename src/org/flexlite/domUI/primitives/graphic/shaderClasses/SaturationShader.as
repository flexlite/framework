package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class SaturationShader extends flash.display.Shader
	{
		[Embed(source="Saturation.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function SaturationShader()
		{
			super(new ShaderClass());
		}
	}
}
