package org.maths.FB.views
{
	import flash.events.MouseEvent;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.models.PickerData;
	import org.robotlegs.mvcs.Mediator;
	
	public class PickerViewMediator extends Mediator
	{
		[Inject]
		public var picker:PickerView;
		
		[Inject]
		public var pickerData:PickerData;
		
		private var buttons:Vector.<HeaderButton>;
		
		public function PickerViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			picker.backButton.addEventListener(MouseEvent.CLICK, back);
			picker.cancelButton.addEventListener(MouseEvent.CLICK, back);
			
			pickerData.pickedLabel="?";
			picker.message.text = pickerData.pickerMessage;
			
			// populate picker
			buttons = new Vector.<HeaderButton>();
			for(var i:int; i < pickerData.buttonLabels.length; i++) {
				var button:HeaderButton = new HeaderButton();
				buttons.push(button);
				button.setStyle("skinClass", pickerData.headerButton.getStyle("skinClass"));
				button.label = pickerData.buttonLabels[i];
				picker.choices.addElement(button);
				button.addEventListener(MouseEvent.CLICK, picked);
			}
		}
		
		override public function onRemove():void
		{
			picker.backButton.removeEventListener(MouseEvent.CLICK, back);
		}
		
		private function back(event:MouseEvent = null):void
		{
			picker.navigator.popView();
		}
		
		private function picked(event:MouseEvent):void
		{
			var b:HeaderButton = event.currentTarget as HeaderButton;
			pickerData.pickedLabel = b.label;
			
			// remove all event listeners
			for(var i:int; i < buttons.length; i++) {
				buttons[i].removeEventListener(MouseEvent.CLICK, picked);
			}
			
			// return to level
			back();
		}
		
	}
}