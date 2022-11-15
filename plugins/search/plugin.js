
mPlugin = mSearchPlugin = {

OnAbort: function( event ) {
	alert( "OnAbort" );
},

OnError: function( event ) {
	alert( "OnError" );
},

OnLoad: function( event ) {
	this.pluginName = "search";

	mElQuery = document.getElementById( "query" );
	mElResult = document.getElementById( "result" );

	Parameters.addOrSet( "allowDelete", Account.IsLoggedIn() );
	Parameters.addOrSet( "allowSearch", Account.IsLoggedIn() );

	OnLoadReady();
},

OnLoadReady: function( event ) {
	this.SearchVideos();
},

OnSuccess: function(event) {
	mElResult.innerHTML = event.currentTarget.responseText;
},

SearchVideos: function() {
	if ( !Parameters.isSet("query") ) {
		return;
	}

	var page = Parameters.get( "page" );
	var query = Parameters.get( "query" );

	Parameters.clear();
	Parameters.add( "page", page ? page : 1 );
	Parameters.add( "query", query );

	execute( "search/search.os", this.OnSuccess, OnError, OnAbort );
},

ShowPage: function( page ) {
	// show a specific page

	var query = Parameters.get( "query" );

	Parameters.clear();
	Parameters.add( "page", page );
	Parameters.add( "query", query );

	LoadPluginWithHistory( "search" );
},

ShowVideo: function( itemID ) {
	if ( !itemID ) {
		return;
	}

	Parameters.clear();
	Parameters.add( "itemID", itemID );

	LoadPluginWithHistory( "showvideo" );
}

};

mCurrentPlugin = mSearchPlugin;

