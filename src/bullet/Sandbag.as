package src.bullet 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.GameEngine;
	import src.Research;
	/**
	 * ...
	 * @author 
	 */
	public class Sandbag extends AbstractBullet 
	{
		
		
		public function Sandbag(X:Number, Y:Number) 
		{
			super();
			maxRotation = 16;
			vr = Math.random() * maxRotation -(maxRotation / 2);
			var level:uint = uint(Math.min(11, Research.damageLevel + 1));
			var visual:MovieClip = new SandbagVisual();
			if (level >= 7) {
				randomRotation = false;
				rotation = GameEngine.launcher.holderMc.rotation;
			}
			_oldX = X;
			_oldY = Y;
			x = X;
			y = Y;
			
			if (GameEngine.currentlyInSpace) {
				_targetScale = NumberUtils.interpolate2(1.2, 7, 0.34, 0.06, GameEngine.world.scaleX, 3, true)
			}else {
				if (GameEngine.world.scaleX >= 0.25) {
					_targetScale = NumberUtils.interpolate2(1, 2, 1.92, 0.25, GameEngine.world.scaleX, 3, true)
				}else {
					_targetScale = NumberUtils.interpolate2(2.4, 7, 0.2, 0.064, GameEngine.world.scaleX, 2, true)
				}
			}
			
			visual.gotoAndStop(level);
			addChild(visual);
		}
		
	}

}