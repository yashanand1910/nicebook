/******************
 * INVARIANTS
 ******************/

open signatures
open constraints
open functions

/**
 * TODO:
 * - Think about what are the conditions that need to get satisfied for every action
 */

pred Invariants[s : Nicebook] {
	objectConstraints
	stateInvariants[s]
}

pred stateInvariants[s : Nicebook] {
	invariantUserCanOnlyBeFriendsWithUsersInTheSameState[s]
	invariantContentCanHaveOneOwnerInOneState[s]
	invariantUsersCanBeTaggedByFriendsOnly[s]
}

-- A user cannot be friends with a user who is not in the same stae
pred invariantUserCanOnlyBeFriendsWithUsersInTheSameState[s: Nicebook] {
	s.users.friends in s.users
}

-- It is okay for Content to have two owners in different states
pred invariantContentCanHaveOneOwnerInOneState[s : Nicebook] {
	all c : s.users.owns | one (s.users & owns.c)
}

-- Users can only be tagged by their friends
pred invariantUsersCanBeTaggedByFriendsOnly[s : Nicebook] {
	all t : getTagsInState[s] | hasTagged.t in isTagged.t.friends
}
