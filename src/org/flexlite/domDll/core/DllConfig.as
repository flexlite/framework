package org.flexlite.domDll.core
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * Dll配置文件解析类
	 * @author DOM
	 */
	public class DllConfig
	{
		/**
		 * 构造函数
		 * @param language 当前的语言环境
		 */		
		public function DllConfig(language:String)
		{
			this.language = language;
		}
		
		/**
		 * 当前的语言环境
		 */		
		private var language:String;
		/**
		 * 进度条队列结束索引(不包括)
		 */		
		public var loadingGroup:Array = [];
		/**
		 * 预加载队列结束索引(不包括)
		 */		
		public var preloadGroup:Array = [];
		/**
		 * 加载列表
		 */		
		private var loadList:Array = [];
		/**
		 * 一级键名字典
		 */		
		private var keyMap:Dictionary = new Dictionary;
		/**
		 * 二级键名字典
		 */		
		private var subkeyMap:Dictionary = new Dictionary;
		
		/**
		 * 解析一个配置数据,构造查询表
		 */		
		public function parseConfig(data:Object):void
		{
			if(data is XML)
			{
				var xmlConfig:XML = data as XML;
				if(xmlConfig.loading[0])
					getItemFromXML(xmlConfig.loading[0],loadingGroup);
				if(xmlConfig.preload[0])
					getItemFromXML(xmlConfig.preload[0],preloadGroup);
				if(xmlConfig.lazyload[0])
					getItemFromXML(xmlConfig.lazyload[0]);
			}
			else
			{
				if(data is ByteArray)
				{
					try
					{
						(data as ByteArray).uncompress();
					}
					catch(e:Error){}
					data = (data as ByteArray).readObject();
				}
				if(data.hasOwnProperty("loading"))
					getItemFromObject(data.loading,loadingGroup);
				if(data.hasOwnProperty("preload"))
					getItemFromObject(data.preload,preloadGroup);
				if(data.hasOwnProperty("lazyload"))
					getItemFromObject(data.lazyload);
			}
		}
		/**
		 * 从xml里解析加载项
		 */		
		private function getItemFromXML(xml:XML,group:Array = null):void
		{
			for each(var item:XML in xml.children())
			{
				var lang:String = String(item.@language);
				if(lang!=language&&lang!="all")
					continue;
				var obj:Object = {name:String(item.@name),url:String(item.@url),
					type:String(item.@type),size:String(item.@size)};
				if(item.hasOwnProperty("@subkeys"))
					obj.subkeys = String(item.@subkeys);
				addItemToList(obj);
				if(group)
					group.push(obj);
			}
		}
		/**
		 * 从Object里解析加载项
		 */		
		private function getItemFromObject(list:Array,group:Array = null):void
		{
			for each(var item:Object in list)
			{
				var lang:String = item.language;
				if(lang!=language&&lang!="all")
					continue;
				delete item.language;
				addItemToList(item);
				if(group)
					group.push(item);
			}
		}
		/**
		 * 添加一个加载项数据到列表
		 */		
		private function addItemToList(item:Object):void
		{
			loadList.push(item);
			keyMap[item.name] = item;
			if(item.hasOwnProperty("subkeys"))
			{
				var subkeys:Array = String(item.subkeys).split(",");
				delete item.subkeys;
				for each(var key:String in subkeys)
				{
					if(subkeyMap[key]!=null)
						continue;
					subkeyMap[key] = item;
				}
			}
		}
		
	}
}