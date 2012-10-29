package org.flexlite.domUI.skins.vector
{
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	/**
	 * Alert默认皮肤
	 * @author DOM
	 */
	public class AlertSkin extends TitleWindowSkin
	{
		/**
		 * 构造函数
		 */		
		public function AlertSkin()
		{
			super();
			this.minHeight = 100;
			this.minWidth = 170;
			this.maxWidth = 310;
		}
		
		/**
		 * [SkinPart]文本内容显示对象
		 */		
		public var contentDisplay:Label;
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
		override protected function createChildren():void
		{
			super.createChildren();
			contentDisplay = new Label;
			contentDisplay.top = 30;
			contentDisplay.left = 1;
			contentDisplay.right = 1;
			contentDisplay.bottom = 36;
			contentDisplay.verticalAlign = VerticalAlign.MIDDLE;
			contentDisplay.textAlign = TextFormatAlign.CENTER;
			contentDisplay.paddingBottom = 10;
			contentDisplay.paddingTop = 10;
			contentDisplay.paddingLeft = 10;
			contentDisplay.paddingRight = 10;
			contentDisplay.selectable = true;
			addElementAt(contentDisplay,0);
			
			var hGroup:Group = new Group;
			hGroup.bottom = 10;
			hGroup.horizontalCenter = 0;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.gap = 10;
			layout.paddingLeft = layout.paddingRight = 20;
			hGroup.layout = layout;
			addElement(hGroup);
			
			okButton = new Button();
			okButton.label = "确定";
			hGroup.addElement(okButton);
			yesButton = new Button();
			yesButton.label = "是";
			hGroup.addElement(yesButton);
			noButton = new Button();
			noButton.label = "否";
			hGroup.addElement(noButton);
			cancelButton = new Button();
			cancelButton.label = "取消";
			hGroup.addElement(cancelButton);
		}
	}
}