package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class ColorBurnShader extends flash.display.Shader
	{
		[Embed(source="ColorBurn.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function ColorBurnShader()
		{
			super(new ShaderClass());
		}
		
	}
}
