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
<<<<<<< HEAD
    invariantUserOnlyCanBeFriendsWithUsersInTheSameState[s]
||||||| 208d15e
	invariantUserCanBeFriendsWithUsersInTheSameState[s]
=======
	invariantUserCanOnlyBeFriendsWithUsersInTheSameState[s]
>>>>>>> origin/feature/saloni
	invariantContentCanHaveOneOwnerInOneState[s]
}

<<<<<<< HEAD
-- Users cannot be friends with users in another Nicebook
pred invariantUserOnlyCanBeFriendsWithUsersInTheSameState[s: Nicebook] {
||||||| 208d15e
pred invariantUserCanBeFriendsWithUsersInTheSameState[s: Nicebook] {
=======
pred invariantUserCanOnlyBeFriendsWithUsersInTheSameState[s: Nicebook] {
>>>>>>> origin/feature/saloni
	s.users.friends in s.users
}

-- Content can be owned by only one user in a Nicebook
pred invariantContentCanHaveOneOwnerInOneState[s : Nicebook] {
	all c : s.users.owns | one (s.users & owns.c)
}

