/********************
 * ASSERTIONS
 * @author: Team 16
 *********************/
 
open signatures
open actions
open invariants

/**
 * Asserts that if a user can view some content in a valid state, this implies that
 * he/she has the required privilege for it
 */
assert NoPrivacyViolation {
	all s : Nicebook, u : User, c : Content | Invariants[s] implies {
		 c in canView[u, s] iff {
			NoPrivacyViolationContentLevel[u, c, s]
			NoPrivacyViolationUserLevel[u, c, s]
		}
	}
}


/*********************************************************************
 * ASSERTIONS TO ENSURE THAT ACTIONS PRESERVE INVARIANTS
 *********************************************************************/

assert addPhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u: User |
		 Invariants[s1] and addPhoto[s1, s2, p, u] implies Invariants[s2]
}

assert removePhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u : User |
		Invariants[s1] and removePhoto[s1, s2, p, u] implies Invariants[s2]
}

assert addCommentPreservesInvariants {
	all s1, s2 : Nicebook, com : Comment, c : Content, u: User |
		Invariants[s1] and addComment[s1, s2, com, c, u] implies Invariants[s2]
}

assert removeCommentPreservesInvariants {
	all s1, s2 : Nicebook, com : Comment, u: User |
		Invariants[s1] and removeComment[s1, s2, com, u] implies Invariants[s2]
}

assert addTagPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, taggee, tagger: User |
		 Invariants[s1] and addTag[s1, s2, p, taggee, tagger] implies Invariants[s2]
}

assert removeTagPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u, taggee : User | 
		Invariants[s1] and removeTag[s1, s2, p, taggee, u] implies Invariants[s2]
}


/*********************************************************************
 * ASSERTIONS TO ENSURE THAT ACTIONS IS SUCCESSFUL
 *********************************************************************/

assert addPhotoSuccess {
	all s1, s2 : Nicebook, p : Photo, u: User |
		 Invariants[s1] and addPhoto[s1, s2, p, u] implies
			p in getContentsInState[s2]
}

assert removePhotoSuccess {
	all s1, s2 : Nicebook, p : Photo, u : User |
		Invariants[s1] and removePhoto[s1, s2, p, u] implies 
			p not in getContentsInState[s2]
}

assert addCommentSuccess {
	all s1, s2 : Nicebook, com : Comment, c : Content, u: User |
		Invariants[s1] and addComment[s1, s2, com, c, u] implies 
			com in getContentsInState[s2]
}

assert removeCommentSuccess {
	all s1, s2 : Nicebook, com : Comment, u: User |
		 Invariants[s1] and removeComment[s1, s2, com, u] implies
			com not in getContentsInState[s2]
}
