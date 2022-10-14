/********************
 * PREDICATES
 * @author: Team 16
 *********************/

open functions

/**
 * Pre-condition checks for addPhoto
 * 
 * @photo_adder : User trying to add a new photo
 * @p : Photo to be added
 * @s : Nicebook state
 */
pred canUserAddPhoto[photo_adder : User, p: Photo, s : Nicebook] {
	-- Sanity Checks --
	-----------------

	-- The user must belong to the state
	photo_adder in s.users

	-- The photo shouldn't already be present in the state
	p not in s.users.owns

	-- The photo should be a fresh one without attached comments or tags
	no p.tags and no commentedOn.p


	-- Privilege Checks --
	--------------------
	-- No privilege required, anybody can add Photo
}

/**
 * Pre-condition checks for removePhoto
 *
 * @photo_remover : User trying to remove the phto
 * @p: The photo to be removed
 * @s : Nicebook state
 */
pred canUserRemovePhoto[photo_remover : User, p: Photo, s : Nicebook] {
	-- Sanity Checks --
	-----------------

	-- User must belong to the state
	photo_remover in s.users
	-- The Photo must belong to the State
	p in getContentsInState[s]


	-- Privilege Checks --
	--------------------
	checkRemovePhotoPrivilege[photo_remover, p]
}

/**
 * Check if User u has the Privilege to delete a Photo
 * @photo_remover : User trying to remove the phto
 * @p: The photo to be removed
 */
pred checkRemovePhotoPrivilege[photo_remover : User, p : Photo] {
	-- User must own the photo
	p in photo_remover.owns
}

/**
 * Pre-condition checks for addComment Action
 *
 * @comment_adder : User trying to add comment
 * @com : Comment to be added
 * @c : Content to be commented upon
 * @s : Nicebook state
 */
pred canUserAddComment[comment_adder: User, com : Comment, c : Content, s : Nicebook] {
	-- Sanity Checks --
	-----------------

	--User must belong to state
	comment_adder in s.users

	-- Comment shouldn't already exist linked to some user in state
	com not in s.users.owns
	
	-- The Content to be commented on must belong to the state
	c in getContentsInState[s]

	-- The Comment should be a fresh one without any comments attached
	no commentedOn.com


	-- Privilege Checks --
	--------------------
	checkAddCommentPrivilege [comment_adder, c, s]
}

/**
 * Check if User comment_adder has the Privilege to comment on 
 * Content c in Nicebook state s
 *
 * @comment_adder : User trying to add comment
 * @c : Content to be commented upon
 * @s : Nicebook state
 */
pred checkAddCommentPrivilege [comment_adder : User, c : Content, s : Nicebook] {
	-- Content c should belong to set of comments that the user has the privilege to comment on
	c in canCommentOn[comment_adder, s]
}

/**
 * Pre-condition checks for removeComment
 *
 * @comment_remover: User trying to remove the comment
 * @com: The Comment to be removed
 * @s : Nicebook state
 */
pred canUserRemoveComment[comment_remover : User, com : Comment, s : Nicebook] {
	-- Sanity Checks --
	-----------------
	
	-- User should belong to state
	comment_remover in s.users
	
	-- Comment should belong to the state
	com in getContentsInState[s]


	-- Privilege Checks --
	--------------------
	checkRemoveCommentPrivilege[comment_remover, com, s]
}

/**
 * Check if User has the privileges to remove Comment
 *
 * @comment_remover: User trying to remove the comment
 * @com: The Comment to be removed
 * @s : Nicebook state
 */
pred checkRemoveCommentPrivilege[comment_remover : User, com : Comment, s:Nicebook] {
	-- Can remove comment if:
	-- - Comment is owned by user OR
	-- - The Comment to be removed is commented on user owned content
	comment_remover in getContentOwnerInState[com + com.^commentedOn, s]
}

/**
 * Pre-condition checks for addTag
 *
 * @tagger: The user trying to tag a user to a photo 
 * @taggee: The user to be tagged on the photo 
 * @p: The photo to be tagged on
 * @t : The Tag instance to be used to link @tagger, @taggee and @p
 * @s: Nicebook state
 */
pred canUserAddTag[tagger, taggee: User, p : Photo, t: Tag, s : Nicebook] {
	-- Sanity Checks --
	-----------------
	-- Both users should be in the state
	(tagger + taggee) in s.users
	
	-- taggee should not already be tagged to the photo
	taggee not in p.tags[isTagged]
	
	-- Tag t should not be linked to any user except tagged
	t not in (s.users.isTagged + (s.users - tagger).hasTagged)
	t in tagger.hasTagged

	-- t should be linked to the photo to be tagged in
	t in p.tags


	-- Privilege Checks --
	--------------------
	checkAddTagPrivileges[tagger, taggee, p, s]
}

/**
 * Check if user has the privileges to tag another user to a photo in state s
 *
 * @tagger: The user trying to tag a user to a photo 
 * @taggee: The user to be tagged on the photo 
 * @p: The photo to be tagged on
 * @s: Nicebook state
 */
pred checkAddTagPrivileges[tagger, taggee : User, p : Photo, s : Nicebook] {
	-- Both tagger/taggee should be able to view the photo
	p in canView[tagger, s] and p in canView[taggee, s]

	-- Tagger/Tagee should be friends and in the same state
	tagger in getFriendsInState[taggee, s]
}

