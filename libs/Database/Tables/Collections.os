
import System.Collections.Vector;

public object TCollectionsRecord {
	public string Description;
	public int Id;
	public string Identifier;
	public int IsPublic;
	public string Name;
	public int RatingCount;
	public int RatingValue;
	public string Tags;
	public int Type;

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
		var query = "DELETE FROM collections WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO collections ( `description`, `id`, `identifier`, `is_public`, `name`, `rating_count`, `rating_value`, `tags`, `type` ) VALUES ( '" + Description + "', '" + Id + "', '" + Identifier + "', '" + IsPublic + "', '" + Name + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Type + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO collections ( `description`, `id`, `identifier`, `is_public`, `name`, `rating_count`, `rating_value`, `tags`, `type` ) VALUES ( '" + Description + "', '" + Id + "', '" + Identifier + "', '" + IsPublic + "', '" + Name + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Type + "' ) ON DUPLICATE KEY UPDATE `description` = '" + Description + "', `identifier` = '" + Identifier + "', `is_public` = '" + IsPublic + "', `name` = '" + Name + "', `rating_count` = '" + RatingCount + "', `rating_value` = '" + RatingValue + "', `tags` = '" + Tags + "', `type` = '" + Type + "'";

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
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsPublic = cast<int>( mysql_get_field_value( result, "is_public" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Type = cast<int>( mysql_get_field_value( result, "type" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM collections WHERE id = '" + id + "'";

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
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsPublic = cast<int>( mysql_get_field_value( result, "is_public" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Type = cast<int>( mysql_get_field_value( result, "type" ) );
	}

	public void loadByResult( int result ) modify {
		Description = cast<string>( mysql_get_field_value( result, "description" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IsPublic = cast<int>( mysql_get_field_value( result, "is_public" ) );
		Name = cast<string>( mysql_get_field_value( result, "name" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Type = cast<int>( mysql_get_field_value( result, "type" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TCollectionsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TCollectionsRecord { '" + Description + "', '" + Id + "', '" + Identifier + "', '" + IsPublic + "', '" + Name + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Type + "' }";
	}

	private int DB const;
}


public object TCollectionsCollection implements ICollection { //<TCollectionsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TCollectionsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TCollectionsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TCollectionsRecord first() const {
		return Collection.first();
	}

	public Iterator<TCollectionsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TCollectionsRecord last() const {
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
			var record = new TCollectionsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TCollectionsRecord( DB );
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

	public void push_back( TCollectionsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TCollectionsRecord> Collection;
	private int DB const;
}


