package org.maths.FB.views
{
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	
	import org.maths.FB.models.AppState;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class HomeMediator extends Mediator
	{
		public static const BACKGROUND:uint = 0x666666;
		public static const PORTRAIT:String = "Portrait";
		public static const LANDSCAPE:String = "Landscape";
		public var accelerometer:Accelerometer;
		
		[Inject]
		public var home:Home;
		
		[Inject]
		public var appState:AppState;
		
		// later: move to a history service
		//private const SO_KEY:String = "org.maths.factorBasher";
		//private var so:SharedObject;
		
		public function HomeMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			appState.startupSignal.add(startup);
			
			home.stage.addEventListener(Event.RESIZE, doLayout);
			
			
			if (Accelerometer.isSupported)
			{
				accelerometer = new Accelerometer();
				accelerometer.setRequestedUpdateInterval(1500);
				accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdated);
			}
			
			// later!
			//registerClassAlias("org.maths.as3ui.data.HistoryVO", HistoryVO);
			//so = SharedObject.getLocal(SO_KEY);
			
			
			trace("device ppi = ", appState.ppi);
			
		}
		
		override public function onRemove():void
		{
			appState.startupSignal.remove(startup);
			home.stage.removeEventListener(Event.RESIZE, doLayout);
			if(accelerometer) {
				accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdated);
				accelerometer = null;
			}
		}
		
		private function startup(event:ContextEvent):void
		{
			// All context mapping has finished at this point
			trace("startup", event);
			
			// Map concrete device specific views
			
		}
		
		private function onAccelerometerUpdated(e:AccelerometerEvent):void
		{
			if (getOrientation() != PORTRAIT) return;
			if (!appState.flat && e.accelerationZ > .97)
			{
				appState.flat = true;
				doLayout();
			}
			else if (appState.flat && e.accelerationZ < .97)
			{
				appState.flat = false;
				this.doLayout();
			}
		}
		
		private function doLayout(event:Event=null):void
		{
			/* Not yet clear what needs to be done here....
			// Remove any children
			while (home.numChildren > 0) home.removeChildAt(0);
			
			if(stageWidth == 0 || stageHeight == 0)
				return;
			
			// Draw the background
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(BACKGROUND);
			bg.graphics.drawRect(0, 0, stageWidth, stageHeight);
			bg.graphics.endFill();
			home.addChild(bg);
			
			var headerPickerClass:Class = deviceClassFactory.getClassFor(HeaderPicker);
			var headerPicker:HeaderPicker = new headerPickerClass();
			headerPicker.x = 100;
			headerPicker.y = 100;
			home.addChild(headerPicker);
			*/
			
		}
		
		private function getOrientation():String
		{
			return (stageHeight > stageWidth) ? PORTRAIT : LANDSCAPE;
		}
		
		private function get stageHeight():int
		{
			return home.stage.stageHeight;
		}
		
		private function get stageWidth():int
		{
			return home.stage.stageWidth;
		}
		
	}
}