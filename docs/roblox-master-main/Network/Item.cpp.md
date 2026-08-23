# Network/Item.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 162 lines)

## Purpose

Implements the variable-width item-type codec and the `ItemQueue` FIFO (see Item.h).

## API / behavior

- `Item::writeItemType`: types 1–3 (Delete/New/ChangeProperty) cost 2 bits; everything else writes 2 zero bits + 5-bit id. Static assert pins `ItemTypeMaxValue < 19`.
- `Item::readItemType`: reads 2 bits; value != 0 is the compact form, else reads 5 more bits.
- `ItemQueue`:
  - `push_back`/`push_front` stamp `timestamp = RBX::Time::now<RBX::Time::Fast>()`; `push_front_preserve_timestamp` keeps the original stamp (used for re-queued items).
  - `pop_if_present` returns front item; `head_wait()` = now − front timestamp (queue latency metric); `head_time()` = front timestamp.
  - `preValidate/postValidate` assert no re-entrant mutation (`inCode` guard); `validate()` currently always true.
  - `deleteAll()` pops and deletes each Item; `clear()` only unlinks.

## Usage

Used by Replicator send/recv pipelines; queue-latency stats come from `head_wait`.

## Gotchas

- The compact form means a stream of Delete/New/ChangeProperty items costs 2 bits each — but ItemTypeEnd (0) in compact form triggers the long-form read; the encoding relies on End never being sent via writeItemType.
- Deleting an Item that is still linked into another queue would corrupt the intrusive list — ownership discipline required.
