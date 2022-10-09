/****************
 * TESTS
 ****************/

open signatures as S
open constraints as C
open actions as AC
open invariants as I
open assertions as A
open functions as F

/****************
 * RUN 
 ****************/

run GenerateAddPhotoValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, p:Photo, u:User | some s1.users and s1 != s2 and
		(Invariants[s1] and addPhoto[s1,s2,p,u] and Invariants[s2])
} for 5

check addPhotoPreservesInvariants for 5

run GenerateRemovePhotoInstances {
    some s1, s2 : Nicebook, p : s1.users.owns & Photo, u1 : s1.users |
        Invariants[s1] and some p[commentedOn] and removePhoto[s1, s2, p, u1] and Invariants[s2]
} for 5 but 2 Nicebook, exactly 3 User, 3 Comment

check removePhotoPreservesInvariants for 5

run GenerateAddCommentValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, com: Comment, c:Content, u:User | some s1.users and s1 != s2 and
		(Invariants[s1] and addComment[s1,s2,com,c,u] and Invariants[s2])
} for 5

check addCommentPreservesInvariants for 5

run GenerateRemoveCommentValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, com : Comment, u : User | some s1.users and s1 != s2 and
		(Invariants[s1] and removeComment[s1,s2,com,u] and Invariants[s2])
} for 5

check removeCommentPreservesInvariants for 5

check NoPrivacyViolation for 7
