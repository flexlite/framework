package org.flexlite.domUI.skins
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.StateChangeEvent;
	import org.flexlite.domUI.states.State;
	
	use namespace dx_internal;
	
	/**
	 * 元素添加事件
	 */	
	[Event(name="elementAdd", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	/**
	 * 元素移除事件 
	 */	
	[Event(name="elementRemove", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	
	/**
	 * 当前视图状态已经改变 
	 */	
	[Event(name="currentStateChange", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * 当前视图状态即将改变 
	 */	
	[Event(name="currentStateChanging", type="org.flexlite.domUI.events.StateChangeEvent")]
	
	[DXML(show="false")]
	
	[DefaultProperty(name="elementsContent",array="true")]
	
	/**
	 * 含有视图状态功能的皮肤基类。注意：为了减少嵌套层级，此皮肤没有继承显示对象，若需要显示对象版本皮肤，请使用Skin。
	 * @see org.flexlite.domUI.components.supportClasses.Skin
	 * @author DOM
	 */
	public class StateSkin extends EventDispatcher 
		implements IContainer, ISkin, IStateClient
	{
		/**
		 * 构造函数
		 */		
		public function StateSkin()
		{
			super();
		}
		
		/**
		 * 主机组件的最小测量宽度。默认值为0。
		 * 注意：此属性仅在皮肤被附加到主机组件前设置，并且主机组件还没有被显式设置过minWidth时才有效。
		 */
		public var minWidth:Number = 0;
		/**
		 * 主机组件的最大测量宽度。默认值为10000。
		 * 注意：此属性仅在皮肤被附加到主机组件前设置，并且主机组件还没有被显式设置过maxWidth时才有效。
		 */
		public var maxWidth:Number = 10000;
		/**
		 * 组件的最小测量高度。默认值为0。
		 * 注意：此属性仅在皮肤被附加到主机组件前设置，并且主机组件还没有被显式设置过minHeight时才有效。
		 */
		public var minHeight:Number = 0;
		/**
		 * 主机组件的最大测量高度。默认值为10000。
		 * 注意：此属性仅在皮肤被附加到主机组件前设置，并且主机组件还没有被显式设置过maxHeight时才有效。
		 */
		public var maxHeight:Number = 10000;
		
		private var _hostComponent:SkinnableComponent;
		/**
		 * @inheritDoc
		 */
		public function get hostComponent():SkinnableComponent
		{
			return _hostComponent;
		}
		/**
		 * @inheritDoc
		 */
		public function set hostComponent(value:SkinnableComponent):void
		{
			if(_hostComponent==value)
				return;
			var i:int;
			if(_hostComponent)
			{
				for(i = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
			}
			
			_hostComponent = value;
			
			if(_hostComponent)
			{
				if(minWidth!=0&&_hostComponent.minWidth==0)
					_hostComponent.minWidth = minWidth;
				if(maxWidth!=10000&&_hostComponent.maxWidth==10000)
					_hostComponent.maxWidth = maxWidth;
				if(minHeight!=0&&_hostComponent.minHeight==0)
					_hostComponent.minHeight = minHeight;
				if(maxHeight!=10000&&_hostComponent.maxHeight==10000)
					_hostComponent.maxHeight = maxHeight;
				
				var n:int = _elementsContent.length;
				for (i = 0; i < n; i++)
				{   
					var elt:IVisualElement = _elementsContent[i];
					if (elt.parent is IVisualElementContainer)
						IVisualElementContainer(elt.parent).removeElement(elt);
					else if(elt.owner is IContainer)
						IContainer(elt.owner).removeElement(elt);
					elementAdded(elt, i);
				}
			}
			if (currentStateChanged)
			{
				currentStateChanged = false;
				commitCurrentState();
				_hostComponent.findSkinParts();
			}
		}
		
		private var _elementsContent:Array = [];
		/**
		 * 返回子元素列表
		 */		
		dx_internal function getElementsContent():Array
		{
			return _elementsContent;
		}
		
		/**
		 * 设置容器子对象数组 。数组包含要添加到容器的子项列表，之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器。
		 * 设置该属性时会对您输入的数组进行一次浅复制操作，所以您之后对该数组的操作不会影响到添加到容器的子项列表数量。
		 */		
		public function set elementsContent(value:Array):void
		{
			if(value==null)
				value = [];
			if(value==_elementsContent)
				return;
			if(_hostComponent)
			{
				var i:int;
				for (i = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
				
				_elementsContent = value.concat();
				
				var n:int = _elementsContent.length;
				for (i = 0; i < n; i++)
				{   
					var elt:IVisualElement = _elementsContent[i];
					
					if(elt.parent is IVisualElementContainer)
						IVisualElementContainer(elt.parent).removeElement(elt);
					else if(elt.owner is IContainer)
						IContainer(elt.owner).removeElement(elt);
					elementAdded(elt, i);
				}
			}
			else
			{
				_elementsContent = value.concat();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return _elementsContent.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			return _elementsContent[index];
		}
		
		private function checkForRangeError(index:int, addingElement:Boolean = false):void
		{
			var maxIndex:int = _elementsContent.length - 1;
			
			if (addingElement)
				maxIndex++;
			
			if (index < 0 || index > maxIndex)
				throw new RangeError("索引:\""+index+"\"超出可视元素索引范围");
		}
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			var index:int = numElements;
			
			if (element.owner == this)
				index = numElements-1;
			
			return addElementAt(element, index);
		}
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			checkForRangeError(index, true);
			
			var host:Object = element.owner; 
			if (host == this)
			{
				setElementIndex(element, index);
				return element;
			}
			else if (element.parent is IVisualElementContainer)
			{
				IVisualElementContainer(element.parent).removeElement(element);
			}
			else if(host is IContainer)
			{
				IContainer(host).removeElement(element);
			}
			
			_elementsContent.splice(index, 0, element);
			
			if(_hostComponent)
				elementAdded(element, index);
			
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return removeElementAt(getElementIndex(element));
		}
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			
			var element:IVisualElement = _elementsContent[index];
			
			if(_hostComponent)
				elementRemoved(element, index);
			
			_elementsContent.splice(index, 1);
			
			return element;
		}
			
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IVisualElement):int
		{
			return _elementsContent.indexOf(element);
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			checkForRangeError(index);
			
			var oldIndex:int = getElementIndex(element);
			if (oldIndex==-1||oldIndex == index)
				return;
			
			if(_hostComponent)
				elementRemoved(element, oldIndex, false);
			
			_elementsContent.splice(oldIndex, 1);
			_elementsContent.splice(index, 0, element);
			
			if(_hostComponent)
				elementAdded(element, index, false);
		}
		
		private var addToDisplayListAt:QName = new QName(dx_internal,"addToDisplayListAt");
		private var removeFromDisplayList:QName = new QName(dx_internal,"removeFromDisplayList");
		/**
		 * 添加一个显示元素到容器
		 */		
		dx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			if(element is DisplayObject)
				_hostComponent[addToDisplayListAt](DisplayObject(element), index);
			
			if (notifyListeners)
			{
				if (hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_ADD, false, false, element, index));
			}
			
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		/**
		 * 从容器移除一个显示元素
		 */		
		dx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			if (notifyListeners)
			{        
				if (hasEventListener(ElementExistenceEvent.ELEMENT_REMOVE))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_REMOVE, false, false, element, index));
			}
			
			var childDO:DisplayObject = element as DisplayObject; 
			if (childDO && childDO.parent == _hostComponent)
			{
				_hostComponent[removeFromDisplayList](element);
			}
			
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _states:Array = [];
		/**
		 * @inheritDoc
		 */
		public function get states():Array
		{
			return _states;
		}
		
		public function set states(value:Array):void
		{
			_states = value;
		}
		/**
		 * 当前视图状态发生改变 
		 */		
		private var currentStateChanged:Boolean;
		
		private var _currentState:String;
		/**
		 * 存储还未验证的视图状态 
		 */		
		private var requestedCurrentState:String;
		/**
		 * @inheritDoc
		 */
		public function get currentState():String
		{
			return currentStateChanged ? requestedCurrentState : _currentState;
		}
		
		public function set currentState(value:String):void
		{
			value = isBaseState(value) ? getDefaultState() : value;
			
			if (value != currentState &&
				!(isBaseState(value) && isBaseState(currentState)))
			{
				requestedCurrentState = value;
				if (_hostComponent)
				{
					currentStateChanged = false;
					commitCurrentState();
					_hostComponent.findSkinParts();
				}
				else
				{
					currentStateChanged = true;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasState(stateName:String):Boolean
		{
			return (getState(stateName, false) != null); 
		}
		
		/**
		 * 是否为基本状态
		 */		
		private function isBaseState(stateName:String):Boolean
		{
			return !stateName || stateName == "";
		}
		
		/**
		 * 返回默认状态
		 */		
		private function getDefaultState():String
		{
			return states.length > 0 ? states[0].name : null;
		}
		/**
		 * 应用当前的视图状态
		 */
		protected function commitCurrentState():void
		{
			var commonBaseState:String = findCommonBaseState(_currentState, requestedCurrentState);
			var event:StateChangeEvent;
			var oldState:String = _currentState ? _currentState : "";
			var destination:State = getState(requestedCurrentState);
			
			initializeState(requestedCurrentState);
			
			if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGING)) 
			{
				event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
				event.oldState = oldState;
				event.newState = requestedCurrentState ? requestedCurrentState : "";
				dispatchEvent(event);
			}
			
			removeState(_currentState, commonBaseState);
			_currentState = requestedCurrentState;
			
			if (!isBaseState(currentState)) 
			{
				applyState(_currentState, commonBaseState);
			}
			
			if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGE))
			{
				event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
				event.oldState = oldState;
				event.newState = _currentState ? _currentState : "";
				dispatchEvent(event);
			}
			
		}
		
		
		/**
		 * 通过名称返回视图状态
		 */		
		private function getState(stateName:String, throwOnUndefined:Boolean=true):State
		{
			if (!states || isBaseState(stateName))
				return null;
			
			for (var i:int = 0; i < states.length; i++)
			{
				if (states[i].name == stateName)
					return states[i];
			}
			
			if (throwOnUndefined)
			{
				throw new ArgumentError("组件上找不到指定的视图状态："+stateName);
			}
			return null;
		}
		
		/**
		 * 返回两个视图状态的共同父级状态
		 */		
		private function findCommonBaseState(state1:String, state2:String):String
		{
			var firstState:State = getState(state1);
			var secondState:State = getState(state2);
			
			if (!firstState || !secondState)
				return "";
			
			if (isBaseState(firstState.basedOn) && isBaseState(secondState.basedOn))
				return "";
			
			var firstBaseStates:Array = getBaseStates(firstState);
			var secondBaseStates:Array = getBaseStates(secondState);
			var commonBase:String = "";
			
			while (firstBaseStates[firstBaseStates.length - 1] ==
				secondBaseStates[secondBaseStates.length - 1])
			{
				commonBase = firstBaseStates.pop();
				secondBaseStates.pop();
				
				if (!firstBaseStates.length || !secondBaseStates.length)
					break;
			}
			
			if (firstBaseStates.length &&
				firstBaseStates[firstBaseStates.length - 1] == secondState.name)
			{
				commonBase = secondState.name;
			}
			else if (secondBaseStates.length &&
				secondBaseStates[secondBaseStates.length - 1] == firstState.name)
			{
				commonBase = firstState.name;
			}
			
			return commonBase;
		}
		
		/**
		 * 获取指定视图状态的所有父级状态列表
		 */		
		private function getBaseStates(state:State):Array
		{
			var baseStates:Array = [];
			
			while (state && state.basedOn)
			{
				baseStates.push(state.basedOn);
				state = getState(state.basedOn);
			}
			
			return baseStates;
		}
		
		/**
		 * 移除指定的视图状态以及所依赖的所有父级状态，除了与新状态的共同状态外
		 */		
		private function removeState(stateName:String, lastState:String):void
		{
			var state:State = getState(stateName);
			
			if (stateName == lastState)
				return;
			
			if (state)
			{
				state.dispatchExitState();
				
				var overrides:Array = state.overrides;
				
				for (var i:int = overrides.length; i; i--)
					overrides[i-1].remove(this);
				
				if (state.basedOn != lastState)
					removeState(state.basedOn, lastState);
			}
		}
		
		/**
		 * 应用新状态
		 */
		private function applyState(stateName:String, lastState:String):void
		{
			var state:State = getState(stateName);
			
			if (stateName == lastState)
				return;
			
			if (state)
			{
				if (state.basedOn != lastState)
					applyState(state.basedOn, lastState);
				
				var overrides:Array = state.overrides;
				
				for (var i:int = 0; i < overrides.length; i++)
					overrides[i].apply(this);
				
				state.dispatchEnterState();
			}
		}
		
		/**
		 * 初始化指定的视图状态以及其父级状态
		 */
		private function initializeState(stateName:String):void
		{
			var state:State = getState(stateName);
			
			while (state)
			{
				state.initialize();
				state = getState(state.basedOn);
			}
		}
	}
}