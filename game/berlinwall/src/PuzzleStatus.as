package  
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.DataComponent;
	import com.pblabs.engine.entity.IEntity;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kanadigital
	 */
	public class PuzzleStatus extends DataComponent 
	{
		public var isBusy:Boolean = false;
		public var selected_piece:IEntity = null;
		public var positions:Object = { };
		public var stack:Array = [];//stack puzzle..
		public var isFinished:Boolean = false;
		public function PuzzleStatus() 
		{
			super();
		}
		protected override function onAdd():void {
			super.onAdd();
			PBE.log(this, "Running");
			
		}
		
		protected override function onRemove():void {
			super.onRemove();
			PBE.log(this, "removed");
		}
	}

}