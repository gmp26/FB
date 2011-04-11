package org.maths.FB.models
{
	import org.maths.FB.models.VO.LevelVO;

	public class Scores
	{
		public function Scores()
		{
		}
		
		/**
		 * list of completed levels. by levelName. This should be persistent
		 */
		private var levelScores:Object = {};
		
		/**
		 * Clear all level scores and completions. 
		 * 
		 */
		public function clearScores():void {
			levelScores = {};
		}
		
		/**
		 * start a game level, zeroing the score
		 * @param levelName
		 * 
		 */
		public function startLevel(levelName:String):void
		{
			levelScores[levelName] = new LevelVO(levelName);
		}
		
		/**
		 * Complete a game level, returning the level state 
		 * @param levelName
		 * @return 
		 * 
		 */
		public function completeLevel(levelName:String):LevelVO
		{
			var state:LevelVO = levelScores[levelName];
			state.completed = true;
			return state;
		}
		
		/**
		 * add a score to a level, returning the new score 
		 * @param levelName
		 * @param score
		 * @return new score
		 * 
		 */
		public function addScore(levelName:String, score:int):int
		{
			var state:LevelVO = levelScores[levelName] as LevelVO;
			state.score += score;
			return state.score;
		}
		
		public function getScore(levelName:String):int
		{
			return (levelScores[levelName] as LevelVO).score;
		}
		
		public function completedLevels():Vector.<String>
		{
			
			var levels:Vector.<String> = new Vector.<String>;
			for(var levelName:String in levelScores) {
				if((levelScores[levelName] as LevelVO).completed)
					levels.push(levelName);
			}
			return levels;
		}
	}
}