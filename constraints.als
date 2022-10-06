/*************************
 * OBJECT CONSTRAINTS 
 **************************/

open signatures as s

pred objectConstraints {
	//constraintUserCanBeInExactlyOneNetwork
	constraintThereAreExactlyFourPrivacyLevels
	constraintNoUserCanBeFriendsWithSelf
	constraintFriendsAreCommutative
	constraintUsersCanBeTaggedByFriendsOnly
	//constraintUserOwnsAtleastOneContent
	constraintCannotTagSameUserInOnePhoto
	constraintTagIsAssociatedWithExactlyOnePhotoAndOnePairOfUsers
	constraintCommentCannotBeDangling
	constraintCommentsCannotHaveCycles
}

// Commented out above
//pred constraintUserCanBeInExactlyOneNetwork {
//	all u : User | one users.u
//}

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
	all  t: Tag | hasTagged.t in isTagged.t.friends
}

// User owns one or more content
//pred constraintUserOwnsAtleastOneContent {
//	all u : User | some u.owns
//}

// Same user cannot be tagged twice in a photo
pred constraintCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | (tags.t1 = tags.t2) implies isTagged.t1 != isTagged.t2
}

// If there is a tag, it must be correlated with exactly one photo
// And that tag must contain exactly one user
pred constraintTagIsAssociatedWithExactlyOnePhotoAndOnePairOfUsers {
	all t : Tag | one tags.t
	all t : Tag | one isTagged.t
	all t : Tag | one hasTagged.t
}

// Comments cannot be dangling, last comment should be attached to Photo
pred constraintCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

// Comments should not have cycles
pred constraintCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}
