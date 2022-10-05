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
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Kaz
}


//• removeTag: Remove a tag from a photo.
pred removeTag [s1, s2: Nicebook, p: Photo, t : Tag, u : User] {
	// TODO: Anyone
}
