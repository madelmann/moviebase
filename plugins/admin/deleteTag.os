#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() {
		if ( !isSet("id") ) {
			return false;
		}
	
		string id = mysql_real_escape_string(Database.Handle, get("id"));
	
		return DeleteTag(id);
	}

	private bool DeleteTag(string id) throws {
		if ( !id ) {
			return false;
		}

		string query = "DELETE FROM tags WHERE id = " + id;

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

