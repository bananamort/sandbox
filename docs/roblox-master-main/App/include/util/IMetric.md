# util/IMetric.h

## Purpose
"Simple class for returning metric values - used for graphics reporting": stringly-keyed metric lookup interface returning either a formatted string or a double.

## Declared API
```cpp
class RBXInterface IMetric {
public:
    IMetric();
    virtual ~IMetric();

    virtual std::string getMetric(const std::string& metric) const = 0;
    virtual double getMetricValue(const std::string& metric) const = 0;
};
```

## Gotchas
- Both methods pure virtual; unknown metric keys' behavior (throw? zero? empty?) is implementation-defined (UNKNOWN).
- String keys: typo-prone, no registry of valid names in this header.
- RBXInterface marker implies shared-library boundary.

## UNKNOWN
- Valid metric key names per implementation (graphics reporting side).
