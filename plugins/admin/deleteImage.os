#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("image") ) {
			return false;
		}
	
		string imageId = mysql_real_escape_string(Database.Handle, get("image"));
	
		Json.AddElement("action", "delete");
		Json.AddElement("id", string imageId);
	
		return DeleteImage(imageId);
	}

	private bool DeleteImage(string id) throws {
		string query = "DELETE FROM images WHERE id = " + id;

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

