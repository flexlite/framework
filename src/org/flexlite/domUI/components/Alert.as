package org.flexlite.domUI.components
{
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.core.IDisplayText;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.managers.PopUpManager;
	
	/**
	 * 弹出对话框，可能包含消息、标题、按钮（“确定”、“取消”、“是”和“否”的任意组合)。
	 * @author DOM
	 */
	public class Alert extends TitleWindow
	{
		/**
		 * 当对话框关闭时，closeEvent.detail的值若等于此属性,表示被点击的按钮为firstButton。
		 */		
		public static const FIRST_BUTTON:String = "firstButton";
		/**
		 * 当对话框关闭时，closeEvent.detail的值若等于此属性,表示被点击的按钮为secondButton。
		 */		
		public static const SECOND_BUTTON:String = "secondButton";
		/**
		 * 当对话框关闭时，closeEvent.detail的值若等于此属性,表示被点击的按钮为closeButton。
		 */		
		public static const CLOSE_BUTTON:String = "closeButton";
		
		/**
		 * 弹出Alert控件的静态方法。在Alert控件中选择一个按钮，将关闭该控件。
		 * @param text 要显示的文本内容字符串。
		 * @param title 对话框标题
		 * @param closeHandler 按下Alert控件上的任意按钮时的回调函数。示例:closeHandler(event:CloseEvent);
		 * event的detail属性包含 Alert.FIRST_BUTTON、Alert.SECOND_BUTTON和Alert.CLOSE_BUTTON。
		 * @param firstButtonLabel 第一个按钮上显示的文本。
		 * @param secondButtonLabel 第二个按钮上显示的文本，若为null，则不显示第二个按钮。
		 * @param modal 是否启用模态。即禁用弹出层以下的鼠标事件。默认true。
		 * @return 弹出的对话框实例的引用
		 */		
		public static function show(text:String="",title:String="",closeHandler:Function=null,
									firstButtonLabel:String="确定",secondButtonLabel:String="",
									modal:Boolean=true,center:Boolean=true):Alert
		{
			var alert:Alert = new Alert();
			alert.contentText = text;
			alert.title = title;
			alert._firstButtonLabel = firstButtonLabel;
			alert._secondButtonLabel = secondButtonLabel;
			alert.closeHandler = closeHandler;
			PopUpManager.addPopUp(alert,modal);
			return alert;
		}
		/**
		 * 构造函数，请通过静态方法Alert.show()来创建对象实例。
		 */		
		public function Alert()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Alert;
		}
		private var _firstButtonLabel:String = "";
		/**
		 * 第一个按钮上显示的文本
		 */
		public function get firstButtonLabel():String
		{
			return _firstButtonLabel;
		}
		public function set firstButtonLabel(value:String):void
		{
			if(_firstButtonLabel==value)
				return;
			_firstButtonLabel = value;
			if(firstButton)
				firstButton.label = value;
		}

		private var _secondButtonLabel:String = "";
		/**
		 * 第二个按钮上显示的文本
		 */
		public function get secondButtonLabel():String
		{
			return _secondButtonLabel;
		}
		public function set secondButtonLabel(value:String):void
		{
			if(_secondButtonLabel==value)
				return;
			_secondButtonLabel = value;
			if(secondButton)
			{
				if(value==null||value=="")
					secondButton.includeInLayout = secondButton.visible
						= (_secondButtonLabel!=""&&_secondButtonLabel!=null);
			}
		}

		
		private var _contentText:String = "";
		/**
		 * 文本内容
		 */
		public function get contentText():String
		{
			return _contentText;
		}
		public function set contentText(value:String):void
		{
			if(_contentText==value)
				return;
			_contentText = value;
			if(contentDisplay)
				contentDisplay.text = value;
		}
		/**
		 * 对话框关闭回调函数
		 */
		private var closeHandler:Function;
		/**
		 * 关闭事件
		 */		
		private function onClose(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
			if(closeHandler!=null)
			{
				var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
				switch(event.currentTarget)
				{
					case firstButton:
						closeEvent.detail = Alert.FIRST_BUTTON;
						break;
					case secondButton:
						closeEvent.detail = Alert.SECOND_BUTTON;
						break;
				}
				closeHandler(closeEvent);
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function closeButton_clickHandler(event:MouseEvent):void
		{
			super.closeButton_clickHandler(event);
			PopUpManager.removePopUp(this);
			var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE,false,false,Alert.CLOSE_BUTTON);
			if(closeHandler!=null)
				closeHandler(closeEvent);
		}
		
		/**
		 * [SkinPart]文本内容显示对象
		 */		
		public var contentDisplay:IDisplayText;
		/**
		 * [SkinPart]第一个按钮，通常是"确定"。
		 */		
		public var firstButton:Button;
		/**
		 * [SkinPart]第二个按钮，通常是"取消"。
		 */		
		public var secondButton:Button;
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance==contentDisplay)
			{
				contentDisplay.text = _contentText;
			}
			else if(instance==firstButton)
			{
				firstButton.label = _firstButtonLabel;
				firstButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==secondButton)
			{
				secondButton.label = _secondButtonLabel;
				secondButton.includeInLayout = secondButton.visible
					= (_secondButtonLabel!=""&&_secondButtonLabel!=null);
				secondButton.addEventListener(MouseEvent.CLICK,onClose);
			}
		}
		/**
		 * @inheritDoc
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance==firstButton)
			{
				firstButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==secondButton)
			{
				secondButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
		}
	}
}