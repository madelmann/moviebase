#!/usr/local/bin/webscript

// library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "actorID" ) ) {
			throw "actorID is missing!";
		}

		string actorID = mysql_real_escape_string( Database.Handle, get( "actorID" ) );
		if ( !actorID ) {
			throw "invalid actorID provided!";
		}

		Json.AddElement( "actorID", actorID );

		if ( isSet( "tag" ) ) {
			string originalTags = Database.retrieveField( TABLE, "tags", actorID );

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

			return Database.updateField( TABLE, "tags", actorID, mysql_real_escape_string( Database.Handle, newTags ) );
		}

		throw "tag is missing!";
	}

	private string TABLE const = "actors";
}

