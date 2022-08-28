
// library imports

// project imports


public object VisitorCounter {
	public void Constructor( int databaseHandle ) throws {
		if ( !databaseHandle ) {
			throw "invalid database handle provided!";
		}

		mDatabaseHandle = databaseHandle;

		load();
	}

	public int getNumVisitors() const {
		return mCount;
	}

	public void increment() modify {
		mCount++;

		store();
	}

	private void load() modify throws {
		var query = "SELECT stats_value FROM stats WHERE stats_key = 'visitor_count'";

		mysql_query( mDatabaseHandle, query );

		var result = mysql_store_result( mDatabaseHandle );
		if ( !result || !mysql_fetch_row( result ) ) {
			throw mysql_error( mDatabaseHandle );
		}

		mCount = cast<int>( mysql_get_field_value( result, "stats_value" ) );
	}

	private void store() throws {
		var query = "UPDATE stats SET stats_value = '" + mCount + "' WHERE stats_key = 'visitor_count'";

		var error = mysql_query( mDatabaseHandle, query );
		if ( error ) {
			throw mysql_error( mDatabaseHandle );
		}
	}

	private int mCount;
	private int mDatabaseHandle;
}

