
mPlugin = {

    // consts
    RESETPASSWORD_VIEW: "resetpasswordView",

    // instance members
    pluginName: "resetpasswordView",

	OnLoad: function( event ) {
		mElUsername = document.getElementById( "username" );
		if ( mElUsername ) {
			mElUsername.addEventListener( "keyup", function( event ) {
				event.preventDefault();
				if ( event.keyCode == 13 ) {
					mPlugin.ResetPassword();
				}
			});
		}

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		LoadingFinished();
	},

	OnResetPasswordFailed: function( message ) {
		Notifications.notifyError( "RESET_PASSWORD_ERROR" );
	},

	OnResetPasswordSuccess: function() {
		Notifications.notifyInfo( "RESET_PASSWORD_SUCCESS" );

		Parameters.clear();

		LoadPlugin( "loginView" );
	},

	ResetPassword: function() {
		Account.ResetPassword( mElUsername.value, mPlugin.OnResetPasswordSuccess, mPlugin.OnResetPasswordFailed );
	}

};

mCurrentPlugin = mPlugin;

