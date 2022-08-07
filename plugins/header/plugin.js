
Header = {

	OnLoad: function() {
		mElSearchQuery = document.getElementById( "query" );

		if ( mElSearchQuery ) {
			mElSearchQuery.addEventListener( "keyup", function( event ) {
				event.preventDefault();
				if ( event.keyCode == 13 ) {
					SearchVideos();
				}
			} );
		}

		this.OnLoadReady();
	},

	OnLoadReady: function() {
		// nothing to do here
	},

	Login: function() {
		Parameters.clear();

		LoadPlugin( "loginView" );
	},

	Reload: function() {
		var menuItems = document.getElementsByClassName( "admin" );

		for ( var idx = 0; idx < menuItems.length; ++idx ) {
			if ( Account.IsLoggedIn() ) {
				menuItems[idx].classList.remove( "admin_hidden" );
			}
			else {
				menuItems[idx].classList.add( "admin_hidden" );
			}
		}
	},

	SearchVideos: function() {
		Parameters.clear();

		LoadPluginWithHistory( "search" );
	},

	Settings: function() {
		Parameters.clear();

		LoadPluginWithHistory( "settingsView" );
	},

	ShowActors: function() {
		Parameters.clear();
		Parameters.add( "allowDelete", Account.IsLoggedIn() );
		Parameters.add( "allowSearch", true);

		LoadPluginWithHistory( "actors" );
	},

	ShowAddVideo: function() {
		Parameters.clear();

		LoadPluginWithHistory( "addvideo" );
	},

	ShowAdmin: function() {
		Parameters.clear();

		LoadPluginWithHistory( "admin" );
	},

	ShowAdvancedSearch: function() {
		Parameters.clear();
		Parameters.add( "allowDelete", Account.IsLoggedIn() );
		Parameters.add( "allowSearch", true);

		LoadPluginWithHistory( "advancedsearch" );
	},

	ShowCollections: function() {
		Parameters.clear();
		Parameters.add( "allowDelete", Account.IsLoggedIn() );
		Parameters.add( "allowSearch", true);

		LoadPluginWithHistory( "collections" );
	},

	ShowDownloads: function() {
		Parameters.clear();

		LoadPluginWithHistory( "downloads" );
	},

	ShowHome: function() {
		Parameters.clear();

		LoadPluginWithHistory( "home" );
	},

	ShowTags: function() {
		Parameters.clear();
		Parameters.add( "allowDelete", mAccount.IsLoggedIn() );
		Parameters.add( "allowSearch", true);

		LoadPluginWithHistory( "tags" );
	},

	ShowVideos: function() {
		Parameters.clear();

		LoadPluginWithHistory( "showvideos" );
	}

};

mCurrentPlugin = Header;