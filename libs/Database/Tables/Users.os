
import System.Collections.Vector;

public object TUsersRecord {
	public int Id;
	public string Identifier;
	public int IsAdmin;
	public string LastModified;
	public string Password;
	public string Prename;
	public string Surname;
	public string Username;

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
		var query = "DELETE FROM users WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO users ( `id`, `identifier`, `is_admin`, `last_modified`, `password`, `prename`, `surname`, `username` ) VALUES ( '" + Id + "', '" + Identifier + "', '" + IsAdmin + "', NULLIF('" + LastModified + "', ''), '" + Password + "', '" + Prename + "', '" + Surname + "', '" + Username + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO users ( `id`, `identifier`, `is_admin`, `last_modified`, `password`, `prename`, `surname`, `username` ) VALUES ( '" + Id + "', '" + Identifier + "', '" + IsAdmin + "', NULLIF('" + LastModified + "', ''), '" + Password + "', '" + Prename + "', '" + Surname + "', '" + Username + "' ) ON DUPLICATE KEY UPDATE `identifier` = '" + Identifier + "', `is_admin` = '" + IsAdmin + "', `last_modified` = NULLIF('" + LastModified + "', ''), `password` = '" + Password + "', `prename` = '" + Prename + "', `surname` = '" + Surname + "', `username` = '" + Username + "'";

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
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Password = cast<string>( mysql_get_field_value( result, "password" ) );
		Prename = cast<string>( mysql_get_field_value( result, "prename" ) );
		Surname = cast<string>( mysql_get_field_value( result, "surname" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM users WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Password = cast<string>( mysql_get_field_value( result, "password" ) );
		Prename = cast<string>( mysql_get_field_value( result, "prename" ) );
		Surname = cast<string>( mysql_get_field_value( result, "surname" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public void loadByResult( int result ) modify {
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Password = cast<string>( mysql_get_field_value( result, "password" ) );
		Prename = cast<string>( mysql_get_field_value( result, "prename" ) );
		Surname = cast<string>( mysql_get_field_value( result, "surname" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TUsersRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TUsersRecord { '" + Id + "', '" + Identifier + "', '" + IsAdmin + "', NULLIF('" + LastModified + "', ''), '" + Password + "', '" + Prename + "', '" + Surname + "', '" + Username + "' }";
	}

	private int DB const;
}


public object TUsersCollection implements ICollection { //<TUsersRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TUsersRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TUsersRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TUsersRecord first() const {
		return Collection.first();
	}

	public Iterator<TUsersRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TUsersRecord last() const {
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
			var record = new TUsersRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TUsersRecord( DB );
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

	public void push_back( TUsersRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TUsersRecord> Collection;
	private int DB const;
}


