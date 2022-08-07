#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("id") ) {
			return false;
		}

		int id = int mysql_real_escape_string(Database.Handle, get("id"));
		if ( !id ) {
			return false;
		}

		Json.AddElement("id", string id);
		Json.AddElement("action", "update");

		if ( isSet("title") ) {
			return SetTitle(string id, mysql_real_escape_string(Database.Handle, get("title")));
		}

		return false;
	}

	private bool SetTitle(string id, string value) {
			return Database.updateField(TABLE, "title", id, value);
	}

	private string TABLE const = "images";
}

