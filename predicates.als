/****************
 * PREDICATES
 ****************/

open functions

pred canUserAddPhoto[photo_adder : User, p: Photo, s : Nicebook] {
	-- Sanity Check
	photo_adder in s.users
	p not in s.users.owns
	no p.tags and no commentedOn.p // Fresh Photo w/o tags and comments

	-- No privilege required, anybody can add Photo
}

pred canUserRemovePhoto[u : User, p: Photo, s : Nicebook] {
	-- Sanity Check
	u in s.users
	p in getContentsInState[s]

	-- Remove Photo privilege
	checkRemovePhotoPrivilege[u, p]
}

pred checkRemovePhotoPrivilege [u : User, p : Photo] {
	p in u.owns
}

pred canUserAddComment[u: User, com : Comment, c : Content, s : Nicebook] {
	-- Sanity Check
	u in s.users
	com not in s.users.owns
	c in getContentsInState[s]
	no commentedOn.com

	-- Add Comment Privilege
	checkAddCommentPrivilege [u, c, s]
}

pred checkAddCommentPrivilege [u : User, c : Content, s : Nicebook] {
	c in canCommentOn[u, s]
}

pred canUserRemoveComment[u : User, com : Comment, s : Nicebook] {
	-- Sanity Check
	u in s.users
	com in getContentsInState[s]

	-- Remove Comment privilege
	checkRemoveCommentPrivilege[u, com]
}

pred checkRemoveCommentPrivilege[u : User, com : Comment] {
	-- Can remove commented if:
	---- Comment is owned by user OR
	---- Comment is commented on user owned content
	u in (com + com.^commentedOn)[owns]
}

pred canUserAddTag[tagger, taggee: User, p : Photo, s : Nicebook] {
	-- Sanity Check
	(tagger + taggee) in s.users
	taggee not in p.tags[isTagged]

	-- Privileges
	checkAddTagPrivileges[tagger, taggee, p, s]
}

pred checkAddTagPrivileges[tagger, taggee : User, p : Photo, s : Nicebook] {
	-- Both tagger/taggee should be able to view the photo
	p in canView[tagger, s] and p in canView[taggee, s]
	-- Tagger/Tagee should be the same user or should be friends
	tagger = taggee or tagger in taggee.friends
}

pred canUserRemoveTag[tag_remover, remove_user_tag: User, p : Photo, s : Nicebook] {
	-- Sanity Check
	(tag_remover + remove_user_tag) in s.users
	remove_user_tag in p.tags[isTagged]

	-- Privileges
	checkRemoveTagPrivileges[tag_remover, remove_user_tag, p]
}

pred checkRemoveTagPrivileges[tag_remover, remove_user_tag : User, p: Photo] {
	tag_remover in p[owns] + p.tags[isTagged] + p.tags[hasTagged]
}

/**
 * Frame conditions utilised to replicate users in Content related actions
 */
pred ModifyContentFrame[u1, u2 : User] {
	u2.commentPrivacy = u1.commentPrivacy
	u2.userViewPrivacy = u1.userViewPrivacy
	u2.friends = u1.friends
	u2.isTagged = u1.isTagged
	u2.hasTagged = u1.hasTagged
}

/**
 * Frame conditions utilised to replicate users in Tag related Actions
 */
pred ModifyTagFrame[u1, u2 : User] {
	u2.commentPrivacy = u1.commentPrivacy
	u2.userViewPrivacy = u1.userViewPrivacy
	u2.friends = u1.friends
	u2.owns = u1.owns
	u2.hasTagged = u1.hasTagged
}

/**
 * Copies all users in state s2 except u1 which is replaced with u2
 */
pred ReplaceUser[s1: Nicebook, u1 : User, s2 : Nicebook, u2 : User] {
	s2.users = s1.users - u1 + u2
}
