module signatures

/****************
 * SIGNATURES
 ****************/

sig Nicebook {
	users : set User
}

sig User {
	friends : set User,
	userViewPrivacy : one PrivacyLevel
	commentPrivacy : one PrivacyLevel
}

abstract sig Content {
	ownedBy : one User,
	contentViewPrivacy : one PrivacyLevel,
}

sig Photo extends Content {
	// Can tag 0 or more User
	tags : set Tag
}

sig Comment extends Content {
	// Can comment on only one Content
	commentedOn : one Content
}

sig Tag {
	taggedUser : one User,
	taggedBy : one User
}


/*
• Each piece of content owned by a user is associated a privacy level that determines 
who is able to view that content on the user’s account.
	-- Content Specific Setting

• Each user has a setting that controls who is able to view content that is published 
on the user’s account by other users.
	-- Comments posted on your photos/and tagged photos
	-- User Profile Content posted by other users 

• Each user has a setting that controls who is able to add a comment to content 
that is owned by the user.
	-- Commenting Privileges for evert content (Photo/Comment)
*/
abstract sig PrivacyLevel {}

one sig OnlyMe extends PrivacyLevel {}
one sig Friends extends PrivacyLevel {}
one sig FriendsOfFriends extends PrivacyLevel {}
one sig Everyone extends PrivacyLevel {}
