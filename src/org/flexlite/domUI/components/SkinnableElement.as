package org.flexlite.domUI.components
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import org.flexlite.domUI.components.supportClasses.DefaultSkinAdapter;
	import org.flexlite.domUI.core.IBitmapAsset;
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.ISkinAdapter;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.core.UITextField;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.InjectorManager;

	use namespace dx_internal;
	
	/**
	 * 皮肤发生改变事件。当给skinName赋值之后，皮肤有可能是异步获取的，在赋值之前监听此事件，可以确保在皮肤解析完成时回调。
	 */	
	[Event(name="skinChanged", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="false")]
	
	/**
	 * 最轻量级的可设置外观元素，通常作为普通显示对象的包装器。默认禁用了鼠标事件。<p/>
	 * 可将普通显示对象直接赋值给skinName属性,或赋值任何类型，从而调用注入的皮肤解析适配器自动获取皮肤并赋值给skin。
	 * 获取的skin对象将会自动跟随SkinnableElement尺寸缩放。<p/>
	 * 注意：SkinnableElement仅在添skin时测量一次初始尺寸， 请不要在外部直接修改skin尺寸，
	 * 若做了引起skin尺寸发生变化的操作, 需手动调用SkinnableElement的invalidateSize()进行重新测量。
	 * @author DOM
	 */
	public class SkinnableElement extends UIComponent
	{
		public function SkinnableElement()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		private var skinNameChanged:Boolean = false;
		
		dx_internal var _skinName:Object;

		/**
		 * 皮肤标识符。可以为Class,String,或DisplayObject实例等任意类型，具体规则由项目注入的素材适配器决定，
		 * 适配器根据此属性值解析获取对应的显示对象，并赋值给skin属性。
		 */	
		public function get skinName():Object
		{
			return _skinName;
		}

		public function set skinName(value:Object):void
		{
			if(_skinName==value)
				return;
			_skinName = value;
			if(initialized||hasParent)
			{
				parseSkinName();
			}
			else
			{
				skinNameChanged = true;
				invalidateProperties();
			}
		}
		
		dx_internal var _skin:DisplayObject;
		/**
		 * 皮肤显示对象。赋值到此属性上的显示对象，会添加到显示列表，并自动跟随组件缩放。
		 */
		public function get skin():DisplayObject
		{
			return _skin;
		}
		
		/**
		 * 皮肤适配器解析skinName后回调函数
		 * @param skin 皮肤显示对象
		 * @param skinName 皮肤标识符
		 */		
		protected function onGetSkin(skin:Object,skinName:Object):void
		{
			if(skin==_skin)
				return;
			if(_skin&&_skin.parent==this)
			{
				super.removeChild(_skin);
			}
			_skin = skin as DisplayObject;
			if(_skin)
			{
				super.addChildAt(_skin,0);
			}
			invalidateSize();
			invalidateParentSizeAndDisplayList();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(skinNameChanged)
			{
				skinNameChanged = false;
				parseSkinName();
			}
		}
		
		/**
		 * 皮肤解析适配器
		 */		
		private static var skinAdapter:ISkinAdapter;
		/**
		 * 解析skinName
		 */		
		private function parseSkinName():void
		{
			if(!skinAdapter)
			{
				try
				{
					skinAdapter = InjectorManager.singletonInjector.getInstance(ISkinAdapter);
				}
				catch(e:Error)
				{
					skinAdapter = new DefaultSkinAdapter();
				}
			}
			if(_skinName==null||_skinName=="")
			{
				skinChnaged(null,_skinName);
			}
			else
			{
				skinAdapter.getSkin(_skinName,skinChnaged);
			}
		}
		/**
		 * 皮肤发生改变
		 */		
		private function skinChnaged(skin:Object,skinName:Object):void
		{
			onGetSkin(skin,skinName);
			if(hasEventListener(UIEvent.SKIN_CHANGED))
			{
				var event:UIEvent = new UIEvent(UIEvent.SKIN_CHANGED);
				dispatchEvent(event);
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			if(!_skin)
				return;
			if(_skin is ILayoutElement)
			{
				measuredWidth = (_skin as ILayoutElement).preferredWidth;
				measuredHeight = (_skin as ILayoutElement).preferredHeight;
			}
			else if(_skin is IBitmapAsset)
			{
				var bitmapData:BitmapData = (_skin as IBitmapAsset).bitmapData;
				measuredWidth = bitmapData?bitmapData.width:0;
				measuredHeight = bitmapData?bitmapData.height:0;
			}
			else if(_skin is TextField&&!(_skin is UITextField))
			{
				measuredWidth = (_skin as TextField).textWidth+4;
				measuredHeight = (_skin as TextField).textHeight+4;
			}
			else
			{
				measuredWidth = _skin.width;
				measuredHeight = _skin.height;
			}
		}
		
		private var _scaleSkin:Boolean = true;

		/**
		 * 是否让skin跟随组件尺寸缩放,默认true。
		 */
		public function get scaleSkin():Boolean
		{
			return _scaleSkin;
		}

		public function set scaleSkin(value:Boolean):void
		{
			if(_scaleSkin==value)
				return;
			_scaleSkin = value;
			if(!value&&_skin&&_skin is ILayoutElement)
			{//取消之前的强制布局
				(_skin as ILayoutElement).setLayoutBoundsSize(NaN,NaN);
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(_scaleSkin&&_skin)
			{
				if(_skin is ILayoutElement)
				{
					(_skin as ILayoutElement).setLayoutBoundsSize(unscaledWidth,unscaledHeight);
				}
				else
				{
					_skin.width = unscaledWidth;
					_skin.height = unscaledHeight;
				}
			}
		}
		
		
		/**
		 * 添加对象到显示列表,此接口仅预留给皮肤不为ISkinPart而需要内部创建皮肤子部件的情况,
		 * 如果需要管理子项，若有，请使用容器的addElement()方法，非法使用有可能造成无法自动布局。
		 */		
		final dx_internal function addToDisplyList(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		/**
		 * 添加对象到指定的索引,此接口仅预留给皮肤不为ISkinPart而需要内部创建皮肤子部件的情况,
		 * 如果需要管理子项，若有，请使用容器的addElementAt()方法，非法使用有可能造成无法自动布局。
		 */		
		final dx_internal function addToDisplyListAt(child:DisplayObject,index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		/**
		 * 从显示列表移除对象,此接口仅预留给皮肤不为ISkinPart而需要内部创建皮肤子部件的情况,
		 * 如果需要管理子项，若有，请使用容器的removeElement()方法,非法使用有可能造成无法自动布局。
		 */		
		final dx_internal function removeFromDisplayList(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		private static const errorStr:String = "在此组件中不可用，若此组件为容器类，请使用";
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#addChild()
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("addChild()"+errorStr+"addElement()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#addChildAt()
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw(new Error("addChildAt()"+errorStr+"addElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#removeChild()
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw(new Error("removeChild()"+errorStr+"removeElement()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#removeChildAt()
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw(new Error("removeChildAt()"+errorStr+"removeElementAt()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#setChildIndex()
		 */		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw(new Error("setChildIndex()"+errorStr+"setElementIndex()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#swapChildren()
		 */		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw(new Error("swapChildren()"+errorStr+"swapElements()代替"));
		}
		[Deprecated] 
		/**
		 * @copy org.flexlite.domUI.components.Group#swapChildrenAt()
		 */		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw(new Error("swapChildrenAt()"+errorStr+"swapElementsAt()代替"));
		}
	}
}