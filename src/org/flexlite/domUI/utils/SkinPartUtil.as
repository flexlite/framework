package org.flexlite.domUI.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.flexlite.domUI.components.supportClasses.Skin;

	/**
	 * 获取皮肤定义的公开属性名工具类
	 * @author DOM
	 */
	public class SkinPartUtil
	{
		private static var skinPartCache:Dictionary;
		
		/**
		 * 从一个Skin或其子类的实例里获取皮肤定义的公开属性名列表
		 * @param skin 皮肤实例
		 */		
		public static function getSkinParts(skin:Skin):Vector.<String>
		{
			if(skinPartCache==null)
			{
				skinPartCache = new Dictionary;
			}
			var key:String = getQualifiedClassName(skin);
			if(skinPartCache[key] != null)
			{
				return skinPartCache[key] as Vector.<String>;
			}
			
			var index:int = key.lastIndexOf(":");
			//编译器生成的变量名前缀
			var compilePrefix:String = "__"+key.substr(index+1)+"_";
			var info:XML = describeType(skin);
			var node:XML;
			var skinClass:String = getQualifiedClassName(Skin);
			var fitClasses:Vector.<String> = new Vector.<String>();
			if(skinClass==info.@name)
			{
				fitClasses.push(skinClass);
			}
			else
			{
				for each(node in info.extendsClass)
				{
					fitClasses.push(node.@type.toString());
					if(node.@type==skinClass)
					{
						break;
					}
				}
			}
			
			var skinParts:Vector.<String> = new Vector.<String>();
			var partName:String;
			for each(node in info.variable)
			{
				partName = node.@name.toString();
				if(!isSkinProperty(partName)
					&&!isCompilerCreate(partName,compilePrefix)
					&&!isBasicType(node.@type))
				{
					skinParts.push(partName);
				}
			}
			for each(node in info.accessor)
			{
				partName = node.@name.toString();
				if(!isSkinProperty(partName)
					&&isFitType(node.@declaredBy,fitClasses)
					&&!isCompilerCreate(partName,compilePrefix)
					&&!isBasicType(node.@type))
					
				{
					skinParts.push(partName);
				}
			}
			skinPartCache[key] = skinParts;
			return skinParts;
		}
		/**
		 * 检查目标类名是否在fitClasses中，即检查变量是否是由Skin及子类声明的，而不是父级以上类声明的。
		 */		
		private static function isFitType(targetClass:String,fitClasses:Vector.<String>):Boolean
		{
			for each(var type:String in fitClasses)
			{
				if(type==targetClass)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 是非引用型的基本数据类型或Object
		 */		
		private static function isBasicType(type:String):Boolean
		{
			return type=="Number"||type=="int"||type=="String"||type=="Boolean"||type=="uint"||type=="Object";
		}
		/**
		 * 是Skin类定义的非皮肤部件属性。
		 */		
		private static function isSkinProperty(partName:String):Boolean
		{
			return partName=="hostComponent"||partName=="states";
		}
		
		/**
		 * 是否是编译器生成的变量名
		 */		
		private static function isCompilerCreate(partName:String,prefix:String):Boolean
		{
			return partName.substr(0,prefix.length)==prefix;
		}
	}
}