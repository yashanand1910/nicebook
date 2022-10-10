/******************
 * INVARIANTS
 * @author: Team 16
 ******************/

open signatures
open constraints
open functions
open predicates

// Comment chain should exist in state
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
	invaraintNoCommentIsPresentWithoutPrivileges[s]
	invariantNoTagIsPresentWithoutPrivileges[s]
}

-- Ensure user's friends are in the same state
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

-- A Comment should not be present unless it has the required privileges
pred invaraintNoCommentIsPresentWithoutPrivileges[s : Nicebook] {
	all com : getContentsInState[s] | 
		let com_owner = getContentOwnerInState[com, s], com_content = com.commentedOn | {
			checkAddCommentPrivilege[com_owner, com_content, s]
		}
}

-- A tag should not be present unless it has the required privileges
pred invariantNoTagIsPresentWithoutPrivileges[s : Nicebook] {
	all t : getTagsInState[s] | let tagger = hasTagged.t, taggee = isTagged.t, p = tags.t | {
		checkAddTagPrivileges[tagger, taggee, p, s]
	}
}
