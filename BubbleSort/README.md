# Lab1: RV32I Simulator
###### tags: `RISC-V`

## Bubble Sort 

Array： `2, 3, 7, 4, 1`
We sort the array from large to small with [Bubble sort](https://en.wikipedia.org/wiki/Bubble_sort). 
Then, we can get the array `7, 4, 3, 2, 1`.

**C code**
####
```cpp=
void BBSort(int *arr, int size) {
    for (int i = 0; i < size - 1; ++i)
        for (int j = 0; j < size - i - 1; ++j)
            if (arr[j] < arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
}

int main()
{
    int arr[] = {2, 3, 7, 4, 1};
    int size = 5
    BBSort(arr, size - 1);
    for (int i = 0; i < size; ++i) {
        printf("%d\n", arr[i]);
    }
    return 0;
}
```
####
**Assembly code**
```cpp=
.data
	arr: .word 2, 3, 7, 4, 1
.text
main:
	la   s0, arr
	mv   t3, s0
	addi s1, s1, 4
	addi t0, zero, -1
	jal  ra, bbsort

	mv   t0, zero
	addi s1, s1, 1
	mv   s0, t3
	j    print

bbsort:
	addi sp, sp, -12
	sw   ra, 8(sp)
	sw   s1, 4(sp)
	sw   s0, 0(sp)
oloop:
	addi t0, t0, 1
	mv   t1, zero
	sub  t2, s1, t0
	blt  t0, s1, iloop
	addi sp, sp, 12
	jr   ra
iloop:
	mv   s0, t3
	bge  t1, t2, oloop
	slli t4, t1, 2
	add  s0, s0, t4
	lw   a2, 0(s0)
	lw   a3, 4(s0)
	addi t1, t1, 1
	blt  a2, a3, swap
	j    iloop
swap:
	sw   a2, 4(s0)
	sw   a3, 0(s0)
	j    iloop

print: 
	bge  t0, s1, end
	lw   a0, 0(s0)
	li   a7, 1
	ecall
	addi t0, t0, 1
	addi s0, s0, 4
	j    print
end:
```



### Call Function
```c
void BBSort(int *arr, int size)
```
``` =5
la   s0, arr
mv   t3, s0       #for print the final array
addi s1, zero, 4  #size - 1
```
Keep the address of array in `s0` and the size of array minus one in `s1`.

```=17
addi sp, sp, -12
sw   ra, 8(sp)
sw   s1, 4(sp)
sw   s0, 0(sp)
```

* `sp` holds the address of the bottom of the stack
* `addi sp, sp, -12` (recall stack hrows downwards)
    * -12, because we have to store `ra`, `s1`, `s0` to the stack
* To clean up the stack, just increment `sp`
`addi sp, sp, 12`
* We can get the `ra` which we save in the stack, and go back to the address of caller
    * `ra`： save where a function is called from so we can get back

![](https://i.imgur.com/ErnLSa8.jpg)

### Control Hazard
* The pipelined processor does't know what instruction to fetch next, because the branch decision hasn't been made by the time the next instruction is fetched.
* If it takes branch, the instructions fetched at the **IF**, **ID**, **EX** stages will be wrong.
* To solve it, we decide the instruction at the **MEM** stage.
* To clean the content at the **IF/ID** stage, we change from the fetched instructions to `nop`.

```=9
jal  ra, bbsort

mv   t0, zero
addi s1, s1, 1
```
![](https://i.imgur.com/10f85Yn.jpg)
```=25
blt  t0, s1, iloop
addi sp, sp, 12
jr   ra
```
![](https://i.imgur.com/cLmWKRn.jpg)

### Data Hazard
```=17
addi sp, sp, -12
sw   ra, 8(sp)
sw   s1, 4(sp)
```
* The instructions have to use the result of the previous instructions.
* **RAW** is the reason which causes data hazards in the case of code below.
* To solve it, the processor use forwarding
* Due to forwarding, we don't wait for `addi sp, sp, -12` finish. `sw ra, 8(sp)` can use the item(0x7fffffe4) from the previous instrucion at the **EX/MEM**.

![](https://i.imgur.com/WtrOnMb.jpg)









