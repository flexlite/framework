package code.app.mvc
{
	import flash.events.Event;
	
	/**
	 * 命令基类
	 * @author dom
	 */
	public class Command extends Event
	{
		/**
		 * 构造函数
		 * @param type 命令类型字符串
		 * @param data 命令携带的数据
		 */		
		public function Command(type:String,data:*)
		{
			super(type,false,true);
			this.data = data;
		}
		/**
		 * 命令携带的数据
		 */		
		public var data:*;
		
		override public function clone():Event
		{
			return new Command(type,data);
		}
	}
}