package org.maths.FB.views
{
	import mx.collections.ArrayList;
	
	import org.maths.FB.models.AppState;
	import org.maths.FB.signals.HideAllSignal;
	import org.maths.FB.signals.NewTableSignal;
	import org.maths.FB.signals.NoRevealsLeftSignal;
	import org.maths.FB.signals.RevealAllSignal;
	import org.maths.FB.signals.RevealOneSignal;
	import org.robotlegs.mvcs.Mediator;
	
	public class TimesTableMediator extends Mediator
	{
		[Inject]
		public var timesTable:TimesTable;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var newTableSignal:NewTableSignal;
		
		[Inject]
		public var revealOneSignal:RevealOneSignal;
		
		[Inject]
		public var revealAllSignal:RevealAllSignal;
		
		[Inject]
		public var hideAllSignal:HideAllSignal;
		
		[Inject]
		public var noRevealsLeft:NoRevealsLeftSignal;
		
		override public function onRegister():void
		{
			drawTable();
			newTableSignal.add(drawTable);
			revealAllSignal.add(revealAll);
			hideAllSignal.add(hideAll);
			
			noRevealsLeft.add(disableAll);
		}
		
		override public function onRemove():void
		{
			newTableSignal.remove(drawTable);
			noRevealsLeft.remove(disableAll);
			revealAllSignal.remove(revealAll);
			hideAllSignal.remove(hideAll);
		}
	
		private function drawTable():void
		{
			timesTable.requestedColumnCount = appState.cols;
			timesTable.requestedRowCount = appState.rows;
			timesTable.dataProvider = new ArrayList(appState.tableData(revealOneSignal));
		}
		
		private function disableAll():void
		{
			trace("disable all");
			revealAll();
			return;
			
			var table:Array = (timesTable.dataProvider as ArrayList).source;
			for(var i:int = 0; i < table.length; i++) {
				if(table[i].enable == true) {
					table[i].enable = false;
				}
			}
			timesTable.dataProvider = new ArrayList(table);;
		}
	
		private function hideAll():void
		{
			trace("hideAll");
			var dp:ArrayList = timesTable.dataProvider as ArrayList;
			for(var i:int = 0; i < dp.length; i++) {
				var data:Object = dp.getItemAt(i);
				data.sel = true;
				dp.itemUpdated(data);
			}
		}

		private function revealAll():void
		{
			trace("revealAll");
			var dp:ArrayList = timesTable.dataProvider as ArrayList;
			for(var i:int = 0; i < dp.length; i++) {
				var data:Object = dp.getItemAt(i);
				if(data.sel == false) {
					//data.sel = true;
					data.enable=false;					
				}

				dp.itemUpdated(data);
			}
		}
	}
}