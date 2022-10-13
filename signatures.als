/****************
 * SIGNATURES
 * @author: Team 16
 ****************/

/********************
 * Privacy Relations
 *********************
 * contentViewPrivacy: 
 * - Content specific setting that controls who related to the user can view user owned content.
 *
 * userViewPrivacy:
 * - Controls viewing privileges associated with comments attached to user owned content.
 *
 * commentPrivacy:
 * - User specific setting that controls who can comment on user owned content.
 */

sig Nicebook {
	users : some User
}

sig User {
	userViewPrivacy : one PrivacyLevel,
	commentPrivacy : one PrivacyLevel,
	friends : set User,
	owns : some Content,
	hasTagged : set Tag,
	isTagged : set Tag
}

fact UserFact {
	-- All users must belong to a Nicebook instance
	User = Nicebook.users
	
	-- User can't be friends with self
	all u : User | u not in u.friends

	-- Users can be friends with another only if they share a state
	all u : User | u.friends in (users.u).users

	-- Friendship is Symmetric
	all u1, u2 : User | u1 in u2.friends implies u2 in u1.friends
}


abstract sig Content {
	contentViewPrivacy : one PrivacyLevel,
}

fact ContentFact{
	-- All Content elements must belong to some User
	Content = User.owns
}

sig Photo extends Content {
	tags : set Tag
}

sig Comment extends Content {
	commentedOn : one Content
}

fact CommentFact {
	-- Comments cannot be cyclic
	all com : Comment | com not in com.^commentedOn
}

sig Tag {}

fact TagFact {
	-- A user cannot be tagged twice in the same photo
	all t1, t2: Tag | (t1 != t2 and tags.t1 = tags.t2) implies isTagged.t1 != isTagged.t2

	-- A tag is associated with exactly one Photo
	all t : Tag | one tags.t
	
	-- All Tag instances must be mapped to a tagger and taggee
	Tag = User.isTagged
	Tag = User.hasTagged
}

/**
 * Abstract object used to define respective Privacy Levels as a singleton sets
 */
abstract sig PrivacyLevel {}
one sig PL_OnlyMe, PL_Friends, PL_FriendsOfFriends, PL_Everyone extends PrivacyLevel {}
