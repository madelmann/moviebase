
mPlugin = {

OnAbort: function(event) {
	// request execution aborted
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function(event) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function(event) {
	this.pluginName = "changepassword";

	mElPassword1 = document.getElementById("password1");
	mElPassword2 = document.getElementById("password2");
	if ( mElPassword2 ) {
		mElPassword2.addEventListener("keyup", function(event) {
			event.preventDefault();
			if ( event.keyCode == 13 ) {
				mPlugin.ChangePassword();
			}
			else {
				mPlugin.CheckPasswords();
			}
		});
	}

	mElMessage = document.getElementById("message");
	mElMessage.textContent = "";

	mPlugin.OnLoadReady();
},

OnLoadReady: function() {
},

OnFailed: function(message) {
	mElMessage.textContent = message;
},

OnSuccess: function() {
        // request execution was successful

        var response = {};
        if ( ParseJSON( event.currentTarget.responseText, response ) ) {
                // json string has been parsed successfully
                if ( response.message.result == "success" ) {
			History.Refresh();
                }
        }
        else {
                // error while parsing json string
                alert( event.currentTarget.responseText );
        }
},

ChangePassword: function() {
	if ( !this.CheckPasswords() ) {
		return;
	}

	Parameters.clear();
	Parameters.add( "password", mElPassword1.value );

	execute( "admin/updatePassword.os", this.OnSuccess, this.OnFailed );
},

CheckPasswords: function() {
	if ( !mElPassword1 || !mElPassword2 ) {
		return false;
	}

	if ( mElPassword1.value == mElPassword2.value ) {
		mElMessage.innerHTML = "";
		return true;
	}
	else {
		mElMessage.innerHTML = "Passwoerter unterscheiden sich...";
	}

	return false;
}

};

mCurrentPlugin = mPlugin;

