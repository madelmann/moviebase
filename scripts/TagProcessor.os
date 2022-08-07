
// library imports
import System.Collections.Map;
import System.Collections.Set;
import System.String;
import System.StringIterator;

// project imports


public object TagProcessor {
	public void Constructor( int dbHandle ) {
		mDBHandle = dbHandle;

		initActors();
		initCollections();
		initTags();
	}

	public void process() throws {
		string query = "SELECT *, IF(added > last_modified, added, last_modified) AS sorted \
						FROM items \
						WHERE deleted = FALSE \
						ORDER BY sorted DESC, added DESC, last_modified ASC";

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		var result = mysql_store_result( mDBHandle );
		if ( !result ) {
			throw mysql_error( mDBHandle );
		}

		while ( mysql_fetch_row( result ) ) {
			processItem( result );
		}
	}

	public void processItem( int result ) {
		var title = new String( mysql_get_field_value( result, "title" ) );
		print( "Title: " + cast<string>( title ) );

		processActors( result, title );
		processTags( result, title.ToLower() );
	}

	private string getActorTags( string actor ) throws {
		try {
			return mActors.get( actor );
		}

		return "";
	}

	private string getCollectionTags( string collection ) throws {
		try {
			return mCollections.get( collection );
		}

		return "";
	}

	private int getQueryResult( string query ) throws {
		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		var result = mysql_store_result( mDBHandle );
		if ( !result ) {
			throw mysql_error( mDBHandle );
		}

		return result;
	}

	private void initActors() modify throws {
		string query = "SELECT * FROM actors WHERE LENGTH( name ) > 3 ORDER BY name DESC";

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		var result = mysql_store_result( mDBHandle );
		if ( !result ) {
			throw mysql_error( mDBHandle );
		}

		mActors = new Map<string, string>();

		while ( mysql_fetch_row( result ) ) {
			mActors.insert( mysql_get_field_value( result, "name" ), mysql_get_field_value( result, "tags" ) );
		}
	}

	private void initCollections() modify throws {
		string query = "SELECT * FROM collections WHERE LENGTH( name ) > 3 ORDER BY name DESC";

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		var result = mysql_store_result( mDBHandle );
		if ( !result ) {
			throw mysql_error( mDBHandle );
		}

		mCollections = new Map<string, string>();

		while ( mysql_fetch_row( result ) ) {
			mCollections.insert( mysql_get_field_value( result, "name" ), mysql_get_field_value( result, "tags" ) );
		}
	}

	private void initTags() modify throws {
		string query = "SELECT LOWER(name) AS name FROM tags WHERE LENGTH( name ) > 3 ORDER BY name DESC";

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		var result = mysql_store_result( mDBHandle );
		if ( !result ) {
			throw mysql_error( mDBHandle );
		}

		mTags = new Set<string>();

		while ( mysql_fetch_row( result ) ) {
			mTags.insert( toLower( mysql_get_field_value( result, "name" ) ) );
		}
	}

	private void processActors( int result, String title ) {
		string originalActors = mysql_get_field_value( result, "actors" );

		var actorIt = new StringIterator( originalActors, "|" );

		var actors = new Set<string>();
		while ( actorIt.hasNext() ) {
			if ( actorIt.next() ) {
				actors.insert( actorIt.current() );
			}
		}

		// check what actors the title contains
		foreach ( Pair<string, string> titleActor : mActors ) {
			if ( titleActor && title.Contains( titleActor.first ) && !actors.contains( titleActor.first ) ) {
				actors.insert( titleActor.first );
			}
		}

		// build tags
		string newActors;
		var newActorIt = actors.getIterator();
		while ( newActorIt.hasNext() ) {
			newActors += newActorIt.next();

			if ( newActorIt.hasNext() ) {
				newActors += "|";
			}
		}

		if ( newActors != originalActors ) {
			print( "Actors: \"" + newActors + "\"" );

			updateActors( mysql_get_field_value( result, "id" ), newActors );
		}
	}

	private void processTags( int result, String title ) {
		string actors = mysql_get_field_value( result, "actors" );
		string actorTags;

		if ( actors ) {
			// collect all tags that belong to the playing actors
			var actorIt = new StringIterator( actors, "|" );
			while ( actorIt.hasNext() ) {
				if ( actorIt.next() ) {
					title += "|" + getActorTags( actorIt.current() );
				}
			}
		}

		string originalTags = toLower( mysql_get_field_value( result, "tags" ) );

		var tagIt = new StringIterator( originalTags, "|" );

		// extract tags
		var tags = new Set<string>();
		while ( tagIt.hasNext() ) {
			if ( tagIt.next() ) {
				tags.insert( tagIt.current() );
			}
		}

		// check what tags the title contains
		foreach ( string titleTag : mTags ) {
			if ( titleTag && title.Contains( titleTag ) && !tags.contains( titleTag ) ) {
				tags.insert( titleTag );
			}
		}

		// build tags
		string newTags;
		var newTagIt = tags.getIterator();
		while ( newTagIt.hasNext() ) {
			newTags += newTagIt.next();

			if ( newTagIt.hasNext() ) {
				newTags += "|";
			}
		}

		if ( originalTags != newTags ) {
			print("Tags:   \"" + newTags + "\"");

			updateTags( mysql_get_field_value( result, "id" ), newTags );
		}
	}

	private void updateActors( string id, string actors ) throws {
		string query = "UPDATE items SET /*last_modified = NOW(),*/ actors = \"" + actors + "\" WHERE id = " + id;

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}
	}

	private void updateTags( string id, string tags ) throws {
		string query = "UPDATE items SET /*last_modified = NOW(),*/ tags = \"" + tags + "\" WHERE id = " + id;

		var error = mysql_query (mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}
	}

	private Map<string, string> mActors;
	private Map<string, string> mCollections;
	private int mDBHandle;
	private Set<string> mTags;
}

