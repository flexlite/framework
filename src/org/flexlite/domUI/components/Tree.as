package org.flexlite.domUI.components
{
	import org.flexlite.domUI.collections.XMLCollection;
	import org.flexlite.domUI.components.supportClasses.TreeItemRenderer;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.events.TreeEvent;
	
	/**
	 * 子节点打开或关闭前一刻分派。可以调用preventDefault()方法阻止节点的状态改变。 
	 */	
	[Event(name="itemOpening", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点打开
	 */	
	[Event(name="itemOpen", type="org.flexlite.domUI.events.TreeEvent")]
	/**
	 * 节点关闭
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
		
		private var _indentation:Number = 17;
		/**
		 * 子节点相对父节点的缩进值，以像素为单位。默认17。
		 */
		public function get indentation():Number
		{
			return _indentation;
		}
		public function set indentation(value:Number):void
		{
			_indentation = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is TreeItemRenderer&&dataProvider is XMLCollection)
			{
				var treeRenderer:TreeItemRenderer = renderer as TreeItemRenderer;
				treeRenderer.hasChildren = XML(data).children().length()>0;
				treeRenderer.opened = XMLCollection(dataProvider).isItemOpen(data as XML);
				treeRenderer.indentation = XMLCollection(dataProvider).getDepth(data as XML)*_indentation;
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
			if(event.renderer is TreeItemRenderer)
				event.renderer.addEventListener(TreeEvent.ITEM_OPENING,onItemOpening);
		}
		/**
		 * 节点即将打开
		 */		
		private function onItemOpening(event:TreeEvent):void
		{
			var renderer:TreeItemRenderer = event.itemRenderer;
			var item:XML = event.item as XML;
			if(!renderer||!(dataProvider is XMLCollection))
				return;
			if(dispatchEvent(event))
			{
				renderer.opened = !renderer.opened;
				var type:String = renderer.opened?TreeEvent.ITEM_OPEN:TreeEvent.ITEM_CLOSE;
				var evt:TreeEvent = new TreeEvent(type,false,false,renderer.itemIndex,item,renderer);
				XMLCollection(dataProvider).expandItem(item,renderer.opened);
				dispatchEvent(evt);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			if(event.renderer is TreeItemRenderer)
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
		 * 打开或关闭一个节点
		 * @param item 要打开或关闭的节点
		 * @param open true表示打开节点，反之关闭。
		 * @param cancelable 是否抛出TreeEvent.ITEM_OPENING事件(通过监听此事件可以阻止本次操作)。
		 */		
		public function expandItem(item:Object,open:Boolean = true,cancelable:Boolean = true):void
		{
			if(!(dataProvider is XMLCollection))
				return;
			var hasOpen:Boolean = XMLCollection(dataProvider).isItemOpen(item);
			if(hasOpen==open)
				return;
			var itemIndex:int = dataProvider.getItemIndex(item);
			if(itemIndex==-1)
				return;
			var renderer:TreeItemRenderer;
			if(cancelable)
			{
				renderer = dataGroup?dataGroup.getElementAt(itemIndex) as TreeItemRenderer:null;
				var evt:TreeEvent = new TreeEvent(TreeEvent.ITEM_OPENING,
					false,true,itemIndex,item,renderer);
				if(!dispatchEvent(evt))
					return;
			}
			if(renderer)
				renderer.opened = open;
			XMLCollection(dataProvider).expandItem(item,open);
		}
		/**
		 * 指定的节点是否打开
		 */		
		public function isItemOpen(item:Object):Boolean
		{
			if(!(dataProvider is XMLCollection))
				return false;
			return XMLCollection(dataProvider).isItemOpen(item);
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
			var renderer:TreeItemRenderer = dataGroup.getElementAt(itemIndex) as TreeItemRenderer; 
			if (renderer)
				renderer.iconSkinName = itemToIcon(renderer.data); 
		}
	}
}