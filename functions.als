/****************
 * FUNCTIONS
 ****************/

open signatures as S

-- Return Content set that user can view
-- User should be able to view parent Comments/Photo
-- User should have the privilege to view comments of parent Comments/Photo
fun canView[u : User] : set Content {
	let r1 = rawCanViewContent[u] | let r2 = rawCanViewContentComments[u] {
		Photo & r1 + 
		{ com : (Comment & r1) | com in r1 and
		com.^commentedOn in r1 and com.^commentedOn in r2 }
	}
}

-- Return set of content that user can comment on
-- The user must have the privilege to comment on parent Comments/Photo
fun canCommentOn[u : User] : set Content {
	let r = rawCanCommentOn[u] {
		Photo & r + 
		{ com : (Comment & r) | 
		com.^commentedOn in r }
	}
}

-- Return Content set that user can view considering content level privileges
-- Do not consider nested Contents
-- Considers content level privacy
fun rawCanViewContent[u : User] : set Content {
	let s = users.u {
		u.owns +
		(u.friends.owns & contentViewPrivacy.PL_Friends) +
		(u.friends.friends.owns & contentViewPrivacy.PL_FriendsOfFriends) +
		(s.users.owns & contentViewPrivacy.PL_Everyone)
	}
}

-- Return Content set that allows user to view its comments
-- Do not consider nested Contents
-- Considers user level privacy
fun rawCanViewContentComments[u : User] : set Content {
	let s = users.u {
		u.owns +
		(u.friends & userViewPrivacy.PL_Friends).owns + 
		(u.friends.friends & userViewPrivacy.PL_FriendsOfFriends).owns + 
		(s.users & userViewPrivacy.PL_Everyone).owns
	}
}

-- Return set of content that user can comment on
-- Content must be viewable to comment
-- Do not consider nesting
-- Considers user specific commenting privacy setting
fun rawCanCommentOn[u : User] : set Content {
	let viewableContent = canView[u] | let s = users.u {
		viewableContent & (u.owns +
		(u.friends & commentPrivacy.PL_Friends).owns +
		(u.friends.friends & commentPrivacy.PL_FriendsOfFriends).owns +
		(s.users & commentPrivacy.PL_Everyone).owns)
	}
}

-- For a Content to be present in a state, all its parents must have owner in current state
fun getContentsInState[s : Nicebook] : set Content {
	let allContent = s.users.owns | { 
		c : allContent | owns.(c.^commentedOn) in s.users
	}
}

-- For a Tag to be present in a state, the tagged user must be present in state
fun getTagsInState[s : Nicebook] : set Tag {
	let allTags = (Photo & s.users.owns).tags | { 
		t : allTags | (isTagged.t in s.users)
	}
}
