# Learn to Fly Idle mechanics

## Cash and upgrades

A kill pays the target's full reward and restores its HP. For the cash-per-second display, each hit counts as `reward / ceil(max HP / damage)`, with damage capped at max HP. The display sums up to 80 hits from the last 3 seconds and divides by the time since the oldest hit, with a 1-second minimum. It averages up to 40 samples of that rate. [Payout](../src/obstacles/Obstacle.as#L46-L71) · [Rate display](../src/CashPerSecond.as#L12-L65)

The HP and price curves use a zero-based level `L` and a scale parameter `K`.

```text
x = (L + (0.06 × L)^1.3) × 37 / K
H(L, K) = round to 2 significant digits after floor(2x + 4^x)
C(L, K) = 2.5 × H(L, K) × (2.5 + (0.06 × 37L / K)^1.42)
```

Target HP is `H(L, 37)`. The reward is `2.5 × H(L, 37)` rounded to a whole number. The first three targets and the final target override both. [Scaling](../src/Scaling.as#L10-L69) · [Rounding](../src/Scaling.as#L108-L114) · [Overrides](../src/obstacles/ObstaclesList.as#L60-L90)

| Upgrade | Stat | Base cost at level `L` |
| --- | --- | --- |
| Launching Power | `floor(59 + 10L + (5L)^1.2 + 1.2^L)` | `C(L, 37)` |
| Base Damage | Hand-tuned through level 34, then the damage curve | `C(L, 267) − 4`, with overrides at levels 1–5 |
| Max Shots | `L + 1` shots in flight | `C(L, 30)`, with overrides at levels 1–4 |
| Auto Fire | `L` | `floor(−2 + x + (4x)^2 + 2.88^x)` for `x = 37L / 25`, with overrides at levels 0–3 |

Base Damage starts at 1. It gains 1 per level through level 10, then 2 through 20, 3 through 30 and 4 through 34. After that it uses `H(L + 1, 270) / floor(4 + 1.1x + (4x)^0.7 + 1.2^x)`, where `x = 37(L + 1) / 270`. [Upgrade tables](../src/upgrades/Upgrades.as#L57-L128) · [Damage curve](../src/Scaling.as#L29-L34)

Generated stats and costs use `toFixed()` with no decimal places. The price getter rounds the research multiplier to 3 decimal places and rounds the discounted price to the nearest whole unit. [Discount](../src/upgrades/UpgradeEntry.as#L20-L24) · [Integer multiplication](../framework/lbg/datatypes/BigUint.as#L126-L210)

## Research

Each update adds `0.01 × delta × More RP multiplier` to the RP counter. Whole points move into the balance. The fraction carries over. Achievements pay a fixed RP reward once each. [RP gain](../src/Research.as#L127-L139) · [Achievement payout](../src/Achievements.as#L195-L209)

All five tracks use the same prices. Levels 1–10 cost 100, 200, 400, 600, 800, 1,000, 1,250, 1,500, 2,000 and 2,500 RP. Research caps at level 10. [Prices and cap](../src/Research.as#L98-L143)

| Track | Level 0 | Level 10 |
| --- | ---: | ---: |
| Damage multiplier | 1 | 2 |
| Bullet update multiplier | 1 | 4 |
| Target distance multiplier | 1 | 0.75 |
| Cash price multiplier | 1 | 0.75 |
| RP gain multiplier | 1 | 5 |

The effects change linearly with each level. Drag Reduction moves the target closer by scaling its distance. [Effects](../src/Research.as#L27-L69) · [Target distance](../src/obstacles/ObstacleListEntry.as#L46-L49)

## Shots and targets

Auto fire adds `Auto Fire level × 0.005 × delta` to a counter capped at 3. Each whole unit attempts one shot and is spent even if the shot limit is full. Manual input queues at most one shot. A shot adds a random angle offset from −1.5° up to but excluding 1.5°. Its initial speed is Launching Power divided by 10, with a further ×0.27 in space. [Fire loop and launch](../src/GameEngine.as#L159-L198) · [Manual input](../src/TiltCannon.as#L88-L96)

Bullets retain the base damage they had at launch. A hit applies the current research damage multiplier, rounded to 4 decimal places before multiplication. The result rounds to the nearest whole HP. The world checks the bullet against the target once its x position reaches the target's left bound. The pixel collision library and artwork are omitted. [Hit checks](../src/World.as#L109-L141) · [Damage](../src/bullet/AbstractBullet.as#L138-L141) · [Rounding](../framework/lbg/datatypes/BigUint.as#L126-L210)

There are 38 targets. Defeating a target makes the next one selectable. Switching targets clears shots in flight. The Moon starts space at index 27. In space, gravity pulls toward Earth and bullet updates use ×0.6 after the research speed multiplier, before clamping. [Target order](../src/obstacles/ObstaclesList.as#L15-L57) · [Next button](../src/Menu.as#L431-L441) · [Target switch](../src/World.as#L65-L79) · [Space physics](../src/bullet/AbstractBullet.as#L64-L114)

## Run timing

The simulation requests a tick every 31 ms. Its `delta` is a smoothed interval in units of a 1/60-second step. Play time uses a separate 1,000 ms timer and adds one second per event. [Timers](../src/Main.as#L36-L41) · [Delta](../framework/lbg/compositetick/DeltaTimer.as#L59-L84) · [Play time](../src/Main.as#L182-L188)

The final target is Dodo Homeworld 666. A qualifying kill records the current play time if it is at most the stored clear time, or if the stored time is under 7,000 seconds. A slower kill can therefore overwrite a sub-7,000-second record. [Final target](../src/obstacles/ObstaclesList.as#L55-L57) · [Clear time](../src/Achievements.as#L56-L68)
