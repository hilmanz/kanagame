package  
{
	import com.pblabs.components.stateMachine.PropertyTransition;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.IPBObject;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.PBE;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kanadigital
	 */
	public class PuzzlePickedComponent extends TickedComponent 
	{
		public var positionReference:PropertyReference;
		private var overlap:Array = [null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		private var pos:Point;
		private var results:Array;
		private var switch_queue:Array;
		private var switch_queue_index:Array;
		
		public function PuzzlePickedComponent() 
		{
			super();
		}
		override protected function onAdd():void 
		{
			PBE.log(this, "Loading Puzzle Picked Component for " + owner.name);	
			super.onAdd();
			//var position:Point = owner.getProperty(positionReference) as Point;
			PBE.mainStage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag, false, 0, true);
			PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, onRelease, false, 0, true);
		}
		
		private function onRelease(e:MouseEvent):void 
		{
			try{
				var status:IEntity = PBE.lookupEntity('status');
				var isFinished:Boolean = status.getProperty(new PropertyReference("@puzzle_status.isFinished")) as Boolean;
				var is_busy:Boolean = status.getProperty(new PropertyReference("@puzzle_status.isBusy")) as Boolean;
				var selected_piece:IEntity = status.getProperty(new PropertyReference("@puzzle_status.selected_piece")) as IEntity;
			
				var positions:Object = status.getProperty(new PropertyReference("@puzzle_status.positions")) as Object;
				var stack:Array = status.getProperty(new PropertyReference("@puzzle_status.stack")) as Array;
				//trace(selected_piece.name);
				if(!isFinished){
					if (is_busy) {
						results = [];
						switch_queue = [];
						switch_queue_index = [];
						pos = new Point(PBE.mainStage.mouseX, PBE.mainStage.mouseY);
						PBE.scene.getRenderersUnderPoint(pos, results);
						var n_overlap:int = 0;
						for each (var o:* in results) {
							
							for (var i:int = 1; i <=40; i++) {
								if (o.owner.name == "puzzle" + i) {
									switch_queue.push("puzzle" + i);
									for (var t:int = 0; t < stack.length; t++) {
										if (stack[t] == o.owner.name) {
											switch_queue_index.push(t);
											break;
										}
									}
								}
							}
						}
						
						//trace(switch_queue_index);
						if (switch_queue.length == 2) {
							//tukar posisinya :D
							var old_pos1:Point = positions[switch_queue[0]];
							var old_pos2:Point = positions[switch_queue[1]];
							positions[switch_queue[0]] = old_pos2;
							positions[switch_queue[1]] = old_pos1;
							status.setProperty(new PropertyReference("@puzzle_status.positions"), positions);
							
							var old_index1:String = stack[switch_queue_index[0]];
							var old_index2:String = stack[switch_queue_index[1]];
							trace(stack[switch_queue_index[0]] + " with " + old_index2);
							trace(stack[switch_queue_index[1]] + " with " + old_index1);
							stack[switch_queue_index[0]] = old_index2;
							stack[switch_queue_index[1]] = old_index1;
							status.setProperty(new PropertyReference("@puzzle_status.stack"), stack);
							
							var piece1:IEntity = PBE.lookupEntity(switch_queue[0]);
							var piece2:IEntity = PBE.lookupEntity(switch_queue[1]);
							piece1.setProperty(new PropertyReference("@Spatial.position"), positions[switch_queue[0]]);
							piece2.setProperty(new PropertyReference("@Spatial.position"), positions[switch_queue[1]]);
						}
						//trace(stack);
						try {
							//trace(positions[selected_piece.name]);
							selected_piece.setProperty(new PropertyReference("@Spatial.position"), positions[selected_piece.name]);
							//set the piece's position back to its original place
							status.setProperty(new PropertyReference("@puzzle_status.isBusy"), false);
							selected_piece.setProperty(new PropertyReference("@render.layerIndex"), 10);
							status.setProperty(new PropertyReference("@puzzle_status.selected_piece"), null);
							status.setProperty(new PropertyReference("@puzzle_status.isBusy"), false);
							
						}catch (e:Error) {
							//trace(e.message);
						}
						if (is_win(stack)) {
							status.setProperty(new PropertyReference("@puzzle_status.isFinished"), true);
						
							PBE.mainStage.dispatchEvent(new Event("WIN"));
						}
					}
				}
			}catch (e:Error) {
				
			}
		}
		private function is_win(stack:Array):Boolean {
			var win:Boolean = true;
			for (var i:int = 1; i < stack.length; i++) {
				if (stack[i - 1] != "puzzle" + (i)) {
					win = false;
				}
			}
			return win;
		}
		protected override function onRemove():void {
			super.onRemove();
			PBE.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			PBE.mainStage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			
			/*for each(var o:IPBObject  in PBE.nameManager.objectList) {
				PBE.log(this, o.name + " removed");
				o.destroy();
			}*/
			results = null;
			pos = null;
			overlap = null;
			switch_queue = null;
			switch_queue_index = null;
			positionReference = null;
			PBE.log(this, this.owner.name+"Removed");
			owner.destroy();
			
		}
		
		private function onDrag(evt:MouseEvent):void {
			var status:IEntity = PBE.lookupEntity('status');
			var isFinished:Boolean = status.getProperty(new PropertyReference("@puzzle_status.isFinished")) as Boolean;
			var is_busy:Boolean = status.getProperty(new PropertyReference("@puzzle_status.isBusy")) as Boolean;
			var selected_piece:IEntity = status.getProperty(new PropertyReference("@puzzle_status.selected_piece")) as IEntity;
				
			if (evt.buttonDown&&!isFinished) {
				results = [];
				pos = new Point(PBE.mainStage.mouseX, PBE.mainStage.mouseY);
				PBE.scene.getRenderersUnderPoint(pos, results);
				
				for each (var o:* in results) {
					//trace(o.owner.name);
					for (var i:int = 1; i <= 10; i++) {
						if (o.owner.name == "puzzle" + i) {
							overlap[i] = 1;
						}else {
							overlap[i] = 0;
						}
					}
					if (owner.name == o.owner.name) {
						if (!is_busy) {
							selected_piece = owner;
							status.setProperty(new PropertyReference("@puzzle_status.selected_piece"), selected_piece);
							status.setProperty(new PropertyReference("@puzzle_status.isBusy"), true);
						}else {
							//trace(selected_piece.name);
							if(owner.name==selected_piece.name){
								var new_pos:Point = new Point(pos.x - PBE.mainStage.stageWidth / 2,
													  pos.y - PBE.mainStage.stageHeight / 2);
								owner.setProperty(new PropertyReference("@Spatial.position"), new_pos);
								owner.setProperty(new PropertyReference("@render.layerIndex"), 11);
							}
						}
					}
				}
			}else {
				var positions:Object = status.getProperty(new PropertyReference("@puzzle_status.positions")) as Object;
				//trace(selected_piece.name);
				if(is_busy){
					try {
						//trace(positions[selected_piece.name]);
						selected_piece.setProperty(new PropertyReference("@Spatial.position"), positions[selected_piece.name]);
						//set the piece's position back to its original place
						status.setProperty(new PropertyReference("@puzzle_status.isBusy"), false);
						selected_piece.setProperty(new PropertyReference("@render.layerIndex"), 10);
						status.setProperty(new PropertyReference("@puzzle_status.selected_piece"), null);
						status.setProperty(new PropertyReference("@puzzle_status.isBusy"), false);
						
					}catch (e:Error) {
						//trace(e.message);
					}
				}
			}
		}
	}

}