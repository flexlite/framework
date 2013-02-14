package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.IInvalidateDisplay;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.events.TreeEvent;
	import org.flexlite.domUI.events.UIEvent;
	
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
		/**
		 * [SkinPart]用于调整缩进值的容器对象。
		 */
		public var contentGroup:DisplayObject;
		
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
			if(contentGroup)
				contentGroup.x = _indent;
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
				disclosureButton.autoSelected = false;
				disclosureButton.addEventListener(MouseEvent.MOUSE_DOWN,
					disclosureButton_mouseDownHandler);
			}
			else if(instance==contentGroup)
			{
				contentGroup.x = _indent;
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
				disclosureButton.autoSelected = true;
				disclosureButton.visible = true;
			}
		}
		/**
		 * 鼠标在disclosureButton上按下
		 */		
		protected function disclosureButton_mouseDownHandler(event:MouseEvent):void
		{
			var evt:TreeEvent = new TreeEvent(TreeEvent.ITEM_OPENING,
				false,true,itemIndex,data,this);
			evt.opening = !_isOpen;
			dispatchEvent(evt);
			event.preventDefault();//防止当前项被选中。
		}
	}
}