#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import libs.Utils;
import Consts;



public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
		ShowTags();
		ShowSearchResults();
	}

	private void ShowSearchResults() throws {
		print( "<div id='searchresults'>No tags selected.</div>" );
	}

	private void ShowTag( int result ) {
		var id = mysql_get_field_value( result, "id" );
		var name = mysql_get_field_value( result, "name" );

		if ( isAdmin() ) {
			print( "<a id='tag_" + name + "' onclick='mPlugin.ToggleTag(\"" + name + "\");'><div class='X' style='float:left' onclick='mPlugin.DeleteTag(" + id + ");'>X</div>" + name + "</a>" );
		}
		else {
			print( "<a id='tag_" + name + "' onclick='mPlugin.ToggleTag(\"" + name + "\");'>" + name + "</a>" );
		}
	}

	private void ShowTags() throws {
		var query = "SELECT id, name FROM tags ORDER BY name ASC";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		print( "<div class='sidenav'>" );

		var result = mysql_store_result( Database.Handle );
		while ( mysql_fetch_row(result) ) {
			ShowTag( result );
		}

		print( "</div>" );
	}
}
