#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("image") ) {
			return false;
		}
	
		var imageId = mysql_real_escape_string(Database.Handle, get("image"));
	
		Json.AddElement("action", "delete");
		Json.AddElement("id", string imageId);
	
		return DeleteImage(imageId);
	}

	private bool DeleteImage(string id) throws {
		var query = "DELETE FROM images WHERE id = " + id;

		var error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

