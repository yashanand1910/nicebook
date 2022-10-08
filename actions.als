/****************
 * ACTIONS
 ****************/

open signatures as S

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
 * - Note any assumptions made in comments
 */

-- addPhoto: Upload a photo to be published on a user’s account.
// TODO: Saloni
pred addPhoto [s1, s2: Nicebook, p : Photo, u1 : User] {
	// Pre
	u1 in s1.users
	p not in s1.users.owns
	no p.tags

	// Post
	one u2 : s2.users {
		-- Add photo
		u2.owns = u1.owns + p

		// Frame
		u2.commentPrivacy = u1.commentPrivacy
		u2.userViewPrivacy = u1.userViewPrivacy
		u2.friends = u1.friends
		u2.isTagged = u1.isTagged
		u2.hasTagged = u1.hasTagged
		
		// Replace user
		s2.users = s1.users - u1 + u2
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

-- addComment: Add a comment to a photo or another comment.
pred addComment [s1, s2: Nicebook, c : Content, com: Comment, u : User] {
	// TODO: Hissah
}

-- removeComment: Remove an existing comment.
pred removeComment [s1, s2: Nicebook, com : Comment, u : User] {
	// TODO: Anyone
}

-- addTag: Add a tag to an existing photo on a user’s account.
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag, u1 : User, taggee : User, tagger : User] {
	// precondition
	// tagee must be a friend of tagger
	taggee in tagger.friends
	// tag should not tagged in the photo
	t not in p.tags
	// the user must own the photo
	p in u1.owns

	// postcondition
	t in tagger.hasTagged
	t in taggee.isTagged
	some p2: Photo {
		// add tag to the existing photo
		p2.tags = p.tags + t
		some u2: User {
			// user to be updated is the owner of the photo
			// update the user of the photo
			u2.owns = u1.owns + p2

			// frame condition
			u2.commentPrivacy = u1.commentPrivacy
			u2.userViewPrivacy = u1.userViewPrivacy
			u2.friends = u1.friends
			u2.isTagged = u1.isTagged
			u2.hasTagged = u1.hasTagged

			// promote: replace the user to new user
			s2.users = s1.users - u1 + u2
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
