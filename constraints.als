/*************************
 * OBJECT CONSTRAINTS 
 *************************/

open signatures as s

pred objectConstraints {
	constraintUserNeedsToBelongToNicebook
	contentNeedsToBelongToUser
	constraintNoUserCanBeFriendsWithSelf
	constraintFriendsAreCommutative
	constraintUserOwnsAtleastOneContent
	constraintCannotTagSameUserInOnePhoto
	constraintTagIsAssociatedWithExactlyOnePhotoAndOnePairOfUsers
	constraintCommentsCannotHaveCycles
}

pred constraintUserNeedsToBelongToNicebook {
	User = Nicebook.users
}

pred contentNeedsToBelongToUser {
	Content = User.owns
}

-- User cannot be a friend of itself
pred constraintNoUserCanBeFriendsWithSelf {
	-- Note: Loops are allowed
	all u : User | u not in u.friends
}

-- If a and b are users then: a is friend of b implies b is friend of a
pred constraintFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
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
	all t : Tag | one tags.t and one isTagged.t and  one hasTagged.t
}

-- Comments should not have cycles
pred constraintCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}
