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
	some s1, s2: Nicebook, p:Photo, u:User | some s1.users and some s2.users and
		(Invariants[s1] and addPhoto[s1,s2,p,u] and Invariants[s2]) and s1 != s2
}

check addPhotoPreservesInvariants for 5

run GenerateRemovePhotoInstances {
    some s1, s2 : Nicebook, p : s1.users.owns & Photo, u : s1.users |
        Invariants[s1] and some p[commentedOn] and removePhoto[s1, s2, p, u] and Invariants[s2]
        and (some u2 : s1.users | u != u2 and u2 in p[commentedOn][owns])
} for 5 but 2 Nicebook

check removePhotoPreservesInvariants for 5
