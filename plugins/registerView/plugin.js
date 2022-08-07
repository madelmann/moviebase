
mPlugin = {

    // consts
    REGISTER_VIEW: "registerView",

    // instance members
    pluginName: "registerView",

	OnLoad: function( event ) {
		mElDisclaimerAccepted = document.getElementById( "disclaimer_accepted" );
		mElUsername = document.getElementById( "username" );
		mElPassword = document.getElementById( "password" );
		if ( mElPassword ) {
			mElPassword.addEventListener( "keyup", function( event ) {
				event.preventDefault();
				if ( event.keyCode == 13 ) {
					mPlugin.Register();
				}
			});
		}

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		LoadingFinished();
	},

	OnRegisterFailed: function( message ) {
		Notifications.notifyError( "REGISTRATION_ERROR" );
	},

	OnRegisterSuccess: function() {
		Notifications.notifySuccess( "REGISTRATION_SUCCESS" );

		Parameters.clear();

		LoadPlugin( "loginView" );
	},

	Register: function() {
		if ( !mElDisclaimerAccepted.checked ) {
			Notifications.notifyWarning( "DISCLAIMER_NOT_ACCEPTED" );
			return;
		}

		Account.Register( mElUsername.value, mPlugin.OnRegisterSuccess, mPlugin.OnRegisterFailed );
	}

};

mCurrentPlugin = mPlugin;

