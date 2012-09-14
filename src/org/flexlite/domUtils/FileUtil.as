<<<<<<< HEAD
package org.flexlite.domUtils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 常用文件操作方法工具类
	 * @author DOM
	 */
	public class FileUtil
	{
		/**
		 * 保存数据到指定文件，返回是否保存成功
		 * @param path 文件完整路径名
		 * @param data 要保存的数据
		 */		
		public static function save(path:String,data:Object):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.exists)
			{//如果存在，先删除，防止出现文件名大小写不能覆盖的问题
				deletePath(file.nativePath);
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			try
			{
				if(data is ByteArray)
				{
					fs.writeBytes(data as ByteArray);
				}
				else if(data is String)
				{
					fs.writeUTFBytes(data as String);
				}
				else
				{
					fs.writeObject(data);
				}
			}
			catch(e:Error)
			{
				fs.close();
				return false;
			}
			fs.close();
			return true;
		}
		
		/**
		 * 打开文件的简便方法,返回打开的FileStream对象，若打开失败，返回null。
		 * @param path 要打开的文件路径
		 */		
		public static function open(path:String):FileStream
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file,FileMode.READ);
			}
			catch(e:Error)
			{
				return null;
			}
			return fs;
		}
		/**
		 * 打开文本文件的简便方法,返回打开文本的内容，若失败，返回"".
		 * @param path 要打开的文件路径
		 */	
		public static function openAsString(path:String):String
		{
			var fs:FileStream = open(path);
			if(!fs)
				return "";
			fs.position = 0;
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return content;
		}
		
		/**
		 * 打开浏览文件对话框
		 * @param onSelect 回调函数：单个文件或单个目录：onSelect(file:File);多个文件：onSelect(fileList:Array)
		 * @param type 浏览类型：1：选择单个文件，2：选择多个文件，3：选择目录 
		 * @param typeFilter 文件类型过滤数组
		 * @param title 对话框标题
		 * @param defaultPath 默认路径
		 */		
		public static function browseForOpen(onSelect:Function,type:int=1,typeFilter:Array=null,title:String="浏览文件",defaultPath:String=""):void
		{
			var file:File;
			if(defaultPath=="")
				file = new File;
			else
				file = File.applicationDirectory.resolvePath(defaultPath);
			switch(type)
			{
				case 1:
					file.addEventListener(Event.SELECT,function(e:Event):void{
						onSelect(e.target as File);
					});
					file.browseForOpen(title,typeFilter);
					break;
				case 2:
					file.addEventListener(FileListEvent.SELECT_MULTIPLE,function(e:FileListEvent):void{
						onSelect(e.files);
					});
					file.browseForOpenMultiple(title,typeFilter);
					break;
				case 3:
					file.addEventListener(Event.SELECT,function(e:Event):void{
						onSelect(e.target as File);
					});
					file.browseForDirectory(title);
					break;
			}
		}
		
		/**
		 * 打开保存文件对话框,选择要保存的路径。要同时保存数据请使用browsewAndSave()方法。
		 * @param onSelect 回调函数：onSelect(file:File)
		 * @param defaultPath 默认路径
		 * @param title 对话框标题
		 */		
		public static function browseForSave(onSelect:Function,defaultPath:String=null,title:String="保存文件"):void
		{
			var file:File
			if(defaultPath!=null)
				file = new File(File.applicationDirectory.resolvePath(defaultPath).nativePath);
			else
				file = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				onSelect(e.target as File);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 打开保存文件对话框，并保存数据。
		 * @param data
		 * @param onSelect 回调函数：onSelect(file:File)
		 * @param title 对话框标题
		 */		
		public static function browsewAndSave(data:Object,defaultPath:String=null,title:String="保存文件"):void
		{
			var file:File
			if(defaultPath!=null)
				file = new File(File.applicationDirectory.resolvePath(defaultPath).nativePath);
			else
				file = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				save(file.nativePath,data);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 移动文件或目录,返回是否移动成功
		 * @param source 文件源路径
		 * @param dest 文件要移动到的目标路径
		 * @param overwrite 是否覆盖同名文件
		 */		
		public static function moveTo(source:String,dest:String,overwrite:Boolean=false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(source).nativePath);
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			try
			{
				file.moveTo(destFile,overwrite);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 复制文件或目录,返回是否复制成功
		 * @param source 文件源路径
		 * @param dest 文件要移动到的目标路径
		 * @param overwrite 是否覆盖同名文件
		 */	
		public static function copyTo(source:String,dest:String,overwrite:Boolean=false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(source).nativePath);
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			try
			{
				file.copyTo(destFile,overwrite);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 删除文件或目录，返回是否删除成功
		 * @param path 要删除的文件源路径
		 * @param moveToTrash 是否只是移动到回收站，默认false，直接删除。
		 */		
		public static function deletePath(path:String,moveToTrash:Boolean = false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(moveToTrash)
			{
				try
				{
					file.moveToTrash();
				}
				catch(e:Error)
				{
					return false;
				}
			}
			else
			{
				if(file.isDirectory)
				{
					try
					{
						file.deleteDirectory(true);
					}
					catch(e:Error)
					{
						return false;
					}
				}
				else
				{
					try
					{
						file.deleteFile();
					}
					catch(e:Error)
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 返回指定文件的父级文件夹路径，若自身已是文件夹则直接返回。返回字符串的结尾已包含分隔符。
		 */		
		public static function getDirectory(path:String):String
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.isDirectory)
				return file.nativePath+File.separator;
			path = file.nativePath;
			var index:int = path.lastIndexOf(File.separator);
			if(index==-1)
			{
				return "";
			}
			return path.substr(0,index+1);
		}
		/**
		 * 获取路径的文件名(不含扩展名)或文件夹名
		 */		
		public static function getFileName(path:String):String
		{
			if(path==null||path=="")
				return "";
			var startIndex:int = path.lastIndexOf("/");
			startIndex = Math.max(path.lastIndexOf("\\"));
			var endIndex:int = path.lastIndexOf(".");
			if(endIndex==-1)
				endIndex = path.length;
			return path.substring(startIndex+1,endIndex);
		}
		
		/**
		 * 搜索指定文件夹及其子文件夹下所有的文件
		 * @param dir 要搜索的文件夹
		 * @param extension 要搜索的文件扩展名，例如："png"。不设置表示获取所有类型文件。注意：若设置了filterFunc，则忽略此参数。
		 * @param filterFunc 过滤函数：filterFunc(file:File):Boolean,返回true则加入结果列表。
		 */		
		public static function search(dir:String,extension:String=null,filterFunc:Function=null):Array
		{
			var file:File = new File(File.applicationDirectory.resolvePath(dir).nativePath);
			var result:Array = [];
			if(!file.isDirectory)
				return result;
			findFiles(file,result,extension,filterFunc);
			return result;
		}
		/**
		 * 递归搜索文件
		 */		
		private static function findFiles(dir:File,result:Array,
										  extension:String=null,filterFunc:Function=null):void
		{
			var fileList:Array = dir.getDirectoryListing();
			for each(var file:File in fileList)
			{
				if(file.isDirectory)
				{
					findFiles(file,result,extension,filterFunc);
				}
				else if(filterFunc!=null)
				{
					if(filterFunc(file))
					{
						result.push(file);
					}
				}
				else if(extension!=null)
				{
					if(file.extension == extension)
					{
						result.push(file);
					}
				}
				else
				{
					result.push(file);
				}
			}
		}
		
		/**
		 * 将url转换为本地路径
		 */		
		public static function url2Path(url:String):String
		{
			return File.applicationDirectory.resolvePath(url).nativePath;
		}
	}
=======
package org.flexlite.domUtils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 常用文件操作方法工具类
	 * @author DOM
	 */
	public class FileUtil
	{
		/**
		 * 保存数据到指定文件，返回是否保存成功
		 * @param path 文件完整路径名
		 * @param data 要保存的数据
		 */		
		public static function save(path:String,data:Object):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.exists)
			{//如果存在，先删除，防止出现文件名大小写不能覆盖的问题
				deletePath(file.nativePath);
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			try
			{
				if(data is ByteArray)
				{
					fs.writeBytes(data as ByteArray);
				}
				else if(data is String)
				{
					fs.writeUTFBytes(data as String);
				}
				else
				{
					fs.writeObject(data);
				}
			}
			catch(e:Error)
			{
				fs.close();
				return false;
			}
			fs.close();
			return true;
		}
		
		/**
		 * 打开文件的简便方法,返回打开的FileStream对象，若打开失败，返回null。
		 * @param path 要打开的文件路径
		 */		
		public static function open(path:String):FileStream
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file,FileMode.READ);
			}
			catch(e:Error)
			{
				return null;
			}
			return fs;
		}
		/**
		 * 打开文本文件的简便方法,返回打开文本的内容，若失败，返回"".
		 * @param path 要打开的文件路径
		 */	
		public static function openAsString(path:String):String
		{
			var fs:FileStream = open(path);
			if(!fs)
				return "";
			fs.position = 0;
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return content;
		}
		
		/**
		 * 打开浏览文件对话框
		 * @param onSelect 回调函数：单个文件或单个目录：onSelect(file:File);多个文件：onSelect(fileList:Array)
		 * @param type 浏览类型：1：选择单个文件，2：选择多个文件，3：选择目录 
		 * @param typeFilter 文件类型过滤数组
		 * @param title 对话框标题
		 * @param defaultPath 默认路径
		 */		
		public static function browseForOpen(onSelect:Function,type:int=1,typeFilter:Array=null,title:String="浏览文件",defaultPath:String=""):void
		{
			var file:File;
			if(defaultPath=="")
				file = new File;
			else
				file = File.applicationDirectory.resolvePath(defaultPath);
			switch(type)
			{
				case 1:
					file.addEventListener(Event.SELECT,function(e:Event):void{
						onSelect(e.target as File);
					});
					file.browseForOpen(title,typeFilter);
					break;
				case 2:
					file.addEventListener(FileListEvent.SELECT_MULTIPLE,function(e:FileListEvent):void{
						onSelect(e.files);
					});
					file.browseForOpenMultiple(title,typeFilter);
					break;
				case 3:
					file.addEventListener(Event.SELECT,function(e:Event):void{
						onSelect(e.target as File);
					});
					file.browseForDirectory(title);
					break;
			}
		}
		
		/**
		 * 打开保存文件对话框,选择要保存的路径。要同时保存数据请使用browsewAndSave()方法。
		 * @param onSelect 回调函数：onSelect(file:File)
		 * @param defaultPath 默认路径
		 * @param title 对话框标题
		 */		
		public static function browseForSave(onSelect:Function,defaultPath:String=null,title:String="保存文件"):void
		{
			var file:File
			if(defaultPath!=null)
				file = new File(File.applicationDirectory.resolvePath(defaultPath).nativePath);
			else
				file = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				onSelect(e.target as File);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 打开保存文件对话框，并保存数据。
		 * @param data
		 * @param onSelect 回调函数：onSelect(file:File)
		 * @param title 对话框标题
		 */		
		public static function browsewAndSave(data:Object,defaultPath:String=null,title:String="保存文件"):void
		{
			var file:File
			if(defaultPath!=null)
				file = new File(File.applicationDirectory.resolvePath(defaultPath).nativePath);
			else
				file = new File;
			file.addEventListener(Event.SELECT,function(e:Event):void{
				save(file.nativePath,data);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 移动文件或目录,返回是否移动成功
		 * @param source 文件源路径
		 * @param dest 文件要移动到的目标路径
		 * @param overwrite 是否覆盖同名文件
		 */		
		public static function moveTo(source:String,dest:String,overwrite:Boolean=false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(source).nativePath);
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			try
			{
				file.moveTo(destFile,overwrite);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 复制文件或目录,返回是否复制成功
		 * @param source 文件源路径
		 * @param dest 文件要移动到的目标路径
		 * @param overwrite 是否覆盖同名文件
		 */	
		public static function copyTo(source:String,dest:String,overwrite:Boolean=false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(source).nativePath);
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			try
			{
				file.copyTo(destFile,overwrite);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 删除文件或目录，返回是否删除成功
		 * @param path 要删除的文件源路径
		 * @param moveToTrash 是否只是移动到回收站，默认false，直接删除。
		 */		
		public static function deletePath(path:String,moveToTrash:Boolean = false):Boolean
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(moveToTrash)
			{
				try
				{
					file.moveToTrash();
				}
				catch(e:Error)
				{
					return false;
				}
			}
			else
			{
				if(file.isDirectory)
				{
					try
					{
						file.deleteDirectory(true);
					}
					catch(e:Error)
					{
						return false;
					}
				}
				else
				{
					try
					{
						file.deleteFile();
					}
					catch(e:Error)
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 返回指定文件的父级文件夹路径，若自身已是文件夹则直接返回。返回字符串的结尾已包含分隔符。
		 */		
		public static function getDirectory(path:String):String
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.isDirectory)
				return file.nativePath+File.separator;
			path = file.nativePath;
			var index:int = path.lastIndexOf(File.separator);
			if(index==-1)
			{
				return "";
			}
			return path.substr(0,index+1);
		}
		/**
		 * 获取路径的文件名(不含扩展名)或文件夹名
		 */		
		public static function getFileName(path:String):String
		{
			if(path==null||path=="")
				return "";
			var startIndex:int = path.lastIndexOf("/");
			startIndex = Math.max(path.lastIndexOf("\\"));
			var endIndex:int = path.lastIndexOf(".");
			if(endIndex==-1)
				endIndex = path.length;
			return path.substring(startIndex+1,endIndex);
		}
		
		/**
		 * 搜索指定文件夹及其子文件夹下所有的文件
		 * @param dir 要搜索的文件夹
		 * @param extension 要搜索的文件扩展名，例如："png"。不设置表示获取所有类型文件。注意：若设置了filterFunc，则忽略此参数。
		 * @param filterFunc 过滤函数：filterFunc(file:File):Boolean,返回true则加入结果列表。
		 */		
		public static function search(dir:String,extension:String=null,filterFunc:Function=null):Array
		{
			var file:File = new File(File.applicationDirectory.resolvePath(dir).nativePath);
			var result:Array = [];
			if(!file.isDirectory)
				return result;
			findFiles(file,result,extension,filterFunc);
			return result;
		}
		/**
		 * 递归搜索文件
		 */		
		private static function findFiles(dir:File,result:Array,
										  extension:String=null,filterFunc:Function=null):void
		{
			var fileList:Array = dir.getDirectoryListing();
			for each(var file:File in fileList)
			{
				if(file.isDirectory)
				{
					findFiles(file,result,extension,filterFunc);
				}
				else if(filterFunc!=null)
				{
					if(filterFunc(file))
					{
						result.push(file);
					}
				}
				else if(extension!=null)
				{
					if(file.extension == extension)
					{
						result.push(file);
					}
				}
				else
				{
					result.push(file);
				}
			}
		}
		
		/**
		 * 将url转换为本地路径
		 */		
		public static function url2Path(url:String):String
		{
			return File.applicationDirectory.resolvePath(url).nativePath;
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}