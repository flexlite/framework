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
		 * 作为 show() 方法的 flags 参数传递时，在 Alert 控件上启用“是”按钮的值。
		 * 您可以使用 | 运算符将此位标志与 OK、CANCEL、NO 和 CLOSE 标志结合使用。
		 */		
		public static const YES:uint = 0x0001;
		/**
		 * 作为 show() 方法的 flags 参数传递时，在 Alert 控件上启用“否”按钮的值。
		 * 您可以使用 | 运算符将此位标志与 OK、CANCEL、YES 和 CLOSE 标志结合使用。
		 */		
		public static const NO:uint = 0x0002;
		/**
		 * 作为 show() 方法的 flags 参数传递时，在 Alert 控件上启用“确定”按钮的值。
		 * 您可以使用 | 运算符将此位标志与 CANCEL、YES、NO 和 CLOSE 标志结合使用。
		 */		
		public static const OK:uint = 0x0004;
		/**
		 * 作为 show() 方法的 flags 参数传递时，在 Alert 控件上启用“取消”按钮的值。
		 * 您可以使用 | 运算符将此位标志与 OK、YES、NO 和 CLOSE 标志结合使用。
		 */		
		public static const CANCEL:uint= 0x0008;
		/**
		 * 作为 show() 方法的 flags 参数传递时，在 Alert 控件上启用"关闭"按钮的值。
		 * 您可以使用 | 运算符将此位标志与 OK、YES、NO 和 CANCEL标志结合使用。
		 */		
		public static const CLOSE:uint = 0x0010;
		
		/**
		 * 弹出Alert控件的静态方法。在Alert控件中选择一个按钮，将关闭该控件。
		 * @param text 要显示的文本内容字符串。
		 * @param title 对话框标题
		 * @param flags Alert控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES、Alert.NO 和  Alert.CLOSE。
		 * 使用按位 OR 运算符可显示多个按钮。例如，传递 (Alert.YES | Alert.NO) 显示“是”和“否”按钮。默认值为:Alert.OK|Alert.CLOSE。
		 * @param closeHandler 按下Alert控件上的任意按钮时的回调函数。示例:closeHandler(event:CloseEvent);
		 * event的detail属性包含 Alert.OK、Alert.CANCEL、Alert.YES、Alert.NO或 Alert.CLOSE值。
		 * @param modal 是否启用模态。即禁用弹出层以下的鼠标事件。默认true。
		 * @return 弹出的对话框实例的引用
		 */		
		public static function show(text:String="",title:String="",flags:uint=0x0014,
									closeHandler:Function=null,modal:Boolean=true):Alert
		{
			var alert:Alert = new Alert();
			alert.contentText = text;
			alert.title = title;
			alert.buttonFlags = flags;
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
		/**
		 * 应该放置哪些按钮的标志。
		 */		
		private var buttonFlags:uint = Alert.OK;
		
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
					case okButton:
						closeEvent.detail = Alert.OK;
						break;
					case yesButton:
						closeEvent.detail = Alert.YES;
						break;
					case noButton:
						closeEvent.detail = Alert.NO;
						break;
					case cancelButton:
						closeEvent.detail = Alert.CANCEL;
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
			var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE,false,false,Alert.CLOSE);
			if(closeHandler!=null)
				closeHandler(closeEvent);
		}
		
		/**
		 * [SkinPart]文本内容显示对象
		 */		
		public var contentDisplay:IDisplayText;
		/**
		 * [SkinPart]"确定"按钮
		 */		
		public var okButton:Button;
		/**
		 * [SkinPart]"是"按钮
		 */		
		public var yesButton:Button;
		/**
		 * [SkinPart]"否"按钮
		 */		
		public var noButton:Button;
		/**
		 * [SkinPart]"取消"按钮
		 */		
		public var cancelButton:Button;
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
			else if(instance==okButton)
			{
				okButton.includeInLayout = okButton.visible = Boolean(buttonFlags&Alert.OK);
				okButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==yesButton)
			{
				yesButton.includeInLayout = yesButton.visible = Boolean(buttonFlags&Alert.YES);
				yesButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==noButton)
			{
				noButton.includeInLayout = noButton.visible = Boolean(buttonFlags&Alert.NO);
				noButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==cancelButton)
			{
				cancelButton.includeInLayout = cancelButton.visible = Boolean(buttonFlags&Alert.CANCEL);
				cancelButton.addEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==closeButton)
			{
				closeButton.visible = Boolean(buttonFlags&Alert.CLOSE);
			}
		}
		/**
		 * @inheritDoc
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance==okButton)
			{
				okButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==yesButton)
			{
				yesButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==noButton)
			{
				noButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
			else if(instance==cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK,onClose);
			}
		}
	}
}