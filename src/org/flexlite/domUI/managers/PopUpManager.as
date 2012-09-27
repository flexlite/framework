package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.core.IEffect;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.managers.impl.PopUpManagerImpl;
	
	/**
	 * 窗口弹出管理器
	 * @author DOM
	 */	
	public class PopUpManager
	{
		/**
		 * 构造函数
		 */		
		public function PopUpManager()
		{
		}
		
		private static var _impl:PopUpManagerImpl;
		/**
		 * 获取单例
		 */		
		private static function get impl():PopUpManagerImpl
		{
			if (!_impl)
			{
				_impl = new PopUpManagerImpl();
			}
			return _impl;
		}
		
		/**
		 * 弹出一个窗口,请调用 removePopUp()来移除使用 addPopUp()方法弹出的窗口。<br/>
		 * 注意：弹出层禁用了自动布局功能。所有相对位置属性在弹出层都是无效的。只能通过设置x,y绝对坐标来控制位置。
		 * @param popUp 要弹出的窗口显示对象
		 * @param modal 是否启用模态。禁用弹出层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。默认true。
		 * @param exclusive 是否独占。若为true，它总是不与任何窗口共存。当弹出时，将隐藏层级在它后面的所有窗口。
		 * 若有层级在它前面的窗口弹出，无论新窗口是否独占，都将它和它后面的窗口全部隐藏。默认为false。
		 * @param priority 弹出优先级。优先级高的窗口显示层级在低的前面。同一优先级的窗口，后添加的窗口层级在前面。
		 * @param popUpEffect 窗口弹出时要播放的动画特效。
		 */		
		public static function addPopUp(popUp:IVisualElement,modal:Boolean=false,center:Boolean=true,
										exclusive:Boolean=false,priority:int=0,
										popUpEffect:IEffect=null):void
		{
			impl.addPopUp(popUp,modal,center,exclusive,priority,popUpEffect);
		}
		
		/**
		 * 返回当前弹出并显示的窗口列表
		 */		
		public function get currentPopUps():Array
		{
			return impl.currentPopUps;
		}
		
		/**
		 * 设置指定的窗口位置居中。若窗口为多个，则将按水平排列窗口，并使其整体居中。
		 * @param popUps 要居中显示的窗口列表
		 * @param gap 若窗口为多个，此值为水平排列时的间隔
		 * @param offsetX 整体水平位置偏移量
		 * @param offsetY 整体竖直位置偏移量
		 */
		public static function centerPopUps(popUps:Array,gap:Number=5,offsetX:Number=0,offsetY:Number=0):void
		{
			impl.centerPopUps(popUps,gap,offsetX,offsetY);
		}
		/**
		 * 移除由addPopUp()方法弹出的窗口。
		 * @param popUp 要移除的窗口
		 */		
		public static function removePopUp(popUp:IVisualElement):void
		{
			impl.removePopUp(popUp);
		}
	}
}