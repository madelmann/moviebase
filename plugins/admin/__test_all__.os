#!/usr/local/bin/slang

public void Main(int argc, string args) {
	print("Testing all scripts...");

	system("./addActor.os");
	system("./addActorTag.os");
	system("./addCollectionTag.os");
	system("./addItemToFavorites.os");
	system("./addTag.os");
	system("./deleteActor.os");
	system("./deleteCollection.os");
	system("./deleteImage.os");
	system("./deleteTag.os");
	system("./deleteVideo.os");
	system("./hideVideo.os");
	system("./incrementViewCount.os");
	system("./index.os");
	system("./insertActor.os");
	system("./insertCollectionItem.os");
	system("./insertCollection.os");
	system("./insertImage.os");
	system("./insertTag.os");
	system("./insertVideo.os");
	system("./loadActor.os");
	system("./loadCollection.os");
	system("./loadItem.os");
	system("./loadSession.os");
	system("./loginUser.os");
	system("./registerUser.os");
	system("./removeActor.os");
	system("./removeActorTag.os");
	system("./removeCollectionItem.os");
	system("./removeCollectionTag.os");
	system("./removeTag.os");
	system("./resetVideoVoting.os");
	system("./search.os");
	system("./unhideVideo.os");
	system("./updateActor.os");
	system("./updateCollection.os");
	system("./updateImage.os");
	system("./updatePassword.os");
	system("./updateUser.os");
	system("./updateVideo.os");

	print("Done... Testing successful.");
}

