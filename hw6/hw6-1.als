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

/****************
 * Invariants
*****************/

-- If a is a user then a cannot be friend o a
pred invariantNoUserCanBeFriendsWithSelf {
	all u : User | u not in u.isFriendOf // Loops are allowed though
}

-- If a and b are users then a is friend of b implies b is friend of a
pred invariantFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.isFriendOf implies u2 in u1.isFriendOf
}

-- If a is a user then a can only be tagged 

pred invariantCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

pred invariantUserOwnsAtleastOneContent {
	all u : User | u in Content.ownedBy
}

pred invariantCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}

pred Invariants {
	invariantNoUserCanBeFriendsWithSelf
	invariantFriendsAreCommutative
	invariantCommentsCannotHaveCycles
	invariantUserOwnsAtleastOneContent
	invariantCommentCannotBeDangling
}

assert assertion {
	Invariants implies (whatever)
}

run GenerateValidInstance {
	some Comment
	Invariants
} //for 10 but exactly 5 User
