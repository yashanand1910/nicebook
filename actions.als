/****************
 * ACTIONS
 ****************/

open signatures as S

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
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

//• removePhoto: Remove an existing photo from a user’s account.
pred removePhoto [s1, s2: Nicebook, p : Photo, u : User] {
	// TODO: Yash
	// Comments should also be deleted
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
pred addTag [s1, s2: Nicebook, p: Photo, u1: User, t : Tag, taggee : User, tagger : User] {
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


//• removeTag: Remove a tag from a photo.
pred removeTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Anyone
}
