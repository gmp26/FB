package org.maths.FB.signals
{
	import org.osflash.signals.Signal;
	
	public class NewProblemSignal extends Signal
	{
		public function NewProblemSignal()
		{
			// Signal forwards the level number
			super(int);
		}
	}
}