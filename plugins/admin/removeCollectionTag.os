#!/usr/local/bin/webscript

// Library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "collectionID" ) ) {
			throw "collectionID is missing!";
		}

		string collectionID = mysql_real_escape_string( Database.Handle, get( "collectionID" ) );
		if ( !collectionID ) {
			throw "invalid collectionID provided!";
		}

		Json.AddElement( "collectionID", collectionID );

		if ( isSet( "tag" ) ) {
			string originalTags = Database.retrieveField( TABLE, "tags", collectionID );

			var originalTagIt = new StringIterator( originalTags, "|" );
			var tags = new Set<string>();

			while ( originalTagIt.hasNext() ) {
				if ( originalTagIt.next() ) {
					tags.insert( originalTagIt.current() );
				}
			}

			string tag = get( "tag" );
			if ( tag ) {
				try { tags.erase( tags.indexOf( tag ) ); }
			}

			string newTags;
			var newTagIt = tags.getIterator();
			while ( newTagIt.hasNext() ) {
				newTags += newTagIt.next();

				if ( newTagIt.hasNext() ) {
					newTags += "|";
				}
			}

			return Database.updateField( TABLE, "tags", collectionID, mysql_real_escape_string( Database.Handle, newTags ) );
		}

		throw "tag is missing!";
	}

	private string TABLE const = "collections";
}

