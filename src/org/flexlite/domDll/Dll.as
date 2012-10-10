package org.flexlite.domDll
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domDll.assetLibs.AmfAssetLib;
	import org.flexlite.domDll.assetLibs.BinAssetLib;
	import org.flexlite.domDll.core.IAssetLib;
	import org.flexlite.domDll.assetLibs.XmlAssetLib;
	import org.flexlite.domDll.core.DllConfig;
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.DllLoader;
	
	
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
		public static function get eventDispather():EventDispatcher
		{
			return instance;
		}
		/**
		 * 当前的语言环境 
		 */		
		public static function get language():String
		{
			return instance.language;
		}
		
		private var language:String;
		
		/**
		 * 加载初始化配置文件并解析，解析完成后开始加载loading界面素材(若有配置)。
		 * @param path 配置文件路径
		 * @param type 配置文件类型
		 * @param language 当前的语言环境 
		 */		
		public static function loadConfig(pathList:Array,type:String="xml",language:String="cn"):void
		{
			instance.loadConfig(pathList,type,language);
		}
		/**
		 * 开始加载配置为"预加载"的资源队列。
		 */		
		public static function loadPreload():void
		{
			instance.loadPreload();
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
			Injector.mapClass(IAssetLib,XmlAssetLib,DllItem.TYPE_XML);
			Injector.mapClass(IAssetLib,BinAssetLib,DllItem.TYPE_BIN);
			Injector.mapClass(IAssetLib,AmfAssetLib,DllItem.TYPE_AMF);
			dllLoader = new DllLoader();
			dllLoader.addEventListener(ProgressEvent.PROGRESS,onGroupProgress);
			dllLoader.addEventListener(Event.COMPLETE,onGroupComp);
		}
		/**
		 * 队列加载进度事件
		 */		
		private function onGroupProgress(event:ProgressEvent):void
		{
			
		}
		/**
		 * 队列加载完成事件
		 */		
		private function onGroupComp(event:Event):void
		{
			switch(groupName)
			{
				case GROUP_CONFIG:
					onConfigComp();
					break;
				case GROUP_LOADING:
					
					break;
				case GROUP_PRELOAD:
					
					break;
			}
		}
		/**
		 * 正在加载的组名
		 */		
		private var groupName:String;
		
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
		 * 加载初始化配置文件并解析，解析完成后开始加载loading界面素材(若有配置)。
		 * @param path 配置文件路径
		 * @param type 配置文件类型
		 * @param language 当前的语言环境 
		 */		
		private function loadConfig(pathList:Array,type:String="xml",language:String="cn"):void
		{
			this.language = language;
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
		private var analyzeDic:Dictionary = new Dictionary;
		/**
		 * dll配置数据
		 */		
		private var dllConfig:DllConfig;
		/**
		 * 配置文件加载并解析完成
		 */		
		private function onConfigComp():void
		{
			dllConfig = new DllConfig(language);
			var analyze:IAssetLib = analyzeDic[configType];
			if(!analyze)
			{
				analyze = analyzeDic[configType] = Injector.getInstance(IAssetLib,configType);
			}
			for each(var name:String in configNameList)
			{
				var config:Object = analyze.getData(name);
				analyze.destoryData(name);
				dllConfig.parseConfig(config);
			}
		}
		/**
		 * 开始加载配置为"预加载"的资源队列。
		 */		
		private function loadPreload():void
		{
			
		}
	}
}