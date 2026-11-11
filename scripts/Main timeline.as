// Main timeline

// ---- layer "Action", frame 1
const VERSION:String = "1.1.103";
txtVersion.text = VERSION;


var myMenu:ContextMenu = new ContextMenu();
myMenu.hideBuiltInItems();
myMenu.builtInItems.quality = true;
contextMenu = myMenu;

stage.scaleMode = StageScaleMode.SHOW_ALL;
stage.quality = "medium";

// ---- layer "Action", frame 2
import flash.events.Event;
import flash.events.MouseEvent;

var mute:Boolean = true;


//Skip preloader - debug
//return;


stop();

stage.addEventListener(Event.ENTER_FRAME, tick);

const MINIMUM_FRAMES:uint = 40;
var increment:Number = 1/MINIMUM_FRAMES;
var frameCount:Number = 0;

function tick(e:Event):void{
	frameCount += increment;
	var ratio:Number = stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal;
	
	ratio = Math.min(frameCount, ratio);
	
	var percent:Number = Math.floor(ratio*100);
	
	preloader.txtLoaded.text = "Cannon " + String(percent) + "% loaded!";
	
	preloader.gotoAndStop(Math.floor(ratio*400));
	
	//if(this.stage.loaderInfo.bytesLoaded >= this.stage.loaderInfo.bytesTotal){
	if(ratio>=1){
		stage.removeEventListener(Event.ENTER_FRAME, tick);
		loadComplete();
	}
}

function loadComplete():void{
	preloader.gotoAndPlay(401);
	//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
	preloader.addEventListener("button_click", finishAnim);
	preloader.addEventListener("button_click_muted", finishAnimMute);
}

function mouseDown(e:MouseEvent):void{
	stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
	//finishAnim();
}

function finishAnim(e:Event):void{
	preloader.gotoAndPlay("shoot");
	preloader.addEventListener(Event.ENTER_FRAME, animEnterFrame);
	mute = false;
}

function finishAnimMute(e:Event):void{
	preloader.gotoAndPlay("shootMute");
	preloader.addEventListener(Event.ENTER_FRAME, animEnterFrame);
	mute = true;
}

function animEnterFrame(e:Event):void{
	if(preloader.currentLabel == "end" || preloader.currentLabel == "endMute"){
		preloader.removeEventListener(Event.ENTER_FRAME, animEnterFrame);
		startGameOld();
	}
}

function startGameOld():void{
	gotoAndStop(3);
}

// ---- layer "Action", frame 3
import src.Main;
import src.Preloader;


stop();

this.stage.addChild(new Main(mute));

// ---- layer "Action", frame 4
import flash.events.ProgressEvent;
import flash.events.Event;
import flash.utils.setTimeout;

stop();
// hide the play button until the game loads
var percent:Number = 0.0;

function startGame():void
{
    trace("Start Game");
    //start the actual game
    this.gotoAndStop(3);
}

// called as the game loads and moves the progress bar accordingly
function update(e:Event):void
{
    if(loaderInfo)
    {
        percent = (loaderInfo.bytesLoaded/loaderInfo.bytesTotal) * 100;
            
        if (percent == 100)
        {
            startGame();
        }
        if (loaderInfo.bytesLoaded == loaderInfo.bytesTotal)
           stage.removeEventListener(Event.ENTER_FRAME, update); 

    }
}



stage.addEventListener(Event.ENTER_FRAME, update);
