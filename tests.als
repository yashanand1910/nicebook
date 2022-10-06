/****************
 * TESTS
 ****************/


open signatures as S
open constraints as C
open actions as AC
open invariants as I
open assertions as A

/****************
 * RUN 
 ****************/

run GenerateValidInstance {
	some s1, s2: Nicebook, p:Photo, u:User | some s1.users and some s2.users and
		(Invariants[s1] and addPhoto[s1,s2,p,u] and Invariants[s2]) and s1 != s2
	
	

} //for 10 but exactly 2 Nicebook


check addPhotoPreservesInvariants for 5
