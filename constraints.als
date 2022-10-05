module constraints

open signatures as s

/*************************
 * OBJECT CONSTRAINTS 
 **************************/

pred constraintUserCanBeInExactlyOneNetwork {
	all u : User | one users.u
}

pred constraintThereAreExactlyFourPrivacyLevels {
	#PrivacyLevel = 4
}

// User cannot be a friend of itself
pred constraintNoUserCanBeFriendsWithSelf {
	-- Note: Loops are allowed
	all u : User | u not in u.friends
}

// If a and b are users then:
// a is friend of b implies b is friend of a
pred constraintFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
}

// Users can only be tagged by their friends
pred constraintUsersCanBeTaggedByFriendsOnly {
	all  t: Tag | t.taggedBy in t.taggedUser.friends
}

// User owns one or more content
pred constraintUserOwnsAtleastOneContent {
	all u : User | u in Content.ownedBy
}

// Same user cannot be tagged twice in a photo
pred constraintCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | (tags.t1 = tags.t2) implies t1.taggedUser != t2.taggedUser
}

// If there is a tag, it must be correlated with exactly one photo
pred constraintTagIsAssociatedWithExactlyOnePhoto {
	all t : Tag | one tags.t
}

// Comments cannot be dangling, last comment should be attached to Photo
pred constraintCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

// Comments should not have cycles
pred constraintCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}
