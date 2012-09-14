<<<<<<< HEAD
package org.flexlite.domUI.utils
{
	
	import org.flexlite.domUI.core.MaskType;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.LuminosityMaskShader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ShaderFilter;
	
	
	/**
	 * 遮罩工具类
	 * @author DOM
	 */	
	public class MaskUtil
	{
		public static function applyLuminositySettings(
			mask:DisplayObject, maskType:String, 
			luminosityInvert:Boolean, luminosityClip:Boolean):void
		{
			if (!mask || maskType != MaskType.LUMINOSITY || mask.filters.length == 0)
				return;
			var shaderFilterIndex:int; 
			var shaderFilter:ShaderFilter; 
			var len:int = mask.filters.length; 
			for (shaderFilterIndex = 0; shaderFilterIndex < len; 
				shaderFilterIndex++)
			{
				if (mask.filters[shaderFilterIndex] is ShaderFilter && 
					ShaderFilter(mask.filters[shaderFilterIndex]).shader 
					is LuminosityMaskShader)
				{
					shaderFilter = mask.filters[shaderFilterIndex];
					break; 
				}
			}
			
			if (shaderFilter)
			{
				
				LuminosityMaskShader(shaderFilter.shader).mode = 
					calculateLuminositySettings(luminosityInvert, luminosityClip);
				mask.filters[shaderFilterIndex] = shaderFilter; 
				mask.filters = mask.filters; 
			}
		}
		
		/**
		 * 应用遮罩
		 */		
		public static function applyMask(mask:DisplayObject, 
											  parent:DisplayObjectContainer):void
		{
			if (!mask)
				return;
			
			var maskComp:UIComponent = mask as UIComponent;            
			if (maskComp)
			{
				if (parent!=null&&parent is UIComponent)
				{
					maskComp.nestLevel = UIComponent(parent).nestLevel + 1;
				}
				maskComp.validateNow(true);
				maskComp.invalidateDisplayList();
				maskComp.setActualSize(maskComp.preferredWidth, 
					maskComp.preferredHeight);                    
			}  
		}
		
		public static function applyMaskType(
			mask:DisplayObject, 
			maskType:String, 
			luminosityInvert:Boolean, 
			luminosityClip:Boolean,
			drawnDisplayObject:DisplayObject):void
		{
			if (!mask)
				return;
			
			if (maskType == MaskType.CLIP)
			{
				
				mask.cacheAsBitmap = false;
				mask.filters = [];
			}
			else if (maskType == MaskType.ALPHA)
			{
				mask.cacheAsBitmap = true;
				drawnDisplayObject.cacheAsBitmap = true;
			}
			else if (maskType == MaskType.LUMINOSITY)
			{
				mask.cacheAsBitmap = true;
				drawnDisplayObject.cacheAsBitmap = true;
				var luminosityMaskShader:LuminosityMaskShader = 
					new LuminosityMaskShader();
				luminosityMaskShader.mode = 
					calculateLuminositySettings(luminosityInvert, luminosityClip); 
				var shaderFilter:ShaderFilter = 
					new ShaderFilter(luminosityMaskShader);
				mask.filters = [shaderFilter];
			}
		}
		
		private static function calculateLuminositySettings(
			luminosityInvert:Boolean, 
			luminosityClip:Boolean):int
		{
			var mode:int = 0;
			
			if (luminosityInvert)
				mode += 1; 
			
			if (luminosityClip) 
				mode += 2;
			
			return mode; 
		}        
	}
=======
package org.flexlite.domUI.utils
{
	
	import org.flexlite.domUI.core.MaskType;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.primitives.graphic.shaderClasses.LuminosityMaskShader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ShaderFilter;
	
	
	/**
	 * 遮罩工具类
	 * @author DOM
	 */	
	public class MaskUtil
	{
		public static function applyLuminositySettings(
			mask:DisplayObject, maskType:String, 
			luminosityInvert:Boolean, luminosityClip:Boolean):void
		{
			if (!mask || maskType != MaskType.LUMINOSITY || mask.filters.length == 0)
				return;
			var shaderFilterIndex:int; 
			var shaderFilter:ShaderFilter; 
			var len:int = mask.filters.length; 
			for (shaderFilterIndex = 0; shaderFilterIndex < len; 
				shaderFilterIndex++)
			{
				if (mask.filters[shaderFilterIndex] is ShaderFilter && 
					ShaderFilter(mask.filters[shaderFilterIndex]).shader 
					is LuminosityMaskShader)
				{
					shaderFilter = mask.filters[shaderFilterIndex];
					break; 
				}
			}
			
			if (shaderFilter)
			{
				
				LuminosityMaskShader(shaderFilter.shader).mode = 
					calculateLuminositySettings(luminosityInvert, luminosityClip);
				mask.filters[shaderFilterIndex] = shaderFilter; 
				mask.filters = mask.filters; 
			}
		}
		
		/**
		 * 应用遮罩
		 */		
		public static function applyMask(mask:DisplayObject, 
											  parent:DisplayObjectContainer):void
		{
			if (!mask)
				return;
			
			var maskComp:UIComponent = mask as UIComponent;            
			if (maskComp)
			{
				if (parent!=null&&parent is UIComponent)
				{
					maskComp.nestLevel = UIComponent(parent).nestLevel + 1;
				}
				maskComp.validateNow(true);
				maskComp.invalidateDisplayList();
				maskComp.setActualSize(maskComp.preferredWidth, 
					maskComp.preferredHeight);                    
			}  
		}
		
		public static function applyMaskType(
			mask:DisplayObject, 
			maskType:String, 
			luminosityInvert:Boolean, 
			luminosityClip:Boolean,
			drawnDisplayObject:DisplayObject):void
		{
			if (!mask)
				return;
			
			if (maskType == MaskType.CLIP)
			{
				
				mask.cacheAsBitmap = false;
				mask.filters = [];
			}
			else if (maskType == MaskType.ALPHA)
			{
				mask.cacheAsBitmap = true;
				drawnDisplayObject.cacheAsBitmap = true;
			}
			else if (maskType == MaskType.LUMINOSITY)
			{
				mask.cacheAsBitmap = true;
				drawnDisplayObject.cacheAsBitmap = true;
				var luminosityMaskShader:LuminosityMaskShader = 
					new LuminosityMaskShader();
				luminosityMaskShader.mode = 
					calculateLuminositySettings(luminosityInvert, luminosityClip); 
				var shaderFilter:ShaderFilter = 
					new ShaderFilter(luminosityMaskShader);
				mask.filters = [shaderFilter];
			}
		}
		
		private static function calculateLuminositySettings(
			luminosityInvert:Boolean, 
			luminosityClip:Boolean):int
		{
			var mode:int = 0;
			
			if (luminosityInvert)
				mode += 1; 
			
			if (luminosityClip) 
				mode += 2;
			
			return mode; 
		}        
	}
>>>>>>> master
}