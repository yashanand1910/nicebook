/****************
 * FUNCTIONS
 ****************/

open signatures as S

/** 
 * For a given state:
 * - Return Content set that user can view
 * - User should be able to view parent Comments/Photo
 * - User should have the privilege to view comments of parent Comments/Photo
 */
fun canView[u : User, s: Nicebook] : set Content {
	let r1 = rawCanViewContent[u, s] | let r2 = rawCanViewContentComments[u, s]  | {
		c : r1 | c.^commentedOn in r1 and c.^commentedOn in r2
	}
}

/**
 * For a given state:
 * - Return set of content that user can comment on
 * - The user must have the privilege to comment on parent Comments/Photo
 */
fun canCommentOn[u : User, s: Nicebook] : set Content {
	let r = rawCanCommentOn[u, s] | {
		com :  r | com.^commentedOn in r
	}
}

/**
 * For a given state:
 * - Return set of content that user can comment on
 * - Content must be viewable to comment
 * - Do not consider nesting
 * - Considers user specific commenting privacy setting
 */
fun rawCanCommentOn[u : User, s: Nicebook] : set Content {
	let viewableContent = canView[u, s] {
		viewableContent & (u.owns +
		(u.friends & commentPrivacy.PL_Friends).owns +
		(u.friends.friends & commentPrivacy.PL_FriendsOfFriends).owns +
		(s.users & commentPrivacy.PL_Everyone).owns)
	}
}

/**
 * For a given state:
 * - Return Content set that user can view considering content level privileges
 * - Do not consider nested Contents
 * - Considers content level privacy
 */
fun rawCanViewContent[u : User, s: Nicebook] : set Content {
	-- s & users.u to ensure that the user is present in the state
	let allContentInState = getContentsInState[s & users.u] | {
		allContentInState & {
			u.owns +
			(u.friends.owns & contentViewPrivacy.PL_Friends) +
			(u.friends.friends.owns & contentViewPrivacy.PL_FriendsOfFriends) +
			(s.users.owns & contentViewPrivacy.PL_Everyone)
		}
	}
}

/**
 * For a given state:
 *  - Return Content set that allows user to view its comments
 *  - Do not consider nested Contents
 *  - Considers user level privacy
*/
fun rawCanViewContentComments[u : User, s: Nicebook] : set Content {
	-- s & users.u to ensure that the user is present in the state
	let allContentInState = getContentsInState[s & users.u] {
		allContentInState & {
			u.owns +
			(u.friends & userViewPrivacy.PL_Friends).owns + 
			(u.friends.friends & userViewPrivacy.PL_FriendsOfFriends).owns + 
			(s.users & userViewPrivacy.PL_Everyone).owns
		}
	}
}

/**
 * Return all content present in a state:
 * - For a Content to be present in a state, all its parent contents must 
 *    have an owner in the current state.
 */
fun getContentsInState[s : Nicebook] : set Content {
	let allContent = s.users.owns | {
		c : allContent | owns.(c.^commentedOn) in s.users
	}
}

/**
 * Return all tags present in a state:
 * - For a Tag to be present in a state, the tagged user must be present in state
 */
fun getTagsInState[s : Nicebook] : set Tag {
	let allTags = s.users.owns.tags | {
		t : allTags | (isTagged.t in s.users)
	}
}
