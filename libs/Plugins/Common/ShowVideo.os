
private void ShowVideo( int width = 720, int height = 480 ) {
	print("
<video id='videoplayer' class='video' width='" + width + "' height='" + height + "' poster='' controls preload='metadata' onclick='mPlugin.IncrementViewCount();'>
<source src='' type='video/mp4'>
Ihr Browser unterstützt das Video Element nicht
</video>
	");
}

private void ShowCollectionItem( string collectionID, string collectionItemID, string id, string imageSrc, string rating, string title, string views, bool addToFavorites = false ) {
	print( "
	<div class='gallery-item'>
		<div class='gallery-item-preview'>
			<image src='resources/thumbs/" + imageSrc + "' class='preview' alt='Image not found' onerror='this.onerror=null;this.src=\"resources/thumbs/" + imageSrc + ".png\";' onclick='mPlugin.ShowCollectionItem(" + collectionID + ", " + collectionItemID + ");'/>
		</div>
		" + (addToFavorites ? "<div class='gallery-item-add-to-playlist' onclick='AddItemToFavorites(" + id + ");'>+</div>" : "") + "
		<label class='gallery-item-title shown' onclick='mPlugin.ShowCollectionItem(" + collectionID + ", " + collectionItemID + ");'>" + title + "</label>
		<div class='rating'>
			<span>" + views + " Views</span> / <span>Rating " + rating + "</span>
		</div>
	</div>
	" );
}

private void ShowPlaylistItem( string id, string imageSrc, string title, bool addToFavorites = false ) {
	print( "
	<div class='playlist-item'>
		<image src='resources/thumbs/" + imageSrc + "' class='playlist-preview' onerror='this.onerror=null;this.src=\"resources/thumbs/" + imageSrc + ".png\";' onclick='mPlaylistPlugin.ShowCollectionItem(" + id + ");'/>
		" + (addToFavorites ? "<div class='playlist-item-add-to-playlist' onclick='AddItemToFavorites(" + id + ");'>+</div>" : "") + "
		<label class='playlist-item-title shown' onclick='mPlugin.ShowCollectionItem(" + id + ");'>" + title + "</label>
	</div>
	" );
}

private void ShowVideoPreview( string id, string imageSrc, string rating, string title, string views, bool addToFavorites = false ) {
	print( "
	<div class='gallery-item'>
		<div class='gallery-item-preview'>
			<image src='resources/thumbs/" + imageSrc + "' class='preview' onerror='this.onerror=null;this.src=\"resources/thumbs/" + imageSrc + ".png\";' onclick='mPlugin.ShowVideo(" + id + ");'/>
		</div>
		" + (addToFavorites ? "<div class='gallery-item-add-to-playlist' onclick='AddItemToFavorites(" + id + ");'>+</div>" : "") + "
		<label class='gallery-item-title shown' onclick='mPlugin.ShowVideo(" + id + ");'>" + title + "</label>
		<div class='rating'>
			<span>" + views + " Views</span> / <span>Rating " + rating + "</span>
		</div>
	</div>
	" );
}

