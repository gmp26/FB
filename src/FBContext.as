package  
{
	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;
	
	import org.maths.FB.models.AppState;
	import org.maths.FB.signals.GreyNumberSignal;
	import org.maths.FB.signals.HideAllSignal;
	import org.maths.FB.signals.NewProblemSignal;
	import org.maths.FB.signals.NewTableSignal;
	import org.maths.FB.signals.NoRevealsLeftSignal;
	import org.maths.FB.signals.RevealAllSignal;
	import org.maths.FB.signals.RevealOneSignal;
	import org.maths.FB.views.Home;
	import org.maths.FB.views.HomeMediator;
	import org.maths.FB.views.Intro1;
	import org.maths.FB.views.Intro1Mediator;
	import org.maths.FB.views.Intro2;
	import org.maths.FB.views.Intro2Mediator;
	import org.maths.FB.views.MainPanel;
	import org.maths.FB.views.MainPanelMediator;
	import org.maths.FB.views.SidePanel;
	import org.maths.FB.views.SidePanelMediator;
	import org.maths.FB.views.TimesTable;
	import org.maths.FB.views.TimesTableMediator;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	import org.robotlegs.mvcs.SignalContext;
	
	public class FBContext extends SignalContext
	{
		private var ppi:Number;
		private var appState:AppState;
		
		public function FBContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, ppi:Number=-1)
		{
			super(contextView, autoStartup);
			this.ppi = ppi;
		}
		
		
	
		override public function startup():void
		{
			// Map signals
			injector.mapSingleton(NewProblemSignal);
			injector.mapSingleton(NewTableSignal);
			injector.mapSingleton(RevealAllSignal);
			injector.mapSingleton(HideAllSignal);
			injector.mapSingleton(RevealOneSignal);
			injector.mapSingleton(NoRevealsLeftSignal);
			injector.mapSingleton(GreyNumberSignal);
			
			// Set up appState
			appState = new AppState();
			if(appState.ppi == -1)
				appState.ppi = Capabilities.screenDPI;
			else
				appState.ppi = ppi;
			
			injector.mapValue(AppState, appState);
			
			// Map commands
			// signalCommandMap.mapSignalClass(StartupCompleteSignal, StartupCompleteCommand);
			
			// Map views
			mediatorMap.mapView(MainPanel, MainPanelMediator);
			mediatorMap.mapView(SidePanel, SidePanelMediator);
			mediatorMap.mapView(TimesTable, TimesTableMediator);
			mediatorMap.mapView(Intro1, Intro1Mediator);
			mediatorMap.mapView(Intro2, Intro2Mediator);
			mediatorMap.mapView(Home, HomeMediator, Home);
			mediatorMap.createMediator(contextView);
			
			
			trace(appState.ppi, appState);
			
			super.startup();
		}
	}
}