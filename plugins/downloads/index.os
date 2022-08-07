#!/usr/local/bin/webscript

// library imports
import System.StringIterator;

// project imports
import libs.Plugins.RenderPlugin;


public object RenderPlugin implements IRenderPlugin {
	public void Render() {
		pre("
<h4>Downloads:</h4>

<table style='width:100%'>
	<tr>
		<td><input type='text' id='source' style='width:100%' /></td>
		<td><input type='text' id='target' style='width:100%' /></td>
		<td><input type='button' value='Download' style='width:100%' onclick='mPlugin.DownloadVideo();' /></td>
	</tr>
</table>
</br>

<table>
	<th>File</th>
	<th>Size</th>
		");

		//string path = "Download/";
		string path = "/home/pi/projects/moviebase/resources/downloads/"

		var fileIt = new StringIterator( system( "ls -1 " + path ), LINEBREAK );
		while ( fileIt.hasNext() ) {
			string filename = fileIt.next();

			if ( !filename ) {
				continue;
			}

			string size = system( "du -h '" + path + filename + "' | cut -f -1" );

			pre("
<tr>
	<td>" + filename + "</td>
	<td>" + size + "</td>
</tr>
			");
		}

		pre("
</table>
		");
	}
	
}

