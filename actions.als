module actions

open signatures as S

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
 */

//• addPhoto: Upload a photo to be published on a user’s account.
pred addPhoto [s1, s2: Nicebook, p : Photo, u : User] {
	// TODO: Saloni
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
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag taggedBy : User, taggedUser : User] {
	// precondition
	// tagTarget must be a friend of tagUser
	tagTarget in tagUser.friends
	t not in p.tags

	// postcondition
	taggedTarget in t.taggedUser
	taggedBy in t.taggedBy
	some p2: Photo {
		// add tag to the existing photo
		p2 = p.tags + t
		some u2: User {
			// user to be updated is the owner of the photo
			let u1 = p.ownedBy
			// update the user of the photo
			p2.ownedBy = u2
			// replace the user to new user
			s2.users = s1.users - u1 + u2
		}
	}
}


//• removeTag: Remove a tag from a photo.
pred removeTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Anyone
}
