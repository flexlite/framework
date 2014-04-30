package org.flexlite.domUI.components
{
	import org.flexlite.domUI.collections.ITreeCollection;
	import org.flexlite.domUI.components.supportClasses.TreeItemRenderer;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.events.TreeEvent;
	
	/**
	 * 子节点打开或关闭前一刻分派。可以调用preventDefault()方法阻止节点的状态改变。 
	 */	
	[Event(name="itemOpening", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点打开，注意：只有通过交互操作引起的节点打开才会抛出此事件。
	 */	
	[Event(name="itemOpen", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点关闭,注意：只有通过交互操作引起的节点关闭才会抛出此事件。
	 */	
	[Event(name="itemClose", type="org.flexlite.domUI.events.TreeEvent")]
	
	[DXML(show="true")]
	
	/**
	 * 树状列表组件
	 * @author DOM
	 */
	public class Tree extends List
	{
		/**
		 * 构造函数
		 */		
		public function Tree()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(!itemRenderer)
				itemRenderer = TreeItemRenderer;
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Tree;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is ITreeItemRenderer&&dataProvider is ITreeCollection)
			{
				var treeCollection:ITreeCollection = dataProvider as ITreeCollection;
				var treeRenderer:ITreeItemRenderer = renderer as ITreeItemRenderer;
				treeRenderer.hasChildren = treeCollection.hasChildren(data);
				treeRenderer.opened = treeCollection.isItemOpen(data);
				treeRenderer.depth = treeCollection.getDepth(data);
				treeRenderer.iconSkinName = itemToIcon(data);
			}
			return super.updateRenderer(renderer, itemIndex, data);
		}
		/**
		 * 根据数据项返回项呈示器中图标的skinName属性值
		 */		
		public function itemToIcon(data:Object):Object
		{
			if(!data)
				return null;
			
			if(_iconFunction!=null)
				return _iconFunction(data);
			
			var skinName:Object;
			if(data is XML)
			{
				try
				{
					if(data[iconField].length() != 0)
					{
						skinName = String(data[iconField]);
					}
				}
				catch(e:Error)
				{
				}
			}
			else if(data is Object)
			{
				try
				{
					if(data[iconField])
					{
						skinName = data[iconField];
					}
				}
				catch(e:Error)
				{
				}
			}
			return skinName;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			if(event.renderer is ITreeItemRenderer)
				event.renderer.addEventListener(TreeEvent.ITEM_OPENING,onItemOpening);
		}
		/**
		 * 节点即将打开
		 */		
		private function onItemOpening(event:TreeEvent):void
		{
			var renderer:ITreeItemRenderer = event.itemRenderer;
			var item:Object = event.item;
			if(!renderer||!(dataProvider is ITreeCollection))
				return;
			if(dispatchEvent(event))
			{
				var opend:Boolean = !renderer.opened;
				ITreeCollection(dataProvider).expandItem(item,opend);
				var type:String = opend?TreeEvent.ITEM_OPEN:TreeEvent.ITEM_CLOSE;
				var evt:TreeEvent = new TreeEvent(type,false,false,renderer.itemIndex,item,renderer);
				dispatchEvent(evt);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			if(event.renderer is ITreeItemRenderer)
				event.renderer.removeEventListener(TreeEvent.ITEM_OPENING,onItemOpening);
		}
		/**
		 * 图标字段或函数改变标志
		 */		
		private var iconFieldOrFunctionChanged:Boolean = false;
		
		private var _iconField:String;
		/**
		 * 数据项中用来确定图标skinName属性值的字段名称。另请参考UIAsset.skinName。
		 * 若设置了iconFunction，则设置此属性无效。
		 */		
		public function get iconField():String
		{
			return _iconField;
		}
		public function set iconField(value:String):void
		{
			if(_iconField==value)
				return;
			_iconField = value;
			iconFieldOrFunctionChanged = true;
			invalidateProperties();
		}
		
		private var _iconFunction:Function;
		/**
		 * 用户提供的函数，在每个数据项目上运行以确定其图标的skinName值。另请参考UIAsset.skinName。
		 * 示例：iconFunction(item:Object):Object
		 */		
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		public function set iconFunction(value:Function):void
		{
			if(_iconFunction==value)
				return;
			_iconFunction = value;
			iconFieldOrFunctionChanged = true;
			invalidateProperties();
		}
		/**
		 * 打开或关闭一个节点,注意，此操作不会抛出open或close事件。
		 * @param item 要打开或关闭的节点
		 * @param open true表示打开节点，反之关闭。
		 */		
		public function expandItem(item:Object,open:Boolean = true):void
		{
			if(!(dataProvider is ITreeCollection))
				return;
			ITreeCollection(dataProvider).expandItem(item,open);
		}
		/**
		 * 指定的节点是否打开
		 */		
		public function isItemOpen(item:Object):Boolean
		{
			if(!(dataProvider is ITreeCollection))
				return false;
			return ITreeCollection(dataProvider).isItemOpen(item);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{       
			super.dataProvider_collectionChangeHandler(event);
			if(event.kind == CollectionEventKind.OPEN||event.kind == CollectionEventKind.CLOSE)
			{
				var renderer:ITreeItemRenderer = dataGroup?
					dataGroup.getElementAt(event.location) as ITreeItemRenderer:null;
				if(renderer)
				{
					updateRenderer(renderer,event.location,event.items[0]);
					if(event.kind == CollectionEventKind.CLOSE&&layout&&layout.useVirtualLayout)
					{
						layout.clearVirtualLayoutCache();
						invalidateSize();
					}
				}
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(iconFieldOrFunctionChanged)
			{
				if(dataGroup!=null)
				{
					var itemIndex:int;
					if(layout && layout.useVirtualLayout)
					{
						for each (itemIndex in dataGroup.getElementIndicesInView())
						{
							updateRendererIconProperty(itemIndex);
						}
					}
					else
					{
						var n:int = dataGroup.numElements;
						for (itemIndex = 0; itemIndex < n; itemIndex++)
						{
							updateRendererIconProperty(itemIndex);
						}
					}
				}
				iconFieldOrFunctionChanged = false; 
			}
		}
		/**
		 * 更新指定索引项的图标
		 */		
		private function updateRendererIconProperty(itemIndex:int):void
		{
			var renderer:ITreeItemRenderer = dataGroup.getElementAt(itemIndex) as ITreeItemRenderer; 
			if (renderer)
				renderer.iconSkinName = itemToIcon(renderer.data); 
		}
	}
}