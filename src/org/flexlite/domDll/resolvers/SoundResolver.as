package org.flexlite.domDll.resolvers
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.flexlite.domDll.core.DllItem;
	import org.flexlite.domDll.core.IResolver;
	
	
	/**
	 * 声音文件解析器
	 * @author DOM
	 */
	public class SoundResolver implements IResolver
	{
		/**
		 * 构造函数
		 */		
		public function SoundResolver()
		{
		}
		
		/**
		 * Sound对象缓存字典
		 */		
		private var soundDic:Dictionary = new Dictionary;
		/**
		 * 加载项字典
		 */		
		private var dllItemDic:Dictionary = new Dictionary();
		/**
		 * @inheritDoc
		 */
		public function loadFile(dllItem:DllItem, compFunc:Function, progressFunc:Function):void
		{
			if(soundDic[dllItem.name])
			{
				compFunc(dllItem);
				return;
			}
			if(!dllItem.groupName)
			{
				var sound:Sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
				sound.load(new URLRequest(dllItem.url));
				soundDic[dllItem.name] = sound;
				dllItem.loaded = true;
				compFunc(dllItem);
				return;
			}
			var loader:Sound = new Sound();
			loader.addEventListener(Event.COMPLETE,onLoadFinish);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadFinish);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			dllItemDic[loader] = {item:dllItem,func:compFunc,progress:progressFunc};
			loader.load(new URLRequest(dllItem.url));
		}
		/**
		 * 防止加载不到音乐文件而报错
		 */		
		private function onIoError(event:Event):void
		{
		}
		/**
		 * 此方法无效,Sound在低版本的Flash Player上不能通过字节流加载。
		 */
		public function loadBytes(bytes:ByteArray,name:String):void
		{
		}
		/**
		 * 加载进度事件
		 */		
		private function onProgress(event:ProgressEvent):void
		{
			var loader:Sound = event.target as Sound;
			var data:Object = dllItemDic[loader];
			var dllItem:DllItem = data.item;
			var progressFunc:Function = data.progress;
			progressFunc(event.bytesLoaded,dllItem);
		}
		
		/**
		 * 一项加载结束
		 */		
		private function onLoadFinish(event:Event):void
		{
			var loader:Sound = event.target as Sound;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onLoadFinish);
			loader.removeEventListener(Event.COMPLETE,onLoadFinish);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			var data:Object = dllItemDic[loader];
			delete dllItemDic[loader];
			var dllItem:DllItem = data.item;
			var compFunc:Function = data.func;
			dllItem.loaded = (event.type==Event.COMPLETE);
			if(dllItem.loaded)
			{
				if(!soundDic[dllItem.name])
				{
					soundDic[dllItem.name] = loader;
				}
			}
			compFunc(dllItem);
		}
		/**
		 * @inheritDoc
		 */
		public function getRes(key:String):*
		{
			return soundDic[key];
		}
		/**
		 * @inheritDoc
		 */
		public function getResAsync(key:String, compFunc:Function):void
		{
			if(compFunc==null)
				return;
			var res:Sound = getRes(key);
			compFunc(res);
		}
		/**
		 * @inheritDoc
		 */
		public function hasRes(name:String):Boolean
		{
			return soundDic[name]!=null;
		}
		/**
		 * @inheritDoc
		 */
		public function destroyRes(name:String):Boolean
		{
			if(soundDic[name])
			{
				delete soundDic[name];
				return true;
			}
			return false;
		}
	}
}