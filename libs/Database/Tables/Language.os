
import System.Collections.Vector;

public object TLanguageRecord {
	public string Description;
	public int Enabled;
	public int Id;
	public string Name;
	public string Token;

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
		var query = "DELETE FROM language WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO language ( `description`, `enabled`, `id`, `name`, `token` ) VALUES ( '" + Description + "', '" + Enabled + "', '" + Id + "', '" + Name + "', '" + Token + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO language ( `description`, `enabled`, `id`, `name`, `token` ) VALUES ( '" + Description + "', '" + Enabled + "', '" + Id + "', '" + Name + "', '" + Token + "' ) ON DUPLICATE KEY UPDATE `description` = '" + Description + "', `enabled` = '" + Enabled + "', `name` = '" + Name + "', `token` = '" + Token + "'";

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
		Enabled = cast<int>( mysql_get_field_value( result, "enabled" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Token = cast<string>( mysql_get_field_value( result, "token" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM language WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Enabled = cast<int>( mysql_get_field_value( result, "enabled" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Token = cast<string>( mysql_get_field_value( result, "token" ) );
	}

	public void loadByResult( int result ) modify {
		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Enabled = cast<int>( mysql_get_field_value( result, "enabled" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		Token = cast<string>( mysql_get_field_value( result, "token" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TLanguageRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TLanguageRecord { '" + Description + "', '" + Enabled + "', '" + Id + "', '" + Name + "', '" + Token + "' }";
	}

	private int DB const;
}


public object TLanguageCollection implements ICollection { //<TLanguageRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TLanguageRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TLanguageRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TLanguageRecord first() const {
		return Collection.first();
	}

	public Iterator<TLanguageRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TLanguageRecord last() const {
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
			var record = new TLanguageRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TLanguageRecord( DB );
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

	public void push_back( TLanguageRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TLanguageRecord> Collection;
	private int DB const;
}


