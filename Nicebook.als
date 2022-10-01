sig User {
	isFriendOf : set User
}

abstract sig Content {}

sig Photo extends Content {
	// Can tag 0 or more User
	ownedBy : one User,
	tags : set Tag
}

sig Tag {
	taggedUser: one User,
	taggedBy: one User
}

sig Comment extends Content {
	// Can comment on only one Content
	commentedOn : one Content
}

pred invariantNoUserCanBeFriendsWithSelf {
	// Loops are allowed though
	all u : User | u not in u.isFriendOf
}

pred invariantFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.isFriendOf implies u2 in u1.isFriendOf
}

pred invariantCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}

pred invariantUserOwnsAtleastOneContent {
	all u : User | u in Content.ownedBy
}

pred invariantCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

pred invariantUserOnlyTaggedByFriends {
	all t: Tag | (some u: User | u in t.taggedBy and u in t.taggedUser.isFriendOf)
}

pred invariantCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | t1 != t2 implies t1.taggedUser != t2.taggedUser 
}

pred invariantTagCannotBeSharedAmongPhotos {
	all t: Tag | one tags.t
}

pred Invariants {
	invariantNoUserCanBeFriendsWithSelf
	invariantFriendsAreCommutative
	invariantCommentsCannotHaveCycles
	invariantUserOwnsAtleastOneContent
	// invariantCommentCannotBeDangling
	invariantUserOnlyTaggedByFriends
 	invariantCannotTagSameUserInOnePhoto
	invariantTagCannotBeSharedAmongPhotos
}

//assert assertion {
//	Invariants implies (whatever)
//}

run GenerateValidInstance {
	some com1, com2: Comment | com1 in com2.commentedOn
	some u: User | no u.isFriendOf
	Invariants
} for 5 but exactly 3 Photo, 5 User
