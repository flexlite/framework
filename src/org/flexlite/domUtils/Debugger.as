package org.flexlite.domUtils
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.skins.vector.TitleWindowSkin;
	
	
	/**
	 * 运行时调试工具
	 * @author DOM
	 */
	public class Debugger extends Group
	{
		/**
		 * 初始化调试工具
		 * @param stage 舞台引用
		 */		
		public static function initialize(stage:Stage):void
		{
			if(!stage)
				return;
			new Debugger(stage);
		}
		/**
		 * 构造函数
		 */		
		public function Debugger(stage:Stage)
		{
			super();
			mouseEnabled = false;
			mouseEnabledWhereTransparent = false;
			appStage = stage;
			visible = false;
			appStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			init();
		}
		/**
		 * 初始化
		 */		
		private function init():void
		{
			var window:TitleWindow = new TitleWindow();
			window.skinName = TitleWindowSkin;
			window.isPopUp = true;
			window.showCloseButton = false;
			addElement(window);
		}
		/**
		 * 舞台引用
		 */		
		private var appStage:Stage;
		/**
		 * 键盘事件
		 */		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.F11)
			{
				visible = !visible;
				if(visible)
				{
					show();
				}
				else
				{
					close();
				}
			}
		}
		
		/**
		 * 显示
		 */		
		private function show():void
		{
			appStage.addChild(this);
			appStage.addEventListener(Event.ADDED,onAdded);
			appStage.addEventListener(Event.RESIZE,onResize);
			appStage.addEventListener(FullScreenEvent.FULL_SCREEN,onResize);
			appStage.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			appStage.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			onResize();
		}
		
		/**
		 * 关闭
		 */		
		private function close():void
		{
			if(parent)
				parent.removeChild(this);
			appStage.removeEventListener(Event.ADDED,onAdded);
			appStage.removeEventListener(Event.RESIZE,onResize);
			appStage.removeEventListener(FullScreenEvent.FULL_SCREEN,onResize);
			appStage.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			appStage.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		/**
		 * stage子项发生改变
		 */		
		private function onAdded(event:Event):void
		{
			if(parent.getChildIndex(this)!=parent.numChildren-1)
				parent.addChild(this);
		}
		
		/**
		 * 舞台尺寸改变
		 */		
		private function onResize(event:Event=null):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0,0.2);
			g.drawRect(0,0,w,h);
			if(currentTarget)
			{
				var pos:Point = currentTarget.localToGlobal(new Point());
				g.drawRect(pos.x,pos.y,currentTarget.width,currentTarget.height);
				g.endFill();
				g.beginFill(0x009aff,0);
				g.lineStyle(1,0xff0000);
				g.drawRect(pos.x,pos.y,currentTarget.width,currentTarget.height);
			}
			g.endFill();
		}
		/**
		 * 当前鼠标下的对象
		 */		
		private var currentTarget:DisplayObject;
		/**
		 * 鼠标经过
		 */		
		private function onMouseOver(event:MouseEvent):void
		{
			if(contains(event.target as DisplayObject))
				return;
			currentTarget = event.target as DisplayObject;
			invalidateDisplayList();
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			if(contains(event.target as DisplayObject))
				return;
			currentTarget = null;
			invalidateDisplayList();
		}
	}
}