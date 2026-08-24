# App/include/v8datamodel/MegaCluster.h

## Purpose

`Terrain` Instance (class MegaClusterInstance, descriptor sMegaCluster, PERSISTENT_HIDDEN) — the voxel terrain part: dual grids (legacy Voxel::Grid + smooth Voxel2::Grid), Lua cell get/set and wedge helpers, world↔cell transforms, region fill/copy/paste, packaged-grid serialization V1–V3 + smooth format, water appearance props, and a macro that freezes inherited part properties to constants.

## Declared API

`class MegaClusterInstance : public DescribedCreatable<MegaClusterInstance, PartInstance, sMegaCluster, ClassDescriptor::PERSISTENT_HIDDEN>`

Log groups: MegaClusterInit, MegaClusterDirty, MegaClusterDecodeStream.

- Overrides neutering part behavior: setPartSizeXml/Ui, setAnchored, getDragUtilitiesSupport→false, getResizeHandleMask→NORM_NONE_MASK, setTranslationUi, setCoordinateFrame, destroyJoints, luaClone, destroy, join, resize, computeExtentsWorld, getTouchingParts, verifySetParent, render3dSelect, getSurface(gridRay, surfaceId&), isSelectable3d→false.
- Lua cell API: `getCellScript(x,y,z) → Tuple`, `setCellScript(x,y,z, CellMaterial, CellBlock=Solid, CellOrientation=NegX)`, `setCellsScript(Region3int16, ...)`, water variants (`getWaterCellScript`, `setWaterCellScript(x,y,z, WaterCellForce, WaterCellDirection)`), autoWedgeCell(s)/Internal.
- Transforms: `cellCornerToWorld(Vector3int16)`, `cellCenterToWorldScript`, `cellToWorldExtents`, `worldToCellScript / worldToCellPreferSolidScript / worldToCellPreferEmptyScript`, private preference helpers.
- Bulk ops: `fillRegion(Region3, float resolution, PartMaterial)`, `fillBlock(cframe, size, material)`, `fillBall(center, radius, material)` (+internal skipWater variant), `copyRegion(Region3int16) → Instance`, `pasteRegion(Instance, corner, bool pasteEmptyCells)`, `clear()`, counts (`getNonEmptyCellCount`, `countCellsScript`), `getMaxExtents()`.
- Smooth conversion: `convertToSmooth()`, `isSmooth()`, smooth replicate int prop; grids `Voxel::Grid* getVoxelGrid()`, `Voxel2::Grid* getSmoothGrid()`; `isAllocated()/isInitialized(); initialize();`
- Serialization: `setPackagedClusterGridV1(string)` (deprecated decode path), V2 string pair, V3 BinaryString pair, smooth BinaryString pair; statics `serializeGridV3(const Voxel::Grid&)` / `deserializeGridV3(...)`; chunk stream templates encode/decode (+V1_Deprecated variants); `incrementCellInChunkIndex`.
- Water look: WaterColor/WaterTransparency/WaveSize/WaveSpeed getters/setters.
- Materials: `Voxel2::MaterialTable* getMaterialTable(); void reloadMaterialTable();`
- Frozen-property macro: `CLUSTER_CONST_PROP_OVERRIDE(ConstType, ArgType, FieldName, Ancestor, SetMethod)` — stamps setters that force constant values for Archivable, BrickColor, CanCollide, Elasticity, Friction, Locked, Material, Name, Reflectance, RotVelocity, Transparency, Velocity, CustomPhysicalProperties ("Properties to make read only, and to only return a constant value").
- Defaults: static kDefaultMaterial/kDefaultBlock/kDefaultOrientation — "these defaults should all correspond with char cell = 0".

## Gotchas

- Nearly every PartInstance mutator is overridden to a fixed constant — treating Terrain as a normal part silently no-ops.
- Three serialized grid generations must all keep decoding (V1 deprecated path retained).
- The class comment "defaults correspond with char cell = 0" encodes the serialized zero-cell contract.

## UNKNOWN

- V2 vs V3 wire differences beyond BinaryString typing (.cpp — see [MegaCluster.md](../../v8datamodel/MegaCluster.md)).

## Cross-links

- Implementation: [App/v8datamodel/MegaCluster.md](../../v8datamodel/MegaCluster.md).
- Base: [PartInstance.md](PartInstance.md); consumers [ChangeHistory.md](ChangeHistory.md), [Explosion.md](Explosion.md).
