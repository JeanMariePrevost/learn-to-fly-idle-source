package lbg.savetofile 
{
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.hurlant.util.Base64;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import lbg.utils.Serialize;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class SaveToFile 
	{
		
		//public static var fileLoadedSignal:Signal = new Signal(Object);
		//protected static var _loadFileRef:FileReference;
		
		
		public static function saveToFile(obj:Object, fileName:String = "Data.txt", secretKey:String = ""):void {
			var ba:ByteArray = new ByteArray();
			
			var hash1:String = MD5.hash(secretKey);
			
			ba.writeUTF(hash1);
			ba.writeObject(obj);
			
			var dataString:String = Serialize.enumerateProperties(obj);
			
			var hash2:String = MD5.hash(dataString);
			
			ba.writeUTF(hash2);
			
			ba.compress();
			
			var fileRef:FileReference = new FileReference();
			fileRef.save(ba, fileName);
		}
		
		public static function loadFromFile(secretKey:String):Signal {
			var fileRef:FileReference = new FileReference();
			var loadSignal:Signal = new Signal(FileData);
			
			function fileSelected(e:Event):void {
				fileRef.removeEventListener(Event.SELECT, fileSelected);
				
				fileRef.load();
				
				fileRef.addEventListener(Event.COMPLETE, fileLoaded);
			}
			
			function fileLoaded(e:Event):void {
				fileRef.removeEventListener(Event.COMPLETE, fileLoaded);
				
				fileRef.data.uncompress();
				var keyHash:String = fileRef.data.readUTF();
				var saveData:Object = fileRef.data.readObject();
				var dataHash:String = fileRef.data.readUTF();
				
				var test1:Boolean = (keyHash == MD5.hash(secretKey));
				
				var dataString:String = Serialize.enumerateProperties(saveData);
				var test2:Boolean = (dataHash == MD5.hash(dataString));
				
				var fileData:FileData = new FileData(saveData, test1, test2);
				
				loadSignal.dispatch(fileData);
			}
			
			fileRef.addEventListener(Event.SELECT, fileSelected);
			fileRef.browse([new FileFilter("Learn To Fly Idle save","*.sav")]);
			return loadSignal;
		}
		
	}

}