/**
 * Pre-condition checks for removeTag
 *
 * @tag_remover: The user trying to remove the tag
 * @taggee: The user whose tag needs to be removed from photo
 * @p: The photo the tag needs to be removed from
 * @s: Nicebook state
 */
pred canUserRemoveTag[tag_remover, taggee: User, p : Photo, s : Nicebook] {
	-- Sanity Checks --
	-----------------

	-- Both users should belong to the state
	(tag_remover + taggee) in s.users

	-- taggee should be tagged in photo
	taggee in p.tags[isTagged]

	-- Photo should belong to the state
	p in getContentsInState[s]


	-- Privilege Checks --
	--------------------
	checkRemoveTagPrivileges[tag_remover, taggee, p, s]
}

/**
 * Check if user has the privileges remove the tag of a user tagged in a photo
 *
 * @tag_remover: The user trying to remove the tag
 * @taggee: The user whose tag needs to be removed from photo
 * @p: The photo the tag needs to be removed from
 * @s: Nicebook state
 */
pred checkRemoveTagPrivileges[tag_remover, taggee : User, p: Photo, s: Nicebook] {
	-- A Tag on a photo can be removed by:
	-- - A user who owns the tagged photo.
	-- - A person who is tagged in the photo (can only delete his/her own tag from photo).
 	-- - A user who has tagged someone in the photo (can only delete tags tagged by him/her)
	tag_remover in (p[owns] + taggee + getTaggerInState[taggee, p, s])
}

/**
 * Frame conditions utilised in all actions
 *
 * @u_old : "pre-state" of a user
 * @u_new : "post-state" of a user
 */
pred BasicFrame[u_old, u_new: User] {
	u_new.commentPrivacy = u_old.commentPrivacy
	u_new.userViewPrivacy = u_old.userViewPrivacy
	u_new.friends = u_old.friends
	u_new.hasTagged = u_old.hasTagged
}

/**
 * Frame conditions utilised to replicate users in Content related actions
 *
 * @u_old : "pre-state" of a user
 * @u_new : "post-state" of a user
 */
pred ModifyContentFrame[u_old, u_new : User] {
	BasicFrame[u_old, u_new]
	u_new.isTagged = u_old.isTagged
}

/**
 * Frame conditions utilised to replicate users in Tag related actions
 * 
 * @u_old : "pre-state" of a user
 * @u_new : "post-state" of a user
 */
pred ModifyTagFrame[u_old, u_new : User] {
	BasicFrame[u_old, u_new]
	u_new.owns = u_old.owns
}

/**
 * Copies users in state s2 except users_old which are replaced by users_new
 *
 * @s1: Nicebook "pre" state
 * @users_old : Users to be replaced
 * @s2: Nicebook "post" state
 * @users_new : Users to replace users_old with
 */
pred ReplaceUser[s1: Nicebook, users_old : User, s2 : Nicebook, users_new : User] {
	s2.users = s1.users - users_old + users_new
}

/**
 * This predicate is used to test the canView function in NoPrivacyViolation assertion
 * - True: Evaluates to true if User u can view Content c in Nicebook state s
 *    based on content privacy settings.
 * - False: Otherwise
 * 
 * @u : User trying to view content
 * @c : Content to be viewed
 * @s : Nicebook state
 */
pred NoPrivacyViolationContentLevel[u : User, c : Content, s : Nicebook] {
	-- Sanity Check--
	u in s.users
	c in getContentsInState[s]

	-- c is owned by u or c is commented on user owned content
	u in (getContentOwnerInState[c + c.^commentedOn, s]) or
	{	
		-- Content and all its parent Contents
		all pc : (c+c.^commentedOn) &s.users.owns | let content_owner = getContentOwnerInState[pc, s] {
			pc.contentViewPrivacy = PL_OnlyMe implies {
				u = content_owner
			}
			pc.contentViewPrivacy = PL_Friends implies {
				u in (content_owner + 
					getFriendsInState[content_owner, s])
			}
			pc.contentViewPrivacy = PL_FriendsOfFriends implies {
				u in (
					getFriendsInState[content_owner, s] + 
					getFriendsInState[getFriendsInState[content_owner, s], s]
				)
			}
			pc.contentViewPrivacy = PL_Everyone implies {
				u in s.users
			}
		}
	}
}

/**
 * This predicate is used to test the canView function in NoPrivacyViolation assertion
 * - True: If User u can view Content c in Nicebook state s based on User privacy settings.
 * - False: Otherwise
 * 
 * @u : User trying to view content
 * @c : Content to be viewed
 * @s : Nicebook state
 */
pred NoPrivacyViolationUserLevel[u : User, c : Content, s : Nicebook] {
	-- Sanity Check--
	u in s.users
	c in getContentsInState[s]

	-- c is owned by u or c is commented on user owned content
	u in (getContentOwnerInState[c + c.^commentedOn, s]) or
	{
		-- All parent Content owners in state
		all pu : getContentOwnerInState[(c.^commentedOn), s] | {
			pu.userViewPrivacy = PL_OnlyMe implies {
				u = pu
			}
			pu.userViewPrivacy = PL_Friends implies {
				u in (pu + getFriendsInState[pu,s])
			}
			pu.userViewPrivacy = PL_FriendsOfFriends implies {
				u in (pu + getFriendsInState[pu,s] + getFriendsInState[getFriendsInState[pu,s], s])
			}
			pu.userViewPrivacy = PL_Everyone implies {
				u in s.users
			}
		}
	}
}
