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
	
	taggee != tagger implies {
		tagger_new.friends = tagger.friends - taggee + taggee_new
		taggee_new.friends = taggee.friends - tagger + tagger_new
		taggee_new.hasTagged = taggee.hasTagged
		tagger_new.isTagged = tagger.isTagged
	}

	tagger = taggee implies {
		tagger_new = taggee_new
		taggee_new.friends = taggee.friends
	}

	taggee_new.owns = taggee.owns
	tagger_new.owns = tagger.owns
}

/**
 * Copies all users in state s2 except users_old which are replaced by users_new
 */
pred ReplaceUser[s1: Nicebook, users_old : User, s2 : Nicebook, users_new : User] {
	s2.users = s1.users - users_old + users_new
}
