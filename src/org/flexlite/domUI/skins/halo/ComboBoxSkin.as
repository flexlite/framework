package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.SkinnableElement;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	[DXML(show="false")]
	
	/**
	 * 
	 * @author DOM
	 */
	public class ComboBoxSkin extends Skin
	{
		public function ComboBoxSkin()
		{
			super();
			this.states = ["normal","open"];
		}
		
		override protected function createChildren():void
		{
			dropDown = new Group;
			var dropDownBorder:SkinnableElement = new SkinnableElement();
			dropDownBorder.skinName = dropDownBorderSkin;
			dropDown.addElement(dropDownBorder);
			dataGroup = new DataGroup;
			dropDown.addElement(dataGroup);
			addElement(dropDown);
			
			openButton = new Button;
			var buttonSkin:ButtonSkin = new ButtonSkin;
			buttonSkin.upSkin = openButtonUpSkin;
			buttonSkin.overSkin = openButtonOverSkin;
			buttonSkin.downSkin = openButtonDownSkin;
			openButton.skinName = buttonSkin;
			addElement(openButton);
			
			textInput = new TextInput;
			textInput.skinName = textInputBorderSkin;
			addElement(textInput);
		}
		
		public var dataGroup:DataGroup;
		
		public var dropDown:Group;
		
		public var openButton:Button;
		
		public var textInput:TextInput;
		
		private var _dropDownBorderSkin:Object;
		/**
		 * 下拉框背景皮肤
		 */
		public function get dropDownBorderSkin():Object
		{
			return _dropDownBorderSkin;
		}
		public function set dropDownBorderSkin(value:Object):void
		{
			_dropDownBorderSkin = value;
		}
		
		private var _openButtonUpSkin:Object;
		/**
		 * 下拉按钮up状态皮肤
		 */
		public function get openButtonUpSkin():Object
		{
			return _openButtonUpSkin;
		}
		public function set openButtonUpSkin(value:Object):void
		{
			_openButtonUpSkin = value;
		}

		private var _openButtonOverSkin:Object;
		/**
		 * 下拉按钮over状态皮肤
		 */
		public function get openButtonOverSkin():Object
		{
			return _openButtonOverSkin;
		}
		public function set openButtonOverSkin(value:Object):void
		{
			_openButtonOverSkin = value;
		}

		private var _openButtonDownSkin:Object;
		/**
		 * 下拉按钮down状态皮肤
		 */
		public function get openButtonDownSkin():Object
		{
			return _openButtonDownSkin;
		}
		public function set openButtonDownSkin(value:Object):void
		{
			_openButtonDownSkin = value;
		}

		private var _textInputBorderSkin:Object;
		/**
		 * 输入框背景皮肤
		 */
		public function get textInputBorderSkin():Object
		{
			return _textInputBorderSkin;
		}
		public function set textInputBorderSkin(value:Object):void
		{
			_textInputBorderSkin = value;
		}
		
		
	}
}