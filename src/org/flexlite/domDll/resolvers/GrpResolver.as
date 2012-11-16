package org.flexlite.domDll.resolvers
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.Injector;
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
		 * @inheritDoc
		 */
		override public function loadBytes(bytes:ByteArray,name:String):void
		{
			if(fileDic[name]||!bytes)
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
			for(var name:String in resList)
			{
				if(keyMap[name])
					continue;
				var item:Object = resList[name];
				var resolver:IResolver = getResolverByType(item.type);
				var subkeys:Array = String(item.subkeys).split(",");
				subkeys.push(name);
				for each(var key:String in subkeys)
				{
					if(keyMap[key]!=null)
						continue;
					keyMap[key] = resolver;
				}
				resolver.loadBytes(item.bytes,name);
			}
		}
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			var resolver:IResolver = keyMap[key];
			if(resolver)
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
			if(resolver)
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
			if(resolver)
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