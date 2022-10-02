/****************
 * Signatures
*****************/

sig User {
	friends : set User
}

abstract sig Content {
	ownedBy : one User,
}

sig Photo extends Content {
    tags : set Tag  // Can tag 0 or more User
}

sig Comment extends Content {
	commentedOn : one Content // Can comment on only one Content
}

sig Tag {
    taggedUser : one User,
    taggedBy : one User
}

/****************
 * Invariants
*****************/

-- If a is a user then a cannot be friend o a
pred invariantNoUserCanBeFriendsWithSelf {
	all u : User | u not in u.friends // Loops are allowed though
}

-- If a and b are users then a is friend of b implies b is friend of a
pred invariantFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
}

-- If a is a user then a can only be tagged 
pred invariantUsersCanTagOnlyFriend {
	all t: Tag | (some u: User | u in t.taggedBy and u in t.taggedUser.friends)
}

pred invariantCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

pred invariantUserOwnsAtleastOneContent {
	all u : User | u in Content.ownedBy
}

pred invariantCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}

-- Same user cannot be tagged in a one photo
pred invariantCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | t1 != t2 implies t1.taggedUser != t2.taggedUser 
}

-- if there is a tag, it must be correlated with exactly one photo
pred aTagInstanceMustBeAssociatedWithExactlyOnePhoto {
	all t : Tag | one tags.t
}


pred Invariants {
	invariantNoUserCanBeFriendsWithSelf
	invariantFriendsAreCommutative
	invariantUsersCanTagOnlyFriend
	invariantCommentsCannotHaveCycles
	invariantUserOwnsAtleastOneContent
	invariantCommentCannotBeDangling
	invariantCannotTagSameUserInOnePhoto
	invariantTagMustHavePhoto
}

run GenerateValidInstance {
	Invariants
}
