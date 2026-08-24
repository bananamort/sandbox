# App/include/v8datamodel/Stats.h

## Purpose

The `RBX::Stats` namespace: a stats-tree of `Item` instances (non-creatable, Item-only children) with typed/bound variants, a JSON writer over reflection values, and `StatsService` — INTERNAL_LOCAL LocalUser-security service that formats job/task-scheduler stats and POSTs category reports to a configurable URL (throttled per-category). Free helpers: registerStatsClasses, setBrowserTrackerId, reportGameStatus.

## Declared API

- Free: `void registerStatsClasses();`
- Namespace-level `static std::string countersApiKey = "76E5A40C-3AE1-4028-9F10-7C62520BD94F";` — hardcoded credential GUID (static in header → per-TU copy).

`class Stats::Item : public DescribedNonCreatable<Item, Instance, sStatsItem>`
- Protected state: `double val; std::string sValue; virtual void update();`
- Ctor + named ctor; readers trigger update(): `const std::string& getStringValue()`, `double getValue()`; `std::string getStringValue2()` ("Slower version ... for Reflection"); `setValue(double, const std::string&)`.
- Formatters: `formatMem(size_t bytes)`, `formatValue(double val, const char* fmt, ...)`, `formatRate(const RunningAverageTimeInterval<Time::Benchmark>&)`, inline `formatPercent(val)` ("%.1f%%" of ×100); template `formatValue<V>(const V&)`.
- Child factories: `Item* createChildItem(const char* name)`; templates `createChildItem<T>(name, boost::function0<T>)`, `createBoundChildItem<V>(name, const V&)` (binds by pointer!), plus profiler/RunningAverage/TotalCountTimeInterval/RunningAverageTimeInterval overloads; `createBoundMemChildItem(name, const size_t&)`, `createBoundPercentChildItem(name, const float&)`.
- askAddChild: Items only.

`template<class T> class TypedStatsItem : public Item` — wraps boost::function0<T> or bound pointer-to-value (`deref` via bind); update() = formatValue(func()). Subclasses: `TypedMemItem` (formatMem), `TypedPercentItem` (formatPercent).

`class Stats::JsonWriter` — writes ValueTable/ValueArray into a stringstream with comma tracking; `seenNonJsonType()` flag; methods writeTableEntries/writeArrayEntries/writeTableEntry/writeKeyValue/writeArrayEntry/writeValue.

`class Stats::StatsService : public DescribedNonCreatable<StatsService, Instance, sStats, Reflection::ClassDescriptor::INTERNAL_LOCAL, RBX::Security::LocalUser>, public Service`
- Inline ctor sets name "Stats", `minReportInterval(10)`.
- Public data: `std::string reporterType; double minReportInterval;`
- URL: `getReportUrl()`, `setReportUrl(std::string)`; private customReportUrl + LastReportTimes map (per-category throttle timestamps) + baseUrlConnection.
- Reporting: `report(category, shared_ptr<const ValueTable>)`; throttled variant `(category, data, int percentage)`; **static `report_BypassThrottlingAndCustomUrl(category, const ValueTable&, const char* optional_Shard="Client")`** with in-header warning "reports without doing any local throttling. Do not use if spammy"; `reportTaskScheduler(bool includeJobs)`, `reportJobsStepWindow()`.
- Private plumbing: reportJob(job, stream, isFirst), addHeader(stream), static addCategoryAndTable, checkLastReport(category), tryToStartScript(), static getDefaultReportUrl(baseUrl, shard), static postReportWithUrl(url, stream), postReport(stream).
- askAddChild Items-only; onServiceProvider override.
- Free fns in namespace: `void setBrowserTrackerId(const std::string& trackerId); void reportGameStatus(const std::string& status, bool blocking = false);`

## Gotchas

- Per project recon: the telemetry POST path is DISABLED in this build yet the file still hardcodes an API-key GUID (`countersApiKey`) as a header-level static — duplicated per TU due to `static`.
- createBoundChildItem stores a POINTER to the caller's value — dangling if the bound object dies before the item.
- getStringValue()/getValue() mutate (call update()) despite looking like getters; getStringValue returns ref into mutable member.
- report_BypassThrottlingAndCustomUrl is static precisely so it can fire without a service instance — deliberate escape hatch.

## UNKNOWN

- Which endpoint getDefaultReportUrl targets in this build (post disabled per recon; exact URL construction out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Stats.md](../../v8datamodel/Stats.md).
- Consumers: [DataModel.md](DataModel.md) (jobs/metrics), [BaseRenderJob.md](BaseRenderJob.md), [PhysicsSettings.md](PhysicsSettings.md); analytics util: Util/Analytics.h.
