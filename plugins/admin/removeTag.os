#!/usr/local/bin/webscript

// Library imports
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

		var tag = API.retrieve( "tag" );
		if ( !tag ) {
			throw "invalid tag provided!";
		}

		Json.AddElement( "id", id );

		var tags = new String( Database.retrieveField( TABLE, "tags", id ) );

		string newTags;
		foreach ( string currentTag : tags.SplitBy( "|" ) ) {
			if ( currentTag != tag ) {
				if ( newTags ) {
					newTags += "|";
				}

				newTags += currentTag;
			}
		}

		return Database.updateField( TABLE, "tags", id, newTags );
	}

	private string TABLE const = "items";
}

