/****************
 * MAIN MODEL
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
	one s : Nicebook | Invariants[s]
}
