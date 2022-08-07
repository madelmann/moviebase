
mPlugin = {

	pluginName: "<plugin name>",

	OnLoad: function( event ) {
		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		// nothing to do here atm
	},

	OnSuccess: function(event) {
		// request execution was successful

		var response = {};
		if ( ParseJSON( event.currentTarget.responseText, response ) ) {
			// json string has been parsed successfully
			alert( response.message.result );
		}
		else {
			// error while parsing json string
			alert( response.message ;
		}
	}

};

mCurrentPlugin = mPlugin;

