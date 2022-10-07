/*************************
 * OBJECT CONSTRAINTS 
 *************************/

open signatures as s

pred objectConstraints {
	constraintUserNeedsToBelongToNicebook
	contentNeedsToBelongToUser
	constraintThereAreExactlyFourPrivacyLevels
    constraintNoDanglingUsers
	constraintNoUserCanBeFriendsWithSelf
	constraintFriendsAreCommutative
	constraintUsersCanBeTaggedByFriendsOnly
	constraintUserOwnsAtleastOneContent
	constraintCannotTagSameUserInOnePhoto
	constraintTagIsAssociatedWithExactlyOnePhotoAndOnePairOfUsers
	constraintCommentsCannotHaveCycles
}

pred constraintThereAreExactlyFourPrivacyLevels {
	#PrivacyLevel = 4
}

<<<<<<< HEAD
-- Dangling users cannot exist
pred constraintNoDanglingUsers {
    Nicebook.users = User
}

||||||| 208d15e
=======
pred constraintUserNeedsToBelongToNicebook {
	User = Nicebook.users
}

pred contentNeedsToBelongToUser {
	Content = User.owns
}

>>>>>>> origin/feature/saloni
-- User cannot be a friend of itself
pred constraintNoUserCanBeFriendsWithSelf {
	// Note: Loops are allowed
	all u : User | u not in u.friends
}

-- If a and b are users then: a is friend of b implies b is friend of a
pred constraintFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
}

-- Users can only be tagged by their friends
pred constraintUsersCanBeTaggedByFriendsOnly {
	all  t: Tag | hasTagged.t in isTagged.t.friends
}

-- User owns one or more content
pred constraintUserOwnsAtleastOneContent {
	all u : User | some u.owns
}

-- Same user cannot be tagged twice in a photo
pred constraintCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | (tags.t1 = tags.t2) implies isTagged.t1 != isTagged.t2
}

-- If there is a tag, it must be correlated with exactly one photo and that tag must contain exactly one user
pred constraintTagIsAssociatedWithExactlyOnePhotoAndOnePairOfUsers {
	all t : Tag | one tags.t and one isTagged.t and one hasTagged.t
}

<<<<<<< HEAD
-- Comments cannot be dangling, first comment should be attached to Photo
pred constraintCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

||||||| 208d15e
-- Comments cannot be dangling, last comment should be attached to Photo
pred constraintCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

=======
>>>>>>> origin/feature/saloni
-- Comments should not have cycles
pred constraintCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}
