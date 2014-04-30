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
	 * Object的集合类数据结构包装器,通常作为Tree组件的数据源。
	 * @author DOM
	 */
	public class ObjectCollection extends EventDispatcher 
		implements ICollection,ITreeCollection
	{
		/**
		 * 构造函数
		 * @param childrenKey 要从item中获取子项列表的属性名,属性值为一个数组或Vector。
		 * @param parentKey 要从item中获取父级项的属性名
		 */		
		public function ObjectCollection(childrenKey:String="children",parentKey:String="parent")
		{
			super();
			this.childrenKey = childrenKey;
			this.parentKey = parentKey;
		}
		/**
		 * 要从item中获取子项列表的属性名
		 */		
		private var childrenKey:String;
		/**
		 * 要从item中获取父级项的属性名
		 */		
		private var parentKey:String;
		
		private var _source:Object;
		/**
		 * 数据源。注意：设置source会同时清空openNodes。
		 */
		public function get source():Object
		{
			return _source;
		}

		public function set source(value:Object):void
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
					_openNodes = [_source];
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
			return -1;
		}
		
		/**
		 * 通知视图，某个项目的属性已更新。
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
		 * 删除指定节点
		 */
		public function removeItem(item:Object):void
		{
			if(isItemOpen(item))
				closeNode(item);
			if(!item)
				return;
			var parent:Object = item[parentKey];
			if(!parent)
				return;
			var list:Array = parent[childrenKey];
			if(!list)
				return;
			var index:int = list.indexOf(item);
			if(index!=-1)
				list.splice(index,1);
			item[parentKey] = null;
			index = nodeList.indexOf(item);
			if(index!=-1)
			{
				nodeList.splice(index,1);
				dispatchCoEvent(CollectionEventKind.REMOVE,index,-1,[item]);
			}
			
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
					nodeList.splice(0,0,_source);
				}
				else
				{
					nodeList.shift();
					if(openNodes.indexOf(_source)==-1)
						openNodes.push(_source);
				}
				refresh();
			}
		}
		
		/**
		 * 添加打开的节点到列表
		 */		
		private function addChildren(parent:Object,list:Array):void
		{
			if(!parent.hasOwnProperty(childrenKey)||_openNodes.indexOf(parent)==-1)
				return;
			for each(var child:Object in parent[childrenKey])
			{
				list.push(child);
				addChildren(child, list);
			}
		}
		/**
		 * @inheritDoc
		 */		
		public function hasChildren(item:Object):Boolean
		{
			if(item.hasOwnProperty(childrenKey))
				return item[childrenKey].length>0;
			return false;
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
			if(open)
				openNode(item);
			else
				closeNode(item);
		}
		/**
		 * 打开一个节点
		 */		
		private function openNode(item:Object):void
		{
			if(_openNodes.indexOf(item)==-1)
			{
				_openNodes.push(item);
				var index:int = nodeList.indexOf(item);
				if(index!=-1)
				{
					var list:Array = [];
					addChildren(item,list);
					var i:int = index;
					while(list.length)
					{
						i++;
						var node:Object = list.shift();
						nodeList.splice(i,0,node);
						dispatchCoEvent(CollectionEventKind.ADD,i,-1,[node]);
					}
					dispatchCoEvent("open",index,index,[item]);
				}
			}
		}
		/**
		 * 关闭一个节点
		 */		
		private function closeNode(item:Object):void
		{
			var index:int = _openNodes.indexOf(item);
			if(index==-1)
				return;
			var list:Array = [];
			addChildren(item,list);
			_openNodes.splice(index,1);
			index = nodeList.indexOf(item);
			if(index!=-1)
			{
				index++;
				while(list.length)
				{
					var node:Object = nodeList.splice(index,1)[0];
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
			var parent:Object = item[parentKey];
			while (parent)
			{
				depth++;
				parent = parent[parentKey];
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
		/**
		 * 一个工具方法，给parent的子项以及子孙项赋值父级引用。
		 * @param parent 要遍历子项的parent对象。
		 * @param childrenKey 要从parent中获取子项列表的属性名,属性值为一个数组或Vector。
		 * @param parentKey 要给子项赋值父级引用的属性名。
		 */
		public static function assignParent(parent:Object,childrenKey:String="children",parentKey:String="parent"):void
		{
			if(!parent.hasOwnProperty(childrenKey))
				return;
			for each(var child:Object in parent[childrenKey])
			{
				try
				{
					child[parentKey] = parent;
				}
				catch(e:Error){}
				assignParent(child);
			}
		}
	}
}