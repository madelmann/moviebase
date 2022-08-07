#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() {
		if ( !isSet("name") ) {
			return false;
		}

		string name = mysql_real_escape_string(Database.Handle, get("name"));

		return AddTag(name);
	}

	private bool AddTag(string name) throws {
		if ( !name ) {
			return true;
		}

		string query = "INSERT INTO tags (name) VALUES ('" + name + "')";

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

