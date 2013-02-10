package org.flexlite.domUI.components.supportClasses
{
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.IInvalidateDisplay;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.events.TreeEvent;
	
	use namespace dx_internal;
	/**
	 * Tree组件的项呈示器基类
	 * @author DOM
	 */
	public class TreeItemRenderer extends ItemRenderer
	{
		/**
		 * 构造函数
		 */		
		public function TreeItemRenderer()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TreeItemRenderer;
		}
		
		/**
		 * [SkinPart]图标显示对象
		 */
		public var iconDisplay:ISkinnableClient;
		/**
		 * [SkinPart]子节点开启按钮
		 */
		public var disclosureButton:ToggleButtonBase;
		
		private var _iconSkinName:Object;
		/**
		 * 图标的皮肤名
		 */
		public function get iconSkinName():Object
		{
			return _iconSkinName;
		}

		public function set iconSkinName(value:Object):void
		{
			if(_iconSkinName==value)
				return;
			_iconSkinName = value;
			if(iconDisplay)
			{
				iconDisplay.skinName = _iconSkinName;
			}
		}

		
		private var _indent:Number = 0;
		/**
		 * 缩进值,以像素为单位。默认值为0。
		 */
		public function get indentation():Number
		{
			return _indent;
		}

		public function set indentation(value:Number):void
		{
			if(value==_indent)
				return;
			_indent = value;
			invalidateDisplayList();
		}
		
		private var _hasChildren:Boolean = false;
		/**
		 * 是否含有子节点,默认false。
		 */
		public function get hasChildren():Boolean
		{
			return _hasChildren;
		}

		public function set hasChildren(value:Boolean):void
		{
			if(_hasChildren==value)
				return;
			_hasChildren = value;
			if(disclosureButton)
			{
				disclosureButton.visible = _hasChildren;
			}
		}
		
		private var _isOpen:Boolean = false;
		/**
		 * 节点是否处于开启状态。
		 */
		public function get opened():Boolean
		{
			return _isOpen;
		}

		public function set opened(value:Boolean):void
		{
			if(_isOpen==value)
				return;
			_isOpen = value;
			if(disclosureButton)
			{
				disclosureButton.selected = _isOpen;
			}
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance==iconDisplay)
			{
				iconDisplay.skinName = _iconSkinName;
			}
			else if(instance==disclosureButton)
			{
				disclosureButton.visible = _hasChildren;
				disclosureButton.selected = _isOpen;
				disclosureButton.addEventListener(MouseEvent.MOUSE_DOWN,
					disclosureButton_mouseDownHandler);
				disclosureButton.addEventListener(MouseEvent.MOUSE_UP, 
					disclosureButton_mouseUpHandler,false,1000);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance==iconDisplay)
			{
				iconDisplay.skinName = null;
			}
			else if(instance==disclosureButton)
			{
				disclosureButton.removeEventListener(MouseEvent.MOUSE_DOWN,
					disclosureButton_mouseDownHandler);
				disclosureButton.removeEventListener(MouseEvent.MOUSE_UP, 
					disclosureButton_mouseUpHandler);
				disclosureButton.visible = true;
			}
		}
		/**
		 * 鼠标在disclosureButton上按下
		 */		
		protected function disclosureButton_mouseDownHandler(event:MouseEvent):void
		{
			dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPENING,
				false,true,data,this,!disclosureButton.selected));
			event.preventDefault();//防止当前项被选中。
		}
		/**
		 * 鼠标在disclosureButton上弹起
		 */		
		protected function disclosureButton_mouseUpHandler(event:MouseEvent):void
		{
			//屏蔽disclosureButton由于交互产生的选中状态改变。
			event.stopImmediatePropagation();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			updateSkinDisplayList();
		}
		/**
		 * 图标和文字的水平间隔
		 */		
		dx_internal var gap:Number = 2;
		/**
		 * 更新皮肤部件的缩进布局
		 */
		protected function updateSkinDisplayList():void
		{
			var startX:Number = Math.round(_indent);
			if(disclosureButton)
			{
				disclosureButton.x = startX;
				startX += disclosureButton.layoutBoundsWidth+gap;
			}
			if(iconDisplay)
			{
				iconDisplay.x = startX;
				if(iconDisplay.layoutBoundsWidth>0)
					startX += iconDisplay.layoutBoundsWidth+gap;
			}
			if(labelDisplay)
			{
				labelDisplay.x = startX;
			}
		}
		
	}
}