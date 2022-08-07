
import System.Collections.Vector;

public object TItemsRecord {
	public string Actors;
	public string Added;
	public int Deleted;
	public string Filename;
	public int Filesize;
	public int Id;
	public int IsPrivate;
	public string LastModified;
	public int Length;
	public string Md5sum;
	public string Owner;
	public int RatingCount;
	public int RatingValue;
	public string Tags;
	public string Text;
	public string Title;
	public int Views;

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
		var query = "DELETE FROM items WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO items ( `actors`, `added`, `deleted`, `filename`, `filesize`, `id`, `is_private`, `last_modified`, `length`, `md5sum`, `owner`, `rating_count`, `rating_value`, `tags`, `text`, `title`, `views` ) VALUES ( '" + Actors + "', NULLIF('" + Added + "', ''), '" + Deleted + "', '" + Filename + "', '" + Filesize + "', '" + Id + "', '" + IsPrivate + "', NULLIF('" + LastModified + "', ''), '" + Length + "', '" + Md5sum + "', '" + Owner + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Text + "', '" + Title + "', '" + Views + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO items ( `actors`, `added`, `deleted`, `filename`, `filesize`, `id`, `is_private`, `last_modified`, `length`, `md5sum`, `owner`, `rating_count`, `rating_value`, `tags`, `text`, `title`, `views` ) VALUES ( '" + Actors + "', NULLIF('" + Added + "', ''), '" + Deleted + "', '" + Filename + "', '" + Filesize + "', '" + Id + "', '" + IsPrivate + "', NULLIF('" + LastModified + "', ''), '" + Length + "', '" + Md5sum + "', '" + Owner + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Text + "', '" + Title + "', '" + Views + "' ) ON DUPLICATE KEY UPDATE `actors` = '" + Actors + "', `added` = NULLIF('" + Added + "', ''), `deleted` = '" + Deleted + "', `filename` = '" + Filename + "', `filesize` = '" + Filesize + "', `is_private` = '" + IsPrivate + "', `last_modified` = NULLIF('" + LastModified + "', ''), `length` = '" + Length + "', `md5sum` = '" + Md5sum + "', `owner` = '" + Owner + "', `rating_count` = '" + RatingCount + "', `rating_value` = '" + RatingValue + "', `tags` = '" + Tags + "', `text` = '" + Text + "', `title` = '" + Title + "', `views` = '" + Views + "'";

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

		Actors = cast<string>( mysql_get_field_value( result, "actors" ) );
		Added = cast<string>( mysql_get_field_value( result, "added" ) );
		Deleted = cast<int>( mysql_get_field_value( result, "deleted" ) );
		Filename = cast<string>( mysql_get_field_value( result, "filename" ) );
		Filesize = cast<int>( mysql_get_field_value( result, "filesize" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		IsPrivate = cast<int>( mysql_get_field_value( result, "is_private" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Length = cast<int>( mysql_get_field_value( result, "length" ) );
		Md5sum = cast<string>( mysql_get_field_value( result, "md5sum" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
		Views = cast<int>( mysql_get_field_value( result, "views" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM items WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Actors = cast<string>( mysql_get_field_value( result, "actors" ) );
		Added = cast<string>( mysql_get_field_value( result, "added" ) );
		Deleted = cast<int>( mysql_get_field_value( result, "deleted" ) );
		Filename = cast<string>( mysql_get_field_value( result, "filename" ) );
		Filesize = cast<int>( mysql_get_field_value( result, "filesize" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		IsPrivate = cast<int>( mysql_get_field_value( result, "is_private" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Length = cast<int>( mysql_get_field_value( result, "length" ) );
		Md5sum = cast<string>( mysql_get_field_value( result, "md5sum" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
		Views = cast<int>( mysql_get_field_value( result, "views" ) );
	}

	public void loadByResult( int result ) modify {
		Actors = cast<string>( mysql_get_field_value( result, "actors" ) );
		Added = cast<string>( mysql_get_field_value( result, "added" ) );
		Deleted = cast<int>( mysql_get_field_value( result, "deleted" ) );
		Filename = cast<string>( mysql_get_field_value( result, "filename" ) );
		Filesize = cast<int>( mysql_get_field_value( result, "filesize" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		IsPrivate = cast<int>( mysql_get_field_value( result, "is_private" ) );
		LastModified = cast<string>( mysql_get_field_value( result, "last_modified" ) );
		Length = cast<int>( mysql_get_field_value( result, "length" ) );
		Md5sum = cast<string>( mysql_get_field_value( result, "md5sum" ) );
		Owner = cast<string>( mysql_get_field_value( result, "owner" ) );
		RatingCount = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		RatingValue = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		Tags = cast<string>( mysql_get_field_value( result, "tags" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
		Title = cast<string>( mysql_get_field_value( result, "title" ) );
		Views = cast<int>( mysql_get_field_value( result, "views" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TItemsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TItemsRecord { '" + Actors + "', NULLIF('" + Added + "', ''), '" + Deleted + "', '" + Filename + "', '" + Filesize + "', '" + Id + "', '" + IsPrivate + "', NULLIF('" + LastModified + "', ''), '" + Length + "', '" + Md5sum + "', '" + Owner + "', '" + RatingCount + "', '" + RatingValue + "', '" + Tags + "', '" + Text + "', '" + Title + "', '" + Views + "' }";
	}

	private int DB const;
}


public object TItemsCollection implements ICollection { //<TItemsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TItemsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TItemsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TItemsRecord first() const {
		return Collection.first();
	}

	public Iterator<TItemsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TItemsRecord last() const {
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
			var record = new TItemsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TItemsRecord( DB );
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

	public void push_back( TItemsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TItemsRecord> Collection;
	private int DB const;
}


