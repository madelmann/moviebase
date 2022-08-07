
mPlugin = {

    // consts
    SETTINGS_VIEW: "settingsView",

    // instance members
    pluginName: "settingsView",

	OnDataReceived: function( event ) {
		var response = {};

		if ( ParseJSON( event.currentTarget.responseText, response ) ) {
			// json string has been parsed successfully
			mGlobals.vm.settings = response.message.settings;

			mPlugin.RenderData( response.message.settings );
		}
		else {
			// error while parsing json string
			OnError( response.message );
		}
	},

	OnDeleteSuccess: function( event ) {
		Parameters.clear();

		LoadPlugin( "loginView" );
	},

	OnLanguagesReceived: function( event ) {
		var response = {};

		mPlugin.LoadData();

		if ( ParseJSON( event.currentTarget.responseText, response ) ) {
			// json string has been parsed successfully

			mGlobals.vm.languages = response.message.languages;

			mPlugin.RenderLanguages( response.message.languages );
		}
		else {
			// error while parsing json string
			OnError( response.message );
		}
	},

	OnLoad: function( event ) {
		mElMessage = document.getElementById( "login_message" );
		if ( mElMessage ) {
			mElMessage.textContent = "";
		}

		mElEmail     = document.getElementById( "email" );
		mElFirstName = document.getElementById( "firstname" );
		mElLanguageSelection = document.getElementById( "language_selection" );
		mElLastName = document.getElementById( "lastname" );
		mElPassword = document.getElementById( "password" );
		//mElPhoneNumber = document.getElementById( "phone_number" );
		mElReceiveLoginNotifications = document.getElementById( "receive_login_notifications" );
		mElReceiveMailNotifications = document.getElementById( "receive_mail_notifications" );
		//mElReceiveSMSNotifications = document.getElementById( "receive_sms_notifications" );

		if ( mElPassword ) {
			mElPassword.addEventListener( "keyup", function( event ) {
				event.preventDefault();
				if ( event.keyCode == 13 ) {
					mPlugin.Login();
				}
			});
		}

		mElPassword1 = document.getElementById( "password" );
		mElPassword2 = document.getElementById( "password2" );
		if ( mElPassword2 ) {
			mElPassword2.addEventListener( "keyup", function( event ) {
				event.preventDefault();

				if ( !mPlugin.CheckPasswords() ) {
					return;
				}

				if ( event.keyCode == 13 ) {
					mPlugin.UpdatePassword();
				}
			});
		}

		mElShowStartPage = document.getElementById( "login_show_start_page" );
		if ( mElShowStartPage ) {
			mElShowStartPage.checked = Account.IsFirstVisit();
		}

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		var elAppVersion = $( "#app_version" );
		elAppVersion.innerHTML = Templates.clone( "app_version" )
									.bind( "APP_VERSION", APP_VERSION )
									.str();

		if ( mGlobals.vm.languages.length > 0 ) {
			this.RenderLanguages( mGlobals.vm.languages );
			this.RenderData( mGlobals.vm.settings );
		}
		else {
			this.LoadLanguages();
		}
		this.UpdateUI();
	},

	OnLoginFailed: function( message ) {
		mElMessage.textContent = message;
	},

	OnUpdateSuccess: function() {
		Notifications.notifySuccess( "CHANGE_PASSWORD_SUCCESS" );

		Parameters.clear();

		mElPassword1.innerText = "";
		mElPassword2.innerText = "";

		History.Refresh();
	},

	CheckPasswords: function() {
		if ( !mElPassword1 || !mElPassword1.value || !mElPassword2 || !mElPassword2.value ) {
			mElMessage.innerHTML = "";
			return false;
		}
		
		if ( mElPassword1.value == mElPassword2.value ) {
			mElMessage.innerHTML = "";

			mElPassword1.classList.add( "is-valid" );
			mElPassword2.classList.add( "is-valid" );
			mElPassword1.classList.remove( "is-invalid" );
			mElPassword2.classList.remove( "is-invalid" );
		}
		else {
			mElMessage.innerHTML = Translations.token( "PASSWORD_MISSMATCH" );

			mElPassword1.classList.remove( "is-valid" );
			mElPassword2.classList.remove( "is-valid" );
			mElPassword1.classList.add( "is-invalid" );
			mElPassword2.classList.add( "is-invalid" );

			return false;
		}

		return true;
	},

	DeleteAccount: function() {
		if ( !confirm( Translations.token( "ACCOUNT_DELETE_CONFIRMATION" ) ) ) {
			return;
		}

		Account.DeleteAccount( mPlugin.OnDeleteSuccess );
	},

	GenerateApiKey: function() {
		Account.GenerateApiKey( mPlugin.Refresh );
	},

	LoadData: function() {
		Parameters.clear();

		api( "admin/users/settings/", this.OnDataReceived, this.OnError, OnAbort );
	},

	LoadLanguages: function() {
		Parameters.clear();

		api( "admin/ui/languages/", this.OnLanguagesReceived, this.OnError, OnAbort );
	},

	Logout: function() {
		Account.Logout( OnLogoutSuccess );
	},

	Refresh: function() {
		History.Refresh();
	},

	Register: function() {
		Parameters.clear();

		LoadPlugin( "registerView" );
	},

	RenderData: function( settings ) {
		mElEmail.value = settings.email;
		mElFirstName.value = settings.firstName;
		mElLanguageSelection.value = settings.language;
		mElLastName.value = settings.lastName;
		//mElPhoneNumber.value = settings.phoneNumber
		mElReceiveLoginNotifications.checked = settings.sendLoginNotifications;
		mElReceiveMailNotifications.checked = settings.sendMailNotifications;
		//mElReceiveSMSNotifications.checked = settings.sendSmsNotifications;
		//mElUsername.value = settings.userName;

		this.UpdateUI();
	},

	RenderLanguages: function( languages ) {
		mElLanguageSelection.innerHTML = "";

		// manually render data
		var listItems = "<option disabled selected class='translation' token='LANGUAGE_SELECTION'>LANGUAGE_SELECTION</option>";

		for ( idx = 0; idx < languages.length; ++idx ) {
			var entry = languages[ idx ];

			listItems += "<option value='" + entry.token + "'>" + entry.language + "</option>";
		}

		mElLanguageSelection.innerHTML = listItems;

		Translations.translate( mElLanguageSelection );    // retranslate element

		LoadingFinished();
	},

	ShowResetPassword: function() {
		Parameters.clear();

		LoadPlugin( "resetPasswordView" );
	},

	UpdatePassword: function() {
        if ( !IsFormValid( "frmPasswordChange" ) ) {
            return;
        }

		if ( !mPlugin.CheckPasswords() ) {
			return;
		}

		Account.UpdatePassword( Parameters.get( "identifier" ), mElPassword1.value, mPlugin.OnUpdateSuccess );
	},

	UpdateUI: function() {
		if ( !mElReceiveMailNotifications.checked ) {
			mElReceiveLoginNotifications.checked = false;
		}

		mElReceiveLoginNotifications.disabled = !mElReceiveMailNotifications.checked;
		//mElReceiveMailNotifications.disabled = !mElReceiveMailNotifications.checked;
	},

	UpdateUser: function() {
        if ( !IsFormValid( "frmUserSettings" ) ) {
            return;
        }

		Parameters.clear();
		if ( mElLanguageSelection.value ) {
			Account.SwitchLanguage( mElLanguageSelection.value );

			Parameters.add( "language", mElLanguageSelection.value );
		}
		Parameters.add( "prename", mElFirstName.value );
		Parameters.add( "surname", mElLastName.value );
		Parameters.add( "receive_login_notifications", mElReceiveLoginNotifications.checked );
		Parameters.add( "receive_mail_notifications", mElReceiveMailNotifications.checked );
		//Parameters.add( "receive_sms_notifications", mElReceiveSMSNotifications.checked );

		execute( "admin/updateUser.os" );
	}

};

mCurrentPlugin = mPlugin;

