# util/MovementHistory.h

## Purpose
Ring buffer (max 80 nodes) of a part's recent translations, delta-compressed to 6 bytes/node for network replication: each node stores quantized dX/dY/dZ at a selectable precision level plus time-since-previous in 2 ms units. Consumers can extract a node list between cutoff times and reconstruct baseline CFrame + linear velocity.

## Declared API
```cpp
#define MH_NUM_MAX_NODES 80
#define MH_MIN_PRECISION 0.01f
#define MH_TOLERABLE_COMPRESSION_ERROR 1.f

// NOTE: header re-typedefs uint8_t/int8_t as unsigned/signed char!

class MovementHistory {
public:
    struct DeltaCompressedTranslation {
        uint8_t precisionLevel;   // in units of MH_MIN_PRECISION
        int8_t dX, dY, dZ;
    };
    struct MovementNode {
        DeltaCompressedTranslation translation;
        uint8_t delta2Ms;         // dt in 1/500 s units; 255 = gap > 0.510s
        MovementNode();           // zeroed
        MovementNode(const CoordinateFrame& newCFrame, const CoordinateFrame& oldCFrame, float deltaSecs);
        bool isZero() const;
        void setZero();
        // "rotation will be estimated by interpolation"
    };

    static const MovementHistory& getDefaultHistory();   // zero-cframe singleton

    MovementHistory(const CoordinateFrame& cFrame, const Velocity& velocity, const Time& timeStamp);

    void clearNodeHistory();
    void addNode(const CoordinateFrame& cFrame, const Velocity& velocity, const Time& timeStamp);
    size_t getNumNodes() const;
    bool hasHistory(float accumulatedError) const;
    void getMovementNodeList(const Time& lastCutOffTime, const Time& currentCutOffTime,
                             std::deque<MovementNode>& result, bool crossPacketCompression,
                             const CoordinateFrame& lastSentCFrame,
                             CoordinateFrame& outCalculatedBaselineCFrame,
                             Vector3& outCalculatedLinearVelocity) const;
    const CoordinateFrame& getBaselineCFrame() const;
    const Velocity& getBaselineVelocity() const;

    static float decompress(int8_t v, uint8_t precisionLevel);
    static void decompress(MovementNode node, Vector3& outTranslation);
    const Time& getLastUpdateTime() const;
    float getTimeSpan() const;                       // seconds
    static float getSecFrom2Ms(uint8_t delta2MS);    // delta2Ms / 500.f
private:
    CoordinateFrame baselineCFrame;
    Velocity baselineVelocity;
    Time lastUpdateTime;
    float timeSpanSec;
    int checksum;
    MovementNode movementNodes[MH_NUM_MAX_NODES];
    size_t startIndex, size;
    void popFront();  void pushBack(MovementNode node);
    MovementNode concatNode(size_t lastIndex, size_t numNodesToConcat) const;
    static int8_t compress(float v, uint8_t precisionLevel);
    static void compress(Vector3 translation, MovementNode& outMovementNode);
};
```

## Gotchas
- Time encoding: `delta2Ms = (uint8_t)(deltaSecs * 500)` — max representable gap ≈ 0.51 s; larger gaps clamp to 255 sentinel.
- Translation is **int8** per axis per step: large per-node movements overflow/wrap unless the precision level adapts (`precisionLevel` scales by MH_MIN_PRECISION).
- Rotation is NOT stored — receivers interpolate it.
- Header redefines `uint8_t`/`int8_t` locally (shadowing real typedefs) — beware ODR surprises when included after <stdint.h>.
- Fixed 80-node history: `addNode` overwrites oldest once full.
- Includes boost::circular_buffer + mutex headers but storage is a plain array; locking is caller's job (UNKNOWN thread contract).

## UNKNOWN
- Wire format details of `crossPacketCompression` and checksum usage (replication code outside this slice).
