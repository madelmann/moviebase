#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Database.Tables.Download;
import libs.Plugins.RenderPlugin;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
		var files = new TDownloadCollection( Database.Handle );
		files.loadByQuery( "SELECT * FROM download ORDER BY created DESC" );

		print("
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
	<tr>
		<th>File</th>
		<th>Created</th>
		<th>Finished</th>
		<th>Retry</th>
		<th>Delete</th>
	</tr>
		" );

		foreach ( TDownloadRecord file : files ) {
			print( "
		<tr>
			<td><a href='resources/downloads/" + file.Target + ".mp4'>" + file.Target + "</a></td>
			<td>" + file.Created + "</td>
			<td>" + file.Done + "</td>
			<td onclick='mPlugin.RetryDownload( " + file.Id + " );' style='cursor: pointer;'>Retry</td>
			<td onclick='mPlugin.DeleteDownload( " + file.Id + " );' style='cursor: pointer;'>Delete</td>
		</tr>
				");
		}

		print("
</table>
		");
	}
	
}

