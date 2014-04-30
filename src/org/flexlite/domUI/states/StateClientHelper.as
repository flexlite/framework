package org.flexlite.domUI.states
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.events.StateChangeEvent;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * 视图状态组件辅助工具类
	 * @author DOM
	 */
	public class StateClientHelper
	{
		/**
		 * 构造函数
		 */		
		public function StateClientHelper(target:IStateClient)
		{
			this.target = target;
		}
		
		/**
		 * 具有视图状态功能的目标实例
		 */		
		private var target:IStateClient;
		
		private var _states:Array = [];
		/**
		 * 为此组件定义的视图状态。
		 */
		public function get states():Array
		{
			return _states;
		}
		public function set states(value:Array):void
		{
			if(_states == value)
				return;
			_states = value;
			_currentStateChanged = true;
			requestedCurrentState = _currentState;
			if(!hasState(requestedCurrentState))
			{
				requestedCurrentState = getDefaultState();
			}
		}


		private var _currentStateChanged:Boolean;
		/**
		 * 当前视图状态发生改变的标志
		 */
		public function get currentStateChanged():Boolean
		{
			return _currentStateChanged;
		}

		
		private var _currentState:String;
		/**
		 * 存储还未验证的视图状态 
		 */		
		private var requestedCurrentState:String;
		/**
		 * 组件的当前视图状态。将其设置为 "" 或 null 可将组件重置回其基本状态。 
		 */	
		public function get currentState():String
		{
			if(_currentStateChanged)
				return requestedCurrentState;
			return _currentState?_currentState:getDefaultState();
		}
		
		public function set currentState(value:String):void
		{
			if(!value)
				value = getDefaultState();
			if (value != currentState &&value&&currentState)
			{
				requestedCurrentState = value;
				_currentStateChanged = true;
			}
		}
		
		/**
		 * 返回是否含有指定名称的视图状态
		 * @param stateName 要检测的视图状态名称
		 */	
		public function hasState(stateName:String):Boolean
		{
			if(!_states)
				return false;
			if(_states[0] is String)
				return _states.indexOf(stateName)!=-1;
			return (getState(stateName) != null); 
		}
		
		/**
		 * 返回默认状态
		 */		
		private function getDefaultState():String
		{
			if(_states&&_states.length>0)
			{
				var state:* = _states[0];
				if(state is String)
					return state;
				return state.name;
			}
			return null;
		}
		/**
		 * 应用当前的视图状态
		 */
		public function commitCurrentState():void
		{
			if(!currentStateChanged)
				return;
			_currentStateChanged = false;
			if(states&&states[0] is String)
			{
				if(states.indexOf(requestedCurrentState)==-1)
					_currentState = getDefaultState();
				else
					_currentState = requestedCurrentState;
				return;
			}
			var destination:State = getState(requestedCurrentState);
			if(!destination)
			{
				requestedCurrentState = getDefaultState();
			}
			var commonBaseState:String = findCommonBaseState(_currentState, requestedCurrentState);
			var event:StateChangeEvent;
			var oldState:String = _currentState ? _currentState : "";
			if (target.hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGING)) 
			{
				event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
				event.oldState = oldState;
				event.newState = requestedCurrentState ? requestedCurrentState : "";
				target.dispatchEvent(event);
			}
			
			removeState(_currentState, commonBaseState);
			_currentState = requestedCurrentState;
			
			if (_currentState) 
			{
				applyState(_currentState, commonBaseState);
			}
			
			if (target.hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGE))
			{
				event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
				event.oldState = oldState;
				event.newState = _currentState ? _currentState : "";
				target.dispatchEvent(event);
			}
			
		}
		
		
		/**
		 * 通过名称返回视图状态
		 */		
		private function getState(stateName:String):State
		{
			if (!_states || !stateName)
				return null;
			
			for (var i:int = 0; i < _states.length; i++)
			{
				if (_states[i].name == stateName)
					return _states[i];
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
			
			if (!firstState.basedOn && !secondState.basedOn)
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
					overrides[i-1].remove(target);
				
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
					overrides[i].apply(target as IContainer);
				
				state.dispatchEnterState();
			}
		}
		
		private var initialized:Boolean = false;
		/**
		 * 初始化所有视图状态
		 */
		public function initializeStates():void
		{
			if(initialized)
				return;
			initialized = true;
			for (var i:int = 0; i < _states.length; i++)
			{
				var state:State = _states[i] as State;
				if(!state)
					break;
				state.initialize(target);
			}
		}
	}
}