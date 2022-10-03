module actions

/**
 * TODO: 
 * - Think about Arguments
 * - Think about State Invariants that actions must preserve
 */

//• addPhoto: Upload a photo to be published on a user’s account.
pred addPhoto [s1, s2: Nicebook, p : Photo, u : User] {
	
}

//• removePhoto: Remove an existing photo from a user’s account.
pred removePhoto [s1, s2: Nicebook, p : Photo, u : User] {
	
}

//• addComment: Add a comment to a photo or another comment.
pred addComment [s1, s2: Nicebook, c : Content, com: Comment] {
	
}

//• removeComment: Remove an existing comment.
pred removeComment [s1, s2: Nicebook, com : Comment] {
	
}


//• addTag: Add a tag to an existing photo on a user’s account.
pred addTag [s1, s2: Nicebook, p: Photo, t : Tag] {
	
}


//• removeTag: Remove a tag from a photo.
pred removeTag [s1, s2: Nicebook, p: Photo, t : Tag] {
	
}
