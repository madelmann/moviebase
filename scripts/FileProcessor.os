#!/usr/local/bin/slang

// library imports
import System.Exception;
import System.IO.File;

// project imports
import libs.Database.Tables.Items;
import TagProcessor;

public enum OperationMode {
	Filename,
	MD5sum,
	RefreshThumbnails,
	Size;
}

public object FileProcessor {
	public object Settings {
		public string FilePath;
		public List<string> Folders;
		public int OutputResolution;
		public OperationMode Mode;

		public void Constructor() {
			FilePath = ".";
			Folders = new List<string>();
			Mode = OperationMode.Filename;
			OutputResolution = 512;
		}

		public void addFolder( string folder ) modify {
			Folders.push_back( folder );
		}

		public string toString() const {
			return "Mode: " + cast<string>( Mode ) + ", Path: \"" + FilePath + "\", Resolution: " + OutputResolution;
		}
	}

	public void Constructor(string filename, int dbHandle, Settings settings) {
		assert( settings );

		mDBHandle     = dbHandle;
		mFilename     = filename;
		mSettings     = settings;
		mTagProcessor = new TagProcessor(dbHandle);


		// fetch owner for admin user
		{
			Database.Query( "SELECT identifier FROM users WHERE username = 'admin' LIMIT 1" );
			Database.FetchRow();

			mOwner = Database.GetFieldValue( "identifier" );
		}
	}

	public void process() {
		var file = new System.IO.File(mFilename, System.IO.File.AccessMode.ReadOnly);

		string c;
		string filename;
		while ( !file.isEOF() ) {
			c = file.readChar();

			if ( c == LINEBREAK ) {
				processFilename(mysql_real_escape_string(mDBHandle, filename));

				filename = "";
				continue;
			}

			filename += c;
		}
	}

	private bool checkFilenameExists(string filename) throws {
		string query = "SELECT * FROM items WHERE filename = \"" + filename + "\"";

		var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}

		var result = mysql_store_result(mDBHandle);
		if ( !result ) {
			throw "no result found";
		}

