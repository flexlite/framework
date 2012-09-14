package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class ExclusionShader extends flash.display.Shader
	{
		[Embed(source="Exclusion.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function ExclusionShader()
		{
			super(new ShaderClass());
		}
		
	}
}
