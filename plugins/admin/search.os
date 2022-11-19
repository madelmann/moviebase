#!/usr/local/bin/webscript

// library imports
import System.Collections.List;
import System.Collections.Range;
import System.StringIterator;

// project imports
import libs.API;
import libs.Consts.General;
import libs.MainDB;
import libs.Plugins.Common.ShowVideo;
import libs.Plugins.RenderPlugin;


public object RenderPlugin implements IRenderPlugin {
	public void Render() modify {
		var query = API.retrieve( "query", "" );
		if ( !query ) {
			return ShowNoQueryGiven();
		}

		mIdentifier = API.retrieve( "identifier", "" );
		mPage       = API.retrieve( "page", 1 );

		mResults = new List<string>();

		SearchActor( query );
		SearchTitle( query );

		var tags = ExtractTags( query );
		if ( !tags.empty() ) {
			SearchTags( tags );
		}

		ShowPages();
	}

	private List<string> ExtractTags( string userquery ) {
		var result = new List<string>();

		var it = new StringIterator( userquery, "|" );
		while ( it.hasNext() ) {
			result.push_back( it.next() );
		}

		return result;
	}

	private int getNumPages() throws {
		return mResults.size() / NUM_VIDEOS_PER_PAGE + 1;
	}

	private void PrintResult( int result ) modify {
		var filename = mysql_get_field_value( result, "filename" );
		if ( mResults.contains( filename ) ) {
			return;
		}

		mResults.push_back( filename );

		var currentPage = mResults.size() / NUM_VIDEOS_PER_PAGE + 1;
		if ( currentPage != mPage ) {
			return;
		}

		var id = mysql_get_field_value( result, "id" );
		var actors = mysql_get_field_value( result, "actors" );
		var md5sum = mysql_get_field_value( result, "md5sum" );
		var rating_count = mysql_get_field_value( result, "rating_count" );
		var rating_value = mysql_get_field_value( result, "rating_value" );
		var tags = mysql_get_field_value( result, "tags" );
		var title = substr( mysql_get_field_value(result , "title" ), 0, 42 );
		var views = mysql_get_field_value( result, "views" );

		ShowVideoPreview( id, md5sum, Utils.prepareRating( cast<int>( rating_value ), cast<int>( rating_count ) ), title, views, Utils.mIsLoggedIn );
	}

	private void Query( string query ) modify throws {
		mysql_query( Database.Handle, query );

		var result = mysql_store_result( Database.Handle );
		if ( !result ) {
			throw mysql_error( Database.Handle );
		}

		while ( mysql_fetch_row( result ) ) {
			PrintResult( result );
		}
	}

	private void SearchActor( string userquery ) modify {
		Query( "SELECT actors, filename, id, md5sum, rating_count, rating_value, tags, title, views FROM items WHERE deleted = FALSE AND ( is_private = FALSE OR owner = '" + mIdentifier + "' ) AND LOWER(actors) LIKE LOWER('%" + userquery + "%') ORDER BY TITLE ASC" );
	}

	private void SearchTitle( string userquery ) modify {
		Query( "SELECT actors, filename, id, md5sum, rating_count, rating_value, tags, title, views FROM items WHERE deleted = FALSE AND ( is_private = FALSE OR owner = '" + mIdentifier + "' ) AND LOWER(title) LIKE LOWER('%" + userquery + "%') ORDER BY TITLE ASC" );
	}

	private void SearchTags( List<string> tags ) modify {
		foreach ( string tag : tags ) {
			Query( "SELECT actors, filename, id, md5sum, rating_count, rating_value, tags, title, views FROM items WHERE deleted = FALSE AND ( is_private = FALSE OR owner = '" + mIdentifier + "' ) AND LOWER(tags) LIKE LOWER('%" + tag + "%') ORDER BY TITLE ASC" );
		}
	}

	private void ShowNoQueryGiven() const {
		print( "No tags selected." );
	}

	private void ShowPages() {
		print( "<div class='pagination3'>" );
		print( "<ul class='firstPage'>" );
		
		var numPages = getNumPages();
		foreach ( int pageNum : 1..numPages ) {	
			if (
				pageNum != 1 && pageNum != numPages			// first and last page will always be visible
				&& (pageNum < mPage - 2 || pageNum > mPage + 2)		// 2 pages left and right of current page will always be visible
				&& pageNum % 20 != 0					// every 20th page will always be visible
			) {
				continue;
			}

			if ( pageNum == mPage ) {
				print( "<li class='page_current'><a class='orangeButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
			else {
				print( "<li class='page_number'><a class='greyButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
		}

		print( "</ul>" );
		print( "</div>" );
	}

	private string mIdentifier;
	private int mPage;
	private List<string> mResults;
}


