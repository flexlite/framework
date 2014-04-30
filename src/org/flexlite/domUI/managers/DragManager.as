package org.flexlite.domUI.managers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DragSource;
	import org.flexlite.domUI.managers.impl.DragManagerImpl;
	
	/**
	 * 拖拽管理器<p/>
	 * 若项目需要自定义拖拽管理器，请实现IDragManager接口，
	 * 并在项目初始化前调用Injector.mapClass(IDragManager,YourDragManager)，
	 * 注入自定义的拖拽管理器类。
	 * @author DOM
	 */
	public class DragManager
	{
		
		private static var _impl:IDragManager;
		/**
		 * 获取单例
		 */		
		private static function get impl():IDragManager
		{
			if (!_impl)
			{
				try
				{
					_impl = Injector.getInstance(IDragManager);
				}
				catch(e:Error)
				{
					_impl = new DragManagerImpl();
				}
			}
			return _impl;
		}
		/**
		 * 正在拖拽的标志
		 */		
		public static function get isDragging():Boolean
		{
			return impl.isDragging;
		}
		/**
		 * 启动拖拽操作。请在MouseDown事件里执行此方法。
		 * @param dragInitiator 启动拖拽的组件
		 * @param dragSource 拖拽的数据源
		 * @param dragImage 拖拽过程中显示的图像
		 * @param xOffset dragImage相对dragInitiator的x偏移量,默认0。
		 * @param yOffset dragImage相对dragInitiator的y偏移量,默认0。
		 * @param imageAlpha dragImage的透明度，默认0.5。
		 */		
		public static function doDrag(
			dragInitiator:InteractiveObject, 
			dragSource:DragSource, 
			dragImage:DisplayObject = null,
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5):void
		{
			impl.doDrag(dragInitiator, dragSource, dragImage, xOffset,
				yOffset, imageAlpha);
		}
		/**
		 * 接受拖拽的数据源。通常在dragEnter事件处理函数调用此方法。
		 * 传入target后，若放下数据源。target将能监听到dragDrop事件。
		 */		
		public static function acceptDragDrop(target:InteractiveObject):void
		{
			impl.acceptDragDrop(target);
		}
		/**
		 * 结束拖拽
		 */		
		dx_internal static function endDrag():void
		{
			impl.endDrag();
		}
	}
}