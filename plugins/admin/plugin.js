
mPlugin = {

	OnLoad: function(event) {
		this.mPluginName = "admin";

		mPlugin.mElSource = document.getElementById("source");
		mPlugin.mElTarget = document.getElementById("target");

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		// nothing to do here atm
	},

	OnSuccess: function(event) {
		// request execution was successful
		//alert("OnSuccess: " + event.currentTarget.responseText);

		var response = {};

		if ( ParseJSON(event.currentTarget.responseText, response) ) {
			// json string has been parsed successfully
			History.Refresh();
		}
		else {
			// error while parsing json string
			alert(response.message);
		}
	},

	DeleteVideo: function(id) {
		Parameters.clear();
		Parameters.add("itemID", id);

		execute("admin/deleteVideo.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort);
	},

	ShowVideo: function(id) {
		Parameters.clear();
		Parameters.add("itemID", id);

		LoadPluginWithHistory("showvideo");
	},

	UnhideVideo: function(id) {
		Parameters.clear();
		Parameters.add("itemID", id);

		execute("admin/unhideVideo.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort);
	}

};

mCurrentPlugin = mPlugin;

