/******************
 * INVARIANTS
 ******************/

open signatures
open constraints

/**
 * TODO:
 * - Think about what are the conditions that need to get satisfied for every action
 */

pred Invariants[s : Nicebook] {
	objectConstraints
	stateInvariants[s]
}

pred stateInvariants[s : Nicebook] {
    invariantUserOnlyCanBeFriendsWithUsersInTheSameState[s]
	invariantContentCanHaveOneOwnerInOneState[s]

}

-- Users cannot be friends with users in another Nicebook
pred invariantUserOnlyCanBeFriendsWithUsersInTheSameState[s: Nicebook] {
	s.users.friends in s.users
}

-- Content can be owned by only one user in a Nicebook
pred invariantContentCanHaveOneOwnerInOneState[s : Nicebook] {
	all c : s.users.owns | one (s.users & owns.c)
}

