#!/usr/local/bin/webscript

// library includes

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("image") ) {
			return false;
		}
	
		string image;
		if ( isSet("image") ) {
			image = "user_submitted/images/" + mysql_real_escape_string(Database.Handle, get("image"));
		}
		string title = mysql_real_escape_string(Database.Handle, get("title"));
	
		Json.AddElement("action", "add");
	
		return InsertImage(image, title);
	}

	private bool InsertImage(string image, string title) throws {
		if ( !image ) {
			return false;
		}

		string query = "INSERT INTO images (image, title) VALUES ('" + image + "', '" + title + "')";

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		Json.AddElement( "id", cast<string>( Database.getLastInsertId() ) );

		return true;
	}
}

