package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.states.StateClientHelper;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 皮肤布局基类<br/>
	 * Skin及其子类中定义的公开属性,会在初始化完成后被直接当做SkinPart并将引用赋值到宿主组件的同名属性上，
	 * 若有延迟创建的部件，请在加载完成后手动调用hostComponent.findSkinParts()方法应用部件。<br/>
	 * @author DOM
	 */
	public class Skin extends Group 
		implements IStateClient,ISkin
	{
		public function Skin()
		{
			super();
			stateClientHelper = new StateClientHelper(this);
		}
		
		private var _hostComponent:SkinnableComponent;

		/**
		 * 主机组件引用,仅当皮肤被应用后才会对此属性赋值 
		 */
		public function get hostComponent():SkinnableComponent
		{
			return _hostComponent;
		}

		public function set hostComponent(value:SkinnableComponent):void
		{
			_hostComponent = value;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			stateClientHelper.initializeStates();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(stateClientHelper.currentStateChanged)
			{
				stateClientHelper.commitCurrentState();
				commitCurrentState();
			}
		}
		
		//========================state相关函数===============start=========================
		
		private var stateClientHelper:StateClientHelper;
		/**
		 * 为此组件定义的视图状态。
		 */
		public function get states():Array
		{
			return stateClientHelper.states;
		}
		
		public function set states(value:Array):void
		{
			stateClientHelper.states = value;
		}
		
		/**
		 * 组件的当前视图状态。
		 */
		public function get currentState():String
		{
			return stateClientHelper.currentState;
		}
		public function set currentState(value:String):void
		{
			stateClientHelper.currentState = value;

			if(stateClientHelper.currentStateChanged)
			{
				if(initialized||parent)
				{
					stateClientHelper.commitCurrentState();
					commitCurrentState();
				}
				else
				{
					invalidateProperties();
				}
			}
		}
		
		/**
		 * 返回是否含有指定名称的视图状态
		 * @param stateName 要检测的视图状态名称
		 */				
		public function hasState(stateName:String):Boolean
		{
			return stateClientHelper.hasState(stateName);
		}
		
		/**
		 * 应用当前的视图状态
		 */		
		protected function commitCurrentState():void
		{
			
		}
		
		//========================state相关函数===============end=========================
		
	}
}
