
function $( element )
{
	return document.querySelector( element );
}

function $all( element )
{
	return document.querySelectorAll( element );
}

function GetPluginName()
{
	if ( mPlugin && mPlugin.pluginName ) {
		return mPlugin.pluginName;
	}

	return "";
}

function IsFormValid( element )
{
	// Fetch all the forms we want to apply custom Bootstrap validation styles to
	var forms = $all( ".needs-validation" );
	if ( element ) {
		forms = $all( "form#" + element + ".needs-validation" );
	}

	if ( !forms ) {
		return true;
	}

	var elementsValid = true;
	forms.forEach( element => {
		if ( !element.checkValidity() ) {
			elementsValid = false;
			return false;
		}
	} );

	return elementsValid;
}

function IsPlugin( pluginName )
{
	return GetPluginName() == pluginName;
}

function ParseJSON( input, output )
{
	try {
		output.message = JSON.parse( input );

		return true;
	}
	catch ( e ) {
		output.message = e.message;
	}

	return false;
}

function Pagination( pagination )
{
	if ( !pagination || pagination.numPages < 2 ) {
		// pagination not needed or invalid
		return;
	}

	var tplPageCurrent     = Templates.clone( "template-pagination-large-page-current" );
	var tplPageNext        = Templates.clone( "template-pagination-large-page-next" );
	var tplPagePrevious    = Templates.clone( "template-pagination-large-page-previous" );
	var tplPage            = Templates.clone( "template-pagination-large-page" );
	var tplPaginationSmall = Templates.clone( "template-pagination-small" );
	var tplPaginationLarge = Templates.clone( "template-pagination-large-all-pages" );

	var modulo = Math.trunc( pagination.numPages / 3 );
	var pages = "";
	for ( var page = 1; page < pagination.numPages + 1; page++ ) {
		if (
			( page != 1 && page != pagination.currentPage && page != pagination.numPages )	// first and last page will always be visible
			&& ( page < pagination.currentPage - 1 || page > pagination.currentPage + 1 )	// 1 page left and right of current page will always be visible
			&& ( page % modulo != 0 )														// every nth page will always be visible
		) {
			continue;
		}

		if ( page == pagination.currentPage ) {
			pages += tplPageCurrent.clone()
						.bind( "PAGE", page )
						.str();

			continue;
		}

		pages += tplPage      .clone()
					.bind( "PAGE", page )
					.str();
	}

	tplPaginationLarge.bind( "PAGES", tplPagePrevious.str() + pages + tplPageNext.str() );
	tplPaginationSmall.bind( "CURRENT_PAGE", pagination.currentPage );

	var pages = $all( ".pagination" );
	for ( var idx = 0; idx < pages.length; idx++ ) {
		pages[ idx ].innerHTML = tplPaginationSmall.str() + tplPaginationLarge.str();

		Translations.translate( pages[ idx ] );
	}
}

function PaginationSmall( pagination )
{
	if ( !pagination || pagination.numPages < 2 ) {
		// pagination not needed or invalid
		return;
	}

	var tplPagination = Templates.clone( "template-pagination-small" )
							.bind( "CURRENT_PAGE", pagination.currentPage );

	var pages = $all( ".pagination" );
	for ( var idx = 0; idx < pages.length; idx++ ) {
		pages[ idx ].innerHTML = tplPagination.str();

		Translations.translate( pages[ idx ] );
	}
}

function PaginationLarge( pagination )
{
	if ( !pagination || pagination.numPages < 2 ) {
		// pagination not needed or invalid
		return;
	}

	var tplPageCurrent  = Templates.clone( "template-pagination-large-page-current" );
	var tplPageNext     = Templates.clone( "template-pagination-large-page-next" );
	var tplPagePrevious = Templates.clone( "template-pagination-large-page-previous" );
	var tplPage         = Templates.clone( "template-pagination-large-page" );
	var tplPagination   = Templates.clone( "template-pagination-large-all-pages" );

	var modulo = Math.trunc( pagination.numPages / 4 );
	var pages = "";
	for ( var page = 1; page < pagination.numPages + 1; page++ ) {
		if (
			( page != 1 && page != pagination.currentPage && page != pagination.numPages + 1 )	// first and last page will always be visible
			&& ( page < pagination.currentPage - 1 || page > pagination.currentPage + 1 )		// 2 pages left and right of current page will always be visible
			&& ( page % modulo != 0 )															// every nth page will always be visible
		) {
			continue;
		}

		if ( page == pagination.currentPage ) {
			pages += tplPageCurrent.clone()
						.bind( "PAGE", page )
						.str();

			continue;
		}

		pages += tplPage.clone()
					.bind( "PAGE", page )
					.str();
	}

	tplPagination.bind( "PAGES", tplPagePrevious.str() + pages + tplPageNext.str() );

	var pages = $all( ".pagination" );
	for ( var idx = 0; idx < pages.length; idx++ ) {
		pages[ idx ].innerHTML = tplPagination.str();

		Translations.translate( pages[ idx ] );
	}
}


function utf8_to_b64( str ) {
	return btoa( unescape( encodeURIComponent( str ) ) );
}

function b64_to_utf8( str ) {
	return decodeURIComponent( escape( atob( str ) ) );
}

function sleep( delay ) {
    var start = new Date().getTime();

    while ( new Date().getTime() < start + delay ) ;
}

function toFixed( num, fixed ) {
	fixed = fixed || 0;
	fixed = Math.pow( 10, fixed );

	return Math.floor( num * fixed ) / fixed;

	//return ( Math.floor( num * 100 ) / 100 ).toFixed( fixed );
}

///////////////////////////////////////////////////////////////////////////////
// Stylesheet handling

function LoadStyleSheet( DOMelement, url )
{
	//DOMelement = document.createElement( "link" );

	DOMelement.disabled = false;
	DOMelement.setAttribute( "rel", "stylesheet" );
	DOMelement.setAttribute( "type", "text/css" );
	DOMelement.setAttribute( "href", url + "?v=" + APP_VERSION );

	//document.body.appendChild( DOMelement );
}

function UnloadStyleSheet( DOMelement )
{
    DOMelement.disabled = true;
    //DOMelement.parentNode.removeChild( DOMelement );
    DOMelement.href = "data:text/css,"; // empty stylesheet to be sure
}

// Stylesheet handling
///////////////////////////////////////////////////////////////////////////////
