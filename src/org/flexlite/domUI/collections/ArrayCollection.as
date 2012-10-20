package org.flexlite.domUI.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	
	/**
	 * 集合数据发生改变 
	 */	
	[Event(name="collectionChange", type="org.flexlite.domUI.events.CollectionEvent")]
	
	/**
	 * 数组的集合类数据结构包装器
	 * 通常作为列表组件的数据源，使用这种数据结构包装普通数组，
	 * 能在数据源发生改变的时候主动通知视图刷新变更的数据项
	 * 可以直接对其使用for in，for each in或ac[i]标方法遍历数据
	 * @author DOM
	 */
	public class ArrayCollection extends Proxy implements ICollection
	{
		/**
		 * 构造函数
		 * @param source 数据源
		 */		
		public function ArrayCollection(source:Array = null)
		{
			super();
			eventDispatcher = new EventDispatcher(this);
			if(source!=null)
			{
				_source = source;
			}
			else
			{
				_source = [];
			}
		}
		
		private var _source:Array;
		/**
		 * 数据源
		 * 通常情况下请不要直接操作数据源，否则对应的视图无法收到数据改变的通知
		 * 若对数据源进行了排序或过滤等操作，请手动调用refresh()方法刷新数据
		 */
		public function get source():Array
		{
			return _source;
		}

		public function set source(value:Array):void
		{
			_source = value;
			dispatchCoEvent(CollectionEventKind.RESET);
		}
		/**
		 * 在对数据源进行排序或过滤操作后可以手动调用此方法刷新所有数据,以更新视图。
		 */		
		public function refresh():void
		{
			dispatchCoEvent(CollectionEventKind.REFRESH);
		}
		
		public function contains(item:Object):Boolean
		{
			return getItemIndex(item)!=-1;
		}
		
		/**
		 * 检测索引是否超出范围
		 */		
		private function checkIndex(index:int):void
		{
			if(index<0||index>=_source.length)
			{
				throw new RangeError("索引:\""+index+"\"超出集合元素索引范围");
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// ICollection接口实现方法
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return _source.length;
		}
		/**
		 * @inheritDoc
		 */
		public function addItem(item:Object):void
		{
			_source.push(item);
			dispatchCoEvent(CollectionEventKind.ADD,_source.length-1,-1,[item]);
		}
		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:Object, index:int):void
		{
			if(index<0||index>_source.length)
			{
				throw new RangeError("索引:\""+index+"\"超出集合元素索引范围");
			}
			_source.splice(index,0,item);
			dispatchCoEvent(CollectionEventKind.ADD,index,-1,[item]);
		}
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			return _source[index];
		}
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			var found:Boolean = false;
			var index:int = 0;
			for each(var obj:Object in _source)
			{
				if(obj===item)
				{
					found = true;
					break;
				}
				index++;
			}
			if(found)
			{
				return index;
			}
			return -1;
		}
		/**
		 * @inheritDoc
		 */
		public function itemUpdated(item:Object):void
		{
			var index:int = getItemIndex(item);
			if(index!=-1)
			{
				dispatchCoEvent(CollectionEventKind.UPDATE,index,-1,[item]);
			}
		}
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			var items:Array = _source.concat();
			_source.length = 0;
			dispatchCoEvent(CollectionEventKind.REMOVE,0,-1,items);
		}
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:int):Object
		{
			checkIndex(index);
			var item:Object = _source.splice(index,1);
			dispatchCoEvent(CollectionEventKind.REMOVE,index,-1,[item]);
			return item;
		}
		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(item:Object, index:int):Object
		{
			checkIndex(index);
			var oldItem:Object = _source.splice(index,1,item);
			dispatchCoEvent(CollectionEventKind.REPLACE,index,-1,[item]);
			return oldItem;
		}
		/**
		 * @inheritDoc
		 */
		public function moveItemAt(oldIndex:int,newIndex:int):Object
		{
			checkIndex(oldIndex);
			checkIndex(newIndex);
			var item:Object = _source.splice(oldIndex,1);
			_source.splice(newIndex,0,item);
			dispatchCoEvent(CollectionEventKind.MOVE,newIndex,oldIndex,[item]);
			return item;
		}
		
		/**
		 * 抛出事件
		 */		
		private function dispatchCoEvent(kind:String = null, location:int = -1,
										 oldLocation:int = -1, items:Array = null):void
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,
				kind,location,oldLocation,items);
			dispatchEvent(event);
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 事件接口实现方法
		//
		//--------------------------------------------------------------------------
		
		private var eventDispatcher:EventDispatcher;
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String,
										 listener:Function,
										 useCapture:Boolean = false,
										 priority:int = 0,
										 useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture,
				priority, useWeakReference);
		}
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String,
											listener:Function,
											useCapture:Boolean = false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
		
		//--------------------------------------------------------------------------
		//
		// 覆盖Proxy的方法，以实现对for each 和for in的支持
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var index:int = convertToIndex(name);
			return getItemAt(index);
		}
		/**
		 * 转换属性名为索引
		 */		
		private function convertToIndex(name:*):int
		{
			if (name is QName)
				name = name.localName;
			
			var index:int = -1;
			try
			{
				var n:Number = parseInt(String(name));
				if (!isNaN(n))
					index = int(n);
			}
			catch(e:Error)
			{
			}
			return index;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var index:int = convertToIndex(name);
			replaceItemAt(value, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var index:int = convertToIndex(name);
			if (index == -1)
				return false;
			return index >= 0 && index < length;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < length ? index + 1 : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextName(index:int):String
		{
			return (index - 1).toString();
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return getItemAt(index - 1);
		}    
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			return null;
		}
		
		
	}
}