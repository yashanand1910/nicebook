open signatures as S
open constraints as S
open actions as AC
open invariants as I
open assertions as A

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
