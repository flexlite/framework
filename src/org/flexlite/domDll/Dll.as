package org.flexlite.domDll
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDll.core.ConfigItem;
	import org.flexlite.domDll.core.DllConfig;
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.DllLoader;
	import org.flexlite.domDll.core.IResolver;
	import org.flexlite.domDll.events.DllEvent;
	import org.flexlite.domDll.resolvers.AmfResolver;
	import org.flexlite.domDll.resolvers.BinResolver;
	import org.flexlite.domDll.resolvers.DxrResolver;
	import org.flexlite.domDll.resolvers.ImgResolver;
	import org.flexlite.domDll.resolvers.SwfResolver;
	import org.flexlite.domDll.resolvers.XmlResolver;
	
	use namespace dx_internal;
	
	/**
	 * 配置文件加载并解析完成事件
	 */
	[Event(name="configComplete",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 一组资源加载完成事件
	 */
	[Event(name="groupComplete",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 一组资源加载进度事件
	 */
	[Event(name="groupProgress",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 一个加载项加载结束事件，可能是加载成功也可能是加载失败。
	 */	
	[Event(name="itemLoadFinished",type="org.flexlite.domDll.events.DllEvent")]
			
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
		 * 加载配置文件并解析
		 * @param configList 配置文件信息列表
		 * @param version 资源版本号。请求资源时加在url后的Get参数，以避免浏览器缓存问题而获取错误的资源。
		 * @param language 当前的语言环境 
		 */		
		public static function loadConfig(configList:Vector.<ConfigItem>,version:String="",language:String="cn"):void
		{
			instance.loadConfig(configList,version,language);
		}
		/**
		 * 根据组名加载一组资源,可多次调用此方法，Dll将会根据调用顺序依次加载每个组。
		 * @param name 要加载资源组的组名
		 */	
		public static function loadGroup(name:String):void
		{
			instance.loadGroup(name);
		}
		/**
		 * 同步方式获取资源。<br/>
		 * 预加载的资源可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 * @return 
		 * "swf" name:Loader subkey:Class<br/>
		 * "dxr" name:DxrFile subkey:DxrData<br/>
		 * "amf" name:Object<br/>
		 * "xml" name:XML<br/>
		 * "img" name:BitmapData<br/>
		 * "bin" name:ByteArray
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
		 * 销毁某个资源文件的缓存数据,返回是否删除成功。
		 * @param name 配置文件中加载项的name属性
		 */
		public static function destroyRes(name:String):Boolean
		{
			return instance.destroyRes(name);
		}
		
		/**
		 * 解析器字典
		 */		
		private var resolverDic:Dictionary = new Dictionary;
		/**
		 * 根据type获取对应的文件解析库
		 */		
		private function getResolverByType(type:String):IResolver
		{
			var resolver:IResolver = resolverDic[type];
			if(!resolver)
			{
				resolver = resolverDic[type] = Injector.getInstance(IResolver,type);
			}
			return resolver;
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
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_XML))
				Injector.mapClass(IResolver,XmlResolver,DllItem.TYPE_XML);
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_BIN))
				Injector.mapClass(IResolver,BinResolver,DllItem.TYPE_BIN);
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_AMF))
				Injector.mapClass(IResolver,AmfResolver,DllItem.TYPE_AMF);
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_IMG))
				Injector.mapClass(IResolver,ImgResolver,DllItem.TYPE_IMG);
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_SWF))
				Injector.mapClass(IResolver,SwfResolver,DllItem.TYPE_SWF);
			if(!Injector.hasMapRule(IResolver,DllItem.TYPE_DXR))
				Injector.mapClass(IResolver,DxrResolver,DllItem.TYPE_DXR);
			dllLoader = new DllLoader();
			dllLoader.addEventListener(ProgressEvent.PROGRESS,onGroupProgress);
			dllLoader.addEventListener(Event.COMPLETE,onGroupComp);
			dllLoader.addEventListener(DllEvent.ITEM_LOAD_FINISHED,onItemLoadFinished)
		}
		/**
		 * 重抛事件
		 */		
		private function onItemLoadFinished(event:DllEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 配置文件组组名
		 */		
		private static const GROUP_CONFIG:String = "config";
		/**
		 * 配置文件名列表
		 */		
		private var configItemList:Array = [];
		/**
		 * 配置文件加载解析完成标志
		 */		
		private var configComplete:Boolean = false;
		/**
		 * 加载配置文件并解析
		 * @param configList 配置文件信息列表
		 * @param version 资源版本号。请求资源时加在url后的Get参数，以避免浏览器缓存问题而获取错误的资源。
		 * @param language 当前的语言环境 
		 */	
		private function loadConfig(configList:Vector.<ConfigItem>,version:String="",language:String="cn"):void
		{
			if(configComplete)
				return;
			dllConfig.language = language;
			dllConfig.version = version;
			var itemList:Vector.<DllItem> = new Vector.<DllItem>();
			var index:int = 0;
			for each(var config:ConfigItem in configList)
			{
				config.name = "DLL__CONFIG"+index;
				configItemList.push(config);
				var dllItem:DllItem = new DllItem(config.name,config.url,config.type);
				itemList.push(dllItem);
				index++;
			}
			groupName = GROUP_CONFIG;
			dllLoader.loadGroup(itemList);
		}
		
		/**
		 * 待加载的组名列表
		 */		
		private var groupList:Vector.<String> = new Vector.<String>();
		/**
		 * 根据组名加载一组资源,可多次调用此方法，Dll将会根据调用顺序依次加载每个组。
		 * @param name 要加载资源组的组名
		 */		
		public function loadGroup(name:String):void
		{
			if(groupList.indexOf(name)!=-1)
				return;
			groupList.push(name);
			loadNextGroup();
		}
		/**
		 * 正在加载的组名
		 */		
		private var groupName:String = GROUP_CONFIG;
		/**
		 * 加载下一组资源
		 */		
		private function loadNextGroup():void
		{
			if(!configComplete||dllLoader.inGroupLoading||groupList.length==0)
				return;
			groupName = groupList.shift();
			var group:Vector.<DllItem> = dllConfig.getGroupByName(groupName);
			dllLoader.loadGroup(group);
		}
		/**
		 * 队列加载进度事件
		 */		
		private function onGroupProgress(event:ProgressEvent):void
		{
			var dllEvent:DllEvent = new DllEvent(DllEvent.GROUP_PROGRESS);
			dllEvent.bytesTotal = event.bytesTotal;
			dllEvent.bytesLoaded = event.bytesLoaded;
			dllEvent.groupName = groupName;
			dispatchEvent(dllEvent);
		}
		
		/**
		 * dll配置数据
		 */		
		private var dllConfig:DllConfig = new DllConfig();
		/**
		 * 队列加载完成事件
		 */		
		private function onGroupComp(event:Event):void
		{
			var dllEvent:DllEvent;
			if(groupName==GROUP_CONFIG)
			{
				for each(var config:ConfigItem in configItemList)
				{
					var resolver:IResolver = getResolverByType(config.type);
					var data:Object = resolver.getRes(config.name);
					resolver.destroyRes(config.name);
					dllConfig.parseConfig(data,config.folder);
				}
				configComplete = true;
				dllEvent = new DllEvent(DllEvent.CONFIG_COMPLETE);
			}
			else
			{
				dllEvent = new DllEvent(DllEvent.GROUP_COMPLETE);
				dllEvent.groupName = groupName;
			}
			dispatchEvent(dllEvent);
			loadNextGroup();
		}
		
		/**
		 * 同步方式获取资源。<br/>
		 * 预加载的资源可以同步获取，但位图资源或含有需要异步解码的资源除外。<br/>
		 * 注意:获取的资源是全局共享的，若你需要修改它，请确保不会对其他模块造成影响，否则建议创建资源的副本以操作。
		 * @param key 对应配置文件里的name属性或sbuKeys属性的一项。
		 * @return 
		 * "swf" name:Loader subkey:Class<br/>
		 * "dxr" name:DxrFile subkey:DxrData<br/>
		 * "amf" name:Object<br/>
		 * "xml" name:XML<br/>
		 * "img" name:BitmapData<br/>
		 * "bin" name:ByteArray
		 */		
		private function getRes(key:String):*
		{
			var type:String = dllConfig.getType(key);
			if(type=="")
				return null;
			var resolver:IResolver = getResolverByType(type);
			return resolver.getRes(key);
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
			var resolver:IResolver = getResolverByType(type);
			var res:* = resolver.getRes(key);
			if(res)
			{
				doCompFunc(compFunc,res,other);
				return;
			}
			var name:String = dllConfig.getName(key);
			if(resolver.hasRes(name))
			{
				doGetResAsync(resolver,key,compFunc,other);
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
					asyncDic[name] = [args];
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
		private function doGetResAsync(resolver:IResolver,key:String,compFunc:Function,other:Object):void
		{
			resolver.getResAsync(key,function(data:*):void{
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
			var resolver:IResolver = getResolverByType(item.type);
			for each(var args:Object in argsList)
			{
				doGetResAsync(resolver,args.key,args.compFunc,args.other);
			}
		}
		/**
		 * 销毁某个资源文件的缓存数据,返回是否删除成功。
		 * @param name 配置文件中加载项的name属性
		 */
		public function destroyRes(name:String):Boolean
		{
			var type:String = dllConfig.getType(name);
			if(type=="")
				return false;
			var resolver:IResolver = getResolverByType(type);
			return resolver.destroyRes(name);
		}
	}
}