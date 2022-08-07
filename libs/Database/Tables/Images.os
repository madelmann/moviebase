
import System.Collections.Vector;

public object TImagesRecord {
	public int Id;
	public string Image;
	public int IsDeleted;
	public int IsProcessed;
	public int IsProcessing;
	public string Owner;
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
		var query = "DELETE FROM images WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO images ( `id`, `image`, `is_deleted`, `is_processed`, `is_processing`, `owner`, `title` ) VALUES ( '" + Id + "', '" + Image + "', '" + IsDeleted + "', '" + IsProcessed + "', '" + IsProcessing + "', '" + Owner + "', '" + Title + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO images ( `id`, `image`, `is_deleted`, `is_processed`, `is_processing`, `owner`, `title` ) VALUES ( '" + Id + "', '" + Image + "', '" + IsDeleted + "', '" + IsProcessed + "', '" + IsProcessing + "', '" + Owner + "', '" + Title + "' ) ON DUPLICATE KEY UPDATE `image` = '" + Image + "', `is_deleted` = '" + IsDeleted + "', `is_processed` = '" + IsProcessed + "', `is_processing` = '" + IsProcessing + "', `owner` = '" + Owner + "', `title` = '" + Title + "'";

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
		Image = cast<string>( mysql_get_field_value( result, "image" ) );
		IsDeleted = cast<int>( mysql_get_field_value( result, "is_deleted" ) );
		IsProcessed = cast<int>( mysql_get_field_value( result, "is_processed" ) );
		IsProcessing = cast<int>( mysql_get_field_value( result, "is_processing" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM images WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Image = cast<string>( mysql_get_field_value( result, "image" ) );
		IsDeleted = cast<int>( mysql_get_field_value( result, "is_deleted" ) );
		IsProcessed = cast<int>( mysql_get_field_value( result, "is_processed" ) );
		IsProcessing = cast<int>( mysql_get_field_value( result, "is_processing" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void loadByResult( int result ) modify {
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Image = cast<string>( mysql_get_field_value( result, "image" ) );
		IsDeleted = cast<int>( mysql_get_field_value( result, "is_deleted" ) );
		IsProcessed = cast<int>( mysql_get_field_value( result, "is_processed" ) );
		IsProcessing = cast<int>( mysql_get_field_value( result, "is_processing" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TImagesRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TImagesRecord { '" + Id + "', '" + Image + "', '" + IsDeleted + "', '" + IsProcessed + "', '" + IsProcessing + "', '" + Owner + "', '" + Title + "' }";
	}

	private int DB const;
}


public object TImagesCollection implements ICollection { //<TImagesRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TImagesRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TImagesRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TImagesRecord first() const {
		return Collection.first();
	}

	public Iterator<TImagesRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TImagesRecord last() const {
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
			var record = new TImagesRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TImagesRecord( DB );
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

	public void push_back( TImagesRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TImagesRecord> Collection;
	private int DB const;
}


