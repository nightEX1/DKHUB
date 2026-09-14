# Steal An Egg - DKHUB Script Hub 🥚✨

A bespoke, high-performance script hub for **Roblox: Steal a Egg** ([Game Link](https://www.roblox.com/games/108053424714724/Steal-a-Egg)). Built using the signature **DKHUB Cosmic Obsidian** UI library (`#A855F7`) and integrated directly with the game's **Network Remote Architecture** for ultra-fast, ban-safe automation.

---

## 🌟 Fitur Unggulan (Remote-Integrated)

### 🎯 1. Tab Main
- **⚡ Super Auto Steal**:
  - Direct Remote Steal via `ActiveAssets: RequestStealTarget` & `StealTargetEvent`.
  - **Instant Skip Steal Animation**: Memotong jeda animasi steal via `ActiveAssets: RequestDnaStealAnimationComplete`.
  - **Area Egg Carry & Drop**: Otomatis membawa dan mendeposit telur area via `Eggs: RequestAreaEggCarry` & `Guards: ForestDeposit`.
  - **14 Rarity Tiers**: `All`, `BrainrotGod`, `Secret`, `Divine`, `Cosmic`, `Eternal`, `Mythic`, `Legendary`, `Epic`, `Rare`, `Superior`, `Uncommon`, `Common`, `Basic`.
  - **Movement Modes**: `Instant TP` atau `Tween (Safe)`.
- **💰 Auto Collect & Cash Flow**:
  - Auto Claim Animal & Plot Income via `ActiveAssets: MoneyCollected`.
  - Auto Redeem Offline Vault Money via `OfflineAssets: Redeem`.
  - Tombol **"Sell All Non-Favorite Assets Now"** via `AssetInventory: SellAllAssets`.
- **🐣 Auto Hatch & Fast Egg Growth**:
  - Auto Hatch pilihan telur via `Eggs: RequestHatchEgg` & `RequestCompleteHatchEgg`.
  - **Auto Skip Growth Time (Instant Ready)** via `Eggs: RequestSkipGrowth`.
  - **Auto Place Eggs to Plot** via `Eggs: RequestPlaceEgg`.
  - **Fast Hatch Mode**: Skip animasi cutscene.
- **🏃 Auto Treadmill (Speed & Power Farm)**:
  - Auto Farm Speed via `Treadmills: SpeedGain`.
  - Auto Upgrade Treadmill Level via `Treadmills: RequestUpgrade`.
  - Auto Equip Best Treadmill via `Treadmills: RequestEquipStatic`.
- **🏰 Auto Base Upgrades & Pets**:
  - Auto Upgrade Base Walls & Defenses via `Plots: RequestBaseUpgrade`.
  - **Auto Equip Best Income Pets** via `Backpack: EquipBest`.
- **🔄 Auto Rebirth**: Otomatis rebirth untuk melipatgandakan multiplier koin.

---

### 🛠️ 2. Tab Misc
- **🎁 Rewards & Quest Auto-Claimer**:
  - **Claim All Index Rewards**: Mengklaim semua hadiah uang & limited egg koleksi via `Index: RequestClaimAll` & `Index: RequestClaimLimitedEggReward`.
  - **Claim Group Rewards**: `GroupReward: ClaimReward`.
  - **Auto Complete Guard Tutorial**: Selesaikan quest pemain baru via `GuardTutorial: RequestSyncProgress`.
- **⚔️ Combat & Slap Aura**:
  - Auto Trigger Bats, Slaps, Medusa Head, Taser Gun pada musuh di sekitar via `Bat:Activate` & GearTools remotes.
- **🏃 Player Enhancements**:
  - Custom WalkSpeed (16 - 250) & JumpPower (50 - 300).
  - Infinite Jump & Noclip (tembus tembok base musuh).
- **👁️ Visuals & All-Rarity ESP**:
  - Color-Coded Egg ESP untuk semua 14 tier rarity.
  - Player ESP (Box highlight + Display Name + HP + Jarak).
- **🚀 Teleports & Utilities**:
  - Teleport ke Base sendiri, Base pemain lain (dropdown otomatis update), dan Shop/Spawn.
  - Anti-AFK (20-Min Idle Bypass), Rejoin Server, Server Hop.
  - Full Performance (FPS Booster) & Disable 3D Rendering (0% GPU).

---

### ⚙️ 3. Tab Settings
- **Automatic Config Persistence**: Auto-save & reload ke `StealAnEgg_DKHUB_Config.json`.
- **Shortcuts**: Keybind `RightControl` & Floating draggable mobile bubble.
- **Master Clean Unloader**: Mematikan semua loop, coroutine, dan koneksi secara aman.

---

## 🚀 Cara Menjalankan

Eksekusi file **[main.lua](file:///e:/Antigravity%20IDE/Steal%20an%20Egg%20-%20DKHUB/main.lua)** di executor Roblox kamu.
Jika ingin mengubah isi modular file di `src/`, cukup jalankan:
```bash
python bundle_main.py
```
