/******************
 * ASSERTIONS
 ******************/

open signatures as S
open constraints as C
open actions as AC
open invariants as I

/**
 * Invariant Assertions for
 * - Initial States
 * - Inductive Steps for each action
 */

assert NoPrivacyViolation {
	// Asserts that no user can view any content that he/she is not supposed to
}

assert addPhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u: User | 
		Invariants[s1] and addPhoto[s1, s2, p, u] implies Invariants[s2]
}

assert removePhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u: User |
		Invariants[s1] and removePhoto[s1, s2, p, u] implies Invariants[s2]
}
