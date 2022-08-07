#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("id") ) {
			return false;
		}
	
		string id = mysql_real_escape_string(Database.Handle, get("id"));
	
		return RemoveCollectionItem(id);
	}

	private bool RemoveCollectionItem(string id) throws {
		string query = "DELETE FROM collection_items WHERE id = " + id;

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

