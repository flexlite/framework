package org.flexlite.domUI.components
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.collections.ICollection;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.RendererExistenceEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;

	use namespace dx_internal;
	
	/**
	 * 添加了项呈示器 
	 */	
	[Event(name="rendererAdd", type="org.flexlite.domUI.events.RendererExistenceEvent")]
	/**
	 * 移除了项呈示器 
	 */	
	[Event(name="rendererRemove", type="org.flexlite.domUI.events.RendererExistenceEvent")]
	
	[DXML(show="true")]
	
	[DefaultProperty(name="dataProvider",array="false")]
	
	/**
	 * 可设置外观的数据项目容器基类
	 * @author DOM
	 */
	public class SkinnableDataContainer extends SkinnableComponent implements IItemRendererOwner
	{
		/**
		 * 构造函数
		 */		
		public function SkinnableDataContainer()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return SkinnableDataContainer;
		}
		/**
		 * @inheritDoc
		 */
		public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is IVisualElement)
			{
				(renderer as IVisualElement).ownerChanged(this);
			}
			renderer.itemIndex = itemIndex;
			renderer.label = itemToLabel(data);
			renderer.data = data;
			return renderer;
		}
		
		/**
		 * 返回可在项呈示器中显示的 String 
		 */		
		public function itemToLabel(item:Object):String
		{
			if (item !== null)
				return item.toString();
			else return " ";
		}
		
		/**
		 * [SkinPart]数据项目容器实体
		 */		
		public var dataGroup:DataGroup;
		/**
		 * dataGroup发生改变时传递的参数 
		 */		
		private var dataGroupProperties:Object = {};
		
		/**
		 * 列表数据源，请使用实现了ICollection接口的数据类型，例如ArrayCollection
		 */		
		public function get dataProvider():ICollection
		{       
			return dataGroup!=null
			? dataGroup.dataProvider 
				: dataGroupProperties.dataProvider;
		}

		public function set dataProvider(value:ICollection):void
		{
			if (dataGroup==null)
			{
				dataGroupProperties.dataProvider = value;
			}
			else
			{
				dataGroup.dataProvider = value;
				dataGroupProperties.dataProvider = true;
			}
		}
		
		/**
		 * 用于数据项目的项呈示器。该类必须实现 IItemRenderer 接口。 <br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。
		 */		
		public function get itemRenderer():Class
		{
			return (dataGroup) 
			? dataGroup.itemRenderer 
				: dataGroupProperties.itemRenderer;
		}
		
		public function set itemRenderer(value:Class):void
		{
			if (dataGroup==null)
			{
				dataGroupProperties.itemRenderer = value;
			}
			else
			{
				dataGroup.itemRenderer = value;
				dataGroupProperties.itemRenderer = true;
			}
		}
		
		/**
		 * 条目渲染器的可选皮肤标识符。在实例化itemRenderer时，若其内部没有设置过skinName,则将此属性的值赋值给它的skinName。
		 * 注意:若itemRenderer不是ISkinnableClient，则此属性无效。
		 */	
		public function get itemRendererSkinName():Object
		{
			return (dataGroup) 
			? dataGroup.itemRendererSkinName 
				: dataGroupProperties.itemRendererSkinName;
		}
		
		public function set itemRendererSkinName(value:Object):void
		{
			if (dataGroup==null)
			{
				dataGroupProperties.itemRendererSkinName = value;
			}
			else
			{
				dataGroup.itemRendererSkinName = value;
				dataGroupProperties.itemRendererSkinName = true;
			}
		}
		
		/**
		 * 为某个特定项目返回一个项呈示器Class的函数。 <br/>
		 * rendererClass获取顺序：itemRendererFunction > itemRenderer > 默认ItemRenerer。 <br/>
		 * 应该定义一个与此示例函数类似的呈示器函数： <br/>
		 * function myItemRendererFunction(item:Object):Class
		 */		
		public function get itemRendererFunction():Function
		{
			return (dataGroup) 
			? dataGroup.itemRendererFunction 
				: dataGroupProperties.itemRendererFunction;
		}
		
		public function set itemRendererFunction(value:Function):void
		{
			if (dataGroup==null)
			{
				dataGroupProperties.itemRendererFunction = value;
			}
			else
			{
				dataGroup.itemRendererFunction = value;
				dataGroupProperties.itemRendererFunction = true;
			}
		}
		
		/**
		 * 布局对象
		 */	
		public function get layout():LayoutBase
		{
			return (dataGroup) 
			? dataGroup.layout 
				: dataGroupProperties.layout;
		}
		
		public function set layout(value:LayoutBase):void
		{
			if (dataGroup==null)
			{
				dataGroupProperties.layout = value;
			}
			else
			{
				dataGroup.layout = value;
				dataGroupProperties.layout = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
			{
				var newDataGroupProperties:Object = {};
				
				if (dataGroupProperties.layout !== undefined)
				{
					dataGroup.layout = dataGroupProperties.layout;
					newDataGroupProperties.layout = true;
				}
				
				if (dataGroupProperties.dataProvider !== undefined)
				{
					dataGroup.dataProvider = dataGroupProperties.dataProvider;
					newDataGroupProperties.dataProvider = true;
				}
				
				if (dataGroupProperties.itemRenderer !== undefined)
				{
					dataGroup.itemRenderer = dataGroupProperties.itemRenderer;
					newDataGroupProperties.itemRenderer = true;
				}
				
				if (dataGroupProperties.itemRendererSkinName !== undefined)
				{
					dataGroup.itemRendererSkinName = dataGroupProperties.itemRendererSkinName;
					newDataGroupProperties.itemRendererSkinName = true;
				}
				
				if (dataGroupProperties.itemRendererFunction !== undefined)
				{
					dataGroup.itemRendererFunction = dataGroupProperties.itemRendererFunction;
					newDataGroupProperties.itemRendererFunction = true;
				}
				dataGroup.rendererOwner = this;
				dataGroupProperties = newDataGroupProperties;
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					dataGroup.addEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					dataGroup.addEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
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
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				dataGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				var newDataGroupProperties:Object = {};
				if(dataGroupProperties.layout)
					newDataGroupProperties.layout = dataGroup.layout;
				if(dataGroupProperties.dataProvider)
					newDataGroupProperties.dataProvider = dataGroup.dataProvider;
				if(dataGroupProperties.itemRenderer)
					newDataGroupProperties.itemRenderer = dataGroup.itemRenderer;
				if(dataGroupProperties.itemRendererSkinName)
					newDataGroupProperties.itemRendererSkinName = dataGroup.itemRendererSkinName;
				if(dataGroupProperties.itemRendererFunction)
					newDataGroupProperties.itemRendererFunction = dataGroup.itemRendererFunction;
				dataGroupProperties = newDataGroupProperties
				dataGroup.rendererOwner = null;
				dataGroup.dataProvider = null;
				dataGroup.layout = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(
			type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if (type == RendererExistenceEvent.RENDERER_ADD && dataGroup)
			{
				dataGroup.addEventListener(
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup)
			{
				dataGroup.addEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			
			if (type == RendererExistenceEvent.RENDERER_ADD && dataGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					dataGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					dataGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function createSkinParts():void
		{
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var temp:VerticalLayout = new VerticalLayout();
			dataGroup.layout = temp;
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			addToDisplayList(dataGroup);
			partAdded("dataGroup",dataGroup);
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function removeSkinParts():void
		{
			if(!dataGroup)
				return;
			partRemoved("dataGroup",dataGroup);
			removeFromDisplayList(dataGroup);
			dataGroup = null;
		}
	}
}