		return mysql_num_rows(result) > 0;
	}

	private bool checkMD5sumExists(string md5sum) throws {
		string query = "SELECT * FROM items WHERE md5sum = \"" + md5sum + "\"";

		var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}

		var result = mysql_store_result(mDBHandle);
		if ( !result ) {
			throw "no result found";
		}

		return mysql_num_rows(result) > 0;
	}

	private bool checkThumbnailExists(string md5sum) {
		try {
			var result = cast<int>( system( "locate '" + md5sum + "' | wc -l " ) );
			if ( result > 0 ) {
				return true;
			}
		}

		return false;
	}

	private void deleteItem( string filename ) throws {
		string query = "UPDATE items SET deleted = true WHERE filename = '" + filename + "'";

		var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}
	}

	private int generateThumbnail(string md5sum, string filename) {
		system( "ffmpegthumbnailer "
                      + " -i \"" + filename + "\""
                      + " -o " + mSettings.FilePath + md5sum
                      + " -s " + mSettings.OutputResolution );

		/*
		system( "thumbnail.sh "
                      + " '" + filename + "'"
                      + " " + mSettings.FilePath + md5sum
                      + " " + mSettings.OutputResolution );
		*/

		return cast<int>( system( "echo $?" ) );
	}

	private string getFileSize(string filename) {
		string size = system( "du \"" + filename + "\"" );

		return substr( size, 0, strfind( size, TABULATOR, 0 ) );
	}

	private string getMD5sum(string filename) {
		return substr( system( "md5sum \"" + filename + "\"" ), 0, 31 );
	}

	private void insertItem(string md5sum, string filename, string filesize) throws {
		int pos = 0;
		string title = filename;

		while ( (pos = strfind(title, "/")) > 0 ) {
			title = substr(title, pos + 1);
		}

		pos = strfind(title, ".mp4");
		if ( pos > 0 ) {
			title = substr(title, 0, strlen(title) - 4);
		}

		string query = "INSERT INTO items (added, filename, filesize, md5sum, owner, title) \
				VALUES (NOW(), \"" + filename + "\", " + filesize + ", \"" + md5sum + "\", \"" + mOwner + "\", \"" + mysql_real_escape_string(mDBHandle, title) + "\")\
				ON DUPLICATE KEY UPDATE \
					filename = \"" + filename + "\",
					owner = \"" + mOwner + "\",
					title = \"" + title  + "\"
				";

				var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}

		// update tags for newly inserted item
		{
			string query = "SELECT * FROM items WHERE md5sum = \"" + md5sum + "\"";

			var error = mysql_query(mDBHandle, query);
			if ( error ) {
				throw mysql_error(mDBHandle);
			}

			var result = mysql_store_result(mDBHandle);
			if ( !result ) {
				throw mysql_error(mDBHandle);
			}

			if ( mysql_fetch_row(result) ) {
				mTagProcessor.processItem(result);
			}
		}
	}

	private TItemsRecord loadItemByFilename(string filename) throws {
		string query = "SELECT * FROM items WHERE filename = \"" + filename + "\"";

		var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}

		var result = mysql_store_result(mDBHandle);
		if ( !result ) {
			throw mysql_error(mDBHandle);
		}

		if ( !mysql_fetch_row(result) ) {
			return TItemsRecord null;
		}

		var record = new TItemsRecord();
		record.Actors = mysql_get_field_value(result, "actors");
		record.Deleted = cast<bool>( mysql_get_field_value(result, "deleted") );
		record.Filename = filename;
		record.Filesize = cast<int>( mysql_get_field_value(result, "filesize") );
		record.Id = cast<int>( mysql_get_field_value(result, "id") );
		record.Md5sum = mysql_get_field_value(result, "md5sum");
		record.Tags = mysql_get_field_value(result, "tags");
		record.Title = mysql_get_field_value(result, "title");

		return record;
	}

	private TItemsRecord loadItemByMD5sum(string md5sum) throws {
		string query = "SELECT * FROM items WHERE md5sum = \"" + md5sum + "\"";

		var error = mysql_query(mDBHandle, query);
		if ( error ) {
			throw mysql_error(mDBHandle);
		}

		var result = mysql_store_result(mDBHandle);
		if ( !result ) {
			throw mysql_error(mDBHandle);
		}

		if ( !mysql_fetch_row(result) ) {
			return TItemsRecord null;
		}

		var record = new TItemsRecord();
		record.Actors = mysql_get_field_value(result, "actors");
		record.Deleted = cast<bool>( mysql_get_field_value(result, "deleted") );
		record.Filename = mysql_get_field_value(result, "filename");
		record.Filesize = cast<int>( mysql_get_field_value(result, "filesize") );
		record.Id = cast<int>( mysql_get_field_value(result, "id") );
		record.Md5sum = md5sum;
		record.Tags = mysql_get_field_value(result, "tags");
		record.Title = mysql_get_field_value(result, "title");

		return record;
	}

	private void processByFilename( string filename ) {
		var record = loadItemByFilename( filename );
		if ( !record ) {
			// no record with this filename found => insert a completely new item

			string filesize = getFileSize( filename );
			string md5sum = getMD5sum( filename );

			insertItem( md5sum, filename, filesize );
			write( "inserted " );
			generateThumbnail( md5sum, filename );
			write( "and generated thumbnail " );
		}
		else {
			write( "checked " );
		}
	}

	private void processByMD5sum( string filename ) {
		string filesize = getFileSize( filename );
		string md5sum = getMD5sum( filename );

		var record = loadItemByMD5sum( md5sum );
		if ( !record ) {
			// no record with this filename found => insert a completely new item

			// insert the new item
			insertItem( md5sum, filename, filesize );
			write( "inserted " );

			// and generate a thumbnail for it
			generateThumbnail( md5sum, filename );
			write( "and generated thumbnail " );
		}
		else if ( record.Filename != filename ) {
			// either the filename has changed or this is a duplicate

			// insert the new item
			insertItem( md5sum, filename, filesize );
			write( "inserted " );

			// and set the old one to deleted
			deleteItem( record.Filename );
		}
		else {
			write( "checked " );
		}
	}

	private void refreshThumbnail( string filename ) {
		string md5sum = getMD5sum( filename );
		if ( !md5sum ) {
			// either an error ocurred during md5sum calculation or the file doesn't exist
			return;
		}

		// generate a thumbnail for this file
		generateThumbnail( md5sum, filename );

		write( "generated thumbnail " );
	}

	private void processFilename(string filename) {
		if ( !mSettings.Folders.empty() ) {
			foreach ( string folder : mSettings.Folders ) {
				if ( folder != substr( filename, 0, strlen( folder ) ) ) {
					return;
				}
			}
		}

		try {
			write( "File \"" + filename + "\" " );

			switch ( mSettings.Mode ) {
				case OperationMode.Filename:          { processByFilename( filename ); break; }
				case OperationMode.MD5sum:            { processByMD5sum( filename ); break; }
				case OperationMode.RefreshThumbnails: { refreshThumbnail( filename ); break; }
				case OperationMode.Size:              { updateFileSize( filename ); break; }
				default:	                      { throw "invalid execution mode set!"; }
			}

			writeln( "successfully" );
		}
		catch ( string e ) {
			print( "failed" );
			print( "Exception: " + e );
		}
		catch ( IException e ) {
			print( "failed" );
			print( "Exception: " + e.what() );
		}
		catch {
			print( "failed" );
		}
	}

	private void updateFileSize( string filename ) throws {
		string size = getFileSize( filename );
		if ( !size ) {
			return;
		}

		string query = "UPDATE items SET filesize = " + size + " WHERE filename = \"" + filename + "\"";

		var error = mysql_query( mDBHandle, query );
		if ( error ) {
			throw mysql_error( mDBHandle );
		}

		write( "updated file size " );
	}

	private int mDBHandle;
	private string mFilename;
	private string mOwner;
	private Settings mSettings;
	private TagProcessor mTagProcessor;
}

