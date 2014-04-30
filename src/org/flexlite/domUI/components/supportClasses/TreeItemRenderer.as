package org.flexlite.domUI.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.ITreeItemRenderer;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.events.TreeEvent;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * Tree组件的项呈示器基类
	 * @author DOM
	 */
	public class TreeItemRenderer extends ItemRenderer implements ITreeItemRenderer
	{
		/**
		 * 构造函数
		 */		
		public function TreeItemRenderer()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown,false,1000);
		}
		
		private function onItemMouseDown(event:MouseEvent):void
		{
			if(event.target==disclosureButton)
			{
				event.stopImmediatePropagation();
			}
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
		
		private var _iconSkinName:Object;
		/**
		 * @inheritDoc
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

		private var _depth:int = 0;
		/**
		 * @inheritDoc
		 */
		public function get depth():int
		{
			return _depth;
		}
		public function set depth(value:int):void
		{
			if(value==_depth)
				return;
			_depth = value;
			if(contentGroup)
			{
				contentGroup.x = _depth*_indentation;
			}
		}
		
		private var _hasChildren:Boolean = false;
		/**
		 * @inheritDoc
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
		 * @inheritDoc
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
				contentGroup.x = _depth*_indentation;
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
		}
	}
}