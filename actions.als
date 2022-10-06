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

//• addPhoto: Upload a photo to be published on a user’s account.
pred addPhoto [s1, s2: Nicebook, p : Photo, u1 : User] {
	// TODO: Saloni
	// Pre
		// No user owns this Photo in the pre-state
		p not in s1.users.owns
		no p.tags
	// Post
		// Find a user in the post-state who is exactly like arg: user
		one u2 : s2.users {
			u2.commentPrivacy = u1.commentPrivacy
			u2.userViewPrivacy = u1.userViewPrivacy
			u2.friends = u1.friends
			u2.owns = u1.owns + p
			u2.isTagged = u1.isTagged
			u2.hasTagged = u1.hasTagged
		}
}

-- removePhoto: Remove an existing photo from a user’s account
pred removePhoto [s1, s2: Nicebook, p : Photo, u : User] {
    // pre-condition:
    p in s1.users[ownedBy]      // Photo must exist in s1
    u in p.ownedBy              // Only owner can delete his photo
    
    // post-condition:
        -- Ensure all tags removed
        -- Ensure all comments removed
        -- Ensure photo is removed
    all t : p.tags | removeTag[s1, s2, t, u]

    // frame condition

    // promote
}

//• addComment: Add a comment to a photo or another comment.
pred addComment [s1, s2: Nicebook, c : Content, com: Comment, u : User] {
	// TODO: Hissah
}

//• removeComment: Remove an existing comment.
pred removeComment [s1, s2: Nicebook, com : Comment, u : User] {
	// TODO: Anyone
}

//• addTag: Add a tag to an existing photo on a user’s account.
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Kaz
}

pred removeTag []

-- removeTag: Remove a tag from a photo
pred removeTag [s1, s2: Nicebook, t : Tag, u : User] {
    // pre-condition:
    t in s1.users[ownedBy].tags                 // Tag must exist in s1
    u in t[tags].ownedBy or u in t.taggedBy     // Only tag/photo owner can delete

    // post-condition:
    some u2 : User {
        some p2 : Photo {
            // local update
            p2.tags = t[tags].tags - t

            // promote
            u2[ownedBy] = u[ownedBy] + p2 - t[tags]

            // frame condition
            p2.ownedBy = t[tags].ownedBy
        }

        // promote
        s2.users = s1.users + u2 - u
    }
}

