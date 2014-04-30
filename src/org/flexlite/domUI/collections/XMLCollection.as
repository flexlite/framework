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
	public class XMLCollection extends EventDispatcher 
		implements ICollection,ITreeCollection
	{
		/**
		 * 构造函数
		 * @param source 数据源
		 * @param openNodes 打开的节点列表
		 */		
		public function XMLCollection(source:XML=null,openNodes:Array=null)
		{
			super();	
			if(openNodes)
			{
				_openNodes = openNodes.concat();
			}
			if(source)
			{
				_source = source;
				if(_showRoot)
				{
					nodeList.push(_source);
				}
				addChildren(_source,nodeList);
			}
		}
		
		private var _source:XML;
		/**
		 * 数据源。注意：设置source会同时清空openNodes。
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
				addChildren(_source,nodeList);
			}
			dispatchCoEvent(CollectionEventKind.RESET);
		}
		
		/**
		 * 要显示的节点列表
		 */		
		private var nodeList:Array = [];
		
		private var _openNodes:Array = [];
		/**
		 * 处于展开状态的节点列表
		 */
		public function get openNodes():Array
		{
			return _openNodes.concat();
		}
		public function set openNodes(value:Array):void
		{
			_openNodes = value?value.concat():[];
			refresh();
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
			for each(var child:XML in children)
			{
				list.push(child);
				if ( _openNodes.indexOf(child)!=-1)
					addChildren(child, list);
			}
		}
		/**
		 * @inheritDoc
		 */		
		public function hasChildren(item:Object):Boolean
		{
			if(!(item is XML))
				return false;
			return XML(item).children().length()>0;
		}
		/**
		 * @inheritDoc
		 */	
		public function isItemOpen(item:Object):Boolean
		{
			return _openNodes.indexOf(item)!=-1;
		}	
		/**
		 * @inheritDoc
		 */	
		public function expandItem(item:Object,open:Boolean=true):void
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
				var i:int = index;
				while(list.length)
				{
					i++;
					var node:XML = list.shift();
					nodeList.splice(i,0,node);
					dispatchCoEvent(CollectionEventKind.ADD,i,-1,[node]);
				}
				dispatchCoEvent(CollectionEventKind.OPEN,index,index,[item]);
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
				index--;
				dispatchCoEvent(CollectionEventKind.CLOSE,index,index,[item]);
			}
		}
		/**
		 * @inheritDoc
		 */	
		public function getDepth(item:Object):int
		{
			var depth:int = 0;
			if(!(item is XML))
				return depth;
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