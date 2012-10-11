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
		 */		
		public function DllConfig()
		{
		}
		
		/**
		 * 当前的语言环境
		 */		
		public var language:String;
				
		private var _loadingGroup:Array = [];
		/**
		 * loading组资源列表
		 */
		public function get loadingGroup():Vector.<DllItem>
		{
			var group:Vector.<DllItem> = new Vector.<DllItem>();
			for each(var obj:Object in _loadingGroup)
			{
				group.push(parseDllItem(obj));
			}
			return group;
		}
		private var _preloadGroup:Array = [];
		/**
		 * 预加载组资源列表
		 */
		public function get preloadGroup():Vector.<DllItem>
		{
			var group:Vector.<DllItem> = new Vector.<DllItem>();
			for each(var obj:Object in _preloadGroup)
			{
				group.push(parseDllItem(obj));
			}
			return group;
		}
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
					getItemFromXML(xmlConfig.loading[0],_loadingGroup);
				if(xmlConfig.preload[0])
					getItemFromXML(xmlConfig.preload[0],_preloadGroup);
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
					getItemFromObject(data.loading,_loadingGroup);
				if(data.hasOwnProperty("preload"))
					getItemFromObject(data.preload,_preloadGroup);
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
		/**
		 * 根据一级键名或二级键名获取加载项的类型。
		 */		
		public function getType(key:String,subKey:String=""):String
		{
			var data:Object;
			if(key)
			{
				data = keyMap[key];
			}
			else if(subKey)
			{
				data = subkeyMap[subKey];
			}
			if(data)
				return data.type;
			return "";
		}
		/**
		 *  通过二级键名获取一级键名
		 */		
		public function getKeyBySubKey(subKey:String):String
		{
			var data:Object = subkeyMap[subKey];
			if(data)
				return data.name;
			return "";
		}
		/**
		 * 根据一级键名或二级键名获取加载项信息对象
		 */		
		public function getDllItem(key:String,subKey:String=""):DllItem
		{
			var data:Object;
			if(key)
			{
				data = keyMap[key];
			}
			else if(subKey)
			{
				data = subkeyMap[subKey];
			}
			if(data)
				return parseDllItem(data);
			return null;
		}
		/**
		 * 转换Object数据为DllItem对象
		 */		
		private function parseDllItem(data:Object):DllItem
		{
			return new DllItem(data.name,data.url,data.type,data.size);
		}
		
	}
}