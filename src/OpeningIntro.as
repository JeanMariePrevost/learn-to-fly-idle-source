package src
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author
	 */
	public class OpeningIntro extends MovieClip
	{
		public var btnSkip:SimpleButton;

		public function OpeningIntro()
		{
			super();
			btnSkip.addEventListener(MouseEvent.CLICK, skipIntro);

		}

		private function skipIntro(e:Event):void
		{
			gotoAndPlay("end");
		}

	}

}
