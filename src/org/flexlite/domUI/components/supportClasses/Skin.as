package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.IHostComponent;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.ISkinPartHost;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.utils.SkinPartUtil;
	
	import flash.utils.Dictionary;

	use namespace dx_internal;
	
	[DXML(show="false")]
	
	/**
	 * 皮肤布局基类<br/>
	 * Skin及其子类中定义的公开属性,会在初始化完成后被直接当做SkinPart并将引用赋值到宿主组件的同名属性上，
	 * 若有延迟加载的部件，请在加载完成后手动调用hostComponent.findSkinParts()方法应用部件。<br/>
	 * @author DOM
	 */
	public class Skin extends Group 
		implements IStateClient,ISkin,ISkinPartHost
	{
		public function Skin()
		{
			super();
		}
		
		private var _hostComponent:IHostComponent;

		/**
		 * 主机组件引用,仅当皮肤被应用后才会对此属性赋值 
		 */
		public function get hostComponent():IHostComponent
		{
			return _hostComponent;
		}

		public function set hostComponent(value:IHostComponent):void
		{
			_hostComponent = value;
		}
		
		public function getSkinParts():Vector.<String>
		{
			return SkinPartUtil.getSkinParts(this);
		}

		
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
			if(styleChangedKeys!=null&&styleChangedKeys.length>0)
			{
				for each(var styleName:String in styleChangedKeys)
				{
					styleChanged(styleName);
				}
				styleChangedKeys = [];
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
		
		
		//=========================样式绑定====================start=======================
				
		/**
		 * 获取样式属性值
		 * @param styleName 样式名
		 */		
		protected function getStyle(styleName:String):*
		{
			if(_hostComponent)
				return _hostComponent.getStyle(styleName);
			return null;
		}
		
		private var styleChangedKeys:Array;
		
		/**
		 * 标记某个样式属性已经改变
		 */		
		public function invalidateStyle(styleName:String):void
		{
			if(styleChangedKeys==null)
			{
				styleChangedKeys = [];
			}
			if(styleChangedKeys.indexOf(styleName)==-1)
			{
				styleChangedKeys.push(styleName);
				invalidateProperties();
			}
			
		}
		
		private var styleBindDic:Dictionary;
		/**
		 * 绑定样式属性的一个简便方法。使用这个方法能在调用setStyle()方法时主动通知指定的组件更新属性值。
		 * @param styleName 样式名
		 * @param prop 组件上要赋值的属性名
		 * @param host 宿主组件相对于this的变量名:this[host][prop],若不设置，则直接使用this[prop]访问属性。
		 * 
		 */		
		protected final function bindStyle(styleName:String,prop:String,host:String=""):void
		{
			if(styleName==null||styleName==""||prop==null||prop=="")
				return;
			if(styleBindDic==null)
				styleBindDic = new Dictionary;
			if(styleBindDic[styleName] == null)
				styleBindDic[styleName] = [];
			for each(var info:StyleBindInfo in styleBindDic[styleName])
			{
				if(info.host==host&&info.prop==prop)
					return;
			}
			styleBindDic[styleName].push(new StyleBindInfo(prop,host));
		}
		/**
		 * 取消绑定过的样式属性
		 * @param styleName 样式名
		 * @param prop 组件上要赋值的属性名
		 * @param host 宿主组件相对于this的变量名:this[host][prop],若不设置，则直接使用this[prop]访问属性。
		 */		
		protected final function unbindStyle(styleName:String,prop:String,host:String=""):Boolean
		{
			if(styleBindDic==null||styleName==null||styleName==""||prop==null||prop=="")
				return false;
			var index:int = 0;
			for each(var info:StyleBindInfo in styleBindDic[styleName])
			{
				if(info.host==host&&info.prop==prop)
				{
					(styleBindDic[styleName] as Array).splice(index,1);
					break;
				}
				index++;
			}
			return false;
		}
		
		/**
		 * 样式属性值改变
		 * @param styleName 样式名
		 */		
		protected function styleChanged(styleName:String):void
		{
			if(styleBindDic==null||_hostComponent==null)
				return;
			for each(var info:StyleBindInfo in styleBindDic[styleName])
			{
				if(info==null)
					continue;
				var host:Object = this;
				if(info.host!=null&&info.host!="")
				{
					try
					{
						host = this[info.host];
					}
					catch(e:Error)
					{
						continue;
					}
				}
				try
				{
					host[info.prop] = getStyle(styleName);
				}
				catch(e:Error)
				{
				}
			}
		}
		
		//=========================样式绑定====================start=======================
	}
}

class StyleBindInfo
{
	public function StyleBindInfo(prop:String,host:String="")
	{
		this.prop = prop;
		this.host = host;
	}
	
	public var prop:String;
	
	public var host:String;
}