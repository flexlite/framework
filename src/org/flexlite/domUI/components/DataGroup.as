package org.flexlite.domUI.components
{
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	use namespace dx_internal;
	
	
	[DXML(show="true")]
	
	[DefaultProperty(name="dataProvider",array="false")]
	
	/**
	 * 添加了项呈示器 
	 */	
	[Event(name="rendererAdd", type="org.flexlite.domUI.events.RendererExistenceEvent")]
	/**
	 * 移除了项呈示器 
	 */	
	[Event(name="rendererRemove", type="org.flexlite.domUI.events.RendererExistenceEvent")]
	
	/**
	 * 数据项目的容器基类
	 * 将数据项目转换为可视元素以进行显示。
	 * @author DOM
	 */
	public class DataGroup extends GroupBase
	{
		public function DataGroup()
		{
			super();
		}
		
		private var _rendererOwner:IItemRendererOwner;
		/**
		 * 项呈示器的主机组件
		 */
		dx_internal function get rendererOwner():IItemRendererOwner
		{
			return _rendererOwner;
		}

		dx_internal function set rendererOwner(value:IItemRendererOwner):void
		{
			_rendererOwner = value;
		}
		
		
		private var useVirtualLayoutChanged:Boolean = false;
		
		override public function set layout(value:LayoutBase):void
		{
			if (value == layout)
				return; 
			
			if (layout!=null)
			{
				layout.typicalLayoutRect = null;
				layout.removeEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}
			
			if (layout && value && (layout.useVirtualLayout != value.useVirtualLayout))
				changeUseVirtualLayout();
			super.layout = value;    
			if (value)
			{
				value.typicalLayoutRect = typicalLayoutRect;
				value.addEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}
		}
		
		/**
		 * 是否使用虚拟布局标记改变
		 */		
		private function layout_useVirtualLayoutChangedHandler(event:Event):void
		{
			changeUseVirtualLayout();
		}
		
		/**
		 * 存储当前可见的项呈示器索引列表 
		 */		
		private var virtualRendererIndices:Vector.<int>;
		
		override public function getVirtualElementAt(index:int):IVisualElement
		{
			virtualRendererIndices.push(index);
			if(indexToRenderer[index]!=null)
			{
				return indexToRenderer[index];
			}
			
			var item:Object = dataProvider[index];
			var renderer:IItemRenderer = createVirtualRenderer(index);
			indexToRenderer[index] = renderer;
			updateRenderer(renderer,index,item);
			if(createNewRendererFlag)
			{
				createNewRendererFlag = false;
				if(renderer is IInvalidating)
					(renderer as IInvalidating).validateNow();
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
					false, false, renderer, index, item));
			}
			return renderer as IVisualElement;
		}
		
		
		private var freeRenderers:Dictionary = new Dictionary;
		
		/**
		 * 释放指定索引处的项呈示器
		 */		
		private function freeRendererByIndex(index:int):void
		{
			if(indexToRenderer[index]==null)
				return;
			var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
			delete indexToRenderer[index];
			if(renderer!=null&&renderer is DisplayObject)
			{
				doFreeRenderer(renderer);
			}
		}
		/**
		 * 释放指定的项呈示器
		 */		
		private function doFreeRenderer(renderer:IItemRenderer):void
		{
			var rendererClass:Class = getDefinitionByName(getQualifiedClassName(renderer)) as Class;
			if(freeRenderers[rendererClass]==null)
			{
				freeRenderers[rendererClass] = new Vector.<IItemRenderer>();
			}
			freeRenderers[rendererClass].push(renderer);
			(renderer as DisplayObject).visible = false;
		}
		
		/**
		 * 是否创建了新的项呈示器标志 
		 */		
		private var createNewRendererFlag:Boolean = false;
		
		/**
		 * 为指定索引创建虚拟的项呈示器
		 */		
		private function createVirtualRenderer(index:int):IItemRenderer
		{
			var item:Object = dataProvider[index];
			var renderer:IItemRenderer;
			var rendererClass:Class = itemToRendererClass(item);
			if(freeRenderers[rendererClass]!=null
				&&freeRenderers[rendererClass].length>0)
			{
				renderer = freeRenderers[rendererClass].pop();
				(renderer as DisplayObject).visible = true;
				return renderer;
			}
			renderer = new rendererClass() as IItemRenderer;
			if(renderer==null||!(renderer is DisplayObject))
				return null;
			super.addChild(renderer as DisplayObject);
			createNewRendererFlag = true;
			return renderer;
		}
		
		/**
		 * 虚拟布局结束清理不可见的项呈示器
		 */		
		private function finishVirtualLayout():void
		{
			if(!virtualLayoutUnderWay)
				return;
			for(var index:* in indexToRenderer)
			{
				if(virtualRendererIndices.indexOf(index)==-1)
				{
					freeRendererByIndex(index);
				}
			}
			virtualLayoutUnderWay = false;
		}
		
		override public function getElementIndicesInView():Vector.<int>
		{
			if(layout != null&&layout.useVirtualLayout)
				return virtualRendererIndices==null?
					new Vector.<int>(0):virtualRendererIndices;
			return super.getElementIndicesInView();
		}
		
		/**
		 * 更改是否使用虚拟布局
		 */		
		private function changeUseVirtualLayout():void
		{
			useVirtualLayoutChanged = true;
			removeDataProviderListener();
			invalidateProperties();
		}
		
		private var dataProviderChanged:Boolean = false;
		
		private var _dataProvider:ICollection;
		/**
		 * 列表数据源，请使用实现了ICollection接口的数据类型，例如ArrayCollection
		 */
		public function get dataProvider():ICollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ICollection):void
		{
			if(_dataProvider==value)
				return;
			removeDataProviderListener();
			_dataProvider = value;
			dataProviderChanged = true;
			invalidateProperties();
		}
		/**
		 * 移除数据源监听
		 */		
		private function removeDataProviderListener():void
		{
			if(_dataProvider!=null)
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,onCollectionChange);
		}
		/**
		 * 数据源改变事件处理
		 */		
		private function onCollectionChange(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionEventKind.ADD:
					itemAddedHandler(event.items,event.location);
					break;
				case CollectionEventKind.MOVE:
					itemMovedHandler(event.items[0],event.location,event.oldLocation);
					break;
				case CollectionEventKind.REMOVE:
					itemRemovedHandler(event.items,event.location);
					break;
				case CollectionEventKind.UPDATE:
				case CollectionEventKind.REPLACE:
					itemUpdatedHandler(event.items[0],event.location);
					break;
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					dataProviderChanged = true;
					invalidateProperties();
					break;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 数据源添加项目事件处理
		 */		
		private function itemAddedHandler(items:Array,index:int):void
		{
			
			var useVirtualLayout:Boolean = layout!=null&&layout.useVirtualLayout;
			
			for each(var item:Object in items)
			{
				if(useVirtualLayout)
				{
					layout.elementAdded(index);
					indexToRenderer.splice(index,0,null);
				}
				else
				{
					var rendererClass:Class = itemToRendererClass(item);
					var renderer:IItemRenderer = new rendererClass() as IItemRenderer;
					if(renderer==null||!(renderer is DisplayObject))
						return;
					super.addChild(renderer as DisplayObject);
					indexToRenderer.splice(index,0,renderer);
					updateRenderer(renderer,index,item);
					dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
						false, false, renderer, index, item));
				}
				
				index ++;
			}
			for(var i:int=index;i<indexToRenderer.length;i++)
				resetRendererItemIndex(i);
		}
		/**
		 * 数据源移动项目事件处理
		 */		
		private function itemMovedHandler(item:Object,location:int,oldLocation:int):void
		{
			if(layout!=null&&layout.useVirtualLayout)
			{
				layout.elementRemoved(oldLocation);
				layout.elementAdded(location);
			}

			var renderer:* = indexToRenderer.splice(oldLocation,1)[0];
			indexToRenderer.splice(location,0,renderer);
			resetRendererItemIndex(location);
			resetRendererItemIndex(oldLocation);
		}
		/**
		 * 数据源移除项目事件处理
		 */		
		private function itemRemovedHandler(items:Array,location:int):void
		{
			var renderers:Array = indexToRenderer.splice(location,items.length);
			var i:int;
			var renderer:IItemRenderer;
			for(i = location;i<indexToRenderer.length;i++)
				resetRendererItemIndex(i);
			if(layout!=null&&layout.useVirtualLayout)
			{
				for(i = 0;i<renderers.length;i++)
				{
					layout.elementRemoved(location);
					renderer = renderers[i] as IItemRenderer;
					if(renderer!=null&&renderer is DisplayObject)
						doFreeRenderer(renderer);
				}
			}
			else
			{
				for(i = 0;i<renderers.length;i++)
				{
					renderer = renderers[i] as IItemRenderer;
					if(renderer!=null&&renderer is DisplayObject)
					{
						super.removeChild(renderer as DisplayObject);
						dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, 
							false, false, renderer, renderer.itemIndex, renderer.data));
					}
				}
			}
		}
		/**
		 * 数据源更新或替换项目事件处理
		 */	
		private function itemUpdatedHandler(item:Object,location:int):void
		{
			var renderer:IItemRenderer = indexToRenderer[location];
			if(renderer!=null)
				updateRenderer(renderer,location,item);
		}
		/**
		 * 调整指定项呈示器的索引值
		 */		
		private function resetRendererItemIndex(index:int):void
		{
			var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
			if (renderer)
				renderer.itemIndex = index;    
		}
		
		
		/**
		 * 项呈示器改变
		 */		
		private var itemRendererChanged:Boolean;
		
		private var _itemRenderer:Class;
		/**
		 * 用于数据项目的项呈示器。该类必须实现 IItemRenderer 接口。<br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。
		 */
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:Class):void
		{
			if(_itemRenderer===value)
				return;
			_itemRenderer = value;
			itemRendererChanged = true;
			removeDataProviderListener();
			invalidateProperties();
		}
		
		private var _itemRendererFunction:Function;
		
		/**
		 * 为某个特定项目返回一个项呈示器Class的函数。<br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。<br/>
		 * 应该定义一个与此示例函数类似的呈示器函数： <br/>
		 * function myItemRendererFunction(item:Object):Class
		 */		
		public function get itemRendererFunction():Function
		{
			return _itemRendererFunction;
		}
		
		public function set itemRendererFunction(value:Function):void
		{
			_itemRendererFunction = value;
			
			itemRendererChanged = true;
			removeDataProviderListener();
			invalidateProperties();
		}
		/**
		 * 为特定的数据项返回项呈示器类定义
		 */		
		private function itemToRendererClass(item:Object):Class
		{
			var rendererClass:Class;
			if(_itemRendererFunction!=null)
			{
				rendererClass = _itemRendererFunction(item);
				if(rendererClass == null)
					rendererClass = _itemRenderer;
			}
			else
			{
				rendererClass = _itemRenderer;
			}
			return rendererClass!=null?rendererClass:ItemRenderer;
		}
		
		/**
		 * @private
		 * 设置默认的ItemRenderer
		 */		
		override protected function createChildren():void
		{
			if(layout==null)
			{
				layout = new VerticalLayout;
			}
			super.createChildren();
		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(itemRendererChanged||dataProviderChanged||useVirtualLayoutChanged)
			{
				removeAllRenderers();
				if(layout!=null)
					layout.clearVirtualLayoutCache();
				useVirtualLayoutChanged = false;
				if(_dataProvider!=null)
					_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,onCollectionChange);
				if(itemRendererChanged)
				{
					var success:Boolean = measureRendererSize();
					if(!success)
					{
						invalidateProperties();
						return;
					}
					itemRendererChanged = false;
				}
				if(layout!=null&&layout.useVirtualLayout)
				{
					invalidateSize();
					invalidateDisplayList();
				}
				else
				{
					createRenderers();
				}
				if(dataProviderChanged)
				{
					dataProviderChanged = false;
					verticalScrollPosition = horizontalScrollPosition = 0;
				}
			}
		}
		/**
		 * 正在进行虚拟布局阶段 
		 */		
		private var virtualLayoutUnderWay:Boolean = false;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(layoutInvalidateDisplayListFlag&&layout!=null&&layout.useVirtualLayout)
			{
				virtualLayoutUnderWay = true;
				virtualRendererIndices = new Vector.<int>();
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(virtualLayoutUnderWay)
				finishVirtualLayout();
		}
		
		/**
		 * 项呈示器的默认尺寸
		 */		
		private var typicalLayoutRect:Rectangle;
		
		/**
		 * 测量项呈示器默认尺寸,返回是否测量成功
		 */		
		private function measureRendererSize():Boolean
		{
			var firstData:Object = _dataProvider?_dataProvider[0]:null;
			if(!firstData)
				return false;
			var rendererClass:Class = itemToRendererClass(firstData);
			var typicalItem:IItemRenderer = new rendererClass() as IItemRenderer;
			if(typicalItem==null||!(typicalItem is DisplayObject))
				return false;
			var displayObj:DisplayObject = typicalItem as DisplayObject;
			super.addChild(displayObj);
			updateRenderer(typicalItem,0,firstData);
			if(typicalItem is IInvalidating)
				(typicalItem as IInvalidating).validateNow();
			typicalLayoutRect = new Rectangle(0,0,displayObj.width,displayObj.height);
			if(layout!=null)
			{
				layout.typicalLayoutRect = typicalLayoutRect;
			}
			super.removeChild(displayObj);
			return true;
		} 
		
		
		
		/**
		 * 索引到项呈示器的转换数组 
		 */		
		private var indexToRenderer:Array = [];
		
		/**
		 * 移除所有项呈示器
		 */		
		private function removeAllRenderers():void
		{
			while(super.numChildren>0)
			{
				var renderer:IItemRenderer = super.removeChildAt(0) as IItemRenderer;
				if(renderer!=null)
					dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, 
						false, false, renderer, renderer.itemIndex, renderer.data));
			}
			indexToRenderer = [];
			freeRenderers = new Dictionary;
			virtualRendererIndices = null;
			
		}
		
		/**
		 * 为数据项创建项呈示器
		 */		
		private function createRenderers():void
		{
			if(_dataProvider==null)
				return;
			var index:int = 0;
			for each(var item:Object in _dataProvider)
			{
				var rendererClass:Class = itemToRendererClass(item);
				var renderer:IItemRenderer = new rendererClass() as IItemRenderer;
				if(renderer == null||!(renderer is DisplayObject))
					continue;
				super.addChild(renderer as DisplayObject);
				indexToRenderer[index] = renderer;
				updateRenderer(renderer,index,item);
				if(renderer is IInvalidating)
					(renderer as IInvalidating).validateNow();
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
					false, false, renderer, index, item));
				index ++;
			}
		}
		
		/**
		 * 更新项呈示器
		 */		
		protected function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(_rendererOwner!=null)
			{
				return _rendererOwner.updateRenderer(renderer,itemIndex,data);
			}
			if(renderer is IVisualElement)
			{
				(renderer as IVisualElement).owner = this;
			}
			renderer.itemIndex = itemIndex;
			renderer.label = itemToLabel(data);
			renderer.data = data;
			return renderer;
		}
		
		/**
		 * 返回可在项呈示器中显示的 String。
		 * 若DataGroup被作为SkinnableDataContainer的皮肤组件,此方法将不会执行，被SkinnableDataContainer.itemToLabel()所替代。 
		 */		
		protected function itemToLabel(item:Object):String
		{
			if (item !== null)
				return item.toString();
			else return " ";
		}
		
		override public function getElementAt(index:int):IVisualElement
		{
			return indexToRenderer[index];
		}
		
		override public function getElementIndex(element:IVisualElement):int
		{
			if(element==null)
				return -1;
			return indexToRenderer.indexOf(element);
		}
		
		override public function get numElements():int
		{
			if(_dataProvider==null)
				return 0;
			return _dataProvider.length;
		}
		
		private static const errorStr:String = "在此组件中不可用，若此组件为容器类，请使用";
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#addChild()
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("addChild()"+errorStr+"addElement()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#addChildAt()
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw(new Error("addChildAt()"+errorStr+"addElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#removeChild()
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("removeChild()"+errorStr+"removeElement()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#removeChildAt()
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw(new Error("removeChildAt()"+errorStr+"removeElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#setChildIndex()
		 */		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw(new Error("setChildIndex()"+errorStr+"setElementIndex()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#swapChildren()
		 */		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw(new Error("swapChildren()"+errorStr+"swapElements()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#swapChildrenAt()
		 */		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw(new Error("swapChildrenAt()"+errorStr+"swapElementsAt()代替"));
		}
		
	}
}