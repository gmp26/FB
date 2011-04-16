package  
{
	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;
	
	import org.maths.FB.models.Analyser;
	import org.maths.FB.models.AppState;
	import org.maths.FB.models.PickerData;
	import org.maths.FB.models.Scores;
	import org.maths.FB.views.CompletedLevels;
	import org.maths.FB.views.CompletedLevelsMediator;
	import org.maths.FB.views.Intro1;
	import org.maths.FB.views.Intro1Mediator;
	import org.maths.FB.views.Intro2;
	import org.maths.FB.views.Intro2Mediator;
	import org.maths.FB.views.Level1;
	import org.maths.FB.views.Level1Mediator;
	import org.maths.FB.views.PickerView;
	import org.maths.FB.views.PickerViewMediator;
	import org.maths.FB.views.StartScreen;
	import org.maths.FB.views.StartScreenMediator;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	import org.robotlegs.mvcs.SignalContext;
	
	public class FBContext extends SignalContext
	{
		private var ppi:Number;
		private var appState:AppState;
		private var analyser:Analyser;
		
		public function FBContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, ppi:Number=-1)
		{
			super(contextView, autoStartup);
			this.ppi = ppi;
		}
		
		
	
		override public function startup():void
		{
			
			// Set up appState
			appState = new AppState();
			if(appState.ppi == -1)
				appState.ppi = Capabilities.screenDPI;
			else
				appState.ppi = ppi;
			
			injector.mapValue(AppState, appState);
			
			analyser = new Analyser();
			injector.mapValue(Analyser, analyser);
			
			injector.mapSingleton(Scores);
			injector.mapSingleton(PickerData);
			
			// Map commands
			// signalCommandMap.mapSignalClass(StartupCompleteSignal, StartupCompleteCommand);
			
			// Map views
			//mediatorMap.mapView(MainPanel, MainPanelMediator);
			//mediatorMap.mapView(SidePanel, SidePanelMediator);
			//mediatorMap.mapView(TimesTable, TimesTableMediator);
			mediatorMap.mapView(StartScreen, StartScreenMediator);
			mediatorMap.mapView(Intro1, Intro1Mediator);
			mediatorMap.mapView(Intro2, Intro2Mediator);
			mediatorMap.mapView(PickerView, PickerViewMediator);
			mediatorMap.mapView(CompletedLevels, CompletedLevelsMediator);
			mediatorMap.mapView(Level1, Level1Mediator);
			mediatorMap.createMediator(contextView);
			
			
			trace(appState.ppi, appState);
			
			super.startup();
		}
	}
}