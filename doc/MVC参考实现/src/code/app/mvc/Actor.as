package code.app.mvc
{
	import code.app.CommonData;
	import code.app.CommonView;
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 命令总线通讯基类
	 * @author dom
	 */
	public class Actor
	{
		/**
		 * 构造函数
		 */		
		public function Actor()
		{
		}
		
		/**
		 * 命令总线实例
		 */		
		private static var _context:Context = Context.getInstance();
		/**
		 * 舞台引用
		 */
		public function get stage():Stage
		{
			return _context.stage;
		}
		
		/**
		 * 公共数据
		 */
		public function get commonData():CommonData
		{
			return _context.commonData;
		}
		
		/**
		 * 公共视图
		 */		
		public function get commonView():CommonView
		{
			return _context.commonView;
		}


		
		//=====================事件总线实现=======================
		/**
		 * 添加命令监听
		 * @param type 命令类型字符串
		 * @param listener 回调函数
		 * @param priority 命令优先级。值越大越优先触发,可以负值，默认值为0。
		 */			
		public function addCommand(type:String,listener:Function,priority:int=0):void
		{
			_context.addEventListener(type,listener,false,priority,true);
		}
		/**
		 * 移除命令监听
		 * @param type 命令类型字符串
		 * @param listener 回调函数
		 */		
		public function removeCommand(type:String,listener:Function):void
		{
			_context.removeEventListener(type,listener);
		}
		/**
		 * 总线上是否添加过指定命令类型的监听
		 * @param type 命令类型字符串
		 */		
		public function hasCommand(type:String):Boolean
		{
			return _context.hasEventListener(type);
		}
		/**
		 * 抛出一个命令
		 * @param command 要抛出的命令
		 * @return 若command.preventDefault()方法被执行，则返回false。
		 */		
		public function dispatch(command:Command):Boolean
		{
			return _context.dispatchEvent(command);
		}
		
		
		//====================失效验证机制实现======================
		/**
		 * EnterFrame事件抛出对象
		 */		
		private static var enterFrameSp:Shape = new Shape;
		/**
		 * 添加过事件监听的标志
		 */		
		private static var listenForEnterFrame:Boolean = false;
		/**
		 * 标记为失效的Actor列表
		 */		
		private static var invalidateActors:Vector.<Actor> = new Vector.<Actor>();
		/**
		 * EnterFrame事件触发
		 */		
		private static function onCallBack(event:Event):void
		{
			listenForEnterFrame = false;
			enterFrameSp.removeEventListener(Event.ENTER_FRAME,onCallBack);
			if(_context.stage)
			{
				_context.stage.removeEventListener(Event.RENDER,onCallBack);
			}
			var list:Vector.<Actor> = invalidateActors;
			invalidateActors = new Vector.<Actor>();
			var actor:Actor;
			while(list.length>0)
			{
				list.shift().validateProperties();
			}
		}
		/**
		 * 标记属性失效
		 */		
		private static function invalidateActor(actor:Actor):void
		{
			invalidateActors.push(actor);
			if(listenForEnterFrame)
				return;
			listenForEnterFrame = true;
			enterFrameSp.addEventListener(Event.ENTER_FRAME,onCallBack);
			var stage:Stage = _context.stage;
			if(stage)
			{
				stage.addEventListener(Event.RENDER,onCallBack);
				stage.invalidate();
			}
		}
		/**
		 * 属性失效的标志
		 */		
		private var invalidatePropertiesFlag:Boolean = false;
		/**
		 * 标记属性失效
		 */		
		public function invalidateProperties():void
		{
			if(invalidatePropertiesFlag)
				return;
			invalidatePropertiesFlag = true;
			invalidateActor(this);
		}
		/**
		 * 立即执行验证
		 */				
		public function validateProperties():void
		{
			if (invalidatePropertiesFlag)
			{
				commitProperties();
				invalidatePropertiesFlag = false;
			}
		}
		/**
		 * 验证失效的属性
		 */		
		protected function commitProperties():void
		{
			
		}
		
	}
}