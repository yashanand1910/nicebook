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
	invariantUserCanBeFriendsWithUsersInTheSameState[s]
	invariantContentCanHaveOneOwnerInOneState[s]

}

pred invariantUserCanBeFriendsWithUsersInTheSameState[s: Nicebook] {
	s.users.friends in s.users
}

pred invariantContentCanHaveOneOwnerInOneState[s : Nicebook] {
	all c : s.users.owns | one (s.users & owns.c)
}
