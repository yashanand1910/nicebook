/****************
 * PREDICATES
 * @author: Team 16
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
	-- Can remove commented if:
	---- Comment is owned by user OR
	---- Comment is commented on user owned content
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
	-- Both tagger/taggee should be able to view the photo
	p in canView[tagger, s] and p in canView[taggee, s]
	-- Tagger/Tagee should be friends
	tagger in taggee.friends
}

pred canUserRemoveTag[tag_remover, taggee: User, p : Photo, s : Nicebook] {
	-- Sanity Check
	(tag_remover + taggee) in s.users
	taggee in p.tags[isTagged]
    p in getContentsInState[s]

	-- Privileges
	checkRemoveTagPrivileges[tag_remover, taggee, p]
}

pred checkRemoveTagPrivileges[tag_remover, taggee : User, p: Photo] {
	tag_remover in (p[owns] + taggee + taggee.isTagged[hasTagged])
}

pred PrivacyFrame[u_old, u_new: User] {
	u_new.commentPrivacy = u_old.commentPrivacy
	u_new.userViewPrivacy = u_old.userViewPrivacy
}

/**
 * Frame conditions utilised to replicate users in Content related actions
 */
pred ModifyContentFrame[u_old, u_new : User] {
	PrivacyFrame[u_old, u_new]

	u_new.friends = u_old.friends
	u_new.isTagged = u_old.isTagged
	u_new.hasTagged = u_old.hasTagged
}

/**
 * Frame conditions utilised to replicate Tagger and Taggee user in Tag related Actions
 */
pred ModifyTagFrame[taggee, taggee_new, tagger, tagger_new : User] {
	PrivacyFrame[taggee, taggee_new]
	PrivacyFrame[tagger, tagger_new]

	tagger_new.friends = tagger.friends - taggee + taggee_new
	taggee_new.friends = taggee.friends - tagger + tagger_new
	taggee_new.hasTagged = taggee.hasTagged
	tagger_new.isTagged = tagger.isTagged
	
	taggee_new.owns = taggee.owns
	tagger_new.owns = tagger.owns
}

/**
 * Copies all users in state s2 except users_old which are replaced by users_new
 */
pred ReplaceUser[s1: Nicebook, users_old : User, s2 : Nicebook, users_new : User] {
	s2.users = s1.users - users_old + users_new
}
