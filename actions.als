/********************
 * ACTIONS
 * @author: Team 16
 *********************/

open signatures
open functions
open predicates

/**
 * Operation: A user adding a new photo
 * 
 * @photo_adder_old : User trying to add a new photo
 * @p : Photo to be added
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred addPhoto [s1, s2: Nicebook, p : Photo, photo_adder_old : User] {
	-- Pre
	canUserAddPhoto[photo_adder_old, p, s1]

	-- Post
	some photo_adder_new : User {
		-- Action: Add photo
		photo_adder_new.owns = photo_adder_old.owns + p

		-- Frame
		ModifyContentFrame[photo_adder_old, photo_adder_new]
		
		-- Replace user
		ReplaceUser[s1, photo_adder_old, s2, photo_adder_new]
	}
}

/**
 * Operation: Remove an existing photo from a user's account
 * 
 * @photo_remover_old : User trying to remove a photo
 * @p : Photo to be removed
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred removePhoto [s1, s2: Nicebook, p : Photo, photo_remover_old : User] {
    -- Pre
    canUserRemovePhoto[photo_remover_old, p, s1]
    
    -- Post
    some photo_remover_new : User {
        -- Action: Remove photo
        photo_remover_new.owns = photo_remover_old.owns - p       

        -- Note: This much is sufficient as it won't appear in getContentsInState anymore
        
        -- Frame 
        ModifyContentFrame[photo_remover_old, photo_remover_new]

        -- Replace user
        ReplaceUser[s1, photo_remover_old, s2, photo_remover_new]
    }
}

/**
 * Operation: Add a comment to a Content
 * 
 * @commenter_old : User trying to add a comment
 * @com : Comment to be added
 * @C : Content to be commented on
 * @p : Photo to be removed
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred addComment [s1, s2: Nicebook, com : Comment, C : Content, commenter_old : User] {
	-- Pre
	canUserAddComment[commenter_old, com, C, s1]

	-- Post
	some commenter_new : User {
		-- Action: commenter_new is owner of com, add com to C
		commenter_new.owns = commenter_old.owns + com
		C in com.commentedOn
		
		-- Frame
		ModifyContentFrame[commenter_old, commenter_new]
		
		-- Replace user
		ReplaceUser[s1, commenter_old, s2, commenter_new]
	}
}

/**
 * Operation: Remove an existing comment.
 * 
 * @com_remover : User trying to remove a comment
 * @com : Comment to be removed
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred removeComment [s1, s2: Nicebook, com : Comment, com_remover : User] {
	-- Pre
	canUserRemoveComment[com_remover, com, s1]

 	-- Post
	some com_owner_new : User | one com_owner_old : (owns.com & s1.users) | {
		-- Remove ownership of com
		com_owner_new.owns = com_owner_old.owns - com

		-- Frame
		ModifyContentFrame[com_owner_old, com_owner_new]

		-- Replace user
		ReplaceUser[s1, com_owner_old, s2, com_owner_new]
	}
}

/**
 * Operation: Add tag to a Photo
 *
 * @tagger_old: The user trying to tag a user to a photo 
 * @taggee_old: The user to be tagged on the photo 
 * @p: The photo to be tagged on
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred addTag [s1, s2: Nicebook, p: Photo, taggee_old, tagger_old : User] {
	some tag: Tag, taggee_new: User {
		-- Pre
		canUserAddTag[tagger_old, taggee_old, p, tag, s1]
		
		-- Post: Add the tag
		taggee_new.isTagged = taggee_old.isTagged + tag

		-- Frame
		ModifyTagFrame[taggee_new, taggee_old]

		-- Replace User
		ReplaceUser[s1, taggee_old, s2, taggee_new]
	}
}

/**
 * Operation: Remove a tag from a photo
 *
 * @tag_remover: The user trying to remove the tag
 * @taggee_old: The user whose tag needs to be removed from photo
 * @p: The photo the tag needs to be removed from
 * @s1 : Nicebook pre-state
 * @s2 : Nicebook post-state
 */
pred removeTag [s1, s2: Nicebook, p : Photo, taggee_old, tag_remover : User] {
	-- Pre
	canUserRemoveTag[tag_remover, taggee_old, p, s1]

	some taggee_new: User | {
		-- Post : Remove the tag
		taggee_new.isTagged = taggee_old.isTagged - getUserTag[taggee_old, p]
		
		-- Frame
		ModifyTagFrame[taggee_old, taggee_new]
		
		-- Replace user
		ReplaceUser[s1, taggee_old, s2, taggee_new]
	}
}
