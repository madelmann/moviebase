#!/usr/local/bin/webscript

// Library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("id") ) {
			throw "id is missing!";
		}

		string id = mysql_real_escape_string(Database.Handle, get("id"));
		if ( !id ) {
			throw "invalid id provided!";
		}

		Json.AddElement("id", id);

		if ( isSet("tag") ) {
			string originalTags = GetTags(id);

			var originalTagIt = new StringIterator(originalTags, "|");
			var tags = new Set<string>();

			while ( originalTagIt.hasNext() ) {
				if ( originalTagIt.next() ) {
					tags.insert( originalTagIt.current() );
				}
			}

			string tag = get("tag");
			if ( tag ) {
				try { tags.erase( tags.indexOf(tag) ); }
			}

			string newTags;
			var newTagIt = tags.getIterator();
			while ( newTagIt.hasNext() ) {
				newTags += newTagIt.next();

				if ( newTagIt.hasNext() ) {
					newTags += "|";
				}
			}

			return SetTags(id, mysql_real_escape_string(Database.Handle, newTags));
		}

		throw "tag is missing!";
	}

	private string GetTags(string id) {
		return Database.retrieveField(TABLE, "tags", id);
	}

	private bool SetTags(string id, string value) {
		return Database.updateField(TABLE, "tags", id, value);
	}

	private string TABLE const = "items";
}

