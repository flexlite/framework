package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.components.supportClasses.GroupBase;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;


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
		/**
		 * 构造函数
		 */		
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
		
		/**
		 * @inheritDoc
		 */
		override public function set layout(value:LayoutBase):void
		{
			if (value == layout)
				return; 
			
			if (layout)
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
		
		override public function setVirtualElementIndicesInView(startIndex:int, endIndex:int):void
		{
			if(!layout||!layout.useVirtualLayout)
				return;
			virtualRendererIndices = new Vector.<int>();
			for(var i:int=startIndex;i<=endIndex;i++)
			{
				virtualRendererIndices.push(i);
			}
			for(var index:* in indexToRenderer)
			{
				if(virtualRendererIndices.indexOf(index)==-1)
				{
					freeRendererByIndex(index);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getVirtualElementAt(index:int):IVisualElement
		{
			if(index<0||index>=dataProvider.length)
				return null;
			var element:IVisualElement = indexToRenderer[index];
			if(!element)
			{
				var item:Object = dataProvider.getItemAt(index);
				var renderer:IItemRenderer = createVirtualRenderer(index);
				indexToRenderer[index] = renderer;
				updateRenderer(renderer,index,item);
				if(createNewRendererFlag)
				{
					if(renderer is IInvalidating)
						(renderer as IInvalidating).validateNow();
					createNewRendererFlag = false;
					dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
						false, false, renderer, index, item));
				}
				element = renderer as IVisualElement;
			}
			return element;
		}
		
		private var rendererToClassMap:Dictionary = new Dictionary(true);
		private var freeRenderers:Dictionary = new Dictionary;
		
		/**
		 * 释放指定索引处的项呈示器
		 */		
		private function freeRendererByIndex(index:int):void
		{
			if(!indexToRenderer[index])
				return;
			var renderer:IItemRenderer = indexToRenderer[index] as IItemRenderer;
			delete indexToRenderer[index];
			if(renderer&&renderer is DisplayObject)
			{
				doFreeRenderer(renderer);
			}
		}
		/**
		 * 释放指定的项呈示器
		 */		
		private function doFreeRenderer(renderer:IItemRenderer):void
		{
			var rendererClass:Class = rendererToClassMap[renderer];
			if(!freeRenderers[rendererClass])
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
		 * @inheritDoc
		 */
		override public function invalidateSize():void
		{
			if(!createNewRendererFlag)//虚拟布局时创建子项不需要重新验证
				super.invalidateSize();
		}
		
		/**
		 * 为指定索引创建虚拟的项呈示器
		 */		
		private function createVirtualRenderer(index:int):IItemRenderer
		{
			var item:Object = dataProvider.getItemAt(index);
			var renderer:IItemRenderer;
			var rendererClass:Class = itemToRendererClass(item);
			if(freeRenderers[rendererClass]
				&&freeRenderers[rendererClass].length>0)
			{
				renderer = freeRenderers[rendererClass].pop();
				(renderer as DisplayObject).visible = true;
				return renderer;
			}
			createNewRendererFlag = true;
			return createOneRenderer(rendererClass);
		}
		/**
		 * 根据rendererClass创建一个Renderer,并添加到显示列表
		 */		
		private function createOneRenderer(rendererClass:Class):IItemRenderer
		{
			var renderer:IItemRenderer;
			if(recyclerDic[rendererClass])
			{
				var hasExtra:Boolean = false;
				for(var key:* in recyclerDic[rendererClass])
				{
					if(!renderer)
					{
						renderer = key as IItemRenderer;
					}
					else
					{
						hasExtra = true;
						break;
					}
				}
				delete recyclerDic[rendererClass][renderer];
				if(!hasExtra)
					delete recyclerDic[rendererClass];
			}
			if(!renderer)
			{
				renderer = new rendererClass() as IItemRenderer;
				rendererToClassMap[renderer] = rendererClass;
			}
			if(!renderer||!(renderer is DisplayObject))
				return null;
			if(_itemRendererSkinName)
			{
				setItemRenderSkinName(renderer);
			}
			super.addChild(renderer as DisplayObject);
			renderer.setLayoutBoundsSize(NaN,NaN);
			return renderer;
		}
		/**
		 * 设置项呈示器的默认皮肤
		 */		
		private function setItemRenderSkinName(renderer:IItemRenderer):void
		{
			if(!renderer)
				return;
			var comp:SkinnableComponent = renderer as SkinnableComponent;
			if(comp)
			{
				if(!comp.skinNameExplicitlySet)
					comp.skinName = _itemRendererSkinName;
			}
			else
			{
				var client:ISkinnableClient = renderer as ISkinnableClient;
				if(client&&!client.skinName)
					client.skinName = _itemRendererSkinName;
			}
		}
		
		private var cleanTimer:Timer;
		/**
		 * 虚拟布局结束清理不可见的项呈示器
		 */		
		private function finishVirtualLayout():void
		{
			if(!virtualLayoutUnderway)
				return;
			virtualLayoutUnderway = false;
			var found:Boolean = false;
			for(var clazz:* in freeRenderers)
			{
				if(freeRenderers[clazz].length>0)
				{
					found = true;
					break;
				}
			}
			if(!found)
				return;
			if(!cleanTimer)
			{
				cleanTimer = new Timer(3000,1);
				cleanTimer.addEventListener(TimerEvent.TIMER,cleanAllFreeRenderer);
			}
			//为了提高持续滚动过程中的性能，防止反复地添加移除子项，这里不直接清理而是延迟后在滚动停止时清理一次。
			cleanTimer.reset();
			cleanTimer.start();
		}
		/**
		 * 延迟清理多余的在显示列表中的ItemRenderer。
		 */		
		private function cleanAllFreeRenderer(event:TimerEvent=null):void
		{
			var renderer:IItemRenderer;
			for each(var list:Vector.<IItemRenderer> in freeRenderers)
			{
				for each(renderer in list)
				{
					DisplayObject(renderer).visible = true;
					recycle(renderer);
				}
			}
			freeRenderers = new Dictionary;
			cleanFreeRenderer = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndicesInView():Vector.<int>
		{
			if(layout&&layout.useVirtualLayout)
				return virtualRendererIndices?
					virtualRendererIndices:new Vector.<int>(0);
			return super.getElementIndicesInView();
		}
		
		/**
		 * 更改是否使用虚拟布局
		 */		
		private function changeUseVirtualLayout():void
		{
			useVirtualLayoutChanged = true;
			cleanFreeRenderer = true;
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
			cleanFreeRenderer = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		/**
		 * 移除数据源监听
		 */		
		private function removeDataProviderListener():void
		{
			if(_dataProvider)
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
					itemUpdatedHandler(event.items[0],event.location);
					break;
				case CollectionEventKind.REPLACE:
					itemRemoved(event.oldItems[0],event.location);
					itemAdded(event.items[0], event.location);
					break;
				case CollectionEventKind.RESET:
				case CollectionEventKind.REFRESH:
					if(layout&&layout.useVirtualLayout)
					{
						for(var index:* in indexToRenderer)
						{
							freeRendererByIndex(index);
						}
					}
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
			var length:int = items.length;
			for (var i:int = 0; i < length; i++)
			{
				itemAdded(items[i], index + i);
			}
			resetRenderersIndices();
		}
		/**
		 * 数据源移动项目事件处理
		 */		
		private function itemMovedHandler(item:Object,location:int,oldLocation:int):void
		{
			itemRemoved(item,oldLocation);
			itemAdded(item,location);
			resetRenderersIndices();
		}
		/**
		 * 数据源移除项目事件处理
		 */		
		private function itemRemovedHandler(items:Array,location:int):void
		{
			var length:int = items.length;
			for (var i:int = length-1; i >= 0; i--)
			{
				itemRemoved(items[i], location + i);
			}
			
			resetRenderersIndices();
		}
		/**
		 * 添加一项
		 */		
		private function itemAdded(item:Object,index:int):void
		{
			if (layout)
				layout.elementAdded(index);
			
			if (layout && layout.useVirtualLayout)
			{
				if (virtualRendererIndices)
				{
					const virtualRendererIndicesLength:int = virtualRendererIndices.length;
					for (var i:int = 0; i < virtualRendererIndicesLength; i++)
					{
						const vrIndex:int = virtualRendererIndices[i];
						if (vrIndex >= index)
							virtualRendererIndices[i] = vrIndex + 1;
					}
					indexToRenderer.splice(index, 0, null); 
				}
				return;
			}
			var rendererClass:Class = itemToRendererClass(item);
			var renderer:IItemRenderer = createOneRenderer(rendererClass);
			indexToRenderer.splice(index,0,renderer);
			if(!renderer)
				return;
			updateRenderer(renderer,index,item);
			dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
				false, false, renderer, index, item));
			
		}
		
		/**
		 * 移除一项
		 */		
		private function itemRemoved(item:Object, index:int):void
		{
			if (layout)
				layout.elementRemoved(index);
			if (virtualRendererIndices && (virtualRendererIndices.length > 0))
			{
				var vrItemIndex:int = -1; 
				const virtualRendererIndicesLength:int = virtualRendererIndices.length;
				for (var i:int = 0; i < virtualRendererIndicesLength; i++)
				{
					const vrIndex:int = virtualRendererIndices[i];
					if (vrIndex == index)
						vrItemIndex = i;
					else if (vrIndex > index)
						virtualRendererIndices[i] = vrIndex - 1;
				}
				if (vrItemIndex != -1)
					virtualRendererIndices.splice(vrItemIndex, 1);
			}
			const oldRenderer:IItemRenderer = indexToRenderer[index];
			
			if (indexToRenderer.length > index)
				indexToRenderer.splice(index, 1);
			
			dispatchEvent(new RendererExistenceEvent(
				RendererExistenceEvent.RENDERER_REMOVE, false, false, oldRenderer, index, item));
			
			if(oldRenderer&&oldRenderer is DisplayObject)
			{
				recycle(oldRenderer);
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, 
					false, false, oldRenderer, oldRenderer.itemIndex, oldRenderer.data));
			}
		}
		
		/**
		 * 对象池字典
		 */		
		private var recyclerDic:Dictionary = new Dictionary();
		/**
		 * 回收一个ItemRenderer实例
		 */		
		private function recycle(renderer:IItemRenderer):void
		{
			super.removeChild(renderer as DisplayObject);
			if(renderer is IVisualElement)
			{
				(renderer as IVisualElement).ownerChanged(null);
			}
			var rendererClass:Class = rendererToClassMap[renderer];
			if(!recyclerDic[rendererClass])
			{
				recyclerDic[rendererClass] = new Dictionary(true);
			}
			recyclerDic[rendererClass][renderer] = null;
		}
		/**
		 * 更新当前所有项的索引
		 */		
		private function resetRenderersIndices():void
		{
			if (indexToRenderer.length == 0)
				return;
			
			if (layout && layout.useVirtualLayout)
			{
				for each (var index:int in virtualRendererIndices)
				resetRendererItemIndex(index);
			}
			else
			{
				const indexToRendererLength:int = indexToRenderer.length;
				for (index = 0; index < indexToRendererLength; index++)
					resetRendererItemIndex(index);
			}
		}
		/**
		 * 数据源更新或替换项目事件处理
		 */	
		private function itemUpdatedHandler(item:Object,location:int):void
		{
			if (renderersBeingUpdated)
				return;//防止无限循环
			
			var renderer:IItemRenderer = indexToRenderer[location];
			if(renderer)
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
			typicalItemChanged = true;
			cleanFreeRenderer = true;
			removeDataProviderListener();
			invalidateProperties();
		}
		
		private var itemRendererSkinNameChange:Boolean = false;
		
		private var _itemRendererSkinName:Object;
		/**
		 * 条目渲染器的可选皮肤标识符。在实例化itemRenderer时，若其内部没有设置过skinName,则将此属性的值赋值给它的skinName。
		 * 注意:若itemRenderer不是ISkinnableClient，则此属性无效。
		 */
		public function get itemRendererSkinName():Object
		{
			return _itemRendererSkinName;
		}
		public function set itemRendererSkinName(value:Object):void
		{
			if(_itemRendererSkinName==value)
				return;
			_itemRendererSkinName = value;
			if(_itemRendererSkinName&&initialized)
			{
				itemRendererSkinNameChange = true;
				invalidateProperties();
			}
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
			if(_itemRendererFunction==value)
				return;
			_itemRendererFunction = value;
			
			itemRendererChanged = true;
			typicalItemChanged = true;
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
				if(!rendererClass)
					rendererClass = _itemRenderer;
			}
			else
			{
				rendererClass = _itemRenderer;
			}
			return rendererClass?rendererClass:ItemRenderer;
		}
		
		/**
		 * @private
		 * 设置默认的ItemRenderer
		 */		
		override protected function createChildren():void
		{
			if(!layout)
			{
				var _layout:VerticalLayout = new VerticalLayout();
				_layout.gap = 0;
				_layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
				layout = _layout;
			}
			super.createChildren();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if(itemRendererChanged||dataProviderChanged||useVirtualLayoutChanged)
			{
				removeAllRenderers();
				if(layout)
					layout.clearVirtualLayoutCache();
				setTypicalLayoutRect(null);
				useVirtualLayoutChanged = false;
				itemRendererChanged = false;
				if(_dataProvider)
					_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,onCollectionChange);
				if(layout&&layout.useVirtualLayout)
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
			
			super.commitProperties();
			
			if(typicalItemChanged)
			{
				typicalItemChanged = false;
				if (_dataProvider&&_dataProvider.length > 0)
				{
					typicalItem = _dataProvider.getItemAt(0);
					measureRendererSize();
				}
			}
			if(itemRendererSkinNameChange)
			{
				itemRendererSkinNameChange = false;
				var length:int = indexToRenderer.length;
				var client:ISkinnableClient;
				var comp:SkinnableComponent;
				for(var i:int=0;i<length;i++)
				{
					setItemRenderSkinName(indexToRenderer[i]);
				}
				for(var clazz:* in freeRenderers)
				{
					var list:Vector.<IItemRenderer> = freeRenderers[clazz];
					if(list)
					{
						length = list.length;
						for(i=0;i<length;i++)
						{
							setItemRenderSkinName(list[i]);
						}
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			if(layout&&layout.useVirtualLayout)
			{
				ensureTypicalLayoutElement();	
			}
			super.measure();
		}
		
		/**
		 * 正在进行虚拟布局阶段 
		 */		
		private var virtualLayoutUnderway:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(layoutInvalidateDisplayListFlag&&layout&&layout.useVirtualLayout)
			{
				virtualLayoutUnderway = true;
				ensureTypicalLayoutElement();
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(virtualLayoutUnderway)
				finishVirtualLayout();
		}
		
		/**
		 * 用于测试默认大小的数据
		 */
		private var typicalItem:Object

		private var typicalItemChanged:Boolean = false;
		/**
		 * 确保测量过默认条目大小。
		 */
		private function ensureTypicalLayoutElement():void
		{
			if (layout.typicalLayoutRect)
				return;
			
			if (_dataProvider&&_dataProvider.length > 0)
			{
				typicalItem = _dataProvider.getItemAt(0);
				measureRendererSize();
			}
		}
		
		/**
		 * 测量项呈示器默认尺寸
		 */		
		private function measureRendererSize():void
		{
			if(!typicalItem)
			{
				setTypicalLayoutRect(null);
				return;
			}
			var rendererClass:Class = itemToRendererClass(typicalItem);
			var typicalRenderer:IItemRenderer = createOneRenderer(rendererClass);
			if(!typicalRenderer)
			{
				setTypicalLayoutRect(null);
				return;
			}
			createNewRendererFlag = true;
			updateRenderer(typicalRenderer,0,typicalItem);
			if(typicalRenderer is IInvalidating)
				(typicalRenderer as IInvalidating).validateNow();
			var rect:Rectangle = new Rectangle(0,0,typicalRenderer.preferredWidth,
				typicalRenderer.preferredHeight);
			recycle(typicalRenderer);
			setTypicalLayoutRect(rect);
			createNewRendererFlag = false;
		} 
		
		/**
		 * 项呈示器的默认尺寸
		 */		
		private var typicalLayoutRect:Rectangle;
		/**
		 * 设置项目默认大小
		 */		
		private function setTypicalLayoutRect(rect:Rectangle):void
		{
			typicalLayoutRect = rect;
			if(layout)
				layout.typicalLayoutRect = rect;
		}
		
		
		/**
		 * 索引到项呈示器的转换数组 
		 */		
		private var indexToRenderer:Array = [];
		/**
		 * 清理freeRenderer标志
		 */		
		private var cleanFreeRenderer:Boolean = false;
		/**
		 * 移除所有项呈示器
		 */		
		private function removeAllRenderers():void
		{
			var length:int = indexToRenderer.length;
			var renderer:IItemRenderer;
			for(var i:int=0;i<length;i++)
			{
				renderer = indexToRenderer[i];
				if(renderer)
				{
					recycle(renderer);
					dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, 
						false, false, renderer, renderer.itemIndex, renderer.data));
				}
			}
			indexToRenderer = [];
			virtualRendererIndices = null;
			if(!cleanFreeRenderer)
				return;
			cleanAllFreeRenderer();
		}
		
		/**
		 * 为数据项创建项呈示器
		 */		
		private function createRenderers():void
		{
			if(!_dataProvider)
				return;
			var index:int = 0;
			var length:int = _dataProvider.length;
			for(var i:int=0;i<length;i++)
			{
				var item:Object = _dataProvider.getItemAt(i);
				var rendererClass:Class = itemToRendererClass(item);
				var renderer:IItemRenderer = createOneRenderer(rendererClass);
				if(!renderer)
					continue;
				indexToRenderer[index] = renderer;
				updateRenderer(renderer,index,item);
				dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, 
					false, false, renderer, index, item));
				index ++;
			}
		}
		/**
		 * 正在更新数据项的标志
		 */		
		private var renderersBeingUpdated:Boolean = false;
		
		/**
		 * 更新项呈示器
		 */		
		protected function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			renderersBeingUpdated = true;
			
			if(_rendererOwner)
			{
				renderer = _rendererOwner.updateRenderer(renderer,itemIndex,data);
			}
			else 
			{
				if(renderer is IVisualElement)
				{
					(renderer as IVisualElement).ownerChanged(this);
				}
				renderer.itemIndex = itemIndex;
				renderer.label = itemToLabel(data);
				renderer.data = data;
			}
			
			renderersBeingUpdated = false;
			return renderer;
		}
		
		/**
		 * 返回可在项呈示器中显示的 String。
		 * 若DataGroup被作为SkinnableDataContainer的皮肤组件,此方法将不会执行，被SkinnableDataContainer.itemToLabel()所替代。 
		 */		
		protected function itemToLabel(item:Object):String
		{
			if (item)
				return item.toString();
			else return " ";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementAt(index:int):IVisualElement
		{
			return indexToRenderer[index];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndex(element:IVisualElement):int
		{
			if(!element)
				return -1;
			return indexToRenderer.indexOf(element);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get numElements():int
		{
			if(!_dataProvider)
				return 0;
			return _dataProvider.length;
		}
		
		private static const errorStr:String = "在此组件中不可用，若此组件为容器类，请使用";
		[Deprecated] 
		/**
		 * addChild()在此组件中不可用，若此组件为容器类，请使用addElement()代替
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("addChild()"+errorStr+"addElement()代替"));
		}
		[Deprecated] 
		/**
		 * addChildAt()在此组件中不可用，若此组件为容器类，请使用addElementAt()代替
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw(new Error("addChildAt()"+errorStr+"addElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * removeChild()在此组件中不可用，若此组件为容器类，请使用removeElement()代替
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("removeChild()"+errorStr+"removeElement()代替"));
		}
		[Deprecated] 
		/**
		 * removeChildAt()在此组件中不可用，若此组件为容器类，请使用removeElementAt()代替
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw(new Error("removeChildAt()"+errorStr+"removeElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * setChildIndex()在此组件中不可用，若此组件为容器类，请使用setElementIndex()代替
		 */		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw(new Error("setChildIndex()"+errorStr+"setElementIndex()代替"));
		}
		[Deprecated] 
		/**
		 * swapChildren()在此组件中不可用，若此组件为容器类，请使用swapElements()代替
		 */		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw(new Error("swapChildren()"+errorStr+"swapElements()代替"));
		}
		[Deprecated] 
		/**
		 * swapChildrenAt()在此组件中不可用，若此组件为容器类，请使用swapElementsAt()代替
		 */		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw(new Error("swapChildrenAt()"+errorStr+"swapElementsAt()代替"));
		}
		
	}
}