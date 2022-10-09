/****************
 * ACTIONS
 ****************/

open signatures
open functions
open predicates

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
 * - Note any assumptions made in comments
 */

-- addPhoto: Upload a photo to be published on a user’s account.
pred addPhoto [s1, s2: Nicebook, p : Photo, photo_adder_old : User] {
	// Pre
	canUserAddPhoto[photo_adder_old, p, s1]

	// Post
	some photo_adder_new : User {
		// Action: Add photo
		photo_adder_new.owns = photo_adder_old.owns + p

		// Frame
		ModifyContentFrame[photo_adder_old, photo_adder_new]
		
		// Replace user
		ReplaceUser[s1, photo_adder_old, s2, photo_adder_new]
	}
}

-- removePhoto: Remove an existing photo from a user’s account
pred removePhoto [s1, s2: Nicebook, p : Photo, photo_remover_old : User] {
    // Pre
    canUserRemovePhoto[photo_remover_old, p, s1]
    
    // Post
    some photo_remover_new : User {
        // Action: Remove photo
        photo_remover_new.owns = photo_remover_old.owns - p       

        -- Note: This much is sufficient as it won't appear in getContentsInState anymore
        
        // Frame 
        ModifyContentFrame[photo_remover_old, photo_remover_new]

        // Replace user
        ReplaceUser[s1, photo_remover_old, s2, photo_remover_new]
    }
}

-- addComment: Add a comment to a Content
pred addComment [s1, s2: Nicebook, com : Comment, C : Content, commenter_old : User] {
	// Pre
	canUserAddComment[commenter_old, com, C, s1]

	// Post
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

-- removeComment: Remove an existing comment.
pred removeComment [s1, s2: Nicebook, com : Comment, com_remover : User] {
	// Pre
	canUserRemoveComment[com_remover, com, s1]

 	// Post
	some com_owner_new : User | one com_owner_old : (owns.com & s1.users) | {
		// Remove ownership of com
		com_owner_new.owns = com_owner_old.owns - com

		// Frame
		ModifyContentFrame[com_owner_old, com_owner_new]

		// Replace user
		ReplaceUser[s1, com_owner_old, s2, com_owner_new]
	}
}

-- addTag: Add a tag to an existing photo on a user’s account.
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Kaz
}

-- removeTag: Remove a tag from a photo
pred removeTag [s1, s2: Nicebook, p : Photo, taggee_old, tag_remover : User] {
    // Pre
    canUserRemoveTag[tag_remover, taggee_old, p, s1]

    // Post
    some taggee_new : User {
        // Action: Remove tag from user 
        taggee_new.isTagged = taggee_old.isTagged - (p.tags & taggee_old.isTagged) 
        
        -- Note: This much is sufficient as it won't appear in getTagsInState anymore

        // Frame
        ModifyTagFrame[taggee_old, taggee_new]

        // Replace user
        ReplaceUser[s1, taggee_old, s2, taggee_new]
    }
}
