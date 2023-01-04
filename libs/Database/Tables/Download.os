
import System.Collections.Vector;

public object TDownloadRecord {
	public string Created;
	public string Done;
	public int Id;
	public string Source;
	public string Started;
	public string Target;

	public void Constructor( int databaseHandle ) {
		DB = databaseHandle;
	}

	public void Constructor( int databaseHandle, string query ) {
		DB = databaseHandle;

		loadByQuery( query );
	}

	public void Constructor( int databaseHandle, int result ) {
		DB = databaseHandle;

		loadByResult( result );
	}

	public void deleteByPrimaryKey( int id ) modify throws {
		var query = "DELETE FROM download WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO download ( `created`, `done`, `id`, `source`, `started`, `target` ) VALUES ( NULLIF('" + Created + "', ''), NULLIF('" + Done + "', ''), '" + Id + "', '" + Source + "', NULLIF('" + Started + "', ''), '" + Target + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO download ( `created`, `done`, `id`, `source`, `started`, `target` ) VALUES ( NULLIF('" + Created + "', ''), NULLIF('" + Done + "', ''), '" + Id + "', '" + Source + "', NULLIF('" + Started + "', ''), '" + Target + "' ) ON DUPLICATE KEY UPDATE `created` = NULLIF('" + Created + "', ''), `done` = NULLIF('" + Done + "', ''), `source` = '" + Source + "', `started` = NULLIF('" + Started + "', ''), `target` = '" + Target + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void loadByQuery( string query ) modify throws {
		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Done = cast<string>( mysql_get_field_value( result, "done" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Source = cast<string>( mysql_get_field_value( result, "source" ) );
		Started = cast<string>( mysql_get_field_value( result, "started" ) );
		Target = cast<string>( mysql_get_field_value( result, "target" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM download WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Done = cast<string>( mysql_get_field_value( result, "done" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Source = cast<string>( mysql_get_field_value( result, "source" ) );
		Started = cast<string>( mysql_get_field_value( result, "started" ) );
		Target = cast<string>( mysql_get_field_value( result, "target" ) );
	}

	public void loadByResult( int result ) modify {
		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Done = cast<string>( mysql_get_field_value( result, "done" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Source = cast<string>( mysql_get_field_value( result, "source" ) );
		Started = cast<string>( mysql_get_field_value( result, "started" ) );
		Target = cast<string>( mysql_get_field_value( result, "target" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TDownloadRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TDownloadRecord { NULLIF('" + Created + "', ''), NULLIF('" + Done + "', ''), '" + Id + "', '" + Source + "', NULLIF('" + Started + "', ''), '" + Target + "' }";
	}

	private int DB const;
}


public object TDownloadCollection implements ICollection { //<TDownloadRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TDownloadRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TDownloadRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TDownloadRecord first() const {
		return Collection.first();
	}

	public Iterator<TDownloadRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TDownloadRecord last() const {
		return Collection.last();
	}

	public void loadByQuery( string query ) modify throws {
		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		Collection.clear();

		var result = mysql_store_result( DB );
		while ( mysql_fetch_row( result ) ) {
			var record = new TDownloadRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TDownloadRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void pop_back() modify {
		Collection.pop_back();
	}

	public void pop_front() modify {
		Collection.pop_front();
	}

	public int size() const {
		return Collection.size();
	}

	public void push_back( TDownloadRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TDownloadRecord> Collection;
	private int DB const;
}


