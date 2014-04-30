package org.flexlite.domUI.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.flexlite.domUI.components.SkinnableComponent;

	[ExcludeClass]
	
	/**
	 * 获取皮肤定义的公开属性名工具类
	 * @author DOM
	 */
	public class SkinPartUtil
	{
		/**
		 * skinPart缓存字典
		 */		
		private static var skinPartCache:Dictionary = new Dictionary();
		/**
		 * 基本数据类型列表
		 */		
		private static var basicTypes:Vector.<String> = 
			new <String>["Number","int","String","Boolean","uint","Object"];
		
		/**
		 * 从一个Skin或其子类的实例里获取皮肤定义的公开属性名列表
		 * @param skin 皮肤实例
		 * @param superClass 皮肤基类，在遍历属性时过滤基类以上类定义的属性。
		 */		
		public static function getSkinParts(host:SkinnableComponent):Vector.<String>
		{
			var key:String = getQualifiedClassName(host);
			if(skinPartCache[key])
			{
				return skinPartCache[key];
			}
			
			var info:XML = describeType(host);
			var node:XML;
			var skinParts:Vector.<String> = new Vector.<String>();
			var partName:String;
			for each(node in info.variable)
			{
				partName = node.@name.toString();
				if(basicTypes.indexOf(node.@type)==-1)
				{
					skinParts.push(partName);
				}
			}
			skinPartCache[key] = skinParts;
			return skinParts;
		}
		
	}
}