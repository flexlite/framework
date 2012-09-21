package org.flexlite.domUI.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import org.flexlite.domUI.events.MoveEvent;
	import org.flexlite.domUI.events.PropertyChangeEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.ILayoutManagerClient;
	import org.flexlite.domUI.managers.IToolTipManagerClient;
	import org.flexlite.domUI.managers.ToolTipManager;
	
	use namespace dx_internal;
	
	/**
	 * 组件尺寸发生改变 
	 */	
	[Event(name="resize", type="org.flexlite.domUI.events.ResizeEvent")]
	/**
	 * 组件位置发生改变 
	 */	
	[Event(name="move", type="org.flexlite.domUI.events.MoveEvent")]
	/**
	 * 组件开始初始化
	 */	
	[Event(name="initialize", type="org.flexlite.domUI.events.UIEvent")]
	
	/**
	 * 组件创建完成 
	 */	
	[Event(name="creationComplete", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 组件的一次三个延迟验证渲染阶段全部完成 
	 */	
	[Event(name="updateComplete", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="false")]
	
	/**
	 * 显示对象基类
	 * @author DOM
	 */
	public class UIComponent extends Sprite 
		implements IUIComponent,ILayoutManagerClient,ILayoutElement,IInvalidating,IVisualElement,IToolTipManagerClient
	{
		public function UIComponent()
		{
			super();
			if(DomGlobals.stage==null)
			{
				if(stage)
				{
					_hasParent = true;
					onAddedToStage();
				}
				else
				{
					addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
				}
			}
			addEventListener(Event.ADDED,onAdded);
		}
		
		private var _id:String;
		/**
		 * 组件 ID。此值将作为对象的实例名称，因此不应包含任何空格或特殊字符。应用程序中的每个组件都应具有唯一的 ID。 
		 */		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		private var _toolTip:Object;
		
		public function get toolTip():Object
		{
			return _toolTip;
		}
		public function set toolTip(value:Object):void
		{
			if(value==_toolTip)
				return;
			var oldValue:Object = _toolTip;
			_toolTip = value;
			
			ToolTipManager.registerToolTip(this, oldValue, value);
			
			dispatchEvent(new Event("toolTipChanged"));
		}
		
		private var _toolTipClass:Class;
		
		public function get toolTipClass():Class
		{
			return _toolTipClass;
		}
		public function set toolTipClass(value:Class):void
		{
			if(value==_toolTipClass)
				return;
			_toolTipClass = value;
		}
		
		private var _toolTipOffset:Point;
		
		public function get toolTipOffset():Point
		{
			return _toolTipOffset;
		}
		
		public function set toolTipOffset(value:Point):void
		{
			_toolTipOffset = value;
		}
		
		private var _toolTipPosition:String = "mouse";

		public function get toolTipPosition():String
		{
			return _toolTipPosition;
		}

		public function set toolTipPosition(value:String):void
		{
			_toolTipPosition = value;
		}

		private var _isPopUp:Boolean;
		
		public function get isPopUp():Boolean
		{
			return _isPopUp;
		}
		public function set isPopUp(value:Boolean):void
		{
			_isPopUp = value;
		}
		
		private var _owner:DisplayObjectContainer;
		
		public function get owner():DisplayObjectContainer
		{
			return _owner ? _owner : parent;
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
			_owner = value;
		}
		
		private var _hasParent:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#hasParent
		 */
		public function get hasParent():Boolean
		{
			return _hasParent||parent!=null;
		}
		/**
		 * 添加到舞台
		 */		
		private function onAddedToStage(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			DomGlobals.initlize(stage);
			checkInvalidateFlag();
			addRenderListener();
		}
		/**
		 * 被添加到显示列表时
		 */		
		private function onAdded(event:Event):void
		{
			if(event.target==this)
			{
				removeEventListener(Event.ADDED,onAdded);
				addEventListener(Event.REMOVED,onRemoved);
				_hasParent = true;
				checkInvalidateFlag();
				initialize();
				addRenderListener();
			}
		}		
		
		/**
		 * 从显示列表移除时
		 */		
		private function onRemoved(event:Event):void
		{
			if(event.target==this)
			{
				removeEventListener(Event.REMOVED,onRemoved);
				addEventListener(Event.ADDED,onAdded);
				_nestLevel = 0;
				_hasParent = false;
			}
		}
		
		private var _updateCompletePendingFlag:Boolean = false;
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#updateCompletePendingFlag
		 */		
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}		
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			_updateCompletePendingFlag = value;
		}
		
		private var _initialized:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#initialized
		 */
		public function get initialized():Boolean
		{
			return _initialized;
		}
		public function set initialized(value:Boolean):void
		{
			_initialized = value;
			if (value)
			{
				dispatchEvent(new UIEvent(UIEvent.CREATION_COMPLETE));
			}
		}
		/**
		 * 初始化组件
		 */
		private function initialize():void
		{
			if (initialized)
				return;
			dispatchEvent(new UIEvent(UIEvent.INITIALIZE));
			createChildren();
			childrenCreated();
		}
		/**
		 * 创建子项,子类覆盖此方法以完成组件子项的初始化操作，
		 * 请务必调用super.createChildren()以完成父类组件的初始化
		 */		
		protected function createChildren():void
		{
			
		}		
		/**
		 * 子项创建完成
		 */		
		protected function childrenCreated():void
		{
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _nestLevel:int = 0;
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#nestLevel
		 */		
		public function get nestLevel():int
		{
			return _nestLevel;
		}
		
		public function set nestLevel(value:int):void
		{
			_nestLevel = value;
			for(var i:int=numChildren-1;i>=0;i--)
			{
				var child:ILayoutManagerClient = getChildAt(i) as ILayoutManagerClient;
				if(child!=null)
				{
					child.nestLevel = _nestLevel+1;
				}
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child is ILayoutManagerClient)
			{
				(child as ILayoutManagerClient).nestLevel = _nestLevel+1;
			}
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is ILayoutManagerClient)
			{
				(child as ILayoutManagerClient).nestLevel = _nestLevel+1;
			}
			return super.addChildAt(child,index);
		}
		
		/**
		 * 检查属性失效标记并应用
		 */		
		private function checkInvalidateFlag():void
		{
			if(DomGlobals.layoutManager==null)
				return;
			if(invalidatePropertiesFlag)
			{
				DomGlobals.layoutManager.invalidateProperties(this);
			}
			if(invalidateSizeFlag)
			{
				DomGlobals.layoutManager.invalidateSize(this);
			}
			if(invalidateDisplayListFlag)
			{
				DomGlobals.layoutManager.invalidateDisplayList(this);
			}
			if(validateNowFlag)
			{
				DomGlobals.layoutManager.validateClient(this);
				validateNowFlag = false;
			}
		}
		
		override public function get doubleClickEnabled():Boolean
		{
			return super.doubleClickEnabled;
		}
		
		override public function set doubleClickEnabled(value:Boolean):void
		{
			super.doubleClickEnabled = value;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:InteractiveObject = getChildAt(i) as InteractiveObject;
				if (child)
					child.doubleClickEnabled = value;
			}
		}
		
		/**
		 * enabled禁用时记录的mouseChildre值 
		 */		
		private var oldMouseChilren:Boolean = true;
		
		/**
		 * @copy flash.display.DisplayObjectContainer#mouseChildren
		 */		
		override public function set mouseChildren(enable:Boolean):void
		{
			if(_enabled)
			{
				super.mouseChildren = enable;
			}
			else
			{
				oldMouseChilren = enable;
			}
		}
		
		private var _enabled:Boolean = true;
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)
				return;
			
			_enabled = value;
			mouseEnabled = value;
			if(value)
			{
				super.mouseChildren = oldMouseChilren;
			}
			else
			{
				oldMouseChilren = super.mouseChildren;
				super.mouseChildren = false;
			}
			invalidateDisplayList();
			
			dispatchEvent(new Event("enabledChanged"));
		}
		
		/**
		 * 属性提交前组件旧的宽度
		 */	
		dx_internal var oldWidth:Number;
			
		private var _explicitWidth:Number = NaN;

		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		
		dx_internal var _width:Number;
		/**
		 * 组件宽度,默认值为NaN,设置为NaN将使用组件的measure()方法自动计算尺寸
		 */		
		override public function set width(value:Number):void
		{
			if(_width==value&&_explicitWidth==value)
				return;
			_width = value;
			_explicitWidth = value;
			invalidateProperties();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
			if(isNaN(value))
				invalidateSize();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		
		/**
		 * 属性提交前组件旧的高度
		 */
		dx_internal var oldHeight:Number;
		
		private var _explicitHeight:Number = NaN;
				
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		
		dx_internal var _height:Number;
		/**
		 * 组件高度,默认值为NaN,设置为NaN将使用组件的measure()方法自动计算尺寸
		 */		
		override public function set height(value:Number):void
		{
			if(_height==value&&_explicitHeight==value)
				return;
			_height = value;
			_explicitHeight = value;
			invalidateProperties();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
			if(isNaN(value))
				invalidateSize();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set scaleX(value:Number):void
		{
			if(super.scaleX == value)
				return;
			super.scaleX = value;
			invalidateParentSizeAndDisplayList();
		}
		
		
		override public function set scaleY(value:Number):void
		{
			if(super.scaleY == value)
				return;
			super.scaleY = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _minWidth:Number = 0;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#minWidth
		 */
		public function get minWidth():Number
		{
			return _minWidth;
		}
		
		public function set minWidth(value:Number):void
		{
			if(_minWidth==value)
				return;
			_minWidth = value;
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _maxWidth:Number = 10000;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#maxWidth
		 */
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			if(_maxWidth==value)
				return;
			_maxWidth = value;
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		
		private var _minHeight:Number = 0;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#minHeight
		 */
		public function get minHeight():Number
		{
			return _minHeight;
		}
		
		public function set minHeight(value:Number):void
		{
			if(_minHeight==value)
				return;
			_minHeight = value;
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		private var _maxHeight:Number = 10000;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#maxHeight
		 */
		public function get maxHeight():Number
		{
			return _maxHeight;
		}
		
		public function set maxHeight(value:Number):void
		{
			if(_maxHeight==value)
				return;
			_maxHeight = value;
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		
		
		private var _measuredWidth:Number = 0;
		/**
		 * 组件的默认宽度（以像素为单位）。此值由 measure() 方法设置。
		 */		
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		
		private var _measuredHeight:Number = 0;
		/**
		 * 组件的默认高度（以像素为单位）。此值由 measure() 方法设置。
		 */
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		
		public function setActualSize(w:Number, h:Number):void
		{
			var change:Boolean = false;
			if(_width != w)
			{
				_width = w;
				change = true;
			}
			if(_height != h)
			{
				_height = h;
				change = true;
			}
			if(change)
			{
				invalidateDisplayList();
				dispatchResizeEvent();
			}
		}
		
		/**
		 * 属性提交前组件旧的X
		 */
		dx_internal var oldX:Number;
		
		override public function set x(value:Number):void
		{
			if(x==value)
				return;
			super.x = value;
			invalidateProperties();
			if (_includeInLayout&&parent && parent is UIComponent)
				UIComponent(parent).childXYChanged();
		}
		
		/**
		 * 属性提交前组件旧的Y
		 */
		dx_internal var oldY:Number;
		
		override public function set y(value:Number):void
		{
			if(y==value)
				return;
			super.y = value;
			invalidateProperties();
			if (_includeInLayout&&parent && parent is UIComponent)
				UIComponent(parent).childXYChanged();
		}
		
		public function get invalidateFlag():Boolean
		{
			return invalidatePropertiesFlag||invalidateSizeFlag||invalidateDisplayListFlag;
		}
		
		dx_internal var invalidatePropertiesFlag:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.core.IInvalidating#invalidateProperties()
		 */		
		public function invalidateProperties():void
		{
			if (!invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = true;
				
				if (_hasParent&&DomGlobals.layoutManager)
					DomGlobals.layoutManager.invalidateProperties(this);
			}
		}
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#validateProperties()
		 */		
		public function validateProperties():void
		{
			if (invalidatePropertiesFlag)
			{
				commitProperties();
				
				invalidatePropertiesFlag = false;
			}
		}
		
		dx_internal var invalidateSizeFlag:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.core.IInvalidating#invalidateSize()
		 */		
		public function invalidateSize():void
		{
			if (!invalidateSizeFlag)
			{
				invalidateSizeFlag = true;
				
				if (_hasParent&&DomGlobals.layoutManager)
					DomGlobals.layoutManager.invalidateSize(this);
			}
		}
		
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#validateSize()
		 */		
		public function validateSize(recursive:Boolean = false):void
		{
			if (recursive)
			{
				for (var i:int = 0; i < numChildren; i++)
				{
					var child:DisplayObject = getChildAt(i);
					if (child is ILayoutManagerClient )
						(child as ILayoutManagerClient ).validateSize(true);
				}
			}
			if (invalidateSizeFlag)
			{
				var changed:Boolean = measureSizes();
				if(changed)
				{
					invalidateDisplayList();
					invalidateParentSizeAndDisplayList();
				}
				invalidateSizeFlag = false;
			}
		}
		/**
		 * 上一次测量的首选宽度
		 */		
		private var oldPreferWidth:Number;
		/**
		 * 上一次测量的首选高度
		 */		
		private var oldPreferHeight:Number;
		/**
		 * 测量组件尺寸，返回尺寸是否发生变化
		 */		
		private function measureSizes():Boolean
		{
			var changed:Boolean = false;
			
			if (!invalidateSizeFlag)
				return changed;
			
			if (!canSkipMeasurement())
			{
				measure();
				if(measuredWidth<minWidth)
				{
					measuredWidth = minWidth;
				}
				if(measuredWidth>maxWidth)
				{
					measuredWidth = maxWidth;
				}
				if(measuredHeight<minHeight)
				{
					measuredHeight = minHeight;
				}
				if(measuredHeight>maxHeight)
				{
					measuredHeight = maxHeight
				}
			}
			if(isNaN(oldPreferWidth))
			{
				oldPreferWidth = preferredWidth;
				oldPreferHeight = preferredHeight;
				changed = true;
			}
			else
			{
				if(preferredWidth!=oldPreferWidth||preferredHeight!=oldPreferHeight)
					changed = true;
				oldPreferWidth = preferredWidth;
				oldPreferHeight = preferredHeight;
			}
			return changed;
		}
		
		dx_internal var invalidateDisplayListFlag:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.core.IInvalidating#invalidateDisplayList()
		 */		
		public function invalidateDisplayList():void
		{
			if (!invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = true;
				
				if (_hasParent&&DomGlobals.layoutManager)
					DomGlobals.layoutManager.invalidateDisplayList(this);
			}
		}
		
		/**
		 * @copy org.flexlite.domUI.managers.ILayoutManagerClient#validateDisplayList()
		 */		
		public function validateDisplayList():void
		{
			if (invalidateDisplayListFlag)
			{
				var unscaledWidth:Number = 0;
				var unscaledHeight:Number = 0;
				if(layoutWidthExplicitlySet)
				{
					unscaledWidth = _width;
				}
				else if(!isNaN(explicitWidth))
				{
					unscaledWidth = _explicitWidth;
				}
				else
				{
					unscaledWidth = measuredWidth;
				}
				if(layoutHeightExplicitlySet)
				{
					unscaledHeight = _height;
				}
				else if(!isNaN(explicitHeight))
				{
					unscaledHeight = _explicitHeight;
				}
				else
				{
					unscaledHeight = measuredHeight;
				}
				if(isNaN(unscaledWidth))
					unscaledWidth = 0;
				if(isNaN(unscaledHeight))
					unscaledHeight = 0;
				setActualSize(unscaledWidth,unscaledHeight);
				updateDisplayList(unscaledWidth,unscaledHeight);
				invalidateDisplayListFlag = false;
			}
		}
		
		dx_internal var validateNowFlag:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.core.IInvalidating#validateNow()
		 */		
		public function validateNow(skipDisplayList:Boolean = false):void
		{
			if(!validateNowFlag&&DomGlobals.layoutManager!=null)
				DomGlobals.layoutManager.validateClient(this,skipDisplayList);
			else
				validateNowFlag = true;
		}
		/**
		 * 标记父级容器的尺寸和显示列表为失效
		 */		
		protected function invalidateParentSizeAndDisplayList():void
		{
			if (!_hasParent||!_includeInLayout)
				return;
			var p:IInvalidating = parent as IInvalidating;
			if (!p)
				return;
			p.invalidateSize();
			p.invalidateDisplayList();
		}
		
		/**
		 * 更新显式列表
		 */		
		protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
		}
		
		/**
		 * 是否可以跳过测量尺寸阶段,返回true则不执行measure()方法
		 */		
		protected function canSkipMeasurement():Boolean
		{
			return !isNaN(_explicitWidth) && !isNaN(_explicitHeight);
		}
		
		/**
		 * 提交属性，子类在调用完invalidateProperties()方法后，应覆盖此方法以应用属性
		 */		
		protected function commitProperties():void
		{
			if(oldWidth != _width||oldHeight != _height)
			{
				dispatchResizeEvent();
			}
			if(oldX != x||oldY != y)
			{
				dispatchMoveEvent();
			}
		}
		/**
		 * 测量组件尺寸
		 */		
		protected function measure():void
		{
			_measuredHeight = 0;
			_measuredWidth = 0;
		}
		/**
		 *  抛出移动事件
		 */
		private function dispatchMoveEvent():void
		{
			if (hasEventListener(MoveEvent.MOVE))
			{
				var moveEvent:MoveEvent = new MoveEvent(MoveEvent.MOVE,oldX,oldY);
				dispatchEvent(moveEvent);
			}
			oldX = x;
			oldY = y;
		}
		
		/**
		 * 子项的xy位置发生改变
		 */		
		dx_internal function childXYChanged():void
		{
			
		}
		
		/**
		 *  抛出尺寸改变事件
		 */
		private function dispatchResizeEvent():void
		{
			if (hasEventListener(ResizeEvent.RESIZE))
			{
				var resizeEvent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE,oldWidth,oldHeight);
				dispatchEvent(resizeEvent);
			}
			oldWidth = _width;
			oldHeight = _height;
		}
		
		/**
		 * 抛出属性值改变事件
		 * @param prop 改变的属性名
		 * @param oldValue 属性的原始值
		 * @param value 属性的新值
		 */		
		protected function dispatchPropertyChangeEvent(prop:String, oldValue:*,
													   value:*):void
		{
			if (hasEventListener("propertyChange"))
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(
					this, prop, oldValue, value));
		}
		
		private var _includeInLayout:Boolean = true;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#includeInLayout
		 */
		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}
		public function set includeInLayout(value:Boolean):void
		{
			if(_includeInLayout==value)
				return;
			_includeInLayout = true;
			invalidateParentSizeAndDisplayList();
			_includeInLayout = value;
		}

		
		private var _left:Number;
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#left
		 */
		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
			if(_left == value)
				return;
			_left = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _right:Number;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#right
		 */
		public function get right():Number
		{
			return _right;
		}
		public function set right(value:Number):void
		{
			if(_right == value)
				return;
			_right = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _top:Number;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#top
		 */
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
			if(_top == value)
				return;
			_top = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _bottom:Number;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#bottom
		 */	
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom(value:Number):void
		{
			if(_bottom == value)
				return;
			_bottom = value;
			invalidateParentSizeAndDisplayList();
		}
		
		
		private var _horizontalCenter:Number;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#horizontalCenter
		 */
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		public function set horizontalCenter(value:Number):void
		{
			if(_horizontalCenter == value)
				return;
			_horizontalCenter = value;
			invalidateParentSizeAndDisplayList();
		}
		
		private var _verticalCenter:Number;
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#verticalCenter
		 */
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		public function set verticalCenter(value:Number):void
		{
			if(_verticalCenter == value)
				return;
			_verticalCenter = value;
			invalidateParentSizeAndDisplayList();
		}
		
		
		private var _percentWidth:Number;
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#percentWidth
		 */
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		public function set percentWidth(value:Number):void
		{
			if(_percentWidth == value)
				return;
			_percentWidth = value;
			invalidateParentSizeAndDisplayList();
		}
		
		
		private var _percentHeight:Number;
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#percentHeight
		 */
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		public function set percentHeight(value:Number):void
		{
			if(_percentHeight == value)
				return;
			_percentHeight = value;
			invalidateParentSizeAndDisplayList();
		}
		
		/**
		 * 父级布局管理器设置了组件的宽度标志，尺寸设置优先级：自动布局>显式设置>自动测量
		 */
		dx_internal var layoutWidthExplicitlySet:Boolean = false;
		
		/**
		 * 父级布局管理器设置了组件的高度标志，尺寸设置优先级：自动布局>显式设置>自动测量
		 */
		dx_internal var layoutHeightExplicitlySet:Boolean = false;
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#setLayoutBoundsSize()
		 */		
		public function setLayoutBoundsSize(layoutWidth:Number,layoutHeight:Number):void
		{
			layoutWidth /= scaleX;
			layoutHeight /= scaleY;
			if(isNaN(layoutWidth))
			{
				layoutWidthExplicitlySet = false;
				layoutWidth = preferredWidth;
			}
			else
			{
				layoutWidthExplicitlySet = true;
			}
			if(isNaN(layoutHeight))
			{
				layoutHeightExplicitlySet = false;
				layoutHeight = preferredHeight;
			}
			else
			{
				layoutHeightExplicitlySet = true;
			}
			
			setActualSize(layoutWidth,layoutHeight);
		}
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#setLayoutBoundsPosition()
		 */		
		public function setLayoutBoundsPosition(x:Number,y:Number):void
		{
			var changed:Boolean = false;
			if(this.x!=x)
			{
				super.x = x;
				changed = true;
			}
			if(this.y!=y)
			{
				super.y = y;
				changed = true;
			}
			if(changed)
			{
				dispatchMoveEvent();
			}
		}
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#preferredWidth
		 */		
		public function get preferredWidth():Number
		{
			var w:Number = isNaN(_explicitWidth) ? measuredWidth:_explicitWidth;
			if(isNaN(w))
				return 0;
			return w*scaleX;
		}
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#preferredHeight
		 */
		public function get preferredHeight():Number
		{
			var h:Number = isNaN(_explicitHeight) ? measuredHeight : _explicitHeight;
			if(isNaN(h))
				return 0;
			return h*scaleY;
		}
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#preferredX
		 */		
		public function get preferredX():Number
		{
			return super.x;
		}
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#preferredY
		 */
		public function get preferredY():Number
		{
			return super.y;
		}
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#layoutBoundsX
		 */	
		public function get layoutBoundsX():Number
		{
			return super.x;
		}
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#layoutBoundsY
		 */	
		public function get layoutBoundsY():Number
		{
			return super.y;
		}
		
		/**
		 * @copy org.flexlite.domUI.core.ILayoutElement#layoutBoundsWidth
		 */		
		public function get layoutBoundsWidth():Number
		{
			var w:Number =  0;
			if(layoutWidthExplicitlySet)
			{
				w = _width;
			}
			else if(!isNaN(explicitWidth))
			{
				w = _explicitWidth;
			}
			else
			{
				w = measuredWidth;
			}
			if(isNaN(w))
				return 0;
			return w*scaleX;
		}
		/**
		 * 组件的布局高度,常用于父级的updateDisplayList()方法中
		 * 按照：布局高度>外部显式设置高度>测量高度 的优先级顺序返回高度
		 */		
		public function get layoutBoundsHeight():Number
		{
			var h:Number =  0
			if(layoutHeightExplicitlySet)
			{
				h = _height;
			}
			else if(!isNaN(explicitHeight))
			{
				h = _explicitHeight;
			}
			else
			{
				h = measuredHeight;
			}
			if(isNaN(h))
				return 0;
			return h*scaleY;
		}
		
		/**
		 * 设置当前组件为焦点对象
		 */		
		public function setFocus():void
		{
			if(DomGlobals.stage!=null)
			{
				DomGlobals.stage.focus = this;
			}
		}
		
		/**
		 * 全局多语言字符串翻译 
		 * 使用这个方法需要在程序初始化时手动用DomGlobals.setLanguageManager()注入一个管理器处理实例
		 * @param resourceName 文字索引，如果库中找不到这个索引则直接使用resourceName
		 * @param parameters 替换的参数，用于替换{}中的内容
		 */		
		public static function tr(resourceName:String,parameters:Array = null):String
		{
			if(DomGlobals.languageManager != null)
			{
				return DomGlobals.languageManager.getText(resourceName,parameters);
			}
			return resourceName;
		}
		
		
		/**
		 * 延迟函数队列 
		 */		
		private var methodQueue:Vector.<MethodQueueElement>;
		/**
		 * 是否添加过事件监听标志 
		 */		
		private var listeningForRender:Boolean = false;
		/**
		 * 为callLater()添加 事件监听
		 */		
		private function addRenderListener():void
		{
			if(!listeningForRender&&methodQueue&&methodQueue.length>0
				&&DomGlobals.stage&&_hasParent)
			{
				DomGlobals.layoutManager.addEventListener(UIEvent.UPDATE_COMPLETE,onCallBack);
				listeningForRender = true;
			}
		}
		
		/**
		 * 延迟函数到下一次组件重绘后执行。由于组件使用了延迟渲染的优化机制，
		 * 在改变组件某些属性后，并不立即应用，而是延迟一帧统一处理，避免了重复的渲染。
		 * 若组件的某些属性会影响到它的尺寸位置，在属性发生改变后，请调用此方法,
		 * 延迟执行函数以获取正确的组件尺寸位置。
		 * @param method 要延迟执行的函数
		 * @param args 函数参数列表
		 */		
		public function callLater(method:Function,args:Array=null):void
		{
			var p:IInvalidating = parent as IInvalidating;
			var parentInvalidateFlag:Boolean = p&&p.invalidateFlag;
			if(invalidateFlag||parentInvalidateFlag||!initialized)
			{
				if(methodQueue==null)
				{
					methodQueue = new Vector.<MethodQueueElement>();
				}
				methodQueue.push(new MethodQueueElement(method,args));
				addRenderListener();
				return;
			}
			if(args==null)
			{
				method();
			}
			else
			{
				method.apply(null,args);
			}
		}
		/**
		 * 执行延迟函数
		 */		
		private function onCallBack(event:Event):void
		{
			DomGlobals.layoutManager.removeEventListener(UIEvent.UPDATE_COMPLETE,onCallBack);
			listeningForRender = false;
			var queue:Vector.<MethodQueueElement> = methodQueue;
			if(!queue||queue.length==0)
				return;
			methodQueue = null;
			for each(var element:MethodQueueElement in queue)
			{
				if(element.args==null)
				{
					element.method();
				}
				else
				{
					element.method.apply(null,element.args);
				}
			}
		}
		
	}
}
/**
 *  延迟执行函数元素
 */
class MethodQueueElement
{
	
	public function MethodQueueElement(method:Function,args:Array = null)
	{
		this.method = method;
		this.args = args;
	}
	
	public var method:Function;
	
	public var args:Array;
}
