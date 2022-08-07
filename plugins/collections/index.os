#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import libs.Consts.General;
import Consts;


public object RenderPlugin implements IRenderPlugin {
	public void Constructor() throws {
		if ( isSet("allowDelete") ) {
			mAllowDelete = cast<bool>( get("allowDelete") );
		}
		if ( isSet("allowSearch") ) {
			mAllowSearch = cast<bool>( get("allowSearch") );
		}
		if ( isSet("identifier") ) {
			mIdentifier = get("identifier");
		}
	}

	public void Render() {
		print("<label  id='collection_label' class='input shown'  style='font-size: 20pt' onclick='mCollectionsPlugin.Swap(\"collection\");'>" + COLLECTION + "</label>");
		print("<input  id='collection_input' class='input' style='font-size: 20pt' hidden='true' type='text' value='" + COLLECTION + "' />");
		print("<button id='save' class='' hidden='true' onclick='mCollectionsPlugin.InsertCollection();'>Speichern</button>");
		print("</br>");print("</br>");

		ShowCollections();
	}

	private void ShowCollection(int handle) {
		string id = mysql_get_field_value( Database.Handle, "id" );
		string name = mysql_get_field_value( Database.Handle, "name" );
		string owner = mysql_get_field_value( Database.Handle, "identifier" );

		print("<li class='collection'>");
		print("<span>");
		if ( mAllowDelete || (name != FAVORITES_COLLECTION && owner == mIdentifier) ) {
		print("<a class='X' onclick='mCollectionsPlugin.DeleteCollection(" + id + ");'>X</a>");
		}
		print("<a onclick='" + (mAllowSearch ? "mCollectionsPlugin.ShowCollection(" + id + ");" : "mCollectionsPlugin.ReturnCollection(" + id + ");") + "'>" + name + "</a>");
		print("</span>");
		print("</li>");
	}

	private void ShowCollections() throws {
		string query = "SELECT id, identifier, is_public, name, type FROM collections WHERE is_public = TRUE OR identifier = '" + mIdentifier + "' ORDER BY name ASC";

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		print("<ul>");

		int result = mysql_store_result(Database.Handle);
		while ( mysql_fetch_row(result) ) {
			ShowCollection(result);
		}

		print("</ul>");
	}

	private bool mAllowDelete = false;
	private bool mAllowSearch = false;
	private string mIdentifier;
}

