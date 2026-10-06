"""Validate simulator captures and save PNGs without an alpha channel."""

from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[2] / "assets" / "app_store"
SIZES = {"iphone_6_9": (1320, 2868), "ipad_13": (2064, 2752)}


def main() -> None:
    for folder, expected_size in SIZES.items():
        images = sorted((ROOT / folder).glob("*.png"))
        if len(images) != 8:
            raise RuntimeError(f"Expected 8 {folder} screenshots, found {len(images)}")
        for path in images:
            with Image.open(path) as source:
                if source.size != expected_size:
                    raise RuntimeError(f"Wrong size for {path}: {source.size}")
                if "A" in source.getbands() and source.getchannel("A").getextrema() != (255, 255):
                    raise RuntimeError(f"Unexpected transparency in {path}")
                output = source.convert("RGB")
                temp = path.with_suffix(".ready.png")
                output.save(temp, format="PNG", optimize=True)
            temp.replace(path)
            with Image.open(path) as verified:
                if verified.mode != "RGB" or verified.size != expected_size:
                    raise RuntimeError(f"Failed to finalize {path}")
            print(f"Ready: {path}")


if __name__ == "__main__":
    main()
