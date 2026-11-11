package src 
{
	import com.coreyoneil.collision.CDK;
	import com.coreyoneil.collision.CollisionList;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import src.bullet.AbstractBullet;
	import src.obstacles.Obstacle;
	import src.obstacles.ObstacleListEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class World extends MovieClip 
	{
		public const WORLD_HEIGHT:Number = 315;
		public const WORLD_WIDTH:Number = 720;
		public const GROUND_LEVEL:Number = 290;//Used to test collision with ground
		public const SCALE_TO_FIT_STATIC_BUFFER:Number = 0;
		public const SCALE_TO_FIT_DYNAMIC_BUFFER:Number = 0.25;
		public const SCALE_TO_FIT_MINIMUM_DISTANCE:Number = 300;
		
		public var currentObstacle:Obstacle;
		public var currentObstacleLevel:uint = 0;
		
		public var bullets:Vector.<AbstractBullet> = new Vector.<AbstractBullet>();
		
		public function World(container:DisplayObjectContainer) 
		{
			container.addChild(this);
			
			Main.phase1.add(tick);
			
			x = 0;
			y = stage.stageHeight - WORLD_HEIGHT;
		}
		
		protected function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			Main.phase1.add(tick);
			
			x = 0;
			y = stage.stageHeight - WORLD_HEIGHT;
		}
		
		public function scaleToFit(pixels:Number):void {
			if (pixels < SCALE_TO_FIT_MINIMUM_DISTANCE) {
				pixels = SCALE_TO_FIT_MINIMUM_DISTANCE;
			}
			var distance:Number = pixels + SCALE_TO_FIT_STATIC_BUFFER + (pixels * SCALE_TO_FIT_DYNAMIC_BUFFER);
			var scale:Number = WORLD_WIDTH / distance;
			scaleX = scaleY = scale;
			y = stage.stageHeight - (WORLD_HEIGHT * scaleY);
			if (!GameEngine.currentlyInSpace) {
				y -= NumberUtils.interpolate2( -25, 50, 300, 1900, pixels, 0.4, true);
			}
		}
		
		public function setObstacle(entry:ObstacleListEntry, level:uint ):void {
			if (currentObstacle != null) {
				removeChild(currentObstacle);
			}
			
			clearAllBullets();
			
			currentObstacleLevel = level;
			
			currentObstacle = new Obstacle(entry);
			addChild(currentObstacle);
			var distance:Number = entry.distance;
			currentObstacle.x = distance;
			
			scaleToFit(entry.distance + entry.scaleMargin);
			
			if (GameEngine.currentlyInSpace) {
				var scaledPosition:Number = (stage.stageHeight - WORLD_HEIGHT / scaleY)*0.5;
				//trace("Value",scaledPosition)
				//graphics.clear();
				//graphics.beginFill(0xFF0000,0.2);
				//graphics.drawCircle(400, scaledPosition, 1000);
				//graphics.endFill();
				//graphics.beginFill(0xFF0000,0.4);
				//graphics.drawCircle(400, scaledPosition, 500);
				//graphics.endFill();
				//graphics.beginFill(0xFF0000);
				//graphics.drawCircle(400, scaledPosition, 50);
				//graphics.endFill();
				currentObstacle.y = scaledPosition;
			}else {
				currentObstacle.y = GameEngine.launcher.y + 20;
			}
			
			
			GameEngine.menu.updateObstacleButtons(currentObstacleLevel);
		}
		
		public function addBullet(bullet:AbstractBullet):void {
			addChild(bullet);
			bullets.push(bullet);
			GameEngine.menu.txtStat6.text = bullets.length.toFixed();
		}
		
		private function tick(delta:Number):void 
		{
			if (GameEngine.currentlyInSpace) {
				//SPACE
				//Dispose bullets for touching earth
				var earthRad:Number = GameEngine.ground.width / 2.1 - 10;
				for each(var b:AbstractBullet in bullets) {
					var distanceToEarth:Number = NumberUtils.distanceBetween(b.x, b.y, GameEngine.ground.x, GameEngine.ground.y);
					if (distanceToEarth < earthRad) {
						disposeBullet(b);
					}
				}
			}else {
				//LAND
				//dispose bullets for reaching ground level
				for each(var b:AbstractBullet in bullets) {
					if (b.y >= GROUND_LEVEL) {
						disposeBullet(b);
					}
				}
			}
			
			var rec:Rectangle = currentObstacle.getRect(this);
			
			for each (var b:AbstractBullet in bullets) {
				if (b.x >= rec.left) {
					if (PixelPerfectCollisionDetection.isColliding(b, currentObstacle, this, false)) {
						if (PixelPerfectCollisionDetection.isColliding(b, currentObstacle, this, true, 0)) {
							currentObstacle.hit(b);
							disposeBullet(b);
						}
					}
				}
			}
			
		}
		
		protected function disposeBullet(bullet:AbstractBullet):void {
			VectorUtils.removeFromVector(bullets, bullet);
			bullet.dispose();
			GameEngine.menu.txtStat6.text = bullets.length.toFixed();
		}
		
		public function clearAllBullets():void {
			var t:Number = 0;
			while (bullets.length > 0) {
				disposeBullet(bullets[0]);
			}
		}
		
		public function disposeWorld():void {
			currentObstacle = null;
			if (bullets != null) {
				clearAllBullets();
				bullets = null;
			}
			Main.phase1.remove(tick);
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			
			parent.removeChild(this);
		}
	}

}