<<<<<<< HEAD
package org.flexlite.domUI.skins
{
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.StateChangeEvent;
	import org.flexlite.domUI.states.State;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 当前视图状态已经改变 
	 */	
	[Event(name="currentStateChange", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * 当前视图状态即将改变 
	 */	
	[Event(name="currentStateChanging", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * Spark主题皮肤默认基类。含有复杂视图状态切换功能,提供给含有绘图元素的DXML代码使用。
	 * @see org.flexlite.domUI.states.State
	 * @author DOM
	 */
	public class SparkSkin extends Skin
	{
		public function SparkSkin()
		{
			super();
		}
		
		/**
		 * 存储还未验证的视图状态 
		 */		
		private var requestedCurrentState:String;
		
		override public function get currentState():String
		{
			return currentStateChanged ? requestedCurrentState : _currentState;
		}
		
		override public function set currentState(value:String):void
		{
			setCurrentState(value);
		}
		
		/**
		 * 设置当前视图状态
		 */		
		private function setCurrentState(stateName:String):void
		{
			stateName = isBaseState(stateName) ? getDefaultState() : stateName;
			
			if (stateName != currentState &&
				!(isBaseState(stateName) && isBaseState(currentState)))
			{
				requestedCurrentState = stateName;
				if (initialized||hasParent)
				{
					commitCurrentState();
					if(hostComponent)
					{
						hostComponent.findSkinParts();
					}
				}
				else
				{
					currentStateChanged = true;
					invalidateProperties();
				}
			}
		}
		
		override public function hasState(stateName:String):Boolean
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
		
		override protected function commitCurrentState():void
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
=======
package org.flexlite.domUI.skins
{
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.StateChangeEvent;
	import org.flexlite.domUI.states.State;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 当前视图状态已经改变 
	 */	
	[Event(name="currentStateChange", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * 当前视图状态即将改变 
	 */	
	[Event(name="currentStateChanging", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * Spark主题皮肤默认基类。含有复杂视图状态切换功能,提供给含有绘图元素的DXML代码使用。
	 * @see org.flexlite.domUI.states.State
	 * @author DOM
	 */
	public class SparkSkin extends Skin
	{
		public function SparkSkin()
		{
			super();
		}
		
		/**
		 * 存储还未验证的视图状态 
		 */		
		private var requestedCurrentState:String;
		
		override public function get currentState():String
		{
			return currentStateChanged ? requestedCurrentState : _currentState;
		}
		
		override public function set currentState(value:String):void
		{
			setCurrentState(value);
		}
		
		/**
		 * 设置当前视图状态
		 */		
		private function setCurrentState(stateName:String):void
		{
			stateName = isBaseState(stateName) ? getDefaultState() : stateName;
			
			if (stateName != currentState &&
				!(isBaseState(stateName) && isBaseState(currentState)))
			{
				requestedCurrentState = stateName;
				if (initialized||hasParent)
				{
					commitCurrentState();
					if(hostComponent)
					{
						hostComponent.findSkinParts();
					}
				}
				else
				{
					currentStateChanged = true;
					invalidateProperties();
				}
			}
		}
		
		override public function hasState(stateName:String):Boolean
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
		
		override protected function commitCurrentState():void
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
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}