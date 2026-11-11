package src 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import lbg.utils.DisplayObjectUtil;
	/**
	 * ...
	 * @author 
	 */
	public class Cloud extends Sprite
	{
		protected const CLOUD_COUNT:uint = 15;
		public var clouds:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		public function Cloud() 
		{
			for (var i:int = 0; i < CLOUD_COUNT; i++) {
				var c:MovieClip = new Clouds();
				clouds.push(c);
				addChild(c);
				resetCloud(c, true);
			}
			
			Main.phase1.add(tick);
		}
		
		private function tick(delta:Number):void 
		{
			for each(var c:MovieClip in clouds) {
				c.x += c.speed * delta;
				if (c.x <= -500) {
					resetCloud(c);
				}
			}
		}
		
		protected function resetCloud(cloud:MovieClip, init:Boolean = false):void {
			cloud.gotoAndStop(Math.ceil(Math.random() * 4));
			cloud.scaleX = cloud.scaleY = 0.1 + Math.random() * 0.4;
			cloud.x = 720 + Math.random() * 720;
			if (init) cloud.x -= 720;
			var yMult:Number = Math.random();
			cloud.y = yMult * 400;
			DisplayObjectUtil.setObjectTint(cloud, 0xDAF3F5, yMult * 0.9);
			cloud.speed = -Math.random() * 0.35;
		}
		
		
	}

}