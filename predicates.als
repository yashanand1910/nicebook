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

pred canUserRemovePhoto[photo_remover : User, p: Photo, s : Nicebook] {
	-- Sanity Check
	photo_remover in s.users
	p in getContentsInState[s]

	-- Remove Photo privilege
	checkRemovePhotoPrivilege[photo_remover, p]
}

pred checkRemovePhotoPrivilege[photo_remover : User, p : Photo] {
	p in photo_remover.owns
}

pred canUserAddComment[comment_adder: User, com : Comment, c : Content, s : Nicebook] {
	-- Sanity Check
	comment_adder in s.users
	com not in s.users.owns
	c in getContentsInState[s]
	no commentedOn.com

	-- Add Comment Privilege
	checkAddCommentPrivilege [comment_adder, c, s]
}

pred checkAddCommentPrivilege [comment_adder : User, c : Content, s : Nicebook] {
	c in canCommentOn[comment_adder, s]
}

pred canUserRemoveComment[comment_remover : User, com : Comment, s : Nicebook] {
	-- Sanity Check
	comment_remover in s.users
	com in getContentsInState[s]

	-- Remove Comment privilege
	checkRemoveCommentPrivilege[comment_remover, com]
}

pred checkRemoveCommentPrivilege[comment_remover : User, com : Comment] {
	comment_remover in (com + com.^commentedOn)[owns]
}

pred canUserAddTag[tagger, taggee: User, p : Photo, s : Nicebook] {
	-- Sanity Check
	(tagger + taggee) in s.users
	taggee not in p.tags[isTagged]

	-- Privileges
	checkAddTagPrivileges[tagger, taggee, p, s]
}

pred checkAddTagPrivileges[tagger, taggee : User, p : Photo, s : Nicebook] {
	p in canView[tagger, s] and p in canView[taggee, s]
	tagger = taggee or tagger in taggee.friends
}

pred canUserRemoveTag[tag_remover, taggee: User, p : Photo, s : Nicebook] {
	-- Sanity Check
	(tag_remover + taggee) in s.users
	taggee in p.tags[isTagged]

	-- Privileges
	checkRemoveTagPrivileges[tag_remover, taggee, p]
}

pred checkRemoveTagPrivileges[tag_remover, taggee : User, p: Photo] {
	tag_remover in (p[owns] + taggee + taggee.isTagged[hasTagged])
}

pred ModifyContentFrame[u1, u2 : User] {
	u2.commentPrivacy = u1.commentPrivacy
	u2.userViewPrivacy = u1.userViewPrivacy
	u2.friends = u1.friends
	u2.isTagged = u1.isTagged
	u2.hasTagged = u1.hasTagged
}

pred ModifyTagFrame[u1, u2 : User] {
	u2.commentPrivacy = u1.commentPrivacy
	u2.userViewPrivacy = u1.userViewPrivacy
	u2.friends = u1.friends
	u2.owns = u1.owns
	u2.hasTagged = u1.hasTagged
}

pred ReplaceUser[s1: Nicebook, u1 : User, s2 : Nicebook, u2 : User] {
	s2.users = s1.users - u1 + u2
}
