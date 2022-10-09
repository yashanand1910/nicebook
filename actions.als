/****************
 * ACTIONS
 ****************/

open signatures as S
open functions
open predicates

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
 * - Note any assumptions made in comments
 */

-- addPhoto: Upload a photo to be published on a user’s account.
// TODO: Saloni
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
pred removePhoto [s1, s2: Nicebook, p : Photo, u1 : User] {
    // pre-condition:
    p in s1.users.owns              // Photo must exist in s1
    u1 in p[owns]                   // Only owner can delete his photo
    
    // post-condition:
    some u2 : s2.users {
        u2.owns = u1.owns - p       // Photo should no longer be owned by user

        -- Note: This doesn't delink comments on this photo
        -- The comments visibility will be taken care by privacy fucntions
        
        // frame condition
        u2.commentPrivacy = u1.commentPrivacy
        u2.userViewPrivacy = u1.userViewPrivacy
        u2.friends = u1.friends
        u2.isTagged = u1.isTagged
        u2.hasTagged = u1.hasTagged

        // promote
        s2.users = s1.users - u1 + u2
    }
}

-- addComment: Add a comment to a Content
// TODO: Saloni
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
// TODO: Saloni
pred removeComment [s1, s2: Nicebook, com : Comment, com_remover : User] {
	// Pre
	canUserRemoveComment[com_remover, com, s1]

 	// Post
	some com_owner_new : User | one com_owner_old : (owns.com & s1.users) | {
		-- Remove ownership of com
		com_owner_new.owns = com_owner_old.owns - com

		-- Frame
		ModifyContentFrame[com_owner_old, com_owner_new]

		-- Replace user
		ReplaceUser[s1, com_owner_old, s2, com_owner_new]
	}
}

-- addTag: Add a tag to an existing photo on a user’s account.
pred addTag [s1, s2: Nicebook, p: Photo, taggee, tagger : User] {
	// precondition
	canUserAddTag[tagger, taggee, p, s1]

	// postcondition
	some t: Tag {
		t not in taggee.isTagged

		//t not in s1.users.owns.tags
		t in p.tags
		t in tagger.hasTagged

		some taggee2: s2.users {
			taggee2.isTagged = taggee.isTagged + t

			// frame condition
			ModifyTagFrame[taggee2, taggee]
			
			// promote the taggee
			ReplaceUser[s1, taggee, s2, taggee2]
		}
	}
}

-- removeTag: Remove a tag from a photo
pred removeTag [s1, s2: Nicebook, t : Tag, u1 : User] {
    // pre-condition:
    t in s1.users.owns.tags                         // Tag must exist in s1
    u1 in t[tags][owns] or u1 in t[hasTagged]       // ASSUMPTION: Only tag/photo owner can delete

    // post-condition:
    some u2 : User {
        some p2 : Photo {
            // local update
            p2.tags = t[tags].tags - t

            // promote
            u2.owns = u1.owns + p2 - t[tags]
        }

        // frame condition
        u2.commentPrivacy = u1.commentPrivacy
        u2.userViewPrivacy = u1.userViewPrivacy
        u2.friends = u1.friends
        u2.isTagged = u1.isTagged
        u2.hasTagged = u1.hasTagged

        // promote
        s2.users = s1.users + u2 - u1
    }
}
