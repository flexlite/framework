package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.components.supportClasses.ListBase;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.IndexChangeEvent;
	import org.flexlite.domUI.events.ListEvent;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.events.UIEvent;

	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 列表组件
	 * @author DOM
	 */
	public class List extends ListBase
	{
		public function List()
		{
			super();
			useVirtualLayout = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(!itemRenderer)
				itemRenderer = ItemRenderer;
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return List;
		}
		
		/**
		 * 是否使用虚拟布局,默认true
		 */		
		override public function get useVirtualLayout():Boolean
		{
			return super.useVirtualLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set useVirtualLayout(value:Boolean):void
		{
			super.useVirtualLayout = value;
		}
		
		
		private var _allowMultipleSelection:Boolean = false;
		/**
		 * 是否允许同时选中多项
		 */
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}

		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}

		private var _selectedIndices:Vector.<int> = new Vector.<int>();
		
		private var _proposedSelectedIndices:Vector.<int>; 
		/**
		 * 当前选中的一个或多个项目的索引列表
		 */		
		public function get selectedIndices():Vector.<int>
		{
			if(_proposedSelectedIndices)
				return _proposedSelectedIndices;
			return _selectedIndices;
		}

		public function set selectedIndices(value:Vector.<int>):void
		{
			setSelectedIndices(value, false);
		}
		/**
		 * @inheritDoc
		 */
		override public function get selectedIndex():int
		{
			if(_proposedSelectedIndices)
			{
				if(_proposedSelectedIndices.length>0)
					return _proposedSelectedIndices[0];
				return -1;
			}
			return super.selectedIndex;
		}
		
		/**
		 * 当前选中的一个或多个项目的数据源列表
		 */		
		public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			var list:Vector.<int> = selectedIndices;
			if (list)
			{
				var count:int = list.length;
				
				for (var i:int = 0; i < count; i++)
					result[i] = dataProvider.getItemAt(list[i]);  
			}
			
			return result;
		}
		
		public function set selectedItems(value:Vector.<Object>):void
		{
			var indices:Vector.<int> = new Vector.<int>();
			
			if (value)
			{
				var count:int = value.length;
				
				for (var i:int = 0; i < count; i++)
				{
					var index:int = dataProvider.getItemIndex(value[i]);
					if (index != -1)
					{ 
						indices.splice(0, 0, index);   
					}
					if (index == -1)
					{
						indices = new Vector.<int>();
						break;  
					}
				}
			}
			setSelectedIndices(indices,false);
		}
		/**
		 * 设置多个选中项
		 */
		dx_internal function setSelectedIndices(value:Vector.<int>, dispatchChangeEvent:Boolean = false):void
		{
			if (dispatchChangeEvent)
				dispatchChangeAfterSelection = (dispatchChangeAfterSelection || dispatchChangeEvent);
			
			if (value)
				_proposedSelectedIndices = value;
			else
				_proposedSelectedIndices = new Vector.<int>();
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_proposedSelectedIndices)
			{
				commitSelection();
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var oldSelectedIndex:Number = _selectedIndex;
			if(_proposedSelectedIndices)
			{
				_proposedSelectedIndices = _proposedSelectedIndices.filter(isValidIndex);
				
				if (!allowMultipleSelection && _proposedSelectedIndices.length>0)
				{
					var temp:Vector.<int> = new Vector.<int>(); 
					temp.push(_proposedSelectedIndices[0]); 
					_proposedSelectedIndices = temp;  
				}
				if (_proposedSelectedIndices.length>0)
				{
					_proposedSelectedIndex = _proposedSelectedIndices[0];
				}
				else
				{
					_proposedSelectedIndex = -1;
				}
			}
			
			var retVal:Boolean = super.commitSelection(false); 
			
			if (!retVal)
			{
				_proposedSelectedIndices = null;
				return false; 
			}
			
			if (selectedIndex > NO_SELECTION)
			{
				if (_proposedSelectedIndices)
				{
					if(_proposedSelectedIndices.indexOf(selectedIndex) == -1)
						_proposedSelectedIndices.push(selectedIndex);
				}
				else
				{
					_proposedSelectedIndices = new <int>[selectedIndex];
				}
			}
			
			if(_proposedSelectedIndices)
			{
				if(_proposedSelectedIndices.indexOf(oldSelectedIndex)!=-1)
					itemSelected(oldSelectedIndex,true);
				commitMultipleSelection(); 
			}
			
			if (dispatchChangedEvents && retVal)
			{
				var e:IndexChangeEvent; 
				
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
			
			return retVal; 
		}
		/**
		 * 是否是有效的索引
		 */		
		private function isValidIndex(item:int, index:int, v:Vector.<int>):Boolean
		{
			return dataProvider && (item >= 0) && (item < dataProvider.length); 
		}
		/**
		 * 提交多项选中项属性
		 */			
		protected function commitMultipleSelection():void
		{
			var removedItems:Vector.<int> = new Vector.<int>();
			var addedItems:Vector.<int> = new Vector.<int>();
			var i:int;
			var count:int;
			
			if (_selectedIndices.length>0&& _proposedSelectedIndices.length>0)
			{
				count = _proposedSelectedIndices.length;
				for (i = 0; i < count; i++)
				{
					if (_selectedIndices.indexOf(_proposedSelectedIndices[i]) == -1)
						addedItems.push(_proposedSelectedIndices[i]);
				}
				count = _selectedIndices.length; 
				for (i = 0; i < count; i++)
				{
					if (_proposedSelectedIndices.indexOf(_selectedIndices[i]) == -1)
						removedItems.push(_selectedIndices[i]);
				}
			}
			else if (_selectedIndices.length>0)
			{
				removedItems = _selectedIndices;
			}
			else if (_proposedSelectedIndices.length>0)
			{
				addedItems = _proposedSelectedIndices;
			}
			
			_selectedIndices = _proposedSelectedIndices;
			
			if (removedItems.length > 0)
			{
				count = removedItems.length;
				for (i = 0; i < count; i++)
				{
					itemSelected(removedItems[i], false);
				}
			}
			
			if (addedItems.length>0)
			{
				count = addedItems.length;
				for (i = 0; i < count; i++)
				{
					itemSelected(addedItems[i], true);
				}
			}
			
			_proposedSelectedIndices = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function isItemIndexSelected(index:int):Boolean
		{
			if (_allowMultipleSelection)
				return _selectedIndices.indexOf(index) != -1;
			
			return super.isItemIndexSelected(index);
		}

		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			//由于ItemRenderer.mouseChildren有可能不为false，在鼠标按下时会出现切换素材的情况，
			//导致target变化而无法抛出原生的click事件,所以此处监听MouseUp来抛出ItemClick事件。
			renderer.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if (renderer == null)
				return;
			
			renderer.removeEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			renderer.removeEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
		}
		/**
		 * 是否捕获ItemRenderer以便在MouseUp时抛出ItemClick事件
		 */		
		dx_internal var captureItemRenderer:Boolean = true;
		
		private var mouseDownItemRenderer:IItemRenderer;
		/**
		 * 鼠标在项呈示器上按下
		 */		
		protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if (event.isDefaultPrevented())
				return;
			
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			var newIndex:int
			if (itemRenderer)
				newIndex = itemRenderer.itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			if(_allowMultipleSelection)
			{
				setSelectedIndices(calculateSelectedIndices(newIndex, event.shiftKey, event.ctrlKey), true);
			}
			else
			{
				setSelectedIndex(newIndex, true);
			}
			if(!captureItemRenderer)
				return;
			mouseDownItemRenderer = itemRenderer;
			DomGlobals.stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler,false,0,true);
			DomGlobals.stage.addEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler,false,0,true);
		}
		/**
		 * 计算当前的选中项列表
		 */		
		private function calculateSelectedIndices(index:int, shiftKey:Boolean, ctrlKey:Boolean):Vector.<int>
		{
			var i:int; 
			var interval:Vector.<int> = new Vector.<int>();  
			if (!shiftKey)
			{
				if(ctrlKey)
				{
					if (_selectedIndices.length>0)
					{
						if (_selectedIndices.length == 1 && (_selectedIndices[0] == index))
						{
							if (!requireSelection)
								return interval; 
							
							interval.splice(0, 0, _selectedIndices[0]); 
							return interval; 
						}
						else
						{
							var found:Boolean = false; 
							for (i = 0; i < _selectedIndices.length; i++)
							{
								if (_selectedIndices[i] == index)
									found = true; 
								else if (_selectedIndices[i] != index)
									interval.splice(0, 0, _selectedIndices[i]);
							}
							if (!found)
							{
								interval.splice(0, 0, index);   
							}
							return interval; 
						} 
					}
					else
					{ 
						interval.splice(0, 0, index); 
						return interval; 
					}
				}
				else 
				{ 
					interval.splice(0, 0, index); 
					return interval; 
				}
			}
			else 
			{
				var start:int = _selectedIndices.length>0 ? _selectedIndices[_selectedIndices.length - 1] : 0; 
				var end:int = index; 
				if (start < end)
				{
					for (i = start; i <= end; i++)
					{
						interval.splice(0, 0, i); 
					}
				}
				else 
				{
					for (i = start; i >= end; i--)
					{
						interval.splice(0, 0, i); 
					}
				}
				return interval; 
			}
		}

		/**
		 * 鼠标在项呈示器上弹起，抛出ItemClick事件。
		 */	
		private function item_mouseUpHandler(event:MouseEvent):void
		{
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			if(itemRenderer!=mouseDownItemRenderer)
				return;
			dispatchListEvent(event,ListEvent.ITEM_CLICK,itemRenderer);
		}
		
		/**
		 * 鼠标在舞台上弹起
		 */		
		private function stage_mouseUpHandler(event:Event):void
		{
			DomGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			DomGlobals.stage.removeEventListener(Event.MOUSE_LEAVE,stage_mouseUpHandler);
			mouseDownItemRenderer = null;
		}
	}
}