// Library symbol "Preloader/PreloaderMc"

// ---- layer "Action", frame 1
btnLtf3.visible = false;
btnLtf1.y += 20;
btnLtf2.y += 20;

btnAD.visible = false;

// ---- layer "Action", frame 401
import flash.events.MouseEvent;

btnStart.addEventListener(MouseEvent.CLICK, click);
btnStartMuted.addEventListener(MouseEvent.CLICK, clickMuted);

function click(e:MouseEvent):void{
	dispatchEvent(new Event("button_click"));
}

function clickMuted(e:MouseEvent):void{
	dispatchEvent(new Event("button_click_muted"));
}

// ---- layer "Action", frame 435
stop();

// ---- layer "Action", frame 579 ("end")
stop();

// ---- layer "Action", frame 761 ("endMute")
stop();
