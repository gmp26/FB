package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.TableButton;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.Analyser;
	import org.maths.FB.models.AppState;
	import org.maths.FB.skins.ToggleCellSkin;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.Label;
	
	public class Level1Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var screen:Level1;
		
		function Level1Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			
			// inject common components into AbstractMediator
			level = screen;
			levelName = "level1";
			content = screen._content;
			rowHeader = screen.rowHeader;
			colHeader = screen.colHeader;
			table = screen.table;
			instruction = screen.instruction;
			endNavigation = screen.endNavigation;
			homeButton = screen._homeButton;
			backButton = screen._backButton;
			skipButton = screen._skipButton;
			checkButton = screen._checkButton;
			nextButton = screen._nextButton;
			tryAgainButton = screen._tryAgainButton;
			min=2;
			max=5;
			
			if(screen.destructionPolicy=="auto")
				newProblem();
			
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override protected function get isCorrect():Boolean
		{
			if(super.isCorrect) {
				scores.completeLevel("level1");
				screen.endNavigation.visible = false;
				return true;
			}
			else
				return false;
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.popView();			
		}
		
		private function newProblem():void
		{
			var val:int;
			var rowHeadings:Array = [];
			var colHeadings:Array = [];
			
			for(var i:int = 0; i < 4; i++) {
				while(rowHeadings.indexOf(val = min + Math.floor((max-min + 1)*Math.random())) >= 0) {};
				rowHeadings[i] = val;
				rowHeader.addElement(newHeader(val));
			}

			for(var j:int = 0; j < 4; j++) {
				while(colHeadings.indexOf(val = min + Math.floor((max-min + 1)*Math.random())) >= 0) {};
				colHeadings[j] = val;
				colHeader.addElement(newHeader(val));
			}	

			for(i=0; i < 4; i++) {
				for(j=0; j < 4; j++) {
					table.addElement(newProduct(i,j));
				}
			} 
			
			// set up the solution analyser
			analyser = new Analyser();
			analyser.setRowRange(4, min, max);
			analyser.setColRange(4, min, max);
			//screen.unknowns.text = "Unknowns " + (analyser.solve() - appState.rows - appState.cols);
		}
		
		private function newHeader(value:int):HeaderButton
		{
			var h:HeaderButton = new HeaderButton();
			h.label = "?";
			h.value = value;
			
			h.addEventListener(MouseEvent.CLICK, headerClicked);
			
			return h;
		}
		
		private function newProduct(row:int, col:int):TableButton
		{
			var t:TableButton = new TableButton();
			t.row = row;
			t.col = col;
			t.label = "";
			
			t.addEventListener(MouseEvent.CLICK, productClicked);
			return t;
		}
		

	}
}