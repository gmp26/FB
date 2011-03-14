package org.maths.factorBasher.controllers
{
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class StartupCompleteCommand extends SignalCommand
	{
		public function StartupCompleteCommand()
		{
			super();
		}

		
		override public function execute():void
		{
			trace("Startup Complete Command executed");
		}
	}
}