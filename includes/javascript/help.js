
mHelp = {

Constructor: function() {
	this.mPanel = document.getElementById("help");
},

Destructor: function() {
},

Hide: function() {
	this.mPanel.classList.remove('help_visible');
},

Show: function() {
	this.mPanel.classList.add('help_visible');
},

Toggle: function() {
	var style = window.getComputedStyle(this.mPanel);
	if ( style.visibility == "hidden" ) {
		this.Show();
	}
	else {
		this.Hide();
	}
}

};

