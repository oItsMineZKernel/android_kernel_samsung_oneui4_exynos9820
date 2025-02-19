# oItsMineZKernel OneUI4 for Exynos 9820/9825 Devices (S10/Note10)

<img src="https://github.com/rifsxd/KernelSU-Next/blob/next/assets/kernelsu_next.png" style="width: 96px;" alt="logo">

Stock OneUI4 with KernelSU Next & SuSFS Based on [Kernel](https://github.com/ivanmeler/android_kernel_samsung_beyondlte) by [`ivanmeler`](https://github.com/ivanmeler)

## Features

- Ramdisk (No more root lost after reboot)
- Nuke all Samsung's security feature on kernel
- Some patched from ExtremeKernel & ThunderStormS Kernel
- KernelSU Next
- SuSFS

## Tested On

- [HyperROM [N10/+/5G]](https://xdaforums.com/t/rom-n10-n10plus-n105g-14-jan-23-v1-1s-hyper-rom-be-unique.4268123) - Based on N975FXXS8HVJ1

## Known Issue

- **Random Bootloop when restart device**
-- There's a change can cause a **bootloop** when restarting. To fix this, press the `Vol down` `+` `Power button (Bixby key)`, and hold until the **splash logo appears**. Keep trying until it boots to the **homescreen**.

## How to Install
Warning: `Please backup your modules before flashing this kernel, as all installed modules may be lost.`
- Flash Zip file via `TWRP`
- Install `KernelSU Next` from [Here](https://github.com/rifsxd/KernelSU-Next/releases)
- Install `susfs4ksu module` from [Here](https://github.com/sidex15/susfs4ksu-module/releases)

## Supported Devices:

`- All dual sim devices are also supported`

> ✅ Working \
> ❔ Need Test \
> ❌ Not Working

| Status |        Name       |  Codename  |    Model   |
|:------:|:-----------------:|:----------:|:----------:|
|    ❔   |    Galaxy S10e    | beyond0lte | SM-G970F/N |
|    ❔   |     Galaxy S10    | beyond1lte | SM-G973F/N |
|    ❔   |    Galaxy S10+    | beyond2lte | SM-G975F/N |
|    ❔   |   Galaxy S10 5G   |   beyondx  | SM-G977B/N |
|    ❔   |   Galaxy Note10   |     d1     | SM-N970F/N |
|    ❔   |  Galaxy Note10 5G |     d1x    |  SM-N971N  |
|    ✅   |   Galaxy Note10+  |     d2s    | SM-N975F/N |
|    ❔   | Galaxy Note10+ 5G |     d2x    | SM-N976B/N |

## Build Instructions:

1. Set up build environment as per Google documentation

   <a href="https://source.android.com/docs/setup/start/requirements" target="_blank">https://source.android.com/docs/setup/start/requirements</a>

2. Properly clone repository with submodules (KernelSU Next)

```html
git clone --recurse-submodules https://github.com/oItsMineZ/oItsMineZKernel-OneUI6.git
```

3. Build for your device

```html
./build.sh -m d2s -k y
```

4. Fetch the flashable zip of the kernel that was just compiled

```html
build/export/oItsMineZKernel-OneUI4...zip
```

5. Flash it using a supported recovery like TWRP

6. Enjoy!

## Credits

- [`rifsxd`](https://github.com/rifsxd) for [KernelSU Next](https://github.com/rifsxd/KernelSU-Next)
- [`simonpunk`](https://gitlab.com/simonpunk) for [susfs4ksu](https://gitlab.com/simonpunk/susfs4ksu)
- [`ivanmeler`](https://gitlab.com/ivanmeler) for [Kernel](https://github.com/ivanmeler/android_kernel_samsung_beyondlte)
- [`ThunderStorms21th`](https://gitlab.com/ThunderStorms21th) for [ThunderStormS Kernel](https://github.com/ThunderStorms21th/S10-source)
- [`Ocin4ever`](https://github.com/Ocin4ever) & [`ExtremeXT`](https://github.com/ExtremeXT) for [ExtremeKernel](https://github.com/Ocin4ever/ExtremeKernel)
