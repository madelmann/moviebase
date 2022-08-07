
private void BeginTags() {
	print("<ul>");
}

private void EditableActor(string id, string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.SearchActor(\"" + name + "\");";
	}

	print( "
	<li class='actor' onclick='" + onclick + "'>
		<span>
			<a class='X' onclick='mPlugin.RemoveActor(" + id + ", \"" + name + "\");'>X</a>" + name + "
		</span>
	</li>
	" );
}

private void EditableCollection(string id, string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.SearchCollection(\"" + name + "\");";
	}

	print( "
	<li class='collection' onclick='" + onclick + "'>
		<span>
			<a class='X' onclick='mPlugin.RemoveCollection(" + id + ", \"" + name + "\");'>X</a>" + name + "
		</span>
	</li>
	" );
}

private void EditableLabel(string name, string value, int size = 12) {
	print( "
	<label  id='" + name + "_label' class='input shown'  style='font-size: " + size + "pt' onclick='mPlugin.Show(\"" + name + "\");'>" + value + "</label>
	<input  id='" + name + "_input' class='input' style='font-size: " + size + "pt' hidden='true' type='text' value='" + value + "' />
	" );
}

private void EditableLabelWithStore(string name, string value, int size = 12, bool editable = true) {
	print("<h3>");

	if ( editable ) {
		print( "
		<label  id='" + name + "_label' class='input shown' style='font-size: " + size + "pt' onclick='mPlugin.Show(\"" + name + "\");'>" + value + "</label>
		<input  id='" + name + "_input' class='input' hidden='true' type='text' value='" + value + "' />
		<button id='" + name + "_save'  class='' hidden='true' onclick='mPlugin.Store(\"" + name + "\");'>Speichern</button>
		" );
	}
	else {
		print("<label  id='" + name + "_label' class='input shown' style='font-size: " + size + "pt'>" + value + "</label>");
	}

	print("</h3>");
}

private void EditableTag(string id, string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.SearchTag(\"" + name + "\");";
	}

	print( "
	<li class='tag' onclick='" + onclick + "'>
		<span>
			<a class='X' onclick='mPlugin.RemoveTag(" + id + ", \"" + name + "\");'>X</a>" + name + "
		</span>
	</li>
	" );
}

private void EditableTextArea(string name, string value, int size = 10) {
	print( "
	<label    id='" + name + "_label' class='textarea shown'  style='font-size: " + size + "pt' onclick='mPlugin.Show(\"" + name + "\");'>" + value + "</label>
	<textarea id='" + name + "_input' class='textarea' style='font-size: " + size + "pt' hidden='true' type='text'>" + value + "</textarea>
	" );
}

private void EditableTextAreaWithStore(string id, string name, string value, int size = 10) {
	print( "
	<label    id='" + name + "_label' class='textarea shown'  style='font-size: " + size + "pt' onclick='mPlugin.Show(\"" + name + "\");'>" + value + "</label>
	<textarea id='" + name + "_input' class='textarea' style='font-size: " + size + "pt' hidden='true' type='text'>" + value + "</textarea>
	<button   id='" + name + "_save'  class='' hidden='true' onclick='mPlugin.Store(\"" + name + "\");'>Speichern</button>
	" );
}

private void EndTags() {
	print("</ul>");
}

private void StaticActor(string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.SearchActor(\"" + name + "\");";
	}

	print( "
	<li class='actor' onclick='" + onclick + "'>
		<span>" + name + "</span>
	</li>
	" );
}

private void StaticCollection(string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.ShowCollection(\"" + name + "\");";
	}

	print( "
	<li class='collection' onclick='" + onclick + "'>
		<span>" + name + "</span>
	</li>
	" );
}

private void StaticElement(string name, string class, string onclick) {
	print( "
	<li class='" + class + "' onclick='" + onclick + "'>
		<span>" + name + "</span>
	</li>
	" );
}

private void StaticLabel(string name, string value, int size = 12) {
	print( "
	<h3>
		<label id='" + name + "_label' class='input shown'  style='font-size: " + size + "pt'>" + value + "</label>
	</h3>
	" );
}

private void StaticTag(string name, string onclick = "") {
	if ( !onclick ) {
		onclick = "mPlugin.SearchTag(\"" + name + "\");";
	}

	print( "
	<li class='tag' onclick='" + onclick + "'>
		<span>" + name + "</span>
	</li>
	" );
}

private void StaticTextArea(string name, string value, int size = 10) {
	print( "<label id='" + name + "_label' class='textarea shown'  style='font-size: " + size + "pt'>" + value + "</label>" );
}


