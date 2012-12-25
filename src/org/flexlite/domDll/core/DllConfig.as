package org.flexlite.domDll.core
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
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
		/**
		 * 当前的资源版本号
		 */		
		public var version:String;
		/**
		 * 根据组名获取组加载项列表
		 * @param name
		 */		
		public function getGroupByName(name:String):Vector.<DllItem>
		{
			var group:Vector.<DllItem> = new Vector.<DllItem>();
			if(!groupDic[name])
				return group;
			for each(var obj:Object in groupDic[name])
			{
				group.push(parseDllItem(obj));
			}
			return group;
		}
		/**
		 * 一级键名字典
		 */		
		private var keyMap:Dictionary = new Dictionary();
		/**
		 * 加载组字典
		 */		
		private var groupDic:Dictionary = new Dictionary();
		/**
		 * 解析一个配置数据,构造查询表
		 */		
		public function parseConfig(data:Object,folder:String):void
		{
			if(!data)
				return;
			var group:Array;
			if(data is XML)
			{
				var xmlConfig:XML = data as XML;
				data = {};
				for each(var item:XML in xmlConfig.children())
				{
					var name:String = String(item.@name);
					if(!name)
						continue;
					group = groupDic[name];
					if(!group)
					{
						group = groupDic[name] = [];
					}
					getItemFromXML(item,folder,group);
				}
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
					(data as ByteArray).position = 0;
					data = (data as ByteArray).readObject();
				}
				for(var key:String in data)
				{
					group = groupDic[key];
					if(!group)
					{
						group = groupDic[key] = [];
					}
					getItemFromObject(data[key],folder,group);
				}
			}
		}
		/**
		 * 从xml里解析加载项
		 */		
		private function getItemFromXML(xml:XML,folder:String,group:Array = null):void
		{
			for each(var item:XML in xml.children())
			{
				var lang:String = String(item.@language);
				if(lang!=language&&lang!="all")
					continue;
				var obj:Object = {name:String(item.@name),url:folder+String(item.@url),
					type:String(item.@type),size:String(item.@size)};
				if(item.hasOwnProperty("@subkeys"))
					obj.subkeys = String(item.@subkeys);
				addItemToKeyMap(obj);
				if(group)
					group.push(obj);
			}
		}
		/**
		 * 从Object里解析加载项
		 */		
		private function getItemFromObject(list:Array,folder:String,group:Array = null):void
		{
			for each(var item:Object in list)
			{
				var lang:String = item.language;
				if(lang!=language&&lang!="all")
					continue;
				delete item.language;
				item.url = folder+item.url;
				addItemToKeyMap(item);
				if(group)
					group.push(item);
			}
		}
		/**
		 * 添加一个加载项数据到列表
		 */		
		private function addItemToKeyMap(item:Object):void
		{
			if(!keyMap[item.name])
				keyMap[item.name] = item;
			if(item.hasOwnProperty("subkeys"))
			{
				var subkeys:Array = String(item.subkeys).split(",");
				delete item.subkeys;
				for each(var key:String in subkeys)
				{
					if(keyMap[key]!=null)
						continue;
					keyMap[key] = item;
				}
			}
		}
		/**
		 * 获取加载项类型。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		public function getType(key:String):String
		{
			var data:Object = keyMap[key];
			return data?data.type:"";
		}
		/**
		 * 获取加载项名称
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		public function getName(key:String):String
		{
			var data:Object = keyMap[key];
			return data?data.name:"";
		}
		/**
		 * 根据一级键名或二级键名获取加载项信息对象
		 */		
		public function getDllItem(key:String):DllItem
		{
			var data:Object = keyMap[key];
			if(data)
				return parseDllItem(data);
			return null;
		}
		/**
		 * 转换Object数据为DllItem对象
		 */		
		public function parseDllItem(data:Object):DllItem
		{
			var url:String = data.url;
			if(version&&url.indexOf("?v=")==-1)
			{
				if(url.indexOf("?")==-1)
					url += "?v="+version;
				else
					url += "&v="+version;
			}
			var dllItem:DllItem = new DllItem(data.name,url,data.type,data.size);
			dllItem.data = data;
			return dllItem;
		}
		
	}
}