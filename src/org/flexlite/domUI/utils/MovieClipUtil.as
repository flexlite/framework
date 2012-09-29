package org.flexlite.domUI.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.IMovieClip;
	
	/**
	 * 影片剪辑工具类
	 * @author DOM
	 */
	public class MovieClipUtil
	{
		/**
		 * 获取状态列表对应的帧索引字典类
		 */		
		public static function getFrameDic(skin:Object,stateList:Array):Dictionary
		{
			var mc:MovieClip = skin as MovieClip;
			var dxrMc:IMovieClip = skin as IMovieClip;
			var totalFrames:int = mc?mc.totalFrames:dxrMc.totalFrames;
			var frameDic:Dictionary = new Dictionary;
			var state:String;
			var index:int;
			if(totalFrames < stateList.length)
			{
				for each(state in stateList)
				{
					frameDic[state] = mc?1:0;
				}
				return frameDic;
			}
			
			var frameLabelV:Array = mc?mc.currentLabels:dxrMc.frameLabels;
			if(frameLabelV == null || frameLabelV.length == 0)
			{
				index = 0;
				for each(state in stateList)
				{
					index++;
					frameDic[state] = mc?index:index-1;
				}
				return frameDic;
			}
			
			index = 0
			for each(state in stateList)
			{
				index++;
				frameDic[state] = getFrameByLabel(state,frameLabelV,mc?index:index-1);
			}
			return frameDic;
		}
		
		/**
		 * 检查标签列表里是否含有指定的标签,若含有，返回对应的帧索引，若不存在，返回传入的defualtFrame值
		 */		
		private static function getFrameByLabel(fname:String,frameLabelV:Array,defualtFrame:int):int
		{
			for each(var frameLabel:FrameLabel in frameLabelV) 
			{
				if(frameLabel.name == fname)
				{
					return frameLabel.frame;
				}
			}
			return defualtFrame;
		}
	}
}