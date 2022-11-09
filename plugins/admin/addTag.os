#!/usr/local/bin/webscript

// library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.API;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var id = API.retrieve( "id" );
		if ( !id ) {
			throw "invalid id provided!";
		}

		var tag = toLower( API.retrieve( "tag" ) );
		if ( !tag ) {
			throw "invalid tag provided!";
		}

		Json.AddElement( "id", id );

		var tags = new String( Database.retrieveField( TABLE, "tags", id ) );

		bool inserted = false;
		string newTags;
		foreach ( string currentTag : tags.SplitBy( "|" ) ) {
			if ( currentTag == tag ) {
				// tag already exists
				return true;
			}
			if ( !inserted && currentTag > tag ) {
				if ( newTags ) {
					newTags += "|";
				}

				newTags += tag;
				inserted = true;
			}

			if ( newTags ) {
				newTags += "|";
			}

			newTags += currentTag;
		}

		if ( !inserted ) {
			if ( newTags ) {
				newTags += "|";
			}

			newTags += tag;
		}

		return Database.updateField( TABLE, "tags", id, newTags );
	}

	private string TABLE const = "items";
}

