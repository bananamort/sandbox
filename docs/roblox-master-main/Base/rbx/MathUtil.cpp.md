# MathUtil.cpp

## Purpose
Implementation of the t-distribution-based outlier detection declared in rbx/MathUtil.h, plus an extra non-header function `GetMappedDOF`. Contains a hardcoded Student-t critical-value table (DOFs 1–30, then 40/50/60/80/100/120, plus a z-approximation row) indexed by confidence level {90%, 95%, 99%, 99.9%}.

## API
```cpp
int GetMappedDOF(int dof);                       // buckets arbitrary dof into a table row index (0..38); NOT in the header
inline double TCritical(unsigned dof, Confidence conf); // internal; DBL_MAX for dof==0
double IsValueOutlier(double value, unsigned count, double average, double std, Confidence conf);
     // |t-score| > t-critical(count-1, conf)
void GetConfidenceInterval(double average, double variance, Confidence conf, double* minV, double* maxV);
     // crude rounded multipliers: 1.644 / 2 / 3 / 4 standard deviations
```

## Usage
Header pair rbx/MathUtil.h. `IsValueOutlier` is the intended consumer entry point (profiler-style sample filtering). Includes rbx/Debug.h for RBXASSERT and uses the ARRAYSIZE macro.

## Gotchas
- `GetMappedDOF`'s actual bucket→row-index mapping (table has 37 rows, indices 0–36): dof<=0→0; 1–30→itself; 31–39→31 (row "50"); 40–49→32 ("60"); 50–59→33 ("80"); 60–79→34 ("100"); 80–99→35 ("120"); 100–119→36 (the z-value row "121"); **dof==120→37 and dof>=121→38 — BOTH OUT OF BOUNDS** (RBXASSERT fires in debug; release reads past the array).
- Even in-range buckets are shifted one row up from their natural match (bucket 31–39 reads the "50" row, not "40"), and the exact 1–30 range indexes DOFs[dof], i.e. the row LABELED dof+1 — every lookup uses critical values one degree of freedom looser than the textbook entry.
- The last DOFs row `{121,...}` actually holds the NORMAL (z) distribution values (1.645/1.96/2.576/3.291), used as the asymptotic approximation.
- `GetConfidenceInterval` ignores the t-table entirely and uses textbook integer-ish multipliers; results differ from TCritical at equal conf levels.
- Division by `std` in IsValueOutlier with std==0 → inf/nan propagation, no guard.
