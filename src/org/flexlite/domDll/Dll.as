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
	import org.flexlite.domDll.fileLib.DxrFileLib;
	import org.flexlite.domDll.fileLib.ImgFileLib;
	import org.flexlite.domDll.fileLib.JsonFileLib;
	import org.flexlite.domDll.fileLib.SwfFileLib;
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
		 * @param folder 所有加载项的路径前缀。可将加载项url中重复的部分提取出来作为folder属性。
		 */		
		public static function setInitConfig(pathList:Array,type:String="xml",language:String="cn",folder:String=""):void
		{
			instance.setInitConfig(pathList,type,language,folder);
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
		 * 只有在loading组和preload组中的资源可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */		
		public static function getRes(key:String):*
		{
			return instance.getRes(key);
		}
		/**
		 * 异步方式获取资源。只要是配置文件里存在的资源，都可以通过异步方式获取。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 * @param compFunc 回调函数。示例：compFunc(data):void,若设置了other参数则为:compFunc(data,other):void
		 * @param other 回调参数(可选),若设置了此参数，获取资源后它将会作为回调函数的第二个参数传入。
		 */		
		public static function getResAsync(key:String,compFunc:Function,other:Object=null):void
		{
			instance.getResAsync(key,compFunc,other);
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
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_XML))
				Injector.mapClass(IFileLib,XmlFileLib,DllItem.TYPE_XML);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_BIN))
				Injector.mapClass(IFileLib,BinFileLib,DllItem.TYPE_BIN);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_AMF))
				Injector.mapClass(IFileLib,AmfFileLib,DllItem.TYPE_AMF);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_IMG))
				Injector.mapClass(IFileLib,ImgFileLib,DllItem.TYPE_IMG);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_SWF))
				Injector.mapClass(IFileLib,SwfFileLib,DllItem.TYPE_SWF);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_DXR))
				Injector.mapClass(IFileLib,DxrFileLib,DllItem.TYPE_DXR);
			if(!Injector.hasMapRule(IFileLib,DllItem.TYPE_JSON))
				Injector.mapClass(IFileLib,JsonFileLib,DllItem.TYPE_JSON);
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
		 * @param folder 所有加载项的路径前缀。可将加载项url中重复的部分提取出来作为folder属性。
		 */		
		private function setInitConfig(pathList:Array,type:String="xml",language:String="cn",folder:String=""):void
		{
			dllConfig.language = language;
			dllConfig.folder = folder;
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
				var config:Object = fileLib.getRes(name);
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
		 * 只有在loading组和preload组中的资源可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 */	
		private function getRes(key:String):*
		{
			var type:String = dllConfig.getType(key);
			if(type=="")
				return null;
			var fileLib:IFileLib = getFileLibByType(type);
			return fileLib.getRes(key);
		}
		
		/**
		 * 异步获取资源参数缓存字典
		 */		
		private var asyncDic:Dictionary = new Dictionary;
		/**
		 * 异步方式获取资源。只要是配置文件里存在的资源，都可以通过异步方式获取。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 * @param compFunc 回调函数。示例：compFunc(data):void,若设置了other参数则为:compFunc(data,other):void
		 * @param other 回调参数(可选),若设置了此参数，获取资源后它将会作为回调函数的第二个参数传入。
		 */		
		private function getResAsync(key:String,compFunc:Function,other:Object=null):void
		{
			if(compFunc==null||!key)
				return;
			var type:String = dllConfig.getType(key);
			if(type=="")
			{
				doCompFunc(compFunc,null,other);
				return;
			}
			var fileLib:IFileLib = getFileLibByType(type);
			var res:* = fileLib.getRes(key);
			if(res)
			{
				doCompFunc(compFunc,res,other);
				return;
			}
			var name:String = dllConfig.getName(key);
			if(fileLib.hasRes(name))
			{
				doGetResAsync(fileLib,key,compFunc,other);
			}
			else
			{
				var args:Object = {key:key,compFunc:compFunc,other:other};
				if(asyncDic[name])
				{
					asyncDic[name].push(args);
				}
				else
				{
					asyncDic[key] = [args];
					var dllItem:DllItem = dllConfig.getDllItem(key);
					dllItem.compFunc = onDllItemComp;
					dllLoader.loadItem(dllItem);
				}
			}
		}
		/**
		 * 执行回调函数
		 */		
		private function doCompFunc(compFunc:Function,res:*,other:Object):void
		{
			if(other)
				compFunc(res,other);
			else 
				compFunc(res);
		}
		/**
		 * 执行异步获取资源
		 */		
		private function doGetResAsync(fileLib:IFileLib,key:String,compFunc:Function,other:Object):void
		{
			fileLib.getResAsync(key,function(data:*):void{
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
			var argsList:Array = asyncDic[item.name];
			delete asyncDic[item.name];
			var fileLib:IFileLib = getFileLibByType(item.type);
			for each(var args:Object in argsList)
			{
				doGetResAsync(fileLib,args.key,args.compFunc,args.other);
			}
		}
	}
}