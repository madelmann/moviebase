#!/usr/local/bin/webscript

// library imports
import System.Collections.Range;
import System.Exception;

// project imports
import libs.API;
import libs.Consts.General;
import libs.Database.Tables.Items;
import libs.Plugins.Common.ShowVideo;
import libs.Plugins.RenderPlugin;


private int NumPages;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
		var identifier = API.retrieve( "identifier", "" );
		var page = API.retrieve( "page", 1 );

		ShowVideos( identifier, page );
		ShowPages( page );
	} 

	private void ShowPages( int currentPage ) {
		print( "<div class='pagination3'>" );
		print( "<ul class='firstPage'>" );

		foreach ( int pageNum : 1..NumPages ) {	
			if (
				pageNum != 1 && pageNum != NumPages							// first and last page will always be visible
				&& (pageNum < currentPage - 2 || pageNum > currentPage + 2)		// 2 pages left and right of current page will always be visible
				&& pageNum % 20 != 0											// every 20th page will always be visible
			) {
				continue;
			}

			if ( pageNum == currentPage ) {
				print( "<li class='page_current'><a class='orangeButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
			else {
				print( "<li class='page_number'><a class='greyButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
		}

		print( "</ul>" );
		print( "</div>" );
	}

	private void ShowVideos( string identifier, int page ) throws {
		string query = "SELECT * "
					 + "FROM items "
					 + "WHERE deleted = false AND ( is_private = FALSE OR owner = '" + identifier + "' )";

		{
			Database.Query( "SELECT COUNT(*) AS numResults FROM ( " + query + " ) as tmp" );
			Database.FetchRow();

			NumPages = 1 + cast<int>( Database.GetFieldValue( "numResults" ) ) / NUM_VIDEOS_PER_PAGE;

			Json.BeginObject( "pagination" );
			Json.AddElement( "currentPage", page );
			Json.AddElement( "numPages", NumPages );
			Json.EndObject();
		}

		query += " ORDER BY added DESC, last_modified DESC";
		query += " LIMIT " + NUM_VIDEOS_PER_PAGE + " OFFSET " + ( page - 1 ) * NUM_VIDEOS_PER_PAGE;

		var items = new TItemsCollection( Database.Handle, query );

		foreach ( TItemsRecord record : items ) {
			ShowVideoPreview( cast<string>( record.Id ), record.Md5sum, Utils.prepareRating( cast<int>( record.RatingValue ), cast<int>( record.RatingCount ) ), record.Title, cast<string>( record.Views ), Utils.mIsLoggedIn );
		}

		print( "</div>" );
	}

	private int mNumPages;
}
