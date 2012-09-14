<<<<<<< HEAD
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class HueShader extends flash.display.Shader
	{
		[Embed(source="Hue.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function HueShader()
		{
			super(new ShaderClass());
		}
		
	}
}
=======
package org.flexlite.domUI.primitives.graphic.shaderClasses
{
	import flash.display.Shader;
	public class HueShader extends flash.display.Shader
	{
		[Embed(source="Hue.pbj", mimeType="application/octet-stream")]
		private static var ShaderClass:Class;
		public function HueShader()
		{
			super(new ShaderClass());
		}
		
	}
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
