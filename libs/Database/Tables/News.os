
import System.Collections.Vector;

public object TNewsRecord {
	public string Created;
	public int Id;
	public string Message;
	public string Title;

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
		var query = "DELETE FROM news WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO news ( `created`, `id`, `message`, `title` ) VALUES ( NULLIF('" + Created + "', ''), '" + Id + "', '" + Message + "', '" + Title + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO news ( `created`, `id`, `message`, `title` ) VALUES ( NULLIF('" + Created + "', ''), '" + Id + "', '" + Message + "', '" + Title + "' ) ON DUPLICATE KEY UPDATE `created` = NULLIF('" + Created + "', ''), `message` = '" + Message + "', `title` = '" + Title + "'";

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
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Message = cast<string>( mysql_get_field_value( result, "message" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM news WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Message = cast<string>( mysql_get_field_value( result, "message" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void loadByResult( int result ) modify {
		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Message = cast<string>( mysql_get_field_value( result, "message" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TNewsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TNewsRecord { NULLIF('" + Created + "', ''), '" + Id + "', '" + Message + "', '" + Title + "' }";
	}

	private int DB const;
}


public object TNewsCollection implements ICollection { //<TNewsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TNewsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TNewsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TNewsRecord first() const {
		return Collection.first();
	}

	public Iterator<TNewsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TNewsRecord last() const {
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
			var record = new TNewsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TNewsRecord( DB );
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

	public void push_back( TNewsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TNewsRecord> Collection;
	private int DB const;
}


