<<<<<<< HEAD
package org.flexlite.domUI.managers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 多语言管理器,初始化完成后调用DomGlobals.setLanguageManager()注入实例，即可调用UIComponent.tr()实现全局多语言翻译
	 * @author DOM
	 */
	public class LanguageManager extends EventDispatcher implements ILanguageManager
	{
		public function LanguageManager(resource:XML)
		{
			super();
			initialize(resource);
		}
		
		private var textDic:Dictionary = new Dictionary;
		/**
		 * 加入语言文字库XML
		 */
		private function initialize(resource:XML):void
		{
			if(resource!=null)	
			{
				var xmlList:XMLList = resource.r;
				for each(var child:XML in xmlList)
				{
					var name:String = child.@name;
					var text:String = child[0];
					textDic[name] = text;
				}
			}
		}
		
		/**
		 *  取得一个文本
		 * @param resourceName 文字索引，如果库中找不到这个索引则直接使用resourceName
		 * @param parameters 替换的参数，用于替换{}中的内容
		 */
		public function getText(resourceName:String,parameters:Array = null):String
		{
			var resourceStr:String;
			if(textDic[resourceName] != null)
			{
				resourceStr =  textDic[resourceName]
			}else
			{
				resourceStr = resourceName;
			}
			if (parameters)	
			{
				for (var j:int = 0, pLen:int = parameters.length; j < pLen; j++)	
				{
					var placeStr:String = "\\{" + j + "\\}";
					var re:RegExp = new RegExp(placeStr,"g");
					resourceStr = resourceStr.replace(re, parameters[j]);
				}
			}
			return resourceStr;
		}
	}
=======
package org.flexlite.domUI.managers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 多语言管理器,初始化完成后调用DomGlobals.setLanguageManager()注入实例，即可调用UIComponent.tr()实现全局多语言翻译
	 * @author DOM
	 */
	public class LanguageManager extends EventDispatcher implements ILanguageManager
	{
		public function LanguageManager(resource:XML)
		{
			super();
			initialize(resource);
		}
		
		private var textDic:Dictionary = new Dictionary;
		/**
		 * 加入语言文字库XML
		 */
		private function initialize(resource:XML):void
		{
			if(resource!=null)	
			{
				var xmlList:XMLList = resource.r;
				for each(var child:XML in xmlList)
				{
					var name:String = child.@name;
					var text:String = child[0];
					textDic[name] = text;
				}
			}
		}
		
		/**
		 *  取得一个文本
		 * @param resourceName 文字索引，如果库中找不到这个索引则直接使用resourceName
		 * @param parameters 替换的参数，用于替换{}中的内容
		 */
		public function getText(resourceName:String,parameters:Array = null):String
		{
			var resourceStr:String;
			if(textDic[resourceName] != null)
			{
				resourceStr =  textDic[resourceName]
			}else
			{
				resourceStr = resourceName;
			}
			if (parameters)	
			{
				for (var j:int = 0, pLen:int = parameters.length; j < pLen; j++)	
				{
					var placeStr:String = "\\{" + j + "\\}";
					var re:RegExp = new RegExp(placeStr,"g");
					resourceStr = resourceStr.replace(re, parameters[j]);
				}
			}
			return resourceStr;
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}