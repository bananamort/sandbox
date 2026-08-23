# ublas_ext.h

## Purpose
Extensions to boost::uBLAS, injected directly INTO namespace boost::numeric::ublas: a classic LU-based `invert_matrix`, a singular-tolerant `lu_factorize_singular` (partial pivoting that keeps going past zero columns and returns the RANK = number of independent columns), and `unswap_rows` to undo permutation swaps on vectors/matrices.

## API
```cpp
namespace boost::numeric::ublas {   // yes, extending boost's namespace
template<class T> bool invert_matrix(const matrix<T>& input, matrix<T>& inverse);
    // false when lu_factorize reports singular
template<class M, class PM, class IsZeroFunctor>
M::size_type lu_factorize_singular(M& m, PM& pm, const IsZeroFunctor& iszero);
    // returns rank (independent column count); iszero decides pivot eligibility
template<class PM, class MV> void unswap_rows(const PM& pm, MV& mv);  // tag-dispatched vector/matrix
}
```

## Usage
Solvers for near-singular systems (physics joints/constraints are the typical uBLAS consumers in 2016 Roblox). UNKNOWN exact call sites within the pruned tree.

## Gotchas
- lu_factorize_singular's zero-column path does `rowi--; continue;` — combined with loop's ++rowi this retries SAME row on next column; if ALL remaining columns are zero the loop exits with rank=rowi. Subtle but intentional.
- Pivot scaling divides the column below the pivot by m(rowi,columni) — no magnitude check beyond the caller's iszero functor.
- BOOST_UBLAS_TYPE_CHECK block keeps a copy `cm` of the input for validation but never uses it here — dead weight when the check macro is on.
- Extending namespace boost is fragile across boost upgrades (collisions with future upstream additions).
- Header-guard style `_UBLAS_EXT_H` — reserved-identifier naming.
