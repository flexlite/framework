package org.flexlite.domDll.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDll.events.DllEvent;
	
	use namespace dx_internal;
	/**
	 * 队列加载进度事件
	 */	
	[Event(name="groupProgress",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 队列加载完成事件
	 */	
	[Event(name="groupComplete",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 一个加载项加载结束事件，可能是加载成功也可能是加载失败。
	 */	
	[Event(name="itemLoadFinished",type="org.flexlite.domDll.events.DllEvent")]
	/**
	 * 多文件队列加载器
	 * @author DOM
	 */
	public class DllLoader extends EventDispatcher
	{
		/**
		 * 构造函数
		 * @param thread 最大同时加载数
		 */		
		public function DllLoader(thread:int=2,retryTimes:int=3)
		{
			super();
			this.thread = thread;
			this.retryTimes = retryTimes;
		}
		
		/**
		 * 最大并发加载数 
		 */		
		private var thread:int = 2;
		/**
		 * 加载失败的重试次数
		 */		
		private var retryTimes:int = 3;
		
		private var _version:String;
		/**
		 * 设置当前的资源版本号
		 */
		public function setVersion(value:String):void
		{
			_version = value;
		}

		
		/**
		 * 当前队列文件字节流总大小,key为groupName
		 */		
		private var totalSizeDic:Dictionary = new Dictionary;
		/**
		 * 已经加载的字节数,key为groupName
		 */		
		private var loadedSizeDic:Dictionary = new Dictionary;
		/**
		 * 当前组加载的项总个数,key为groupName
		 */		
		private var groupTotalDic:Dictionary = new Dictionary;
		/**
		 * 已经加载的项个数,key为groupName
		 */		
		private var numLoadedDic:Dictionary = new Dictionary;
		/**
		 * 正在加载的组列表,key为groupName
		 */		
		private var itemListDic:Dictionary = new Dictionary;
		
		/**
		 * 优先级队列,key为priority，value为groupName列表
		 */		
		private var priorityQueue:Object = {};
		/**
		 * 加载失败的项列表
		 */		
		private var retryTimesDic:Dictionary = new Dictionary();
		/**
		 * 加载失败的项列表
		 */		
		private var failedList:Vector.<DllItem> = new Vector.<DllItem>();
		/**
		 * 检查指定的组是否正在加载中
		 */		
		public function isGroupInLoading(groupName:String):Boolean
		{
			return itemListDic[groupName]!==undefined;
		}
		/**
		 * 开始加载一组文件
		 * @param list 加载项列表
		 * @param groupName 组名
		 * @param priority 加载优先级
		 */			
		public function loadGroup(list:Vector.<DllItem>,groupName:String,priority:int=0):void
		{
			if(itemListDic[groupName]||!groupName)
				return;
			if(!list||list.length==0)
			{
				var event:DllEvent = new DllEvent(DllEvent.GROUP_COMPLETE);
				event.groupName = groupName;
				dispatchEvent(event);
				return;
			}
			if(priorityQueue[priority])
				priorityQueue[priority].push(groupName);
			else
				priorityQueue[priority] = [groupName];
			itemListDic[groupName] = list;
			var totalSize:int = 0;
			for each(var dllItem:DllItem in list)
			{
				dllItem._groupName = groupName;
				dllItem.bytesLoaded = 0;
				totalSize += dllItem.size;
			}
			totalSizeDic[groupName] = totalSize;
			loadedSizeDic[groupName] = 0;
			groupTotalDic[groupName] = list.length;
			numLoadedDic[groupName] = 0;
			next();
		}
		/**
		 * 延迟加载队列
		 */		
		private var lazyLoadList:Vector.<DllItem> = new Vector.<DllItem>();
		/**
		 * 加载一个文件
		 * @param dllItem 要加载的项
		 */		
		public function loadItem(dllItem:DllItem):void
		{
			lazyLoadList.push(dllItem);
			dllItem._groupName = "";
			next();
		}
		/**
		 * 资源解析库字典类
		 */		
		private var resolverDic:Dictionary = new Dictionary;
		/**
		 * 正在加载的线程计数
		 */		
		private var loadingCount:int = 0;
		/**
		 * 加载下一项
		 */		
		private function next():void
		{
			while(loadingCount<thread)
			{
				var dllItem:DllItem = getOneDllItem();
				if(!dllItem)
					break;
				loadingCount++;
				dllItem.startTime = getTimer();
				if(dllItem.loaded)
				{
					onItemProgress(dllItem.size,dllItem);
					onItemComplete(dllItem);
				}
				else
				{
					var resolver:IResolver = resolverDic[dllItem.type];
					if(!resolver)
					{
						resolver = resolverDic[dllItem.type] = Injector.getInstance(IResolver,dllItem.type);
					}
					var url:String = dllItem.url;
					if(_version&&url.indexOf("?v=")==-1)
					{
						if(url.indexOf("?")==-1)
							url += "?v="+_version;
						else
							url += "&v="+_version;
						dllItem.url = url;
					}
					resolver.loadFile(dllItem,onItemComplete,onItemProgress);
				}
			}
		}
		
		/**
		 * 当前应该加载同优先级队列的第几列
		 */		
		private var queueIndex:int = 0;
		/**
		 * 获取下一个待加载项
		 */		
		private function getOneDllItem():DllItem
		{
			if(failedList.length>0)
				return failedList.shift();
			var maxPriority:int = int.MIN_VALUE;
			for(var p:* in priorityQueue)
			{
				maxPriority = Math.max(maxPriority,int(p));
			}
			var queue:Array = priorityQueue[maxPriority];
			if(!queue||queue.length==0)
			{
				if(lazyLoadList.length==0)
					return null;
				//后请求的先加载，以便更快获取当前需要的资源
				return lazyLoadList.pop();
			}
			var length:int = queue.length;
			var list:Vector.<DllItem>;
			for(var i:int=0;i<length;i++)
			{
				if(queueIndex>=length)
					queueIndex = 0;
				list = itemListDic[queue[queueIndex]];
				if(list.length>0)
					break;
				queueIndex++;
			}
			if(list.length==0)
				return null;
			return list.shift();
		}
		/**
		 * 加载进度更新
		 */		
		private function onItemProgress(bytesLoaded:int,dllItem:DllItem):void
		{
			if(!dllItem._groupName)
				return;
			var groupName:String = dllItem._groupName;
			loadedSizeDic[groupName] += bytesLoaded - dllItem.bytesLoaded;
			dllItem.bytesLoaded = bytesLoaded;
			var progressEvent:DllEvent = new DllEvent(DllEvent.GROUP_PROGRESS);
			progressEvent.groupName = groupName;
			progressEvent.bytesLoaded = loadedSizeDic[groupName];
			progressEvent.bytesTotal = totalSizeDic[groupName];
			dispatchEvent(progressEvent);
		}
		/**
		 * 加载结束
		 */		
		private function onItemComplete(dllItem:DllItem):void
		{
			loadingCount--;
			if(!dllItem.loaded)
			{
				if(!retryTimesDic[dllItem])
					retryTimesDic[dllItem] = 0;
				retryTimesDic[dllItem]++;
				if(retryTimesDic[dllItem]<=retryTimes)
				{
					failedList.push(dllItem);
					next();
					return;
				}
				else
				{
					delete retryTimesDic[dllItem];
				}
			}
			dllItem._loadTime = getTimer()-dllItem.startTime;
			var groupName:String = dllItem._groupName;
			var itemLoadEvent:DllEvent = new DllEvent(DllEvent.ITEM_LOAD_FINISHED);
			itemLoadEvent.groupName = groupName;
			itemLoadEvent.dllItem = dllItem;
			dispatchEvent(itemLoadEvent);
			if(dllItem.compFunc!=null)
				dllItem.compFunc(dllItem);
			if(groupName)
			{
				numLoadedDic[groupName]++;
				if(!dllItem.loaded)
					loadedSizeDic[groupName] += dllItem.size;
				var progressEvent:DllEvent = new DllEvent(DllEvent.GROUP_PROGRESS);
				progressEvent.groupName = groupName;
				progressEvent.bytesLoaded = loadedSizeDic[groupName];
				progressEvent.bytesTotal = totalSizeDic[groupName];
				dispatchEvent(progressEvent);
				if(numLoadedDic[groupName]==groupTotalDic[groupName])
				{
					removeGroupName(groupName);
					delete totalSizeDic[groupName];
					delete loadedSizeDic[groupName];
					delete groupTotalDic[groupName];
					delete numLoadedDic[groupName];
					delete itemListDic[groupName];
					
					var event:DllEvent = new DllEvent(DllEvent.GROUP_COMPLETE);
					event.groupName = groupName;
					dispatchEvent(event);
				}
			}
			next();
		}
		/**
		 * 从优先级队列中移除指定的组名
		 */		
		private function removeGroupName(groupName:String):void
		{
			for(var p:* in priorityQueue)
			{
				var queue:Array = priorityQueue[p];
				var length:int = queue.length;
				var index:int = 0;
				var found:Boolean = false;
				for each(var name:String in queue)
				{
					if(name==groupName)
					{
						queue.splice(index,1);
						found = true;
						break;
					}
					index++;
				}
				if(found)
				{
					if(queue.length==0)
					{
						delete priorityQueue[p];
					}
					break;
				}
			}
		}
	}
}