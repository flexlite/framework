package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IStateClient;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 皮肤布局基类<br/>
	 * Skin及其子类中定义的公开属性,会在初始化完成后被直接当做SkinPart并将引用赋值到宿主组件的同名属性上，
	 * 若有延迟加载的部件，请在加载完成后手动调用hostComponent.findSkinParts()方法应用部件。<br/>
	 * @author DOM
	 */
	public class Skin extends Group 
		implements IStateClient,ISkin
	{
		public function Skin()
		{
			super();
		}
		
		private var _hostComponent:Object;

		/**
		 * 主机组件引用,仅当皮肤被应用后才会对此属性赋值 
		 */
		public function get hostComponent():Object
		{
			return _hostComponent;
		}

		public function set hostComponent(value:Object):void
		{
			_hostComponent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (currentStateChanged)
			{
				currentStateChanged = false;
				commitCurrentState();
				if(hostComponent)
				{
					hostComponent.findSkinParts();
				}
			}
		}
		
		//========================state相关函数===============start=========================
		
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
			_states = value;
		}
		
		dx_internal var _currentState:String;
		
		/**
		 * 当前视图状态发生改变 
		 */		
		dx_internal var currentStateChanged:Boolean;
		/**
		 * 组件的当前视图状态。
		 */
		public function get currentState():String
		{
			if(_currentState==null||_currentState=="")
				return _states[0];
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState==value)
				return;
			_currentState = value;
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
		
		/**
		 * 应用当前的视图状态
		 */		
		protected function commitCurrentState():void
		{
			
		}
		
		/**
		 * 返回是否含有指定名称的视图状态
		 * @param stateName 要检测的视图状态名称
		 */				
		public function hasState(stateName:String):Boolean
		{
			for each(var state:String in states)
			{
				if(state==stateName)
					return true;
			}
			return false;
		}
		
		//========================state相关函数===============end=========================
		
	}
}
