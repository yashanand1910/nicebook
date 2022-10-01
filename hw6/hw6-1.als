sig User {
	isFriendOf : set User
}

abstract sig Content {}

sig Photo extends Content {
	// Can tag 0 or more User
	ownedBy : one User,
	tags : set User
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
