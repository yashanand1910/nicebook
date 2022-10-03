open signatures as s
open constraints as c
open actions as a
open invariants as i

pred Invariants {
	constraintNoUserCanBeFriendsWithSelf
	constraintFriendsAreCommutative
	constraintUsersCanBeTaggedByFriendsOnly
	constraintUserOwnsAtleastOneContent
	constraintCannotTagSameUserInOnePhoto
	constraintTagIsAssociatedWithExactlyOnePhoto
	constraintCommentsCannotHaveCycles
	constraintCommentCannotBeDangling
	constraintThereAreExactlyFourPrivacyLevels
	constraintUserCanBeInExactlyOneNetwork
	
}

/****************
 * RUN 
 ****************/

run GenerateValidInstance {
	Invariants
}
