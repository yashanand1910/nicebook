/********************
 * FUNCTIONS
 * @author: Team 16
 *********************/

open signatures

/** 
 * For a given state:
 * - Return Content set that user can view
 * - User should be able to view parent Comments/Photo
 * - User should have the privilege to view comments of parent Comments/Photo
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun canView[u : User, s: Nicebook] : set Content {
	let r1 = getContentsInState[s & users.u], r2 = rawCanViewContent[u,s], 
		r3 = rawCanViewContentComments[u,s] | r1 & {
			(u.owns + u.owns[^commentedOn]) +
			{c : r2 | c.^commentedOn in r2 and c.^commentedOn in r3}
		}
}

/**
 * For a given state:
 * - Return set of content that user can comment on
 * - The user must have the privilege to comment on parent Comments/Photo
 * 
 * @u : User instance
 * @s: Nicebook State
 */
fun canCommentOn[u : User, s: Nicebook] : set Content {
	let r1 = canView[u, s], r2 = rawCanCommentOn[u,s] | r1 & {
		(u.owns + u.owns[^commentedOn]) +
		{c :  r2 | c.^commentedOn in r2}
	}
}

/**
 * - Return set of content that user can comment on
 * - Content must be viewable to comment
 * - Do not consider nesting
 * - Considers user specific commenting privacy setting
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun rawCanCommentOn[u : User, s : Nicebook] : set Content {
	let u_friends = getFriendsInState[u,s] | {
		u.owns +
		(u_friends & commentPrivacy.PL_Friends).owns +
		((u_friends + getFriendsInState[u_friends, s]) & commentPrivacy.PL_FriendsOfFriends).owns +
		(commentPrivacy.PL_Everyone & s.users).owns
	}
}

/**
 * - Return Content set that user can view considering content level privileges
 * - Do not consider nested Contents priviledges
 * - Considers content level privacy
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun rawCanViewContent[u : User, s : Nicebook] : set Content {
	let u_friends = getFriendsInState[u,s] | {
		u.owns +
		(u_friends.owns & contentViewPrivacy.PL_Friends) +
		((u_friends.owns + getFriendsInState[u_friends, s].owns) & contentViewPrivacy.PL_FriendsOfFriends) +
		contentViewPrivacy.PL_Everyone
	}
}

/**
 *  - Return Content set that allows user to view its comments
 *  - Do not consider nested Contents
 *  - Considers user level privacy
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun rawCanViewContentComments[u : User, s : Nicebook] : set Content {
	let u_friends = getFriendsInState[u,s] | {
		u.owns +
		(u_friends & userViewPrivacy.PL_Friends).owns + 
		((u_friends + getFriendsInState[u_friends, s]) & userViewPrivacy.PL_FriendsOfFriends).owns + 
		(userViewPrivacy.PL_Everyone & s.users).owns
	}
}

/**
 * Return all content present in a state:
 * - For a Content to be present in a state, all its parent contents must 
 *    have an owner in the current state.
 *
 * @s: Nicebook State
 */
fun getContentsInState[s : Nicebook] : set Content {
	let allContent = s.users.owns | {
		c : allContent | c.^commentedOn in allContent
	}
}

/**
 * Return all tags present in a state:
 * - For a Tag to be present in a state, the tagged user and the tagged photo must be present in the state
 * 
 * @s: Nicebook State
 */
fun getTagsInState[s : Nicebook] : set Tag {
	{s.users.isTagged & s.users.owns.tags}
}

/**
 * Returns owner of content in a particular state
 *
 * @c : Content
 * @s: Nicebook State
 */
fun getContentOwnerInState[c : Content, s : Nicebook] : set User {
	{owns.c & s.users}
}

/**
 * Return contents owned by user in a state
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun getUserOwnedContentsInState[u : User, s : Nicebook] : set Content {
	{u.owns & getContentsInState[s]}
}

/**
 * Return friends of user in a state
 *
 * @u : User instance
 * @s: Nicebook State
 */
fun getFriendsInState[u : User, s : Nicebook] : set User{
	{u.friends & s.users}
}

/**
 * Return the Tag instance that links User u to Photo p
 *
 * @u : User instance
 * @p : Photo
 */
fun getUserTag[u : User, p : Photo] : set Tag {
	{p.tags & u.isTagged}
}

/**
 * Return Tagger user who has tagged User u to Photo p
 * 
 * @u : User instance
 * @p : Photo
 * @s: Nicebook State
 */
fun getTaggerInState[u : User, p : Photo, s : Nicebook] : set User {
	{getUserTag[u,p][hasTagged] & s.users}
}
