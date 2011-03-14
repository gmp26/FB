package org.maths.FB.signals
{
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.natives.NativeRelaySignal;
	
	public class StartupCompleteSignal extends NativeRelaySignal
	{
		public function StartupCompleteSignal(target:IEventDispatcher, eventType:String, eventClass:Class=null)
		{
			super(target, eventType, eventClass);
		}
	}
}