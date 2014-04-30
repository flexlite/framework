package org.flexlite.domDll.resolvers
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IResolver;
	
	/**
	 * 组资源解析器<br/>
	 * 为了避免零碎文件造成的加载时间过长，可将预加载的资源组合并成一个字节流文件，通过此类加载并分拆。
	 * @author DOM
	 */
	public class GrpResolver extends BinResolver
	{
		/**
		 * 构造函数
		 */		
		public function GrpResolver()
		{
			super();
		}
		
		/**
		 * name和subkey到解析器的映射表
		 */		
		private var keyMap:Dictionary = new Dictionary;
		/**
		 * EnterFrame事件抛出者
		 */		
		private var eventDispatcher:Shape = new Shape();
		/**
		 * 已经添加过事件监听的标志
		 */		
		private var listenForEnterFrame:Boolean = false;
		/**
		 * 带回调列表
		 */		
		private var completeList:Array = [];
		/**
		 * @inheritDoc
		 */
		override protected function onLoadFinish(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var data:Object = dllItemDic[loader];
			delete dllItemDic[loader];
			recycler.push(loader);
			var dllItem:DllItem = data.item;
			var compFunc:Function = data.func;
			dllItem.loaded = (event.type==Event.COMPLETE);
			if(dllItem.loaded)
			{
				loadBytes(loader.data,dllItem.name);
			}
			
			completeList.push({compFunc:compFunc,dllItem:dllItem,count:1});
			if(!listenForEnterFrame)
			{
				eventDispatcher.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				listenForEnterFrame = true;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			for(var i:int=completeList.length-1;i>=0;i--)
			{
				var data:Object = completeList[i];
				data.count--;
				if(data.count<0)
				{
					completeList.splice(i,1);
					data.compFunc(data.dllItem);
				}
			}
			if(completeList.length==0)
			{
				eventDispatcher.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				listenForEnterFrame = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function loadBytes(bytes:ByteArray,name:String):void
		{
			if(keyMap[name]||!bytes)
				return;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error){}
			bytes.position = 0;
			if(bytes.readUTF()!="dll")
				return;
			var resList:Object;
			try
			{
				resList = bytes.readObject();
			}
			catch(e:Error)
			{
				return;
			}
			keyMap[name] = this;
			for(var subName:String in resList)
			{
				if(keyMap[subName])
					continue;
				var item:Object = resList[subName];
				var resolver:IResolver = getResolverByType(item.type);
				var subkeys:Array = String(item.subkeys).split(",");
				subkeys.push(subName);
				for each(var key:String in subkeys)
				{
					if(keyMap[key]!=null)
						continue;
					keyMap[key] = resolver;
				}
				resolver.loadBytes(item.bytes,subName);
			}
		}
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			var resolver:IResolver = keyMap[key];
			if(resolver&&resolver!=this)
				return resolver.getRes(key);
			else
				return null;
		}
		/**
		 * @inheritDoc
		 */
		override public function getResAsync(key:String,compFunc:Function):void
		{
			var resolver:IResolver = keyMap[key];
			if(resolver&&resolver!=this)
				resolver.getResAsync(key,compFunc);
			else
				compFunc(null);
		}
		/**
		 * @inheritDoc
		 */
		override public function hasRes(name:String):Boolean
		{
			return keyMap[name]!=null;
		}
		/**
		 * @inheritDoc
		 */
		override public function destroyRes(name:String):Boolean
		{
			var resolver:IResolver = keyMap[name];
			if(resolver&&resolver!=this)
				return resolver.destroyRes(name);
			else
				return false;
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
				resolver = resolverDic[type] = Injector.getInstance(IResolver,type);
			return resolver;
		}
	}
}
