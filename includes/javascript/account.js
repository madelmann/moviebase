
const DEFAULT_LANGUAGE = "EN";

Account = {

	identifier: null,
	language: DEFAULT_LANGUAGE,
	persistentSession: false,
	sessionId: null,

OnError: function( event ) {
	// request execution failed
	Notifications.notifyError( event.currentTarget.responseText );

	Account.Logout( History.Refresh );
},

OnLoginSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			Account.SetLogin( response.message.data );

			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else {
			if ( mCallbackFailed ) {
				mCallbackFailed( response.message.message );
			}
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnRegisterSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnSessionReload: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			Account.SetLogin( response.message.data );
		}
		else {
			Account.Logout( LoadPlugin( "loginView" ) );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnUpdateSuccess: function( event ) {
	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

Constructor: function() {
	mCallbackFailed = null;
	mCallbackSuccess = null;
	mElLoginLabel = null;
	mElSettingsLabel = null;

	this.identifier = localStorage.getItem( "identifier" );
	this.persistentSession = localStorage.getItem( "persistentSession" );
	this.sessionId = localStorage.getItem( "sessionID" );

	if ( this.identifier && this.sessionId ) {
		Parameters.addOrSetPermanent( "identifier", this.identifier );
		Parameters.addOrSetPermanent( "sessionID", this.sessionId );

		Account.ReloadSession( this.identifier, this.sessionId );
	}
},

DeleteAccount: function( identifier ) {
	execute( "admin/deleteUser.os", Logout, this.OnError, OnAbort );
},

GetIdentifier: function() {
	return this.identifier;
},

GetLastPlugin: function() {
	return localStorage.getItem( "lastPlugin" );
},

GetSessionId: function() {
	return this.sessionId;
},

IsLoggedIn: function() {
	return this.identifier && this.sessionId;
},

IsSessionPersistent: function() {
	return this.identifier && this.persistentSession;
},

Login: function( username, password, stayLoggedIn, callbackSuccess, callbackFailed ) {
	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	this.persistentSession = stayLoggedIn;

	Parameters.clear();
	Parameters.add( "username", username );
	Parameters.add( "password", password );
	Parameters.add( "stayLoggedIn", stayLoggedIn );

	execute( "admin/loginUser.os", this.OnLoginSuccess, this.OnError, OnAbort );
},

Logout: function( callbackSuccess ) {
	if ( mElLoginLabel ) {
		mElLoginLabel.classList.remove( "hidden" );
	}
	if ( mElSettingsLabel ) {
		mElSettingsLabel.classList.add( "hidden" );
	}

	mCallbackFailed = null;
	mCallbackSuccess = callbackSuccess;

	this.identifier = null;
	this.persistentSession = false;
	this.sessionId = null;

	localStorage.removeItem( "identifier" );
	localStorage.removeItem( "lastPlugin" );
	localStorage.removeItem( "persistentSession" );
	localStorage.removeItem( "sessionID" );

	execute( "admin/logoutUser.os" );

	Parameters.removePermanent( "identifier" );
	Parameters.removePermanent( "sessionID" );

	if ( callbackSuccess ) {
		callbackSuccess();
	}
},

Register: function( username, callbackSuccess, callbackFailed ) {
	mCallbackFailed = callbackFailed
	mCallbackSuccess = callbackSuccess;

	Parameters.clear();
	Parameters.add( "username", username );

	execute( "admin/registerUser.os", this.OnRegisterSuccess, this.OnError, OnAbort );
},

ReloadSession: function( identifier, sessionID ) {
	Parameters.clear();
	Parameters.addOrSet( "identifier", identifier );
	Parameters.addOrSet( "sessionID", sessionID );

	execute( "admin/loadSession.os", this.OnSessionReload, this.OnError, OnAbort );
},

ResetPassword: function( username, callbackSuccess, callbackFailed ) {
	if ( !username ) {
		if ( callbackFailed ) {
			callbackFailed( "username identifier" );
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "username", username );

	execute( "admin/resetPassword.os", this.OnSuccess, this.OnError, OnAbort );
},

SetCurrentPlugin: function( pluginName ) {
	localStorage.setItem( "lastPlugin", pluginName );
},

SetLogin: function( data ) {
	if ( !mElLoginLabel ) {
		mElLoginLabel = document.getElementById( "login_label" );
	}
	if ( mElLoginLabel ) {
		mElLoginLabel.classList.add( "hidden" );
	}
	if ( !mElSettingsLabel ) {
		mElSettingsLabel = document.getElementById( "settings_label" );
	}
	if ( mElSettingsLabel ) {
		mElSettingsLabel.textContent = data.username;
		mElSettingsLabel.classList.remove( "hidden" );
	}

	this.identifier = data.identifier;
	this.sessionId = data.sessionID;

	localStorage.setItem( "identifier", this.identifier );
	localStorage.setItem( "persistentSession", this.persistentSession );
	localStorage.setItem( "sessionID", this.sessionId );

	Parameters.addOrSetPermanent( "identifier", this.identifier );
	Parameters.addOrSetPermanent( "sessionID", this.sessionId );

	Account.SwitchLanguage( data.language );
},

SwitchLanguage: function( language ) {
	if ( !language ) {
		language = DEFAULT_LANGUAGE;
	}

	if ( this.language == language ) {
		// no need to change anything
		return;
	}

	this.language = language;
	document.documentElement.setAttribute( "lang", language.toLowerCase() );

	Translations.loadLanguage( language );
},

SwitchUser: function( identifier, sessionID ) {
	this.identifier = identifier;
	this.sessionId = sessionID;

	Parameters.addOrSetPermanent( "identifier", this.identifier );
	Parameters.addOrSetPermanent( "sessionID", this.sessionId );

	Navigation.Reload();
},

UpdatePassword: function( identifier, password, callbackSuccess, callbackFailed ) {
	if ( !identifier ) {
		if ( callbackFailed ) {
			callbackFailed( "invalid identifier" );
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "password", password );

	execute( "admin/updatePassword.os", this.OnSuccess, this.OnError, OnAbort );
},

UpdateUser: function( identifier, prename, surname, callbackSuccess, callbackFailed ) {
	if ( !identifier ) {
		if ( callbackFailed ) {
			callbackFailed("invalid identifier");
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "prename", prename );
	Parameters.add( "surname", surname );

	execute( "admin/updateUser.os", this.OnSuccess, this.OnError, OnAbort );
}

}

