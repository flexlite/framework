package org.flexlite.domUtils
{
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	
	/**
	 * swf素材库解析工具
	 * @author DOM
	 */
	public class SwfMatLib extends EventDispatcher
	{
		public function SwfMatLib()
		{
			super();
		}
		
		/**
		 * 应用程序域字典
		 */		
		private var appDomainDic:Dictionary = new Dictionary;
		
		/**
		 * 添加一个应用程序域
		 * @param appDonmain 程序域引用
		 * @param domainName 程序域对应的唯一标识字符串
		 */		
		public function addAppDomain(appDonmain:ApplicationDomain,domainKey:String):void
		{
			appDomainDic[domainKey] = appDonmain;
		}
		
		/**
		 * 缓存的类定义字典
		 */		
		private var returnClass:Dictionary = new Dictionary;
		
		/**
		 * 根据导出类名获取对应的类定义
		 */		
		public function getClassByName(name:String):Class
		{
			if(returnClass[name])
			{
				return returnClass[name];
			}
			for each(var appDomain:ApplicationDomain in appDomainDic)
			{
				if(appDomain&&appDomain.hasDefinition(name))
				{
					var clazz:Class = appDomain.getDefinition(name) as Class;
					returnClass[name] = clazz;
					return clazz;
				}
			}
			return null;
		}
		
		/**
		 * 在指定程序域里获取类定义
		 * @param domainKey 程序域对应的唯一标识字符串
		 * @param name 导出类名
		 */		
		public function getClassInDomainByName(domainKey:String,name:String):Class
		{
			var appDomain:ApplicationDomain = appDomainDic[domainKey];
			if(appDomain&&appDomain.hasDefinition(name))
			{
				var clazz:Class = appDomain.getDefinition(name) as Class;
				returnClass[name] = clazz;
				return clazz;
			}
			return null;
		}
		/**
		 * 获取所有的导出类名列表
		 */		
		public function getDefinitions():Vector.<String>
		{
			var definitions:Vector.<String> = new Vector.<String>();
			for each(var appDomain:ApplicationDomain in appDomainDic)
			{
				var names:Vector.<String> = appDomain.getQualifiedDefinitionNames();
				definitions = definitions.concat(names);
			}
			return definitions;
		}
	}
}