
import System.Collections.Vector;

public object TActorsRecord {
	public string Description;
	public int Id;
	public string Name;
	public string Tags;

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
		var query = "DELETE FROM actors WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO actors ( `description`, `id`, `name`, `tags` ) VALUES ( '" + Description + "', '" + Id + "', '" + Name + "', '" + Tags + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO actors ( `description`, `id`, `name`, `tags` ) VALUES ( '" + Description + "', '" + Id + "', '" + Name + "', '" + Tags + "' ) ON DUPLICATE KEY UPDATE `description` = '" + Description + "', `name` = '" + Name + "', `tags` = '" + Tags + "'";

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

		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM actors WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
	}

	public void loadByResult( int result ) modify {
		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TActorsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TActorsRecord { '" + Description + "', '" + Id + "', '" + Name + "', '" + Tags + "' }";
	}

	private int DB const;
}


public object TActorsCollection implements ICollection { //<TActorsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TActorsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TActorsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TActorsRecord first() const {
		return Collection.first();
	}

	public Iterator<TActorsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TActorsRecord last() const {
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
			var record = new TActorsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TActorsRecord( DB );
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

	public void push_back( TActorsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TActorsRecord> Collection;
	private int DB const;
}


