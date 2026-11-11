package src 
{
	import lbg.audio.SoundManager;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Audio 
	{
		protected static var soundManager:SoundManager = new SoundManager();
		protected static var _mute:Boolean = false;
		protected static var _volume:Number = 1;
		protected static var _track:Number = 1;
		
		public static function stopAll():void {
			soundManager.stopAllSounds();
		}
		
		public static function playLbgTheme():void {
			if (mute) return;
			soundManager.playSound(new AudioLbg(), false, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm1():void {
			_track = 1;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm1(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm2():void {
			_track = 2;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm2(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm3():void {
			_track = 3;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm3(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm4():void {
			_track = 4;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm4(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm5():void {
			_track = 5;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm5(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm6():void {
			_track = 6;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm6(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm7():void {
			_track = 7;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm7(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm8():void {
			_track = 8;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm8(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm9():void {
			_track = 9;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm9(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function playBgm0():void {
			_track = 10;
			if (mute) return;
			soundManager.stopAllSounds();
			soundManager.playSound(new Bgm0(), true, "bgm");
			soundManager.setVolume(_volume);
		}
		
		public static function setVolume(volume:Number = 1):void {
			_volume = NumberUtils.constrain(volume, 0, 1);
			soundManager.setVolume(_volume);
		}
		
		static public function get volume():Number 
		{
			return _volume;
		}
		
		static public function get track():Number 
		{
			return _track;
		}
		
		static public function get mute():Boolean 
		{
			return _mute;
		}
		
		static public function set mute(value:Boolean):void 
		{
			var old:Boolean = _mute;
			_mute = value;
			if (!old && value) {
				stopAll();
			}else if (old && !value) {
				playTrackFromNumer(_track);
			}
		}
		
		public static function playTrackFromNumer(track:Number):void {
			switch(track) {
				case 1:
					Audio.playBgm1();
					break;
				case 2:
					Audio.playBgm2();
					break;
				case 3:
					Audio.playBgm3();
					break;
				case 4:
					Audio.playBgm4();
					break;
				case 5:
					Audio.playBgm5();
					break;
				case 6:
					Audio.playBgm6();
					break;
				case 7:
					Audio.playBgm7();
					break;
				case 8:
					Audio.playBgm8();
					break;
				case 9:
					Audio.playBgm9();
					break;
				case 10:
					Audio.playBgm0();
					break;
				default:
					Audio.playBgm1();
					break;
			}
		}
		
	}

}