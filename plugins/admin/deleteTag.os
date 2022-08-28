#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() {
		if ( !isSet("id") ) {
			return false;
		}
	
		var id = mysql_real_escape_string(Database.Handle, get("id"));
	
		return DeleteTag(id);
	}

	private bool DeleteTag(string id) throws {
		if ( !id ) {
			return false;
		}

		var query = "DELETE FROM tags WHERE id = " + id;

		var error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

