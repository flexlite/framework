package org.flexlite.domDll.core
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	/**
	 * Dll配置文件解析器
	 * @author DOM
	 */
	public class DllConfig implements IDllConfig
	{
		/**
		 * 构造函数
		 */		
		public function DllConfig()
		{
		}
		
		private var _language:String;
		/**
		 * @inheritDoc
		 */
		public function setLanguage(value:String):void
		{
			_language = value;
		}

		/**
		 * @inheritDoc
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
		 * @inheritDoc
		 */	
		public function createGroup(name:String,keys:Array,override:Boolean=false):Boolean
		{
			if((!override&&groupDic[name])||!keys||keys.length==0)
				return false;
			var group:Array = [];
			for each(var key:String in keys)
			{
				var item:Object = keyMap[key];
				if(item&&group.indexOf(item)==-1)
					group.push(item);
			}
			if(group.length==0)
				return false;
			groupDic[name] = group;
			return true;
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
		 * @inheritDoc
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
				if(lang!=_language&&lang!="all")
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
				if(lang!=_language&&lang!="all")
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
				item.subkeys = subkeys;
				for each(var key:String in subkeys)
				{
					if(keyMap[key]!=null)
						continue;
					keyMap[key] = item;
				}
			}
		}
		/**
		 * @inheritDoc
		 */		
		public function getType(key:String):String
		{
			var data:Object = keyMap[key];
			return data?data.type:"";
		}
		/**
		 * @inheritDoc
		 */	
		public function getName(key:String):String
		{
			var data:Object = keyMap[key];
			return data?data.name:"";
		}
		/**
		 * @inheritDoc
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
		private function parseDllItem(data:Object):DllItem
		{
			var dllItem:DllItem = new DllItem(data.name,data.url,data.type,data.size);
			dllItem.data = data;
			return dllItem;
		}
		
	}
}