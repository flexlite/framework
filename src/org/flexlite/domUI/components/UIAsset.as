package org.flexlite.domUI.components
{

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.IBitmapAsset;
	import org.flexlite.domCore.IInvalidateDisplay;
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.DefaultSkinAdapter;
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.ISkinAdapter;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.UIEvent;

	use namespace dx_internal;
	
	/**
	 * 皮肤发生改变事件。当给skinName赋值之后，皮肤有可能是异步获取的，在赋值之前监听此事件，可以确保在皮肤解析完成时回调。
	 */	
	[Event(name="skinChanged", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="true")]
	
	/**
	 * 素材包装器。<p/>
	 * 注意：UIAsset仅在添skin时测量一次初始尺寸， 请不要在外部直接修改skin尺寸，
	 * 若做了引起skin尺寸发生变化的操作, 需手动调用UIAsset的invalidateSize()进行重新测量。
	 * @author DOM
	 */
	public class UIAsset extends UIComponent implements ISkinnableClient
	{
		public function UIAsset()
		{
			super();
			mouseChildren = false;
		}
		
		private var skinNameChanged:Boolean = false;
		/**
		 * 外部显式设置了皮肤名
		 */		
		dx_internal var skinNameExplicitlySet:Object = false;
		
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
			skinNameExplicitlySet = true;
			if(createChildrenCalled)
			{
				parseSkinName();
			}
			else
			{
				skinNameChanged = true;
			}
		}
		
		dx_internal var _skin:DisplayObject;
		/**
		 * 显示对象皮肤。
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
			if(_skin!==skin)//如果皮肤是重用的，就不用执行添加和移除操作。
			{
				if(_skin&&_skin.parent==this)
				{
					super.removeChild(_skin);
				}
				_skin = skin as DisplayObject;
				if(_skin)
				{
					super.addChildAt(_skin,0);
				}
			}
			aspectRatio = NaN;
			invalidateSize();
			invalidateDisplayList();
			if(stage)
				validateNow();
		}
		
		private var createChildrenCalled:Boolean = false;
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(skinNameChanged)
			{
				parseSkinName();
			}
			createChildrenCalled = true;
		}
		
		/**
		 * 皮肤解析适配器
		 */		
		private static var skinAdapter:ISkinAdapter;
		/**
		 * 默认的皮肤解析适配器
		 */	
		private static var defaultSkinAdapter:DefaultSkinAdapter;
		
		private var skinReused:Boolean = false;
		/**
		 * 解析skinName
		 */		
		private function parseSkinName():void
		{
			skinNameChanged = false;
			var adapter:ISkinAdapter = skinAdapter;
			if(!adapter)
			{
				try
				{
					adapter = skinAdapter = Injector.getInstance(ISkinAdapter);
				}
				catch(e:Error)
				{
					if(!defaultSkinAdapter)
						defaultSkinAdapter = new DefaultSkinAdapter();
					adapter = defaultSkinAdapter;
				}
			}
			if(!_skinName)
			{
				skinChnaged(null,_skinName);
			}
			else
			{
				var reuseSkin:DisplayObject = skinReused?null:_skin;
				skinReused = true;
				adapter.getSkin(_skinName,skinChnaged,reuseSkin);
			}
		}
		/**
		 * 皮肤发生改变
		 */		
		private function skinChnaged(skin:Object,skinName:Object):void
		{
			if(skinName!==_skinName)
				return;
			onGetSkin(skin,skinName);
			skinReused = false;
			if(hasEventListener(UIEvent.SKIN_CHANGED))
			{
				var event:UIEvent = new UIEvent(UIEvent.SKIN_CHANGED);
				dispatchEvent(event);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(!_skin)
				return;
			if(_skin is ILayoutElement&&!(_skin as ILayoutElement).includeInLayout)
				return;
			var rect:Rectangle = getMeasuredSize();
			this.measuredWidth = rect.width;
			this.measuredHeight = rect.height;
		}
		
		/**
		 * 获取测量大小
		 */		
		private function getMeasuredSize():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			if(_skin is ILayoutElement)
			{
				rect.width = (_skin as ILayoutElement).preferredWidth;
				rect.height = (_skin as ILayoutElement).preferredHeight;
			}
			else if(_skin is IBitmapAsset)
			{
				rect.width = (_skin as IBitmapAsset).measuredWidth;
				rect.height = (_skin as IBitmapAsset).measuredHeight;
			}
			else
			{
				var oldScaleX:Number = _skin.scaleX;
				var oldScaleY:Number = _skin.scaleY;
				_skin.scaleX = 1;
				_skin.scaleY = 1;
				rect.width = _skin.width;
				rect.height = _skin.height;
				_skin.scaleX = oldScaleX;
				_skin.scaleY = oldScaleY;
			}
			return rect;
		}
		
		private var _maintainAspectRatio:Boolean = false;
		/**
		 * 是否保持皮肤的宽高比,默认为false。
		 */
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}

		public function set maintainAspectRatio(value:Boolean):void
		{
			if(_maintainAspectRatio==value)
				return;
			_maintainAspectRatio = value;
			invalidateDisplayList();
		}
		
		/**
		 * 皮肤宽高比
		 */		
		dx_internal var aspectRatio:Number = NaN;

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(_skin)
			{
				if(_maintainAspectRatio)
				{
					var layoutBoundsX:Number = 0;
					var layoutBoundsY:Number = 0;
					if(isNaN(aspectRatio))
					{
						var rect:Rectangle = getMeasuredSize();
						if(rect.width==0||rect.height==0)
							aspectRatio = 0;
						else
							aspectRatio = rect.width/rect.height;
					}
					if(aspectRatio>0&&unscaledHeight>0&&unscaledWidth>0)
					{
						var ratio:Number = unscaledWidth/unscaledHeight;
						if(ratio>aspectRatio)
						{
							var newWidth:Number = unscaledHeight*aspectRatio;
							layoutBoundsX = Math.round((unscaledWidth-newWidth)*0.5);
							unscaledWidth = newWidth;
						}
						else
						{
							var newHeight:Number = unscaledWidth/aspectRatio;
							layoutBoundsY = Math.round((unscaledHeight-newHeight)*0.5);
							unscaledHeight = newHeight;
						}
						
						if(_skin is ILayoutElement)
						{
							if((_skin as ILayoutElement).includeInLayout)
							{
								(_skin as ILayoutElement).setLayoutBoundsPosition(layoutBoundsX,layoutBoundsY);
							}
						}
						else
						{
							_skin.x = layoutBoundsX;
							_skin.y = layoutBoundsY;
						}
					}
				}
				if(_skin is ILayoutElement)
				{
					if((_skin as ILayoutElement).includeInLayout)
					{
						(_skin as ILayoutElement).setLayoutBoundsSize(unscaledWidth,unscaledHeight);
					}
				}
				else
				{
					_skin.width = unscaledWidth;
					_skin.height = unscaledHeight;
					if(_skin is IInvalidateDisplay)
						IInvalidateDisplay(_skin).validateNow();
				}
			}
		}
		
		
		/**
		 * 添加对象到显示列表,此接口仅预留给皮肤不为ISkin而需要内部创建皮肤子部件的情况,
		 * 如果需要管理子项，若有，请使用容器的addElement()方法，非法使用有可能造成无法自动布局。
		 */		
		final dx_internal function addToDisplayList(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		/**
		 * 添加对象到指定的索引,此接口仅预留给皮肤不为ISkin而需要内部创建皮肤子部件的情况,
		 * 如果需要管理子项，若有，请使用容器的addElementAt()方法，非法使用有可能造成无法自动布局。
		 */		
		final dx_internal function addToDisplayListAt(child:DisplayObject,index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		/**
		 * 从显示列表移除对象,此接口仅预留给皮肤不为ISkin而需要内部创建皮肤子部件的情况,
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