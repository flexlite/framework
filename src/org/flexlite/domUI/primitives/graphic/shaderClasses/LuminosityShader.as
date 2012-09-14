<<<<<<< HEAD
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class LuminosityShader extends flash.display.Shader
	{
		[Embed(source="Luminosity.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function LuminosityShader()
		{
			super(new ShaderClass());
		}
	}
}
=======
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class LuminosityShader extends flash.display.Shader
	{
		[Embed(source="Luminosity.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function LuminosityShader()
		{
			super(new ShaderClass());
		}
	}
}
>>>>>>> master
