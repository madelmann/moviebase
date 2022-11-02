#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import Consts;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() throws {
		base.Constructor();

		if ( isSet("allowDelete") ) {
			mAllowDelete = bool get("allowDelete");
		}
		if ( isSet("allowSearch") ) {
			mAllowSearch = bool get("allowSearch");
		}
	}

	public void Render() {
		//EditableLabel("tag", TAG, 20);
		print("<label  id='tag_label' class='input shown'  style='font-size: 20pt' onclick='mTagsPlugin.Swap(\"tag\");'>" + TAG + "</label>");
		print("<input  id='tag_input' class='input' style='font-size: 20pt' hidden='true' type='text' value='" + TAG + "' />");
		print("<button id='save' class='' hidden='true' onclick='mTagsPlugin.InsertTag();'>Speichern</button>");
		print("</br>");print("</br>");

		ShowTags();
	}

	private void ShowTag(int handle) {
		var id = mysql_get_field_value(Database.Handle, "id");
		var name = mysql_get_field_value(Database.Handle, "name");

		print("<li class='tag'>");
		print("<span>");
		if ( mAllowDelete ) {
		print("<a class='X' onclick='mTagsPlugin.DeleteTag(" + id + ");'>X</a>");
		}
		print("<a onclick='" + (mAllowSearch ? "mTagsPlugin.SearchTag(\"" + name + "\");" : "mTagsPlugin.ReturnTag(\"" + name + "\");") + "'>" + name + "</a>");
		print("</span>");
		print("</li>");
	}

	private void ShowTags() throws {
		var query = "SELECT id, name FROM tags ORDER BY name ASC";

		var error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		print("<ul>");

		var result = mysql_store_result(Database.Handle);
		while ( mysql_fetch_row(result) ) {
			ShowTag(result);
		}

		print("</ul>");
	}

	public bool mAllowDelete = false;
	public bool mAllowSearch = false;
}

