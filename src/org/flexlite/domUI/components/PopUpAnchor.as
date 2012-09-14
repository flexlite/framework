package org.flexlite.domUI.components
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.dx_internal;
<<<<<<< HEAD
	import org.flexlite.domUI.managers.PopUpManager;
=======
	import org.flexlite.domUI.managers.PopUpManager;
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
	
	use namespace dx_internal;
	
	[DefaultProperty(name="popUp")]
	
	[DXML(show="false")]
	/**
	 * PopUpAnchor组件用于定位布局中的弹出控件或下拉控件
	 * @author DOM
	 */	
	public class PopUpAnchor extends UIComponent
	{
		/**
		 * 构造函数
		 */		
		public function PopUpAnchor()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		/**
		 * popUp已经弹出的标志
		 */		
		private var popUpIsDisplayed:Boolean = false;
		/**
		 * 自身已经添加到舞台标志
		 */		
		private var addedToStage:Boolean = false;
		
		private var _popUpHeightMatchesAnchorHeight:Boolean = false;
		/**
		 * 如果为 true，则将popUp控件的高度设置为 PopUpAnchor的高度值。
		 */
		public function get popUpHeightMatchesAnchorHeight():Boolean
		{
			return _popUpHeightMatchesAnchorHeight;
		}
		public function set popUpHeightMatchesAnchorHeight(value:Boolean):void
		{
			if (_popUpHeightMatchesAnchorHeight == value)
				return;
			
			_popUpHeightMatchesAnchorHeight = value;
			
			invalidateDisplayList();
		}
		
		private var _popUpWidthMatchesAnchorWidth:Boolean = false;
		/**
		 * 如果为true，则将popUp控件的宽度设置为PopUpAnchor的宽度值。
		 */		
		public function get popUpWidthMatchesAnchorWidth():Boolean
		{
			return _popUpWidthMatchesAnchorWidth;
		}
		public function set popUpWidthMatchesAnchorWidth(value:Boolean):void
		{
			if (_popUpWidthMatchesAnchorWidth == value)
				return;
			
			_popUpWidthMatchesAnchorWidth = value;
			
			invalidateDisplayList();
		}
		
		private var _displayPopUp:Boolean = false;
		/**
		 * 如果为 true，则将popUp对象弹出。若为false，关闭弹出的popUp。
		 */		
		public function get displayPopUp():Boolean
		{
			return _displayPopUp;
		}
		public function set displayPopUp(value:Boolean):void
		{
			if (_displayPopUp == value)
				return;
			
			_displayPopUp = value;
			addOrRemovePopUp();
		}
		
		
		private var _popUp:IVisualElement;
		/**
		 * 要弹出或移除的目标显示对象。
		 */		
		public function get popUp():IVisualElement
		{ 
			return _popUp 
		}
		public function set popUp(value:IVisualElement):void
		{
			if (_popUp == value)
				return;
			
			_popUp = value;
			
			dispatchEvent(new Event("popUpChanged"));
		}
		
		private var _popUpPosition:String = PopUpPosition.TOP_LEFT;
		/**
		 * popUp相对于PopUpAnchor的弹出位置。请使用PopUpPosition里定义的常量。
		 * @see org.flexlite.domUI.components.PopUpPosition
		 */		
		public function get popUpPosition():String
		{
			return _popUpPosition;
		}
		public function set popUpPosition(value:String):void
		{
			if (_popUpPosition == value)
				return;
			
			_popUpPosition = value;
			invalidateDisplayList();    
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);                
			applyPopUpTransform(unscaledWidth, unscaledHeight);            
		}
		/**
		 * 手动刷新popUp的弹出位置和尺寸。
		 */		
		public function updatePopUpTransform():void
		{
			applyPopUpTransform(width, height);
		}
		/**
		 * 计算popUp的弹出位置
		 */		
		private function calculatePopUpPosition():Point
		{
			var registrationPoint:Point = new Point();
			switch(_popUpPosition)
			{
				case PopUpPosition.BELOW:
					registrationPoint.x = 0;
					registrationPoint.y = height;
					break;
				case PopUpPosition.ABOVE:
					registrationPoint.x = 0;
					registrationPoint.y = -popUp.layoutBoundsHeight;
					break;
				case PopUpPosition.LEFT:
					registrationPoint.x = -popUp.layoutBoundsWidth;
					registrationPoint.y = 0;
					break;
				case PopUpPosition.RIGHT:
					registrationPoint.x = width;
					registrationPoint.y = 0;
					break;            
				case PopUpPosition.CENTER:
					registrationPoint.x = (width - popUp.layoutBoundsWidth)*0.5;
					registrationPoint.y = (height - popUp.layoutBoundsHeight)*0.5;
					break;            
				case PopUpPosition.TOP_LEFT:
					break;
			}
			registrationPoint = localToGlobal(registrationPoint);
			if(DomGlobals.appContainer)
			{
				registrationPoint = DomGlobals.appContainer.globalToLocal(registrationPoint);
			}
			return registrationPoint;
		}
		/**
		 * 添加或移除popUp
		 */		
		private function addOrRemovePopUp():void
		{
			if (!addedToStage)
				return;
			
			if (popUp == null)
				return;
			
			if (popUp.parent == null && displayPopUp)
			{
				PopUpManager.addPopUp(popUp);
				popUp.owner = this;
				popUpIsDisplayed = true;
				applyPopUpTransform(width, height);
			}
			else if (popUp.parent != null && !displayPopUp)
			{
				removeAndResetPopUp();
			}
		}
		/**
		 * 移除并重置popUp
		 */		
		private function removeAndResetPopUp():void
		{
			PopUpManager.removePopUp(popUp);
			popUpIsDisplayed = false;
		}
		/**
		 * 对popUp应用尺寸和位置调整
		 */		
		private function applyPopUpTransform(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!popUpIsDisplayed)
				return;
			if (popUpWidthMatchesAnchorWidth)
				popUp.width = unscaledWidth;
			else
				popUp.width = NaN;
			
			if (popUpHeightMatchesAnchorHeight)
				popUp.height = unscaledHeight;
			else
				popUp.height = NaN;
			var popUpPoint:Point = calculatePopUpPosition();
			popUp.x = popUpPoint.x;
			popUp.y = popUpPoint.y;
		}
		/**
		 * 添加到舞台事件
		 */		
		private function addedToStageHandler(event:Event):void
		{
			addedToStage = true;
			addOrRemovePopUp();    
		}
		/**
		 * 从舞台移除事件
		 */		
		private function removedFromStageHandler(event:Event):void
		{
			if (popUp != null && DisplayObject(popUp).parent != null)
				removeAndResetPopUp();
			
			addedToStage = false;
		}
		
	}
}
