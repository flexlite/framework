package org.flexlite.domDll
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domDll.core.DllConfig;
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.DllLoader;
	import org.flexlite.domDll.core.IFileLib;
	import org.flexlite.domDll.events.DllEvent;
	import org.flexlite.domDll.fileLib.AmfFileLib;
	import org.flexlite.domDll.fileLib.BinFileLib;
	import org.flexlite.domDll.fileLib.ImgFileLib;
	import org.flexlite.domDll.fileLib.XmlFileLib;
	
	/**
	 * loading组资源加载进度事件。
	 */	
	[Event(name="loadingProgress",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * loading组资源加载完成事件
	 */
	[Event(name="loadingComplete",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * preload组资源加载进度事件
	 */
	[Event(name="preloadProgress",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * preload组资源加载完成事件
	 */
	[Event(name="preloadComplete",type="org.flexlite.domDll.events.DllEvent")]
			
	/**
	 * 资源管理器
	 * @author DOM
	 */
	public class Dll extends EventDispatcher
	{
		/**
		 * 构造函数
		 */		
		public function Dll()
		{
			super();
			if(_instance)
			{
				throw new Error("实例化单例:Dll出错！");
			}
			init();
		}
		
		private static var _instance:Dll;
		/**
		 * 获取单例
		 */		
		private static function get instance():Dll
		{
			if(!_instance)
			{
				_instance = new Dll();
			}
			return _instance;
		}
		/**
		 * 获取事件监听对象
		 */		
		public static function get eventDispather():Dll
		{
			return instance;
		}
		
		/**
		 * 加载初始化配置文件并解析，解析完成后开始加载loading组资源。
		 * @param path 配置文件路径
		 * @param type 配置文件类型
		 * @param language 当前的语言环境 
		 */		
		public static function loadConfig(pathList:Array,type:String="xml",language:String="cn"):void
		{
			instance.loadConfig(pathList,type,language);
		}
		/**
		 * 开始加载配置为"预加载"组的资源。
		 */		
		public static function loadPreloadGroup():void
		{
			instance.loadPreloadGroup();
		}
		
		/**
		 * 同步方式获取资源。<br/>
		 * 在loading组和preload组中的资源都可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 通常对应配置文件里的name属性。
		 * @param subKey 二级键名(可选)，通常对应swf里的导出类名。
		 */		
		public static function getRes(key:String,subKey:String=""):*
		{
			return instance.getRes(key,subKey);
		}
		/**
		 * 异步方式获取资源。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 通常对应配置文件里的name属性。
		 * @param compFunc 回调函数。示例：compFunc(data):void,若设置了other参数则为:compFunc(data,other):void
		 * @param subKey 二级键名(可选),通常对应swf里的导出类名。
		 * @param other 回调参数(可选),若设置了此参数，获取资源后它将会作为回调函数的第二个参数传入。
		 */		
		public static function getResAsync(key:String,compFunc:Function,subKey:String="",other:Object=null):void
		{
			instance.getResAsync(key,compFunc,subKey,other);
		}
		
		/**
		 * 多文件队列加载器
		 */		
		private var dllLoader:DllLoader;
		/**
		 * 初始化
		 */		
		private function init():void
		{
			Injector.mapClass(IFileLib,XmlFileLib,DllItem.TYPE_XML);
			Injector.mapClass(IFileLib,BinFileLib,DllItem.TYPE_BIN);
			Injector.mapClass(IFileLib,AmfFileLib,DllItem.TYPE_AMF);
			Injector.mapClass(IFileLib,ImgFileLib,DllItem.TYPE_IMG);
			dllLoader = new DllLoader();
			dllLoader.addEventListener(ProgressEvent.PROGRESS,onGroupProgress);
			dllLoader.addEventListener(Event.COMPLETE,onGroupComp);
		}
		/**
		 * 队列加载进度事件
		 */		
		private function onGroupProgress(event:ProgressEvent):void
		{
			var dllEvent:DllEvent;
			switch(groupName)
			{
				case GROUP_LOADING:
					dllEvent = new DllEvent(DllEvent.LOADING_PROGRESS);
					break;
				case GROUP_PRELOAD:
					dllEvent = new DllEvent(DllEvent.PRELOAD_PROGRESS);
					break;
			}
			if(dllEvent)
			{
				dllEvent.bytesTotal = event.bytesTotal;
				dllEvent.bytesLoaded = event.bytesLoaded;
				dispatchEvent(dllEvent);
			}
		}
		/**
		 * 队列加载完成事件
		 */		
		private function onGroupComp(event:Event):void
		{
			var dllEvent:DllEvent;
			switch(groupName)
			{
				case GROUP_CONFIG:
					onConfigComp();
					break;
				case GROUP_LOADING:
					dllEvent = new DllEvent(DllEvent.LOADING_COMPLETE);
					dispatchEvent(event);
					break;
				case GROUP_PRELOAD:
					dllEvent = new DllEvent(DllEvent.PRELOAD_COMPLETE);
					break;
			}
			if(dllEvent)
			{
				dispatchEvent(dllEvent);
			}
		}
		
		/**
		 * 正在加载的组名
		 */		
		private var groupName:String = GROUP_CONFIG;
		
		private static const GROUP_CONFIG:String = "config";
		private static const GROUP_LOADING:String = "loading";
		private static const GROUP_PRELOAD:String = "preload";
		/**
		 * 配置文件名列表
		 */		
		private var configNameList:Array = [];
		/**
		 * 配置文件的类型
		 */		
		private var configType:String;
		/**
		 * 加载初始化配置文件并解析，解析完成后开始加载loading组资源(若有配置)。
		 * @param path 配置文件路径
		 * @param type 配置文件类型
		 * @param language 当前的语言环境 
		 */		
		private function loadConfig(pathList:Array,type:String="xml",language:String="cn"):void
		{
			dllConfig.language = language;
			var itemList:Vector.<DllItem> = new Vector.<DllItem>();
			var index:int = 0;
			for each(var path:String in pathList)
			{
				var name:String = "DLL__CONFIG"+index;
				configNameList.push(name);
				var dllItem:DllItem = new DllItem(name,path,type);
				itemList.push(dllItem);
				index++;
			}
			groupName = GROUP_CONFIG;
			configType = type;
			dllLoader.loadGroup(itemList);
		}
		
		/**
		 * 解析器字典
		 */		
		private var fileLibDic:Dictionary = new Dictionary;
		/**
		 * 根据type获取对应的文件解析库
		 */		
		private function getFileLibByType(type:String):IFileLib
		{
			var fileLib:IFileLib = fileLibDic[type];
			if(!fileLib)
			{
				fileLib = fileLibDic[type] = Injector.getInstance(IFileLib,type);
			}
			return fileLib;
		}
		/**
		 * dll配置数据
		 */		
		private var dllConfig:DllConfig = new DllConfig();
		/**
		 * 配置文件加载并解析完成
		 */		
		private function onConfigComp():void
		{
			var fileLib:IFileLib = getFileLibByType(configType);
			for each(var name:String in configNameList)
			{
				var config:Object = fileLib.getRes(name,"");
				fileLib.destoryRes(name);
				dllConfig.parseConfig(config);
			}
			var loadingGroup:Vector.<DllItem> = dllConfig.loadingGroup;
			groupName = GROUP_LOADING;
			dllLoader.loadGroup(loadingGroup);
		}
		
		/**
		 * 开始加载配置为"预加载"组的资源。
		 */		
		private function loadPreloadGroup():void
		{
			var preloadGroup:Vector.<DllItem> = dllConfig.preloadGroup;
			if(preloadGroup.length>0)
			{
				groupName = GROUP_PRELOAD;
				dllLoader.loadGroup(preloadGroup);
			}
		}
		/**
		 * 同步方式获取资源。<br/>
		 * 在loading组和preload组中的资源都可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 通常对应配置文件里的name属性。
		 * @param subKey 二级键名(可选)，通常对应swf里的导出类名。
		 */		
		private function getRes(key:String,subKey:String=""):*
		{
			var type:String = dllConfig.getType(key,subKey);
			var fileLib:IFileLib = getFileLibByType(type);
			return fileLib.getRes(key,subKey);
		}
		
		/**
		 * 加载完成回调函数字典
		 */		
		private var keyDic:Dictionary = new Dictionary;
		/**
		 * 异步获取资源回调函数字典
		 */		
		private var compFuncDic:Dictionary = new Dictionary;
		/**
		 * 异步获取资源回调函数附加参数字典
		 */		
		private var otherDic:Dictionary = new Dictionary;
		/**
		 * 异步方式获取资源。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 通常对应配置文件里的name属性。
		 * @param compFunc 回调函数。示例：compFunc(data):void,若设置了other参数则为:compFunc(data,other):void
		 * @param subKey 二级键名(可选),通常对应swf里的导出类名。
		 * @param other 回调参数(可选),若设置了此参数，获取资源后它将会作为回调函数的第二个参数传入。
		 */		
		private function getResAsync(key:String,compFunc:Function,subKey:String="",other:Object=null):void
		{
			if(compFunc==null)
				return;
			var type:String = dllConfig.getType(key,subKey);
			var fileLib:IFileLib = getFileLibByType(type);
			var res:* = fileLib.getRes(key,subKey);
			if(res)
			{
				if(other)
					compFunc(res,other);
				else 
					compFunc(res);
				return;
			}
			if(!key)
			{
				key = dllConfig.getKeyBySubKey(subKey);
			}
			if(!key)
			{
				if(other)
					compFunc(null,other);
				else 
					compFunc(null);
				return;
			}
			else if(fileLib.hasRes(key))
			{
				doGetResAsync(fileLib,key,subKey,compFunc,other);
			}
			else
			{
				otherDic[key+"#"+subKey] = other;
				if(keyDic[key])
				{
					keyDic[key].push(key+"#"+subKey);
				}
				else
				{
					keyDic[key] = new <String>[key+"#"+subKey];
					var dllItem:DllItem = dllConfig.getDllItem(key,subKey);
					dllItem.compFunc = onDllItemComp;
					dllLoader.loadItem(dllItem);
				}
			}
		}
		/**
		 * 执行异步获取资源
		 */		
		private function doGetResAsync(fileLib:IFileLib,key:String,subKey:String,compFunc:Function,other:Object):void
		{
			fileLib.getResAsync(key,subKey,function(data:*):void{
				if(other)
					compFunc(data,other);
				else 
					compFunc(data);
			});
		}
		/**
		 * 一个加载项加载完成
		 */		
		private function onDllItemComp(item:DllItem):void
		{
			var keyList:Vector.<String> = keyDic[item.name];
			delete keyDic[item.name];
			var fileLib:IFileLib = getFileLibByType(item.type);
			for each(var key:String in keyList)
			{
				var keys:Array = key.split("#");
				var compFunc:Function = compFuncDic[key];
				delete compFuncDic[key];
				var other:Object = otherDic[key];
				delete otherDic[key];
				doGetResAsync(fileLib,keys[0],keys[1],compFunc,other);
			}
		}
	}
}