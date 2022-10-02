/****************
 * SIGNATURES
 ****************/

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
 * INVARIANTS 
 ****************/

-- User cannot be a friend of itself
pred invariantNoUserCanBeFriendsWithSelf {
	all u : User | u not in u.friends // Note: Loops are allowed though
}

-- If a and b are users then a is friend of b implies b is friend of a
pred invariantFriendsAreCommutative {
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
}

-- Users can only be tagged by their friends
pred invariantUsersCanBeTaggedByFriendsOnly {
	all  t: Tag | t.taggedBy in t.taggedUser.friends
}

-- User owns one or more content
pred invariantUserOwnsAtleastOneContent {
	all u : User | u in Content.ownedBy
}

-- Same user cannot be tagged twice in a photo
pred invariantCannotTagSameUserInOnePhoto {
	all t1, t2: Tag | t1 != t2 implies t1.taggedUser != t2.taggedUser 
}

-- if there is a tag, it must be correlated with exactly one photo
pred invariantTagIsAssociatedWithExactlyOnePhoto {
	all t : Tag | one tags.t
}

-- Additional --

-- Comments cannot be dangling, last comment in a series should be attached to content
pred invariantCommentCannotBeDangling {
	all com : Comment | (some p : Photo | p in com.^commentedOn)
}

-- Comments should not have cycles
pred invariantCommentsCannotHaveCycles {
	all com : Comment | com not in com.^commentedOn
}

pred Invariants {
	invariantNoUserCanBeFriendsWithSelf
	invariantFriendsAreCommutative
	invariantUsersCanBeTaggedByFriendsOnly
	invariantUserOwnsAtleastOneContent
	invariantCannotTagSameUserInOnePhoto
	invariantTagIsAssociatedWithExactlyOnePhoto
	invariantCommentsCannotHaveCycles
	invariantCommentCannotBeDangling
}

/****************
 * RUN 
 ****************/

run GenerateValidInstance {
	Invariants
}
