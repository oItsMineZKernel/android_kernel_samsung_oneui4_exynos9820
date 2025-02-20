# oItsMineZKernel OneUI4 for Exynos 9820/9825 Devices (S10/Note10)

<img src="https://github.com/rifsxd/KernelSU-Next/blob/next/assets/kernelsu_next.png" style="width: 96px;" alt="logo">

Stock OneUI4 `(S9 Binary)` Kernel with KernelSU Next & SuSFS Based on [ExtremeKernel](https://github.com/Ocin4ever/ExtremeKernel) by [`Ocin4ever`](https://github.com/Ocin4ever) & [`ExtremeXT`](https://github.com/ExtremeXT)

## Features

- Ramdisk (No more root lost after reboot)
- Nuke all Samsung's security feature on kernel
- Some patched from ExtremeKernel & ThunderStormS Kernel
- KernelSU Next
- SuSFS

## Tested On

- [Dr.Ketan ROM - S09](https://xdaforums.com/t/31-07-24-i-n975f-i-n976b-i-n976n-i-n970f-i-dr-ketan-rom-i-oneui-4-1-i-oneui-3-1.3962839) - Based on N975FXX`S9`HWHA `(S9 Binary)`

## Known Issue

- **Work on S9 binary rom only**
-- This kernel is based on binary `S9`. If you try to install it on rom with older binary version `S8`, it will cause a bootloop.

## How to check binary version of your current rom?
- Go to `Settings >> About phone >> Software information` and find your `Build number.`
   - N975FXX`S9`HWHA `S9 Binary` ✅ Working
   - N975FXX`S8`HVJ1 `S8 Binary` ❌ Not Working

## How to Install
Warning: `Please backup your modules before flashing this kernel, as all installed modules may be lost.`
- Flash Zip file via `TWRP`
- Install `KernelSU Next` from [Here](https://github.com/rifsxd/KernelSU-Next/releases)
- Install `susfs4ksu module` from [Here](https://github.com/sidex15/susfs4ksu-module/releases)

## Supported Devices:

`- All dual sim and Korean devices are also supported`

> ✅ Working \
> ❔ Need Test \
> ❌ Not Working

| Status |        Name       |  Codename  |    Model   |
|:------:|:-----------------:|:----------:|:----------:|
|    ❔   |    Galaxy S10e    | beyond0lte | SM-G970F |
|    ❔   |    Galaxy S10e (Korean)    | beyond0lteks | SM-G970N |
|    ❔   |     Galaxy S10    | beyond1lte | SM-G973F |
|    ❔   |    Galaxy S10 (Korean)    | beyond1lteks | SM-G973N |
|    ❔   |    Galaxy S10+    | beyond2lte | SM-G975F |
|    ❔   |    Galaxy S10+ (Korean)    | beyond2lteks | SM-G975N |
|    ❔   |   Galaxy S10 5G   |   beyondx  | SM-G977B |
|    ❔   |    Galaxy S10 5G (Korean)    | beyondxks | SM-G977N |
|    ❔   |   Galaxy Note10   |     d1     | SM-N970F |
|    ❔   |  Galaxy Note10 5G (Korean) |     d1xks    |  SM-N971N  |
|    ✅   |   Galaxy Note10+  |     d2s    | SM-N975F |
|    ❔   | Galaxy Note10+ 5G |     d2x    | SM-N976B |
|    ❔   |  Galaxy Note10+ 5G (Korean) |     d2xks    |  SM-N976N  |

## Build Instructions:

1. Set up build environment as per Google documentation

   <a href="https://source.android.com/docs/setup/start/requirements" target="_blank">https://source.android.com/docs/setup/start/requirements</a>

2. Properly clone repository with submodules (Toolchains & KernelSU Next)

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
- [`Ocin4ever`](https://github.com/Ocin4ever) & [`ExtremeXT`](https://github.com/ExtremeXT) for [ExtremeKernel](https://github.com/Ocin4ever/ExtremeKernel)
- [`ThunderStorms21th`](https://gitlab.com/ThunderStorms21th) for [ThunderStormS Kernel](https://github.com/ThunderStorms21th/S10-source)
