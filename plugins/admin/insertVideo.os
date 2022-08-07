#!/usr/local/bin/webscript

// library includes

// project imports
import libs.Plugins.ExecutePlugin;
import Consts;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("tags") ) {
			throw "tags missing!";
		}
		if ( !isSet("title") ) {
			throw "title missing!";
		}

		string owner = isSet("identifier") ? mysql_real_escape_string(Database.Handle, get("identifier")) : "";
		string filename = mysql_real_escape_string(Database.Handle, get("source"));
		string tags = mysql_real_escape_string(Database.Handle, get("tags"));
		string title = mysql_real_escape_string(Database.Handle, get("title"));

		if ( !owner ) {
			throw "invalid account provided!";
		}
		if ( !filename || filename == SOURCE ) {
			throw "invalid source provided!";
		}
		if ( !tags || tags == TAGS ) {
			throw "invalid tags provided!";
		}
		if ( !title || title == TITLE ) {
			throw "invalid title provided!";
		}

		return InsertVideo(filename, owner, tags, title);
	}

	private bool InsertVideo(string filename, string owner, string tags, string title) throws {
		if ( !title ) {
			return false;
		}

		string query = "INSERT INTO items (filename, tags, title) VALUES ('" + filename + "', '" + tags + "', '" + title + "')";

		Json.AddElement("query", query);

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		Json.AddElement("id", cast<string>( Database.getLastInsertId() ));

		return true;
	}
}

