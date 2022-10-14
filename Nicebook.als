/********************
 * MAIN MODEL
 * @author: Team 16
 *********************/

open signatures as S
open actions as AC
open invariants as I
open assertions as A

/****************
 * RUN 
 ****************/

-- addPhoto Tests
run GenerateAddPhotoValidInstance {
	#Nicebook = 2
	some s1,s2: Nicebook, u: User, p:Photo | s1 != s2 and
		Invariants[s1] and addPhoto[s1,s2,p,u] and Invariants[s2]
} for 5

check addPhotoPreservesInvariants for 4

-- removePhoto Tests
run GenerateRemovePhotoValidInstance {
    #Nicebook = 2
    some s1, s2 : Nicebook, p : Photo, u : User | s1 != s2 and
        (Invariants[s1] and removePhoto[s1, s2, p, u] and Invariants[s2])
} for 5 but 2 Nicebook, exactly 3 User, 3 Comment

check removePhotoPreservesInvariants for 4

-- addComment Tests
run GenerateAddCommentValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, com: Comment, c : Content, u : User | some s1.users and s1 != s2 and
		(Invariants[s1] and addComment[s1,s2,com,c,u] and Invariants[s2])
} for 5

check addCommentPreservesInvariants for 5

-- removeComment Tests
run GenerateRemoveCommentValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, com : Comment, u : User | some s1.users and s1 != s2 and
		(Invariants[s1] and removeComment[s1,s2,com,u] and Invariants[s2])
} for 5

check removeCommentPreservesInvariants for 5

-- addTag Tests
run GenerateAddTagValidInstance {
	#Nicebook = 2
	some s1, s2: Nicebook, p: Photo, taggee: User, tagger: User | some s1.users and
		Invariants[s1] and addTag[s1,s2,p,taggee,tagger] and Invariants[s2] and s1 != s2
} for 5

check addTagPreservesInvariants for 5

-- removeTag Tests
run GenerateRemoveTagValidInstance {
    #Nicebook = 2
    some s1, s2 : Nicebook, p : Photo, u, taggee : User | s1 != s2 and
        (Invariants[s1] and removeTag[s1, s2, p, taggee, u] and Invariants[s2])
} for 5

check removeTagPreservesInvariants for 5

-- Privacy Tests
check NoPrivacyViolation for 5

check addPhotoSuccess for 5
check removePhotoSuccess for 5
check addCommentSuccess for 5
check removeCommentSuccess for 5
