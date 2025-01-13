.global _start
_start:
	li t0, 1 /* t0 <- 1 */
	li t1, 30 /* t1 <- 30 */
	li t2,0 /* t2 <- 0 */
	li s0, 0 /* s0 <- 0 */
loop: bge t2, t1, endloop
	add t2, t2, t0 /* t2 <- t2 + t0(1) */
	add s0,s0,t2 /* s0 <- s0 + t2 */
	bge x0,x0, loop
endloop:
	add s1, x0, s0
done: j done