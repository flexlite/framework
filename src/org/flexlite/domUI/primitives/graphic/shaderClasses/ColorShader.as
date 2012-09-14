package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class ColorShader extends flash.display.Shader
	{
		[Embed(source="Color.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function ColorShader()
		{
			super(new ShaderClass());
		}
		
	}
}
