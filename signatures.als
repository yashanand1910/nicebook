module signatures

/****************
 * SIGNATURES
 ****************/

sig Nicebook {
	users : set User
}

sig User {
	friends : set User,
	userPrivacy : one PrivacyLevel
}

abstract sig Content {
	ownedBy : one User,
	contentPrivacy : one PrivacyLevel
}

sig Photo extends Content {
	// Can tag 0 or more User
	tags : set Tag
}

sig Comment extends Content {
	commentedOn : one Content // Can comment on only one Content
}

sig Tag {
	taggedUser : one User,
	taggedBy : one User
}

abstract sig PrivacyLevel {}

one sig OnlyMe extends PrivacyLevel {}
one sig Friends extends PrivacyLevel {}
one sig FriendsOfFriends extends PrivacyLevel {}
one sig Everyone extends PrivacyLevel {}
