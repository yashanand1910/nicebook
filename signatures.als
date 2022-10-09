/****************
 * SIGNATURES
 ****************/

/**
 * Each piece of content owned by a user is associated a privacy level that determines 
 * who is able to view that content on the user’s account.
 *   -- Content Specific Setting
 *
 * Each user has a setting that controls who is able to view content that is published 
 * on the user’s account by other users.
 *  -- Comments posted on your photos/and tagged photos
 *  -- User Profile Content posted by other users 

 * Each user has a setting that controls who is able to add a comment to content 
 * that is owned by the user.
 *  -- Commenting Privileges for evert content (Photo/Comment)
 */

sig Nicebook {
	users : some User
}

sig User {
	friends : set User,
	-- Who can view Comments published by other users on user owned Photos
	userViewPrivacy : one PrivacyLevel,
	-- Who can comment on user owned Content
	commentPrivacy : one PrivacyLevel,
	hasTagged : set Tag,
	isTagged : set Tag,
	owns : some Content
}


abstract sig Content {
	contentViewPrivacy : one PrivacyLevel,
}

sig Photo extends Content {
	// Can tag 0 or more User
	tags : set Tag
}

sig Comment extends Content {
	// Can comment on only one Content
	commentedOn : one Content
}

sig Tag {}

abstract sig PrivacyLevel {}

one sig PL_OnlyMe, PL_Friends, PL_FriendsOfFriends, PL_Everyone extends PrivacyLevel {}
