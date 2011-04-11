package org.maths.FB.views
{
	import flash.events.MouseEvent;
	
	import org.maths.FB.models.AppState;
	import org.maths.FB.signals.GreyNumberSignal;
	import org.maths.FB.signals.NewProblemSignal;
	import org.maths.FB.signals.NoRevealsLeftSignal;
	import org.maths.FB.signals.RevealAllSignal;
	import org.maths.FB.signals.RevealOneSignal;
	import org.robotlegs.base.MediatorBase;
	
	public class SidePanelMediator extends MediatorBase
	{

		[Inject]
		public var sidePanel:SidePanel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var newProblemSignal:NewProblemSignal;
		
		[Inject]
		public var revealOneSignal:RevealOneSignal;
		
		[Inject]
		public var revealAllSignal:RevealAllSignal;
		
		[Inject]
		public var noRevealsLeft:NoRevealsLeftSignal;
		
		[Inject]
		public var greyNumberSignal:GreyNumberSignal;
		
		
		override public function onRegister():void
		{
			sidePanel.level1Button.addEventListener(MouseEvent.CLICK, newLevel1Problem);
			//sidePanel.dragHelp.text = "The purple numbers can be\ndragged onto headers.";
			sidePanel.domainLabel.text = "Click cells to reveal enough answers to be sure of the row and column headers.";
			if(appState.teacher) {
				sidePanel.currentState = "teacher";
				//sidePanel.domainLabel.text = "How few reveals do you need\nto complete the table?";
				sidePanel.countLabel.text = "reveals used";
			}
			else {
				sidePanel.level2Button.addEventListener(MouseEvent.CLICK, newLevel2Problem);
				sidePanel.level3Button.addEventListener(MouseEvent.CLICK, newLevel3Problem);
				//sidePanel.domainLabel.text = "Click cells to reveal enough answers to be sure of the row and column headers";
				sidePanel.countLabel.text = "reveals left";
			}
			sidePanel.revealButton.addEventListener(MouseEvent.CLICK, revealAll);
			
			revealOneSignal.add(oneReveal);
			greyNumberSignal.add(setGreyMessage)
			
			newLevel1Problem();
			
		}
		
		override public function onRemove():void
		{
			sidePanel.level1Button.removeEventListener(MouseEvent.CLICK, newLevel1Problem);
			if(!appState.teacher) {
				sidePanel.level2Button.removeEventListener(MouseEvent.CLICK, newLevel2Problem);
				sidePanel.level3Button.removeEventListener(MouseEvent.CLICK, newLevel3Problem);
			}
			sidePanel.revealButton.removeEventListener(MouseEvent.CLICK, revealAll);

			revealOneSignal.remove(oneReveal);
			greyNumberSignal.remove(setGreyMessage)
		}
		
		private function oneReveal():void
		{
			var n:int = parseInt(sidePanel.revealCount.text);
			if(appState.teacher)
				sidePanel.revealCount.text = (n+1).toString();
			else {
				if(n == 1 || n != n) {
					sidePanel.revealCount.text = "0";
					noRevealsLeft.dispatch();
					return;
				}
				sidePanel.revealCount.text = (n-1).toString();
			}
		}
		
		private function setGreyMessage(needed:Boolean):void
		{
			sidePanel.dragHelp.text = "Purple numbers can be\ndragged onto headers.";
			if(needed)
				sidePanel.dragHelp.text += "\n\nThe grey number is unavailable.";
		}
		
		private function newLevel1Problem(event:MouseEvent = null):void
		{
			// if in teacher mode there's no limit
			if(appState.teacher) {
				newProblemSignal.dispatch(0);
				sidePanel.revealCount.text = "0";
			}
			else {
				newProblemSignal.dispatch(1);
				sidePanel.revealCount.text = appState.initialReveals[1].toString();
			}
		}
		
		private function newLevel2Problem(event:MouseEvent):void
		{
			// if in teacher mode there's no limit
			newProblemSignal.dispatch(2);
			sidePanel.revealCount.text = appState.initialReveals[2].toString();
		}
		
		private function newLevel3Problem(event:MouseEvent):void
		{
			// if in teacher mode there's no limit
			newProblemSignal.dispatch(3);
			sidePanel.revealCount.text = appState.initialReveals[3].toString();
		}
		
		private function revealAll(event:MouseEvent):void
		{
			revealAllSignal.dispatch();
		}
	}
}