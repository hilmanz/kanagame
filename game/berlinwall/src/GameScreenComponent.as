package  
{
	import flash.display.MovieClip;
	import com.pblabs.rendering2D.MovieClipRenderer;
	
	/**
	 * ...
	 * @author Kanadigital
	 */
	public class GameScreenComponent extends MovieClipRenderer 
	{
		
		public function GameScreenComponent() 
		{
			super();
		}
		protected override function getClipInstance():MovieClip {
			
			return this.clip;
		}
	}

}