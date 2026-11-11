package lbg.savetofile 
{
	/**
	 * ...
	 * @author 
	 */
	public class FileData extends Object 
	{
		
		protected var _hash1:Boolean;
		protected var _hash2:Boolean;
		public var data:Object;
		
		public function FileData(data:Object, hash1:Boolean, hash2:Boolean) 
		{
			this.data = data;
			_hash1 = hash1;
			_hash2 = hash2;
		}
		
		/**
		 * True if the secretKey hash is the expected value
		 */
		public function get hash1():Boolean 
		{
			return _hash1;
		}
		
		
		/**
		 * True if the data hash is the same
		 */
		public function get hash2():Boolean 
		{
			return _hash2;
		}
		
	}

}