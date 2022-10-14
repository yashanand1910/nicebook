/********************
 * INVARIANTS
 * @author: Team 16
 *********************/

open signatures
open functions
open predicates

pred Invariants[s : Nicebook] {
	stateInvariants[s]
}

pred stateInvariants[s : Nicebook] {
	invariantContentCanHaveExactlyOneOwnerInOneState[s]
	invaraintNoCommentIsPresentWithoutPrivileges[s]
	invariantNoTagIsPresentWithoutPrivileges[s]
	invariantTagsInStateShouldHaveExactlyOneTaggerTaggeePairInState[s]
}

/**
 * Content should have exactly one owner in a given state
 * It is valid for a Content to have owners belonging to different states
 */
pred invariantContentCanHaveExactlyOneOwnerInOneState[s : Nicebook] {
	all c : s.users.owns | one (s.users & owns.c)
}

/**
 * Tag should map to exactly one tagger and one taggee in a state
 */
pred invariantTagsInStateShouldHaveExactlyOneTaggerTaggeePairInState[s: Nicebook] {
	all t : (getTagsInState[s]) | one (isTagged.t & s.users) and one (s.users & hasTagged.t)
}

/**
 * A Comment should not be present in a state unless it has the required privileges
 */
pred invaraintNoCommentIsPresentWithoutPrivileges[s : Nicebook] {
	all com : getContentsInState[s] | 
		let com_owner = getContentOwnerInState[com, s], com_content = com.commentedOn | {
			-- The user owning the comment should have the privilege to comment on com_content
			checkAddCommentPrivilege[com_owner, com_content, s]
		}
}

/**
 * A tag should not be present unless it has the required privileges
 */
pred invariantNoTagIsPresentWithoutPrivileges[s : Nicebook] {
	all t : getTagsInState[s] | some taggee, tagger : User, p : Photo {
		-- The user 't' tags in Nicebook state 's'
		taggee = (s.users & isTagged.t)

		-- The user that has tagged 'taggee' to Photo 'p' in Nicebook State 's'
		tagger = getTaggerInState[taggee, p, s]

		-- Photo with the tag
		p = tags.t

		-- Privileges must be present
		checkAddTagPrivileges[tagger, taggee, p, s]
	}
}
