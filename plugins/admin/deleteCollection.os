#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("id") ) {
			return false;
		}
	
		var id = mysql_real_escape_string(Database.Handle, get("id"));
	
		return DeleteCollection(id);
	}

	private bool DeleteCollection(string id) throws {
		if ( !id ) {
			return false;
		}

		// Delete items that belong to that collection
		{
			var query = "DELETE FROM collection_items WHERE collection_id = " + id;

			var error = mysql_query(Database.Handle, query);
			if ( error ) {
				throw mysql_error(Database.Handle);
			}
		}

		// Delete the collection itself
		{
			var query = "DELETE FROM collections WHERE id = " + id;

			var error = mysql_query(Database.Handle, query);
			if ( error ) {
				throw mysql_error(Database.Handle);
			}
		}

		return true;
	}
}

