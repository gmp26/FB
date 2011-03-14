package org.maths.FB.signals
{
	import org.osflash.signals.Signal;
	
	public class GreyNumberSignal extends Signal
	{
		public function GreyNumberSignal()
		{
			// if true, add a grey number message.
			// if false, remove it.
			super(Boolean);
		}
	}
}