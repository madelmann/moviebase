
mPlugin = {

    // consts
    LOGIN_VIEW: "loginView",

    // instance members
    pluginName: "loginView",

	OnKeyPress: function( event ) {
		Login();
	},

	OnLoad: function( event ) {
		mElPassword = document.getElementById( "password" );
		mElStayLoggedIn = document.getElementById( "stay_logged_in" );
		mElUsername = document.getElementById( "username" );

		if ( mElPassword ) {
			mElPassword.addEventListener( "keyup", function( event ) {
				event.preventDefault();

				if ( event.keyCode == 13 ) {
					mPlugin.Login();
				}
			});
		}

		this.OnLoadReady();
	},

	OnLoadReady: function() {
		LoadingFinished();
	},

	Login: function() {
		Account.Login( mElUsername.value, mElPassword.value, mElStayLoggedIn.checked, OnLoginSuccess, OnLoginFailed );
	},

	Logout: function() {
		Account.Logout( OnLogoutSuccess );
	},

	Register: function() {
		Parameters.clear();

		LoadPluginWithHistory( "registerView" );
	},

	ResetPassword: function() {
		Parameters.clear();

		LoadPluginWithHistory( "resetPasswordView" );
	}

};

mCurrentPlugin = mPlugin;

