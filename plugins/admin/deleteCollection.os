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
	
		return DeleteCollection(id);
	}

	private bool DeleteCollection(string id) throws {
		if ( !id ) {
			return false;
		}

		// Delete items that belong to that collection
		{
			string query = "DELETE FROM collection_items WHERE collection_id = " + id;

			int error = mysql_query(Database.Handle, query);
			if ( error ) {
				throw mysql_error(Database.Handle);
			}
		}

		// Delete the collection itself
		{
			string query = "DELETE FROM collections WHERE id = " + id;

			int error = mysql_query(Database.Handle, query);
			if ( error ) {
				throw mysql_error(Database.Handle);
			}
		}

		return true;
	}
}

