package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.SkinBasicLayout;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.events.SkinPartEvent;
	import org.flexlite.domUI.utils.SkinPartUtil;
	
	use namespace dx_internal;
	
	/**
	 * 皮肤部件附加事件 
	 */	
	[Event(name="partAdded", type="org.flexlite.domUI.events.SkinPartEvent")]
	/**
	 * 皮肤部件卸载事件 
	 */	
	[Event(name="partRemoved", type="org.flexlite.domUI.events.SkinPartEvent")]
	
	[DXML(show="false")]
	
	[SkinState("normal")]
	[SkinState("disabled")]
	
	/**
	 * 复杂可设置外观组件的基类，接受ISkin类或任何显示对象作为皮肤。
	 * 当皮肤为ISkin时，将自动匹配两个实例内同名的公开属性(显示对象)，
	 * 并将皮肤的属性引用赋值到此类定义的同名属性(必须没有默认值)上,
	 * 如果要对公共属性添加事件监听或其他操作，
	 * 请覆盖partAdded()和partRemoved()方法
	 * @author DOM
	 */
	public class SkinnableComponent extends UIAsset
	{
		/**
		 * 构造函数
		 */		
		public function SkinnableComponent()
		{
			super();
			mouseChildren = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(!defaultTheme)
			{
				try
				{
					defaultTheme = Injector.getInstance(Theme);
				}
				catch(e:Error){}
			}
			if(defaultTheme&&skinName==null)
			{
				skinName = defaultTheme.getSkinName(hostComponentKey);
				skinNameExplicitlySet = false;
			}
			if(skinName==null)
			{//让部分组件在没有皮肤的情况下创建默认的子部件。
				onGetSkin(null,null);
			}
			super.createChildren();
		}
		/**
		 * 默认的皮肤解析适配器
		 */		
		private static var defaultTheme:Theme;
		
		/**
		 * 在皮肤注入管理器里标识自身的默认键，可以是类定义，实例，或者是完全限定类名。
		 * 子类覆盖此方法，用于获取注入的缺省skinName。
		 */		
		protected function get hostComponentKey():Object
		{
			return SkinnableComponent;
		}
		
		private var _skinObject:Object 
		/**
		 * 存储皮肤适配器解析skinName得到的原始皮肤对象，包括非显示对象皮肤的实例。
		 */
		public function get skinObject():Object
		{
			return _skinObject;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onGetSkin(skin:Object,skinName:Object):void
		{
			var oldSkin:Object = _skinObject;
			detachSkin(oldSkin);
			if(_skin)
			{
				if(_skin.parent==this)
				{
					removeFromDisplayList(_skin); 
				}
			}
			
			if(skin is DisplayObject)
			{
				_skin = skin as DisplayObject;
				addToDisplayListAt(_skin,0);
			}
			else
			{
				_skin = null;
			}
			_skinObject = skin;
			attachSkin(_skinObject);
			aspectRatio = NaN;
			invalidateSkinState();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 附加皮肤
		 */		
		protected function attachSkin(skin:Object):void
		{
			if(skin is ISkin)
			{
				var newSkin:ISkin = skin as ISkin;
				newSkin.hostComponent = this;
				findSkinParts();
			}
			else
			{
				if(!hasCreatedSkinParts)
				{
					createSkinParts();
					hasCreatedSkinParts = true;
				}
			}
			if(skin is ISkin&&skin is DisplayObject)
				skinLayoutEnabled = false;
			else
				skinLayoutEnabled = true;
		}
		/**
		 * 匹配皮肤和主机组件的公共变量，并完成实例的注入。此方法在附加皮肤时会自动执行一次。
		 * 若皮肤中含有延迟实例化的子部件，在子部件实例化完成时需要从外部再次调用此方法,完成注入。
		 */	
		public function findSkinParts():void
		{
			var curSkin:Object = _skinObject;
			if(!curSkin||!(curSkin is ISkin))
				return;
			var skinParts:Vector.<String> = SkinPartUtil.getSkinParts(this);
			for each(var partName:String in skinParts)
			{
				if((partName in this)&&(partName in curSkin)&&curSkin[partName] != null
					&&this[partName]==null)
				{
					try
					{
						this[partName] = curSkin[partName];
						partAdded(partName,curSkin[partName]);
					}
					catch(e:Error)
					{
					}
				}
			}
		}
		
		/**
		 * 由组件自身创建了SkinPart的标志
		 */		
		private var hasCreatedSkinParts:Boolean = false;
		/**
		 * 由组件自身来创建必要的SkinPart，通常是皮肤为空或皮肤不是ISkinPart时调用。
		 */		
		dx_internal function createSkinParts():void
		{
		}
		/**
		 * 删除组件自身创建的SkinPart
		 */		
		dx_internal function removeSkinParts():void
		{
		}
		
		/**
		 * 卸载皮肤
		 */		
		protected function detachSkin(skin:Object):void
		{       
			if(hasCreatedSkinParts)
			{
				removeSkinParts();
				hasCreatedSkinParts = false;
			}
			if(skin is ISkin)
			{
				var skinParts:Vector.<String> = SkinPartUtil.getSkinParts(this);
				for each(var partName:String in skinParts)
				{
					if(!(partName in this))
						continue;
					if (this[partName] != null)
					{
						partRemoved(partName,this[partName]);
					}
					this[partName] = null;
				}
				(skin as ISkin).hostComponent = null;
			}
		}
		
		/**
		 * 若皮肤是ISkinPartHost,则调用此方法附加皮肤中的公共部件
		 */		
		protected function partAdded(partName:String,instance:Object):void
		{
			var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_ADDED);
			event.partName = partName;
			event.instance = instance;
			dispatchEvent(event);
		}
		/**
		 * 若皮肤是ISkinPartHost，则调用此方法卸载皮肤之前注入的公共部件
		 */		
		protected function partRemoved(partName:String,instance:Object):void
		{       
			var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_REMOVED);
			event.partName = partName;
			event.instance = instance;
			dispatchEvent(event);
		}
		
		
		
		//========================皮肤视图状态=====================start=======================
		
		private var stateIsDirty:Boolean = false;
		
		/**
		 * 标记当前需要重新验证皮肤状态
		 */		
		public function invalidateSkinState():void
		{
			if (stateIsDirty)
				return;
			
			stateIsDirty = true;
			invalidateProperties();
		}
		
		/**
		 * 灰度滤镜
		 */		
		private static var grayFilters:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1])];
		/**
		 * 旧的滤镜列表
		 */		
		private var oldFilters:Array;
		/**
		 * 被替换过灰色滤镜的标志
		 */		
		private var grayFilterIsSet:Boolean = false;
		
		/**
		 * 子类覆盖此方法,应用当前的皮肤状态
		 */		
		protected function validateSkinState():void
		{
			var curState:String = getCurrentSkinState();
			var hasState:Boolean = false;
			var curSkin:Object = _skinObject;
			if(curSkin is IStateClient)
			{
				(curSkin as IStateClient).currentState = curState;
				hasState = (curSkin as IStateClient).hasState(curState);
			}
			if(hasEventListener("stateChanged"))
				dispatchEvent(new Event("stateChanged"));
			if(enabled)
			{
				if(grayFilterIsSet)
				{
					filters = oldFilters;
					oldFilters = null;
					grayFilterIsSet = false;
				}
			}
			else
			{
				if(!hasState&&!grayFilterIsSet)
				{
					oldFilters = filters;
					filters = grayFilters;
					grayFilterIsSet = true;
				}
			}
		}
		
		private var _autoMouseEnabled:Boolean = true;
		/**
		 * 在enabled属性发生改变时是否自动开启或禁用鼠标事件的响应。默认值为true。
		 */
		public function get autoMouseEnabled():Boolean
		{
			return _autoMouseEnabled;
		}
		
		public function set autoMouseEnabled(value:Boolean):void
		{
			if(_autoMouseEnabled==value)
				return;
			_autoMouseEnabled = value;
			if(_autoMouseEnabled)
			{
				super.mouseChildren = enabled ? explicitMouseChildren : false;
				super.mouseEnabled  = enabled ? explicitMouseEnabled  : false;
			}
			else
			{
				super.mouseChildren = explicitMouseChildren;
				super.mouseEnabled  = explicitMouseEnabled;
			}
		}
		
		/**
		 * 外部显式设置的mouseChildren属性值 
		 */		
		private var explicitMouseChildren:Boolean = true;
		/**
		 * @inheritDoc
		 */		
		override public function set mouseChildren(value:Boolean):void
		{
			if(enabled)
				super.mouseChildren = value;
			explicitMouseChildren = value;
		}
		/**
		 * 外部显式设置的mouseEnabled属性值
		 */		
		private var explicitMouseEnabled:Boolean = true;
		/**
		 * @inheritDoc
		 */	
		override public function set mouseEnabled(value:Boolean):void
		{
			if(enabled)
				super.mouseEnabled = value;
			explicitMouseEnabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			if(super.enabled==value)
				return;
			super.enabled = value;
			if(_autoMouseEnabled)
			{
				super.mouseChildren = value ? explicitMouseChildren : false;
				super.mouseEnabled  = value ? explicitMouseEnabled  : false;
			}
			invalidateSkinState();
		}
		
		/**
		 * 返回组件当前的皮肤状态名称,子类覆盖此方法定义各种状态名
		 */		
		protected function getCurrentSkinState():String 
		{
			return enabled?"normal":"disabled"
		}
		
		//========================皮肤视图状态===================end========================
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(stateIsDirty)
			{
				stateIsDirty = false;
				validateSkinState();
			}
		}
		
		private var layout:SkinBasicLayout;
		/**
		 * 启用或禁用组件自身的布局。通常用在当组件的皮肤不是ISkinPartHost，又需要自己创建子项并布局时。
		 */		
		dx_internal function set skinLayoutEnabled(value:Boolean):void
		{
			var hasLayout:Boolean = (layout != null);
			if(hasLayout==value)
				return;
			if(value)
			{
				layout = new SkinBasicLayout();
				layout.target = this;
			}
			else
			{
				layout.target = null;
 				layout = null;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override dx_internal function childXYChanged():void
		{
			if(layout)
			{
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(layout)
			{
				layout.measure();
			}
			var skinObject:Object = _skinObject;
			if(!_skin&&skinObject)
			{//为非显示对象的皮肤测量
				var measuredW:Number = this.measuredWidth;
				var measuredH:Number = this.measuredHeight;
				try
				{
					if(!isNaN(skinObject.width))
						measuredW = Math.ceil(skinObject.width);
					if(!isNaN(skinObject.height))
						measuredH = Math.ceil(skinObject.height);
					if(skinObject.hasOwnProperty("minWidth")&&
						measuredW<skinObject.minWidth)
					{
						measuredW = skinObject.minWidth;
					}
					if(skinObject.hasOwnProperty("maxWidth")&&
						measuredW>skinObject.maxWidth)
					{
						measuredW = skinObject.maxWidth;
					}
					if(skinObject.hasOwnProperty("minHeight")&&
						measuredH<skinObject.minHeight)
					{
						measuredH = skinObject.minHeight;
					}
					if(skinObject.hasOwnProperty("maxHeight")&&
						measuredH>skinObject.maxHeight)
					{
						measuredH = skinObject.maxHeight
					}
					this.measuredWidth = measuredW;
					this.measuredHeight = measuredH;
				}
				catch(e:Error){}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(layout)
			{
				layout.updateDisplayList(unscaledWidth,unscaledHeight);
			}
		}
	}
}