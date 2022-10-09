/******************
 * ASSERTIONS
 ******************/

open signatures as S
open constraints as C
open actions as AC
open invariants as I
open functions as F
/**
 * Invariant Assertions for
 * - Initial States
 * - Inductive Steps for each action
 */

assert NoPrivacyViolation {
	all s : Nicebook, u : s.users, c : getContentsInState[s] | 
	let content_owner = getContentOwnerInState[c, s] |
	(Invariants[s] and c in canView[u, s]) implies {
		some (getUserOwnedContentsInState[u, s] & c.^commentedOn) or
		{
			c.contentViewPrivacy = PL_OnlyMe implies {
			u = content_owner
			}
			c.contentViewPrivacy = PL_Friends implies {
				u in (u + getFriendsInState[content_owner, s])
			}
			c.contentViewPrivacy = PL_FriendsOfFriends implies {
				u in ( 
					u +
					getFriendsInState[content_owner, s] + 
					getFriendsInState[getFriendsInState[content_owner, s], s]
				)
			}
			c.contentViewPrivacy = PL_Everyone implies {
				u in s.users
			}
		}
	}
}

assert addPhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, u: User |
		 s1 != s2 and Invariants[s1] and addPhoto[s1, s2, p, u] implies Invariants[s2]
}

assert removePhotoPreservesInvariants {
	all s1, s2 : Nicebook, p : s1.users.owns & Photo, u : s1.users |
		Invariants[s1] and removePhoto[s1, s2, p, u] implies Invariants[s2]
}

assert addCommentPreservesInvariants {
	all s1, s2 : Nicebook, com : Comment, c : Content, u: User |
		 Invariants[s1] and addComment[s1, s2, com, c, u] implies Invariants[s2]
}

assert addTagPreservesInvariants {
	all s1, s2 : Nicebook, p : Photo, taggee, tagger: User |
		 Invariants[s1] and addTag[s1, s2, p, taggee, tagger] implies Invariants[s2]
}

assert removeCommentPreservesInvariants {
	all s1, s2 : Nicebook, com : Comment, u: User |
		 Invariants[s1] and removeComment[s1, s2, com, u] implies Invariants[s2]
}
