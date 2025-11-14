# Evaluating_Low_level_complexity
A benchmark that evaluetes computational complexity on various fronts. It measures the cost of abstracting the program language to a higher level.

This repository now contains a basic implementation of the **mergesort** algorithm
in three low‑level languages, suitable for simple benchmarking and comparison:

- `src/c/mergesort.c` – canonical recursive mergesort in C (with optional test `main`).
- `src/asm/mergesort.asm` – x86‑64 assembly version using recursive splitting plus a
	simple bubble pass over the segment.
- `src/fortran/mergesort.f90` – recursive mergesort in modern Fortran.

## Quick usage

From the `Evaluating_Low_level_complexity` root:

### C

```bash
cc -DTEST_MERGESORT -O2 src/c/mergesort.c -o mergesort_c
./mergesort_c
```

### Fortran

```bash
gfortran -O2 src/fortran/mergesort.f90 -o mergesort_fortran
./mergesort_fortran
```

### Assembly (x86‑64 System V)

```bash
nasmlink="mergesort_asm"
nasminput="src/asm/mergesort.asm"
nasmprefix="mergesort"

; assemble and link (GNU toolchain, Linux/Mac):
as "$nasminput" -o ${nasmprefix}.o
cc ${nasmprefix}.o -o "$nasmlink"
./"$nasmlink"
```

The assembly implementation focuses on structure and call overhead rather than a
fully optimal merge step, which keeps the code compact while still allowing you
to measure recursion and memory‑access patterns at a low level.

## Algorithmic complexity (mergesort)

- **Time complexity (worst / average case)**: $O(n \log n)$
	- A list of size $n$ is recursively split into two halves, producing a
		recursion tree whose height is proportional to $\log n$.
	- At each level of the tree, the total cost of the merge step is linear in
		the input size ($O(n)$), because every element is visited and copied once.
	- Therefore, total cost: $O(n)$ per level $\times$ $O(\log n)$ levels $=$ $O(n \log n)$.
- **Time complexity (best case)**: still $O(n \log n)$ for the classical
	implementation, because recursion and merge steps are performed even if the
	array is already sorted.
- **Space complexity**: $O(n)$ extra, due to the temporary arrays used during
	the merge step (plus recursion stack frames, on the order of $O(\log n)$
	depth).

These asymptotic results are independent of the language (C, Assembly, or
Fortran): the asymptotic cost is dominated by the algorithmic structure.

## Empirical timing results (C vs Assembly vs Fortran)

In typical mergesort benchmarks on integer arrays (for example, arrays of size
between $10^4$ and $10^7$), you usually observe that:

- **C**: often serves as the baseline; modern compilers (GCC/Clang) with
	optimizations (`-O2`, `-O3`) produce highly efficient code, often close to
	hardware limits.
- **Assembly**: in theory can be as fast as or slightly faster than C, but in
	practice it depends heavily on the quality of the hand‑written implementation.
	A simple assembly implementation, without all micro‑optimizations
	(vectorization, prefetching, loop unrolling, etc.), tends to be close to or
	even slightly slower than a highly optimized C version.
- **Fortran**: for numerical operations on contiguous arrays, Fortran compilers
	are also very aggressive at optimization. A well‑written mergesort in Fortran
	typically has performance similar to C for the same algorithm.

The typical behavior is:

- Execution times grow approximately proportional to $n \log n$ in all three
	languages (doubling $n$ increases the time to a bit more than double).
- Absolute differences between languages tend to be multiplicative constants
	(for example, “C is 1.0×, Fortran 0.9×–1.1×, Assembly 0.8×–1.2×” of the time),
	strongly dependent on the compiler, optimization flags, and implementation
	details.

For this repository, the implementations were written to be clear and direct
for educational purposes and low‑complexity benchmarking, not to reach the
absolute last word in optimization. To obtain concrete numeric results on your
hardware, run the generated binaries with different input sizes and measure
time using your preferred tool (for example, `time`, small Python scripts, or
system profiling tools).
