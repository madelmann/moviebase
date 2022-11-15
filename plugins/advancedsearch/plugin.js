
mPlugin = {

OnAbort: function( event ) {
	// request execution aborted
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function( event ) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function( callback ) {
	this.mCallback = callback;
	this.pluginName = "advancedsearch";

	this.mElSearchResult = document.getElementById( "searchresults" );

	Parameters.addOrSet( "allowDelete", Account.IsLoggedIn() );
	Parameters.addOrSet( "allowSearch", Account.IsLoggedIn() );

	var searchTags = Parameters.get( "searchTags" );
	if ( searchTags ) {
		this.PrepareTags( searchTags );
	}
	else {
		Parameters.add( "searchTags", "" );
	}

	OnLoadReady();
},

OnLoadReady: function() {
	// nothing to do here atm
},

OnSearchSuccess: function( event ) {
	mPlugin.mElSearchResult.innerHTML = event.currentTarget.responseText;
},

OnSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		History.Refresh();
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

DeleteTag: function( id ) {
        if ( !id ) {
                return;
        }

        Parameters.clear();
        Parameters.add( "id", id );

        execute( "admin/deleteTag.os", this.OnSuccess, OnError, OnAbort );
},

PrepareTag: function( tag ) {
	var elTag = document.getElementById( "tag_" + tag );
	if ( !elTag ) {
		return;
	}

	elTag.classList.add( "selected" );
},

PrepareTags: function( tags ) {
	var list = tags.split( "|" );
	if ( list ) {
		list.forEach( tag => this.PrepareTag( tag ) );
	}

	this.mElSearchResult.innerHTML = "<img class='loading_spinner' src='resources/images/loading.gif' alt='Loading...'/>";

	execute( "advancedsearch/search.os", this.OnSearchSuccess, OnError, OnAbort );
},

SearchTag: function( tag ) {
	// search for the given tag
	Search( tag );
},

ShowPage: function( page ) {
	// show a specific page

	var searchTags = Parameters.get( "searchTags" );

	Parameters.clear();
	Parameters.add( "page", page );
	Parameters.add( "searchTags", searchTags );

	LoadPluginWithHistory( "advancedsearch" );
},

ShowVideo: function(id) {
	if ( !id ) {
		return;
	}

	var searchTags = Parameters.get( "searchTags" );

	Parameters.clear();
	Parameters.add( "itemID", id );
	Parameters.add( "searchTags", searchTags );

	LoadPluginWithHistory( "showvideo" );
},

ToggleTag: function( tag ) {
	var elTag = document.getElementById( "tag_" + tag );
	if ( !elTag ) {
		return;
	}

	this.mElSearchResult.innerHTML = "<img class='loading_spinner' src='resources/images/loading.gif' alt='Loading...'/>";

	var searchTags = Parameters.get( "searchTags" );
	if ( searchTags == "|" ) {
		searchTags = "";
	}

	if ( searchTags.includes( tag ) ) {
		elTag.classList.remove( "selected" );

		searchTags = searchTags.replace( tag, "" );
	}
	else {
		elTag.classList.add( "selected" );

		if ( searchTags ) {
			searchTags += "|";
		}

		searchTags += tag;
	}

	Parameters.addOrSet( "searchTags", searchTags );

	execute( "advancedsearch/search.os", this.OnSearchSuccess, OnError, OnAbort );
}

};

mCurrentPlugin = mPlugin;

