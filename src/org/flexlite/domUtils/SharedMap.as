package org.flexlite.domUtils
{
	import flash.utils.Dictionary;
	
	/**
	 * 具有动态内存管理功能的哈希表。<br/>
	 * 此类通常用于动态共享高内存占用的数据对象，比如BitmapData。
	 * 它类似Dictionary，使用key-value形式来存储数据。
	 * 但当外部对value的所有引用都断开时，value会被GC标记为可回收对象，并从哈希表移除。<br/>
	 * <b>注意：</b>
	 * 只有引用型的value才能启用动态内存管理，若value是基本数据类型(例如String,int等)时，需手动remove()它。
	 * @author DOM
	 */
	public class SharedMap
	{
		/**
		 * 构造函数
		 * @param groupSize 分组大小,数字越小查询效率越高，但内存占用越高。
		 */		
		public function SharedMap(groupSize:int=200)
		{
			if(groupSize<1)
				groupSize = 1;
			this.groupSize = groupSize;
		}
		
		/**
		 * key缓存字典
		 */		
		private var keyDic:Dictionary = new Dictionary();
		/**
		 * 上一次的value缓存字典
		 */		
		private var lastValueDic:Dictionary;
		/**
		 * 通过值获取键
		 * @param value
		 */		
		private function getValueByKey(key:String):*
		{
			var valueDic:Dictionary = keyDic[key];
			if(!valueDic)
				return null;
			var found:Boolean = false;
			var value:*;
			for(value in valueDic)
			{
				if(valueDic[value]===key)
				{
					found = true;
					break;
				}
			}
			if(!found)
			{
				value = null;
				delete keyDic[key];
			}
			return value;
		}
		
		/**
		 * 分组大小
		 */		
		private var groupSize:int = 200;
		/**
		 * 添加过的key的总数
		 */		
		private var totalKeys:int = 0;
		/**
		 * 设置键值映射
		 * @param key 键
		 * @param value 值
		 */		
		public function set(key:String,value:*):void
		{
			var valueDic:Dictionary = keyDic[key];
			if(valueDic)
			{
				var oldValue:* = getValueByKey(key);
				if(oldValue!=null)
					delete valueDic[oldValue];
			}
			else
			{
				if(totalKeys%groupSize==0)
					lastValueDic = new Dictionary(true);
				valueDic = lastValueDic;
				totalKeys++;
			}
			if(valueDic[value]!==undefined)
				valueDic = lastValueDic = new Dictionary(true);
			keyDic[key] = valueDic;
			valueDic[value] = key;
		}
		/**
		 * 获取指定键的值
		 * @param key
		 */		
		public function get(key:String):*
		{
			return getValueByKey(key);
		}
		/**
		 * 检测是否含有指定键
		 * @param key 
		 */		
		public function has(key:String):Boolean
		{
			var valueDic:Dictionary = keyDic[key];
			if(!valueDic)
				return false;
			var has:Boolean = false;
			for(var value:* in valueDic)
			{
				if(valueDic[value]===key)
				{
					has = true;
					break;
				}
			}
			if(!has)
				delete keyDic[key];
			return has;
		}
		/**
		 * 移除指定的键
		 * @param key 要移除的键
		 * @return 是否移除成功
		 */		
		public function remove(key:String):Boolean
		{
			var value:* = getValueByKey(key);
			if(value==null)
				return false;
			var valueDic:Dictionary = keyDic[key];
			delete keyDic[key];
			delete valueDic[value];
			return true;
		}
		/**
		 * 获取键名列表
		 */		
		public function get keys():Vector.<String>
		{
			var keyList:Vector.<String> = new Vector.<String>();
			var cacheDic:Dictionary = new Dictionary();
			for(var key:String in keyDic)
			{
				var valueDic:Dictionary = keyDic[key];
				if(cacheDic[valueDic])
					continue;
				cacheDic[valueDic] = true;
				for each(var validKey:String in valueDic)
				{
					keyList.push(validKey);
				}
			}
			return keyList;
		}
		/**
		 * 获取值列表
		 */		
		public function get values():Array
		{
			var valueList:Array = [];
			var cacheDic:Dictionary = new Dictionary();
			for(var key:String in keyDic)
			{
				var valueDic:Dictionary = keyDic[key];
				if(cacheDic[valueDic])
					continue;
				cacheDic[valueDic] = true;
				for(var value:* in valueDic)
				{
					valueList.push(value);
				}
			}
			return valueList;
		}
		/**
		 * 刷新缓存并删除所有失效的键值。
		 */		
		public function refresh():void
		{
			var keyList:Vector.<String> = keys;
			for(var key:String in keyDic)
			{
				if(keyList.indexOf(key)==-1)
					delete keyDic[key];
			}
		}
	}
}