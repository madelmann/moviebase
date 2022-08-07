
mPlugin = {

OnAbort: function( event ) {
	// request execution failed
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function( event ) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function() {
	this.mPluginName = "showactor";

	mElActorImage = document.getElementById( "actor_image" );
	mElCollectionPlugin = document.getElementById( "collection-plugin" );
	mElCollections = document.getElementById( "collections" );
	mElName = document.getElementById( "name_label" );
	mElVideos = document.getElementById( "videos" );
	mElTagPlugin = document.getElementById( "tag-plugin" );
	mElTags = document.getElementById( "tags" );

	mActorID = null;
	mActorName = Parameters.get( "actor" );
	mCollectionPlugin = null;
	mImageBrowser = null;
	mPage = Parameters.get( "page" );
	mTagPlugin = null;

	this.OnLoadReady();
},

OnLoadReady: function() {
	// load actor data
	this.RequestActorData( mActorName );

	// load actor videos
	this.SearchVideos( mActorName, mPage );
},

OnLoadSuccess: function( event ) {
	var response = {};

	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			mPlugin.FillItemData( response.message );
		}
	}
	else {
		// error while parsing json string
		//alert( response.message );
	}
},

OnSearchSuccess: function( event ) {
	mElVideos.innerHTML = event.currentTarget.responseText;

	if ( !mElVideos.innerHTML ) {
		mElVideos.innerHTML = "keine Ergebnisse gefunden";
	}
},

OnSuccess: function( event ) {
	var response = {};

	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

OnCollectionPluginReady: function() {
	mElCollectionPlugin.hidden = false;
},

OnCollectionSelected: function( collectionID ) {
	if ( !mActorID ) {
		// invalid video id set
		return;
	}

	mElCollectionPlugin.hidden = true;


	Parameters.clear();
	Parameters.add( "actorID", mActorID );
	Parameters.add( "collectionID", collectionID );

	//execute( "admin/insertCollectionItem.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

OnTagPluginReady: function() {
	mElTagPlugin.hidden = false;
},

OnTagSelected: function( tag ) {
	if ( !mActorID ) {
		return;
	}

	mElTagPlugin.hidden = true;

	Parameters.clear();
	Parameters.add( "actorID", mActorID );
	Parameters.add( "tag", tag );

	execute( "admin/addActorTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

OnUpdateSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			// this needs to be activated as soon as all data is loaded via JavaScript
			mPlugin.RequestActorData( mActorName );
		}
	}
},

FillItemData: function( data ) {
	if ( !data ) {
		// invalid data received!
		return;
	}

	mActorID = data.id;
	mActorName = data.name;

	if ( data.collections ) {
		// display collections
		mElCollections.innerHTML = "";

		for ( var idx = 0; idx < data.collections.length; idx++ ) {
			mElCollections.innerHTML += RenderCollectionItem( null, data.collections[idx] );
		}
	}
	if ( data.name ) {
		// display name
		mElName.textContent = data.name;
	}
	if ( data.tags ) {
		// display tags
		mElTags.innerHTML = "";

		for ( var idx = 0; idx < data.tags.length; idx++ ) {
			mElTags.innerHTML += RenderTag( mActorID, data.tags[idx] );
		}
	}
	if ( data.thumbnail ) {
		// display actor image
		mElActorImage.src = data.thumbnail;
	}
},

Hide: function( element ) {
	mPlugin.SetVisibility( element, false );
},

HideAll: function() {
	mPlugin.Hide( "name" );

	// nothing else to hide
},

RemoveCollection: function( collectionID ) {
	if ( !collectionID ) {
		return false;
	}

	Parameters.clear();
	Parameters.add( "collectionID", collectionID );

	//execute( "admin/removeCollectionItem.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

RemoveTag: function( actorID, tag ) {
	if ( !tag ) {
		return false;
	}

	Parameters.clear();
	Parameters.add( "actorID", actorID );
	Parameters.add( "tag", tag );

	execute( "admin/removeActorTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

RequestActorData: function( actor ) {
	Parameters.clear();
	Parameters.add( "actor", actor );

	execute( "admin/loadActor.os", this.OnLoadSuccess, OnError, OnAbort );
},

ResetVideoVoting: function() {
	Parameters.clear();
	Parameters.add( "actorID", mActorID );

	//execute( "admin/resetVideoVoting.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

SearchTag: function( tag ) {
	// search for the given tag
	SearchTag( tag );
},

SearchVideos: function( actor, page ) {
	if ( !actor ) {
		return;
	}
	if ( !page ) {
		page = 1;
	}

	Parameters.clear();
	Parameters.add( "query", actor );
	Parameters.add( "page", page );

	execute( "admin/search.os", this.OnSearchSuccess, OnError, OnAbort );
},

SetVisibility: function( name, state ) {
	if ( !name ) {
		return;         // invalid name provided
	}

	var elCancel = document.getElementById( "cancel" );
	var elLabel = document.getElementById( name + "_label" );
	var elInput = document.getElementById( name + "_input" );
	var elSave = document.getElementById( name + "_save" );

	if ( elSave.hidden ) {
		elCancel.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elCancel.hidden = !state;
	elLabel.hidden = state;
	elInput.hidden = !state;
	elSave.hidden = !state;
},

Show: function( element ) {
	mPlugin.SetVisibility( element, true );
},

ShowAddCollection: function() {
	if ( !mElCollectionPlugin.hidden ) {
		mElCollectionPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add( "allowDelete", false );
	Parameters.add( "allowSearch", false );

	LoadPluginInto( "collections", mElCollectionPlugin, mPlugin.OnCollectionPluginReady, mPlugin.OnCollectionSelected );
},

ShowAddTag: function() {
	if ( !mElTagPlugin.hidden ) {
		mElTagPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add( "allowDelete", false );
	Parameters.add( "allowSearch", false );

	LoadPluginInto( "tags", mElTagPlugin, mPlugin.OnTagPluginReady, mPlugin.OnTagSelected );
},

ShowCollection: function( collectionID ) {
	if ( !collectionID ) {
		return;
	}

	Parameters.clear();
	Parameters.add( "collectionID", collectionID );

	LoadPluginWithHistory( "showcollection" );
},

ShowPage: function( page ) {
	// show a specific page

	Parameters.clear();
	Parameters.add( "actor", mActorName );
	Parameters.add( "page", page );

	LoadPluginWithHistory( "showactor" );
},

ShowVideo: function( videoID ) {
	if ( !videoID ) {
		return;
	}

	Parameters.clear();
	Parameters.add( "itemID", videoID );

	LoadPluginWithHistory( "showvideo" );
},

Store: function( name ) {
	if ( !name ) {
		return;
	}

	var elInput = document.getElementById( name + "_input" );

	Parameters.clear();
	Parameters.add( "actorID", mActorID );
	Parameters.add( name, elInput.value );

	execute( "admin/updateActor.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );

	mPlugin.Swap( name );
},

Swap: function( name ) {
	if ( !name ) {
		return;
	}

	var elCancel = document.getElementById( "cancel" );
	var elLabel = document.getElementById( name + "_label" );
	var elInput = document.getElementById( name + "_input" );
	var elSave = document.getElementById( name + "_save" );

	if ( elSave.hidden ) {
		elCancel.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elLabel.hidden = !elLabel.hidden;
	elInput.hidden = !elInput.hidden;
	elSave.hidden = !elSave.hidden;
},

Vote: function( value ) {
	Parameters.clear();
	Parameters.add( "actorID", mActorID );
	Parameters.add( "rating", value );

	execute( "admin/updateActor.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
}

}

mCurrentPlugin = mPlugin;

