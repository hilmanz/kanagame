package
{
	import com.pblabs.engine.resource.ResourceBundle;
	
	public class Resources extends ResourceBundle
	{

		
		
		[Embed(source = "../assets/Level1.pbelevel", mimeType = 'application/octet-stream')]
		public var Level1:Class;
		
		[Embed(source = "../assets/LevelDescriptions.xml",mimeType='application/octet-stream')]
		public var LevelDescriptions:Class;
		
		
		public function Resources():void {
					
		}
	}
}