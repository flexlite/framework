package org.flexlite.domUI.collections
{
	import flash.events.EventDispatcher;
	
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	
	/**
	 * 集合数据发生改变 
	 */	
	[Event(name="collectionChange", type="org.flexlite.domUI.events.CollectionEvent")]
	
	[DXML(show="false")]
	
	[DefaultProperty(name="source")]
	/**
	 * XML的集合类数据结构包装器,通常作为Tree组件的数据源。
	 * @author DOM
	 */
	public class XMLCollection extends EventDispatcher implements ICollection
	{
		/**
		 * 构造函数
		 * @param source 数据源
		 * @param openNodes 打开的节点列表
		 */		
		public function XMLCollection(source:XML=null,openNodes:Array=null)
		{
			super();	
			if(source)
			{
				_source = source;
				_openNodes = openNodes?openNodes:[];
				if(_showRoot)
				{
					nodeList.push(_source);
				}
				else 
				{
					addChildren(_source,nodeList);
				}
			}
		}
		
		private var _source:XML;
		/**
		 * 数据源
		 */
		public function get source():XML
		{
			return _source;
		}

		public function set source(value:XML):void
		{
			_source = value;
			_openNodes = [];
			nodeList = [];
			if(_source)
			{
				if(_showRoot)
				{
					nodeList.push(_source);
				}
				else 
				{
					addChildren(_source,nodeList);
				}
			}
			dispatchCoEvent(CollectionEventKind.RESET);
		}
		
		/**
		 * 要显示的节点列表
		 */		
		private var nodeList:Array = [];
		
		private var _openNodes:Array = [];
		/**
		 * 打开的节点列表
		 */
		public function get openNodes():Array
		{
			return _openNodes.concat();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return nodeList.length;
		}
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			return nodeList[index];
		}
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			var length:int = nodeList.length;
			for(var i:int=0;i<length;i++)
			{
				if(nodeList[i]===item)
				{
					return i;
				}
			}
			return 0;
		}
		
		private var _showRoot:Boolean = false;
		/**
		 * 是否显示根节点,默认false。
		 */
		public function get showRoot():Boolean
		{
			return _showRoot;
		}
		public function set showRoot(value:Boolean):void
		{
			if(_showRoot==value)
				return;
			_showRoot = value;
			if(_source)
			{
				if(_showRoot)
				{
					nodeList.push(_source);
				}
				else
				{
					nodeList.shift();
				}
			}
		}
		/**
		 * 添加打开的节点到列表
		 */		
		private function addChildren(parent:XML,list:Array):void
		{
			var children:XMLList = parent.children();
			var length:int = children.length();
			for (var i:int = 0; i < length; i++)
			{
				list.push(children[i]);
				if (isOpen(children[i]))
					addChildren(children[i], list);
			}
		}
		
		/**
		 * 指定的节点是否打开
		 */		
		public function isOpen(item:Object):Boolean
		{
			return _openNodes.indexOf(item)!=-1;
		}	
		/**
		 * 打开或关闭一个节点
		 * @param item 要打开或关闭的节点
		 * @param open true表示打开节点，反之关闭。
		 */		
		public function expandNode(item:Object,open:Boolean=true):void
		{
			if(!(item is XML))
				return;
			if(open)
				openNode(item as XML);
			else
				closeNode(item as XML);
		}
		/**
		 * 打开一个节点
		 */		
		private function openNode(item:XML):void
		{
			var index:int = nodeList.indexOf(item);
			if(index!=-1&&_openNodes.indexOf(item)==-1)
			{
				_openNodes.push(item);
				var list:Array = [];
				addChildren(item,list);
				while(list.length)
				{
					index++;
					var node:XML = list.shift();
					nodeList.splice(index,0,node);
					dispatchCoEvent(CollectionEventKind.ADD,index,-1,[node]);
				}
			}
		}
		/**
		 * 关闭一个节点
		 */		
		private function closeNode(item:XML):void
		{
			var index:int = _openNodes.indexOf(item);
			if(index==-1)
				return;
			_openNodes.splice(index,1);
			index = nodeList.indexOf(item);
			if(index!=-1)
			{
				
				var list:Array = [];
				addChildren(item,list);
				index++;
				while(list.length)
				{
					var node:XML = nodeList.splice(index,1)[0];
					dispatchCoEvent(CollectionEventKind.REMOVE,index,-1,[node]);
					list.shift();
				}
			}
		}
		/**
		 * 获取节点的深度
		 */		
		public function getDepth(item:XML):int
		{
			var depth:int = 0;
			var parent:XML = item.parent();
			while (parent)
			{
				depth++;
				parent = parent.parent();
			}
			if(depth>0&&!_showRoot)
				depth--;
			return depth;
		}
		/**
		 * 刷新数据源。
		 */		
		public function refresh():void
		{
			nodeList = [];
			if(_source)
			{
				if(_showRoot)
				{
					nodeList.push(_source);
				}
				addChildren(_source,nodeList);
			}
			dispatchCoEvent(CollectionEventKind.REFRESH);
		}
		
		/**
		 * 抛出事件
		 */		
		private function dispatchCoEvent(kind:String = null, location:int = -1,
										 oldLocation:int = -1, items:Array = null,oldItems:Array=null):void
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,
				kind,location,oldLocation,items,oldItems);
			dispatchEvent(event);
		}

	}
}