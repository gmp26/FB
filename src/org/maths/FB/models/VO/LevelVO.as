package org.maths.FB.models.VO
{
	public class LevelVO
	{
		function LevelVO(name:String)
		{
			this.name = name;
			completed = false;
			score = 0;
		}
		
		public var name:String;
		public var completed:Boolean;
		public var score:int;
	}
}