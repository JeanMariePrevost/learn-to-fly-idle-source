package src.bullet 
{
	import com.hurlant.math.BigInteger;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.datatypes.BigUint;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.GameEngine;
	import src.Main;
	import src.Research;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractBullet extends MovieClip 
	{
		protected const CCD_LENGTH_ADJUST:Number = 0.013;
		
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var vr:Number = 0;
		
		public var damage:String = "0";
		
		protected var maxRotation:Number = 8;
		protected var randomRotation:Boolean = true;
		
		protected var _oldX:Number = 0;
		protected var _oldY:Number = 0;
		protected var _ccd:MovieClip = new CCD();
		
		protected var _targetScale:Number = 1;
		protected var _targetScaleCount:Number = 0;
		protected var _targetScaleDuration:Number = 25;//Number of frame to to from normal to max size
		
		public function AbstractBullet() 
		{
			Main.phase1.add(tick);
			_ccd.scaleX = 0;
			_ccd.scaleY = 0;
			addChild(_ccd);
		}
		
		protected function tick(delta:Number):void {
			//Bullet scaling as distance goes up
			if (_targetScaleCount < _targetScaleDuration) {
				_targetScaleCount += 1 * delta;
				_targetScaleCount = Math.min(_targetScaleCount, _targetScaleDuration);
				
				var scale:Number = Easing.easeOutQuart(_targetScaleCount, 1, _targetScale - 1, _targetScaleDuration);
				if (scale < scaleX) {
					//Conditionnal to "fix" a bug.. I know...
					scaleX = scaleY = _targetScale;
				}else {
					scaleX = scaleY = scale;
				}
			}
			
			delta *= Research.getSpeedDamage();
			
			
			if (GameEngine.currentlyInSpace) {
				delta *= GameEngine.SPACE_SPEED_MULT;
			}
			delta = NumberUtils.constrain(delta, 0.1, 60);
			var drag:Number = GameEngine.drag;
			if (delta > 2) {
				//High delta makes bullet go less far (e.g. on regain focus)
				drag = NumberUtils.interpolate2(drag, drag * 0.42, 2, 100, delta, 0.6, true);
				//Log.log("delta drag adjust - delta:", delta, "Drag:", drag);
			}
			
			if (randomRotation) {
				rotation += vr * delta;
			}else {
				if(Math.abs(_oldX - x) >=0.5){
					var pathAngle:Number = Trig.angleTo(_oldX, _oldY, x, y);
					rotation  = pathAngle;
				}
			}
			
			_oldX = x;
			_oldY = y;
			
			//Different gravity/drag for space and land
			if (GameEngine.currentlyInSpace) {
				///////
				//SPACE
				///////
				var angle:Number = Trig.angleToObject(this, GameEngine.ground);
				var gravX:Number = Trig.vectorX(GameEngine.gravity, angle);
				var gravY:Number = Trig.vectorY(GameEngine.gravity, angle);
				
				vx += gravX * delta;
				vy += gravY * delta;
				vx *= 1 - (drag * delta);
				vy *= 1 - (drag * delta);
			}else {
				//////
				//LAND
				//////
				vy += GameEngine.gravity * delta;
				vx *= 1 - (drag * delta);
				//Selective drag
				if(vy<=0){
					vy *= 1 - (drag * delta);
				}else {
					vy *= 1 - (drag * delta * 0.05);
				}
			}
			
			x += vx * delta;
			y += vy * delta;
			
			var r:Number = Trig.angleTo(x, y, _oldX, _oldY);
			_ccd.rotation = r - rotation;
			var distance:Number = NumberUtils.distanceBetween(x, y, _oldX, _oldY);
			_ccd.scaleX = distance * CCD_LENGTH_ADJUST / scaleX;
			_ccd.scaleY = 0.1;
			
		}
		
		public function dispose():void {
			Main.phase1.remove(tick);
			_ccd = null;
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			parent.removeChild(this);
		}
		
		public function getTotalDamage():String {
			var bu:BigUint = new BigUint(damage);
			bu.multiply(Research.getDamage());
			return bu.toString();
		}
		
	}

}