package org.flexlite.domUI.components
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.PopUpPosition;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.effects.animation.Animation;
	import org.flexlite.domUI.effects.animation.MotionPath;
	import org.flexlite.domUI.managers.PopUpManager;
	import org.flexlite.domUI.utils.callLater;
	
	use namespace dx_internal;
	
	[DefaultProperty(name="popUp")]
	
	[DXML(show="true")]
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
		 * popUp相对于PopUpAnchor的弹出位置。请使用PopUpPosition里定义的常量。默认值TOP_LEFT。
		 * @see org.flexlite.domUI.core.PopUpPosition
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
		
		/**
		 * @inheritDoc
		 */
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
			registrationPoint = popUp.parent.globalToLocal(registrationPoint);
			return registrationPoint;
		}
		
		/**
		 * 正在播放动画的标志
		 */		
		private var inAnimation:Boolean = false;
		
		private var _animator:Animation = null;
		/**
		 * 动画类实例
		 */		
		private function get animator():Animation
		{
			if (_animator)
				return _animator;
			_animator = new Animation(animationUpdateHandler);
			_animator.endFunction = animationEndHandler;
			_animator.startFunction = animationStartHandler;
			return _animator;
		}
		
		private var _openDuration:Number = 250;
		/**
		 * 窗口弹出的动画时间(以毫秒为单位)，设置为0则直接弹出窗口而不播放动画效果。默认值250。
		 */
		public function get openDuration():Number
		{
			return _openDuration;
		}
		
		public function set openDuration(value:Number):void
		{
			_openDuration = value;
		}
		
		private var _closeDuration:Number = 150;
		/**
		 * 窗口关闭的动画时间(以毫秒为单位)，设置为0则直接关闭窗口而不播放动画效果。默认值150。
		 */
		public function get closeDuration():Number
		{
			return _closeDuration;
		}

		public function set closeDuration(value:Number):void
		{
			_closeDuration = value;
		}

		/**
		 * 动画开始播放触发的函数
		 */		
		private function animationStartHandler(animation:Animation):void
		{
			inAnimation = true;
			popUp.addEventListener("scrollRectChange",onScrollRectChange);
			if(popUp is IUIComponent)
				IUIComponent(popUp).enabled = false;
		}
		/**
		 * 防止外部修改popUp的scrollRect属性
		 */		
		private function onScrollRectChange(event:Event):void
		{
			if(inUpdating)
				return;
			inUpdating = true;
			(popUp as DisplayObject).scrollRect = new Rectangle(Math.round(animator.currentValue["x"]),
				Math.round(animator.currentValue["y"]),popUp.width, popUp.height);
			inUpdating = false;
		}
		
		private var inUpdating:Boolean = false;
		/**
		 * 动画播放过程中触发的更新数值函数
		 */		
		private function animationUpdateHandler(animation:Animation):void
		{
			inUpdating = true;
			(popUp as DisplayObject).scrollRect = new Rectangle(Math.round(animation.currentValue["x"]),
				Math.round(animation.currentValue["y"]),popUp.width, popUp.height);
			inUpdating = false;
		}
		
		/**
		 * 动画播放完成触发的函数
		 */		
		private function animationEndHandler(animation:Animation):void
		{
			inAnimation = false;
			popUp.removeEventListener("scrollRectChange",onScrollRectChange);
			if(popUp is IUIComponent)
				IUIComponent(popUp).enabled = true;
			DisplayObject(popUp).scrollRect = null;
			if(!popUpIsDisplayed)
			{
				PopUpManager.removePopUp(popUp);
				popUp.ownerChanged(null);
			}
		}
		
		/**
		 * 添加或移除popUp
		 */		
		private function addOrRemovePopUp():void
		{
			if (!addedToStage||!popUp)
				return;
			
			if (popUp.parent == null && displayPopUp)
			{
				PopUpManager.addPopUp(popUp,false,false,systemManager);
				popUp.ownerChanged(this);
				popUpIsDisplayed = true;
				if(inAnimation)
					animator.end();
				if(initialized)
				{
					applyPopUpTransform(width, height);
					if(_openDuration>0)
						startAnimation();
				}
				else
				{
					callLater(function():void{
						if(_openDuration>0)
							startAnimation();
					});
				}
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
			if(inAnimation)
				animator.end();
			popUpIsDisplayed = false;
			if(_closeDuration>0)
			{
				startAnimation();
			}
			else
			{
				PopUpManager.removePopUp(popUp);
				popUp.ownerChanged(null);
			}
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
			if (popUpHeightMatchesAnchorHeight)
				popUp.height = unscaledHeight;
			if(popUp is IInvalidating)
				(popUp as IInvalidating).validateNow();
			var popUpPoint:Point = calculatePopUpPosition();
			popUp.x = popUpPoint.x;
			popUp.y = popUpPoint.y;
		}
		/**
		 * 开始播放动画
		 */		
		private function startAnimation():void
		{
			animator.motionPaths = createMotionPath();
			if(popUpIsDisplayed)
			{
				animator.duration = _openDuration;
			}
			else
			{
				animator.duration = _closeDuration;
			}
			animator.play();
		}
		
		private var valueRange:Number = 1;
		/**
		 * 创建动画轨迹
		 */		
		private function createMotionPath():Vector.<MotionPath>
		{
			var xPath:MotionPath = new MotionPath("x");
			var yPath:MotionPath = new MotionPath("y");
			var path:Vector.<MotionPath> = new <MotionPath>[xPath,yPath];
			switch(_popUpPosition)
			{
				case PopUpPosition.TOP_LEFT:
				case PopUpPosition.CENTER:
				case PopUpPosition.BELOW:
					xPath.valueFrom = xPath.valueTo = 0;
					yPath.valueFrom = popUp.height;
					yPath.valueTo = 0;
					valueRange = popUp.height;
					break;
				case PopUpPosition.ABOVE:
					xPath.valueFrom = xPath.valueTo = 0;
					yPath.valueFrom = -popUp.height;
					yPath.valueTo = 0;
					valueRange = popUp.height;
					break;
				case PopUpPosition.LEFT:
					yPath.valueFrom = yPath.valueTo = 0;
					xPath.valueFrom = -popUp.width;
					xPath.valueTo = 0;
					valueRange = popUp.width;
					break;
				case PopUpPosition.RIGHT:
					yPath.valueFrom = yPath.valueTo = 0;
					xPath.valueFrom = popUp.width;
					xPath.valueTo = 0;
					valueRange = popUp.width;
					break;    
				default:
					valueRange = 1;
					break;
			}
			valueRange = Math.abs(valueRange);
			if(!popUpIsDisplayed)
			{
				var tempValue:Number = xPath.valueFrom;
				xPath.valueFrom = xPath.valueTo;
				xPath.valueTo = tempValue;
				tempValue = yPath.valueFrom;
				yPath.valueFrom = yPath.valueTo;
				yPath.valueTo = tempValue;
			}
			return path;
		}
		/**
		 * 添加到舞台事件
		 */		
		private function addedToStageHandler(event:Event):void
		{
			addedToStage = true;
			callLater(checkPopUpState);
		}
		
		/**
		 * 延迟检查弹出状态，防止堆栈溢出。
		 */		
		private function checkPopUpState():void
		{
			if(addedToStage)
			{
				addOrRemovePopUp();    
			}
			else
			{
				if (popUp != null && DisplayObject(popUp).parent != null)
					removeAndResetPopUp();
			}
		}
		
		/**
		 * 从舞台移除事件
		 */		
		private function removedFromStageHandler(event:Event):void
		{
			addedToStage = false;
			callLater(checkPopUpState);
		}
		
	}
}
