
import System.Collections.Vector;

public object TGroupsRecord {
	public int Id;
	public string Name;

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
		var query = "DELETE FROM groups WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO groups ( `id`, `name` ) VALUES ( '" + Id + "', '" + Name + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO groups ( `id`, `name` ) VALUES ( '" + Id + "', '" + Name + "' ) ON DUPLICATE KEY UPDATE `name` = '" + Name + "'";

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

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM groups WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
	}

	public void loadByResult( int result ) modify {
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TGroupsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TGroupsRecord { '" + Id + "', '" + Name + "' }";
	}

	private int DB const;
}


public object TGroupsCollection implements ICollection { //<TGroupsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TGroupsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TGroupsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TGroupsRecord first() const {
		return Collection.first();
	}

	public Iterator<TGroupsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TGroupsRecord last() const {
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
			var record = new TGroupsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TGroupsRecord( DB );
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

	public void push_back( TGroupsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TGroupsRecord> Collection;
	private int DB const;
}


