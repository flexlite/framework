package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.components.IItemRenderer;
	import org.flexlite.domUI.components.SkinnableDataContainer;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.CollectionEvent;
	import org.flexlite.domUI.events.CollectionEventKind;
	import org.flexlite.domUI.events.IndexChangeEvent;
	import org.flexlite.domUI.events.ListEvent;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;

	use namespace dx_internal;
	
	
	/**
	 * 指示用户执行了将鼠标指针滑过控件中某个项呈示器的操作。 
	 */	
	[Event(name="itemRollOver", type="org.flexlite.domUI.events.ListEvent")]
	/**
	 * 指示用户执行了将鼠标指针从控件中某个项呈示器上移开的操作  
	 */	
	[Event(name="itemRollOut", type="org.flexlite.domUI.events.ListEvent")]
	/**
	 * 指示用户执行了将鼠标在某个项呈示器上单击的操作。 
	 */	
	[Event(name="itemClick", type="org.flexlite.domUI.events.ListEvent")]
	/**
	 * 指示索引即将更改,可以通过调用preventDefault()方法阻止索引发生更改
	 */	
	[Event(name="changing", type="org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * 选中项改变事件。仅当用户与此控件交互时才抛出此事件。 
	 * 以编程方式更改 selectedIndex 或 selectedItem 属性的值时，该控件并不抛出change事件，而是抛出valueCommit事件。
	 */	
	[Event(name="change", type="org.flexlite.domUI.events.IndexChangeEvent")]
	/**
	 * 属性改变事件
	 */	
	[Event(name="valueCommit", type="org.flexlite.domUI.events.UIEvent")]

	[DXML(show="false")]
	
	/**
	 * 支持选择内容的所有组件的基类。 
	 * @author DOM
	 */
	public class ListBase extends SkinnableDataContainer
	{
		/**
		 * 未选中任何项时的索引值 
		 */		
		public static const NO_SELECTION:int = -1;
		
		/**
		 * 未设置缓存选中项的值
		 */
		dx_internal static const NO_PROPOSED_SELECTION:int = -2;
		/**
		 * 自定义的选中项
		 */		
		dx_internal static var CUSTOM_SELECTED_ITEM:int = -3;
		
		public function ListBase()
		{
			super();
			focusEnabled = true;
		}
		
		/**
		 * 正在进行所有数据源的刷新操作
		 */		
		dx_internal var doingWholesaleChanges:Boolean = false;
		
		private var dataProviderChanged:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function set dataProvider(value:ICollection):void
		{
			if (dataProvider)
				dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, 
					dataProvider_collectionChangeHandler);
			
			dataProviderChanged = true;
			doingWholesaleChanges = true;
			
			if (value)
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, 
					dataProvider_collectionChangeHandler, false, 0, true);
			
			super.dataProvider = value;
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set layout(value:LayoutBase):void
		{
			if (value && useVirtualLayout)
				value.useVirtualLayout = true;
			
			super.layout = value;
		}
		
		
		private var _labelField:String = "label";
		
		private var labelFieldOrFunctionChanged:Boolean; 
		
		/**
		 * 数据项如果是一个对象，此属性为数据项中用来显示标签文字的字段名称。
		 * 若设置了labelFunction，则设置此属性无效。
		 */		
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			if (value == _labelField)
				return 
				
				_labelField = value;
			labelFieldOrFunctionChanged = true;
			invalidateProperties();
		}
		
		private var _labelFunction:Function; 
		
		/**
		 * 用户提供的函数，在每个项目上运行以确定其标签。
		 * 示例：function labelFunc(item:Object):String 。
		 */		
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		public function set labelFunction(value:Function):void
		{
			if (value == _labelFunction)
				return 
				
			_labelFunction = value;
			labelFieldOrFunctionChanged = true;
			invalidateProperties(); 
		}
		
		private var _requireSelection:Boolean = false;
		
		private var requireSelectionChanged:Boolean = false;
		
		/**
		 * 如果为 true，则必须始终在控件中选中数据项目。<br/>
		 * 如果该值为 true，则始终将 selectedIndex 属性设置为 0 和 (dataProvider.length - 1) 之间的一个值。 
		 */		
		public function get requireSelection():Boolean
		{
			return _requireSelection;
		}
		
		public function set requireSelection(value:Boolean):void
		{
			if (value == _requireSelection)
				return;
			
			_requireSelection = value;
			
			if (value)
			{
				requireSelectionChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * 在属性提交前缓存真实的选中项的值
		 */
		dx_internal var _proposedSelectedIndex:int = NO_PROPOSED_SELECTION;
		
		dx_internal var _selectedIndex:int = NO_SELECTION;
		
		/**
		 * 选中项目的基于 0 的索引。<br/>
		 * 或者如果未选中项目，则为-1。设置 selectedIndex 属性会取消选择当前选定的项目并选择指定索引位置的数据项目。 <br/>
		 * 当用户通过与控件交互来更改 selectedIndex 属性时，此控件将分派 change 和 changing 事件。<br/>
		 * 当以编程方式更改 selectedIndex 属性的值时，此控件不分派 change 和 changing 事件。
		 */		
		public function get selectedIndex():int
		{
			if (_proposedSelectedIndex != NO_PROPOSED_SELECTION)
				return _proposedSelectedIndex;
			
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			setSelectedIndex(value, false);
		}
		
		/**
		 * 是否允许自定义的选中项
		 */		
		dx_internal var allowCustomSelectedItem:Boolean = false;
		/**
		 * 索引改变后是否需要抛出事件 
		 */		
		dx_internal var dispatchChangeAfterSelection:Boolean = false;
		
		/**
		 * 设置选中项
		 */
		dx_internal function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false):void
		{
			if (value == selectedIndex)
			{
				return;
			}
			
			if (dispatchChangeEvent)
				dispatchChangeAfterSelection = (dispatchChangeAfterSelection || dispatchChangeEvent);
			_proposedSelectedIndex = value;
			invalidateProperties();
		}
		
		
		/**
		 *  在属性提交前缓存真实选中项的数据源
		 */
		dx_internal var _pendingSelectedItem:*;
		
		private var _selectedItem:*;
		
		/**
		 * 当前已选中的项目。设置此属性会取消选中当前选定的项目并选择新指定的项目。<br/>
		 * 当用户通过与控件交互来更改 selectedItem 属性时，此控件将分派 change 和 changing 事件。<br/>
		 * 当以编程方式更改 selectedItem 属性的值时，此控件不分派 change 和 changing 事件。
		 */		
		public function get selectedItem():*
		{
			if (_pendingSelectedItem !== undefined)
				return _pendingSelectedItem;
			
			if (allowCustomSelectedItem && selectedIndex == CUSTOM_SELECTED_ITEM)
				return _selectedItem;
			
			if (selectedIndex == NO_SELECTION || dataProvider == null)
				return undefined;
			
			return dataProvider.length > selectedIndex ? dataProvider.getItemAt(selectedIndex) : undefined;
		}
		
		public function set selectedItem(value:*):void
		{
			setSelectedItem(value, false);
		}
		
		/**
		 * 设置选中项数据源
		 */
		dx_internal function setSelectedItem(value:*, dispatchChangeEvent:Boolean = false):void
		{
			if (selectedItem === value)
				return;
			
			if (dispatchChangeEvent)
				dispatchChangeAfterSelection = (dispatchChangeAfterSelection || dispatchChangeEvent);
			
			_pendingSelectedItem = value;
			invalidateProperties();
		}
		
		private var _useVirtualLayout:Boolean = false;
		
		/**
		 * 是否使用虚拟布局,默认flase
		 */
		public function get useVirtualLayout():Boolean
		{
			return (layout) ? layout.useVirtualLayout : _useVirtualLayout;
		}
		
		public function set useVirtualLayout(value:Boolean):void
		{
			if (value == useVirtualLayout)
				return;
			
			_useVirtualLayout = value;
			if (layout)
				layout.useVirtualLayout = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dataProviderChanged)
			{
				dataProviderChanged = false;
				doingWholesaleChanges = false;
				
				if (selectedIndex >= 0 && dataProvider && selectedIndex < dataProvider.length)
					itemSelected(selectedIndex, true);
				else if (requireSelection)
					_proposedSelectedIndex = 0;
				else
					setSelectedIndex(-1, false);
			}
			
			if (requireSelectionChanged)
			{
				requireSelectionChanged = false;
				
				if (requireSelection &&
					selectedIndex == NO_SELECTION &&
					dataProvider &&
					dataProvider.length > 0)
				{
					_proposedSelectedIndex = 0;
				}
			}
			
			if (_pendingSelectedItem !== undefined)
			{
				if (dataProvider)
					_proposedSelectedIndex = dataProvider.getItemIndex(_pendingSelectedItem);
				else
					_proposedSelectedIndex = NO_SELECTION;
				
				
				if (allowCustomSelectedItem && _proposedSelectedIndex == -1)
				{
					_proposedSelectedIndex = CUSTOM_SELECTED_ITEM;
					_selectedItem = _pendingSelectedItem;
				}
				
				_pendingSelectedItem = undefined;
			}
			
			var changedSelection:Boolean = false;
			if (_proposedSelectedIndex != NO_PROPOSED_SELECTION)
				changedSelection = commitSelection();
			
			if (selectedIndexAdjusted)
			{
				selectedIndexAdjusted = false;
				if (!changedSelection)
				{
					dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
				}
			}
			
			if (labelFieldOrFunctionChanged)
			{
				if (dataGroup!=null)
				{
					var itemIndex:int;
					
					if (layout && layout.useVirtualLayout)
					{
						for each (itemIndex in dataGroup.getElementIndicesInView())
						{
							updateRendererLabelProperty(itemIndex);
						}
					}
					else
					{
						var n:int = dataGroup.numElements;
						for (itemIndex = 0; itemIndex < n; itemIndex++)
						{
							updateRendererLabelProperty(itemIndex);
						}
					}
				}
				
				labelFieldOrFunctionChanged = false; 
			}
		}
		
		/**
		 *  更新项呈示器文字标签
		 */
		private function updateRendererLabelProperty(itemIndex:int):void
		{
			var renderer:IItemRenderer = dataGroup.getElementAt(itemIndex) as IItemRenderer; 
			if (renderer)
				renderer.label = itemToLabel(renderer.data); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
			{
				if (_useVirtualLayout && dataGroup.layout)
					dataGroup.layout.useVirtualLayout = true;
				
				dataGroup.addEventListener(
					RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler);
				dataGroup.addEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{        
			super.partRemoved(partName, instance);
			
			if (instance == dataGroup)
			{
				dataGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddHandler);
				dataGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dataGroup_rendererRemoveHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			itemSelected(itemIndex, isItemIndexSelected(itemIndex));
			return super.updateRenderer(renderer, itemIndex, data); 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function itemToLabel(item:Object):String
		{
			if (_labelFunction != null)
				return _labelFunction(item);
			
			if (item is String)
				return String(item);
			
			if (item is XML)
			{
				try
				{
					if (item[labelField].length() != 0)
						item = item[labelField];
				}
				catch(e:Error)
				{
				}
			}
			else if (item is Object)
			{
				try
				{
					if (item[labelField] != null)
						item = item[labelField];
				}
				catch(e:Error)
				{
				}
			}
			
			if (item is String)
				return String(item);
			
			try
			{
				if (item !== null)
					return item.toString();
			}
			catch(e:Error)
			{
			}
			
			return " ";
		}
		
		/**
		 * 选中或取消选中项目时调用。子类必须覆盖此方法才可设置选中项。 
		 * @param index 已选中的项目索引。
		 * @param selected true为选中，false取消选中
		 */		
		protected function itemSelected(index:int, selected:Boolean):void
		{
			if(!dataGroup)
				return;
			var renderer:IItemRenderer = dataGroup.getElementAt(index) as IItemRenderer;
			if(renderer==null)
				return;
			renderer.selected = selected;
		}
		
		/**
		 * 返回指定索引是否等于当前选中索引
		 */
		dx_internal function isItemIndexSelected(index:int):Boolean
		{        
			return index == selectedIndex;
		}
		
		/**
		 * 提交选中项属性，返回是否成功提交，false表示被取消
		 */		
		protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var maxIndex:int = dataProvider ? dataProvider.length - 1 : -1;
			var oldSelectedIndex:int = _selectedIndex;
			var e:IndexChangeEvent;
			
			if (!allowCustomSelectedItem || _proposedSelectedIndex != CUSTOM_SELECTED_ITEM)
			{
				if (_proposedSelectedIndex < NO_SELECTION)
					_proposedSelectedIndex = NO_SELECTION;
				if (_proposedSelectedIndex > maxIndex)
					_proposedSelectedIndex = maxIndex;
				if (requireSelection && _proposedSelectedIndex == NO_SELECTION && 
					dataProvider && dataProvider.length > 0)
				{
					_proposedSelectedIndex = NO_PROPOSED_SELECTION;
					dispatchChangeAfterSelection = false;
					return false;
				}
			}
			
			var tmpProposedIndex:int = _proposedSelectedIndex;
			
			if (dispatchChangeAfterSelection)
			{
				e = new IndexChangeEvent(IndexChangeEvent.CHANGING, false, true);
				e.oldIndex = _selectedIndex;
				e.newIndex = _proposedSelectedIndex;
				if (!dispatchEvent(e))
				{
					itemSelected(_proposedSelectedIndex, false);
					_proposedSelectedIndex = NO_PROPOSED_SELECTION;
					dispatchChangeAfterSelection = false;
					return false;
				}
				
			}
			
			_selectedIndex = tmpProposedIndex;
			_proposedSelectedIndex = NO_PROPOSED_SELECTION;
			
			if (oldSelectedIndex != NO_SELECTION)
				itemSelected(oldSelectedIndex, false);
			if (_selectedIndex != NO_SELECTION)
				itemSelected(_selectedIndex, true);
		
			//子类若需要自身抛出Change事件，而不是在此处抛出，可以设置dispatchChangedEvents为false
			if (dispatchChangedEvents)
			{
				if (dispatchChangeAfterSelection)
				{
					e = new IndexChangeEvent(IndexChangeEvent.CHANGE);
					e.oldIndex = oldSelectedIndex;
					e.newIndex = _selectedIndex;
					dispatchEvent(e);
					dispatchChangeAfterSelection = false;
				}
				dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			}
			
			return true;
		}
		
		private var selectedIndexAdjusted:Boolean = false;
		/**
		 * 仅调整选中索引值而不更新选中项,即在提交属性阶段itemSelected方法不会被调用，也不会触发changing和change事件。
		 * @param newIndex 新索引。
		 * @param add 如果已将项目添加到组件，则为 true；如果已删除项目，则为 false。
		 */		
		protected function adjustSelection(newIndex:int, add:Boolean=false):void
		{
			if (_proposedSelectedIndex != NO_PROPOSED_SELECTION)
				_proposedSelectedIndex = newIndex;
			else
				_selectedIndex = newIndex;
			selectedIndexAdjusted = true;
			invalidateProperties();
		}
		
		/**
		 * 数据项添加
		 */
		protected function itemAdded(index:int):void
		{
			if (doingWholesaleChanges)
				return;
			
			if (selectedIndex == NO_SELECTION)
			{
				if (requireSelection)
					adjustSelection(index,true);
			}
			else if (index <= selectedIndex)
			{
				adjustSelection(selectedIndex + 1,true);
			}
		}
		
		/**
		 * 数据项移除
		 */
		protected function itemRemoved(index:int):void
		{
			if (selectedIndex == NO_SELECTION || doingWholesaleChanges)
				return;
			
			if (index == selectedIndex)
			{
				if (requireSelection && dataProvider && dataProvider.length > 0)
				{       
					if (index == 0)
					{
						_proposedSelectedIndex = 0;
						invalidateProperties();
					}
					else 
						setSelectedIndex(0, false);
				}
				else
					adjustSelection(-1,false);
			}
			else if (index < selectedIndex)
			{
				adjustSelection(selectedIndex - 1,false);
			}
		}
		
		
		/**
		 * 项呈示器被添加
		 */
		protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			var renderer:DisplayObject = event.renderer as DisplayObject;
			
			if (renderer == null)
				return;
			
			renderer.addEventListener(MouseEvent.ROLL_OVER, item_mouseEventHandler);
			renderer.addEventListener(MouseEvent.ROLL_OUT, item_mouseEventHandler);
		}
		/**
		 * 项呈示器被移除
		 */		
		protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			var renderer:DisplayObject = event.renderer as DisplayObject;
			
			if (renderer == null)
				return;
			
			renderer.removeEventListener(MouseEvent.ROLL_OVER, item_mouseEventHandler);
			renderer.removeEventListener(MouseEvent.ROLL_OUT, item_mouseEventHandler);
		}
		
		private static const TYPE_MAP:Object = {rollOver:"itemRollOver",
			rollOut:"itemRollOut"};
		
		/**
		 * 项呈示器鼠标事件
		 */		
		private function item_mouseEventHandler(event:MouseEvent):void
		{
			var type:String = event.type;
			type = TYPE_MAP[type];
			if (hasEventListener(type))
			{
				var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
				dispatchListEvent(event,type,itemRenderer);
			}
		}
		/**
		 * 抛出列表事件
		 * @param mouseEvent 相关联的鼠标事件
		 * @param type 事件名称
		 * @param itemRenderer 关联的条目渲染器实例
		 */		
		dx_internal function dispatchListEvent(mouseEvent:MouseEvent,type:String,itemRenderer:IItemRenderer):void
		{
			var itemIndex:int = -1;
			if (itemRenderer)
				itemIndex = itemRenderer.itemIndex;
			else
				itemIndex = dataGroup.getElementIndex(mouseEvent.currentTarget as IVisualElement);

			var listEvent:ListEvent = new ListEvent(type, false, false,
				mouseEvent.localX,
				mouseEvent.localY,
				mouseEvent.relatedObject,
				mouseEvent.ctrlKey,
				mouseEvent.altKey,
				mouseEvent.shiftKey,
				mouseEvent.buttonDown,
				mouseEvent.delta,
				itemIndex,
				dataProvider.getItemAt(itemIndex),
				itemRenderer);
			dispatchEvent(listEvent);
		}
		
		/**
		 * 数据源发生改变
		 */
		protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			var items:Array = event.items;
			if (event.kind == CollectionEventKind.ADD)
			{
				var length:int = items.length;
				for (var i:int = 0; i < length; i++)
				{
					itemAdded(event.location + i);
				}
			}
			else if (event.kind == CollectionEventKind.REMOVE)
			{
				length = items.length;
				for (i = length-1; i >= 0; i--)
				{
					itemRemoved(event.location + i);
				}
			}
			else if (event.kind == CollectionEventKind.MOVE)
			{
				itemRemoved(event.oldLocation);
				itemAdded(event.location);
			}
			else if (event.kind == CollectionEventKind.RESET)
			{
				if (dataProvider.length == 0)
				{
					setSelectedIndex(NO_SELECTION, false);
				}
				else
				{
					dataProviderChanged = true; 
					invalidateProperties(); 
				}
			}
			else if (event.kind == CollectionEventKind.REFRESH)
			{
				setSelectedIndex(NO_SELECTION, false);
			}
		}
	}
}