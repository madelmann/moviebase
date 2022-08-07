#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import Consts;


public object RenderPlugin implements IRenderPlugin {
    public void Constructor() throws {
		if ( isSet("allowDelete") ) {
			mAllowDelete = cast<bool>( get( "allowDelete" ) );
		}
		if ( isSet("allowSearch") ) {
			mAllowSearch = cast<bool>( get( "allowSearch" ) );
		}
		if ( isSet( "showAll" ) ) {
			mShowAll = cast<bool>( get( "showAll" ) );
		}
	}

	public void Render() {
		print("<label  id='actor_label' class='input shown'  style='font-size: 20pt' onclick='mActorsPlugin.Swap(\"actor\");'>" + ACTOR + "</label>");
		print("<input  id='actor_input' class='input' style='font-size: 20pt' hidden='true' type='text' value='" + ACTOR + "' />");
		print("<button id='save' class='' hidden='true' onclick='mActorsPlugin.InsertActor();'>Speichern</button>");
		print("</br>");
		print("</br>");
	
		ShowActors();
	}

	private void ShowActor(int handle) {
		int count = cast<int>( mysql_get_field_value(Database.Handle, "cnt") );
		string id = mysql_get_field_value(Database.Handle, "id");
		string name = mysql_get_field_value(Database.Handle, "name");

		if ( count <= 1 && !mShowAll ) {
			return;
		}

		print("<li class='actor'>");
		print("<span>");
		if ( mAllowDelete ) {
			print("<a class='X' onclick='mActorsPlugin.DeleteActor(" + id + ");'>X</a>");
		}
		print("<a onclick='" + (mAllowSearch ? "mActorsPlugin.ShowActor(\"" + name + "\");" : "mActorsPlugin.ReturnActor(\"" + name + "\");") + "'>" + name + /*" (" + count + ")" +*/ "</a>");
		print("</span>");
		print("</li>");
	}

	private void ShowActors() throws {
		string query = "SELECT * FROM (SELECT a.id, a.name, COUNT(a.name) as cnt FROM actors a LEFT JOIN items i ON ( i.actors LIKE a.name ) GROUP BY a.name) AS sub";

		//#ORDER BY cnt DESC, name ASC";

		int error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		print( "<ul>" );

		int result = mysql_store_result( Database.Handle );
		while ( mysql_fetch_row( result ) ) {
			ShowActor( result );
		}

		print( "</ul>" );
	}

	private bool mAllowDelete = false;
	private bool mAllowSearch = false;
	private bool mShowAll = false;
}

