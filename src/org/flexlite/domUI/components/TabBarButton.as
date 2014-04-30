package org.flexlite.domUI.components
{
	import flash.events.Event;
	
	import org.flexlite.domUI.components.supportClasses.ToggleButtonBase;
	import org.flexlite.domCore.dx_internal;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	/**
	 * 数据源发生改变
	 */	
	[Event(name="dataChange",type="flash.events.Event")]
	
	/**
	 * 选项卡组件的按钮条目
	 * @author DOM
	 */	
	public class TabBarButton extends ToggleButtonBase implements IItemRenderer
	{
		
		public function TabBarButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TabBarButton;
		}
		
		private var _allowDeselection:Boolean = true;
		/**
		 * 如果为 true，用户单击当前选定的按钮时即会将其取消选择。
		 * 如果为 false，用户必须选择不同的按钮才可取消选择当前选定的按钮。
		 */		
		public function get allowDeselection():Boolean
		{
			return _allowDeselection;
		}
		
		public function set allowDeselection(value:Boolean):void
		{
			_allowDeselection = value;
		}
		
		private var _data:Object;
		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			dispatchEvent(new Event("dataChange"));
		}
		
		private var _itemIndex:int;
		/**
		 * @inheritDoc
		 */
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set label(value:String):void
		{
			if (value != label)
			{
				super.label = value;
				
				if (labelDisplay)
					labelDisplay.text = label;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buttonReleased():void
		{
			if (selected && !allowDeselection)
				return;
			
			super.buttonReleased();
		}
	}
	
}