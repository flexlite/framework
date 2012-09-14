<<<<<<< HEAD
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class SoftLightShader extends flash.display.Shader
	{
		[Embed(source="SoftLight.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function SoftLightShader()
		{
			super(new ShaderClass());
		}
	}
}
=======
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class SoftLightShader extends flash.display.Shader
	{
		[Embed(source="SoftLight.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function SoftLightShader()
		{
			super(new ShaderClass());
		}
	}
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
