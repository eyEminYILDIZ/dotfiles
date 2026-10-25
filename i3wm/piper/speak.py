#!/usr/bin/env python3
"""Read text aloud with Piper, picking an English, Turkish, Arabic or Kurdish (Kurmanji) voice.

Usage: speak.py [--lang en|tr|ar|ku] [--speed N] [text...]   (reads stdin when no text is given)
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

BASE = os.path.expanduser("~/.local/share/piper")
PIPER = os.path.join(BASE, "venv/bin/piper")
VOICES = {
    "en": "en_US-lessac-medium",
    "tr": "tr_TR-dfki-medium",
    "ar": "ar_JO-kareem-medium",
    "ku": "ku_TR-berfin_renas-medium",
}
SPEEDS = {"tr": 1.3, "en": 0.9}  # per-language default speed; others use 1.0


def clean(text):
    text = re.sub(r"```.*?```", " ", text, flags=re.S)
    text = re.sub(r"`([^`]*)`", r"\1", text)
    text = re.sub(r"!\[[^\]]*\]\([^)]*\)", " ", text)
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text)
    text = re.sub(r"https?://\S+", " ", text)
    text = re.sub(r"^\s{0,3}#{1,6}\s*", "", text, flags=re.M)
    text = re.sub(r"^\s*[-*+]\s+", "", text, flags=re.M)
    text = re.sub(r"^\s*>\s?", "", text, flags=re.M)
    text = re.sub(r"[*_~|]+", " ", text)
    text = re.sub(r"^[\s\-:]+$", "", text, flags=re.M)
    return re.sub(r"\s+", " ", text).strip()


def detect(text):
    arabic = len(re.findall(r"[؀-ۿ]", text))
    turkish = len(re.findall(r"[ğĞşŞıİ]", text))
    latin = len(re.findall(r"[A-Za-z]", text))
    if arabic > latin and arabic > turkish:
        return "ar"
    if len(re.findall(r"[êÊ]", text)) >= 1 or len(re.findall(r"[îÎûÛ]", text)) >= 2:
        return "ku"
    if turkish >= 2:
        return "tr"
    return "en"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lang", choices=VOICES)
    ap.add_argument("--speed", type=float, help="speech speed multiplier (default: 1.3 Turkish, 0.9 English, 1.0 otherwise)")
    ap.add_argument("text", nargs="*")
    args = ap.parse_args()

    raw = " ".join(args.text) if args.text else sys.stdin.read()
    text = clean(raw)
    if not text:
        return
    lang = args.lang or detect(text)
    speed = args.speed or SPEEDS.get(lang, 1.0)
    model = os.path.join(BASE, "voices", VOICES[lang] + ".onnx")

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        wav = f.name
    try:
        subprocess.run([PIPER, "-m", model, "--length-scale", str(1 / speed), "-f", wav], input=text.encode(),
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        for player in ("paplay", "pw-play", "aplay"):
            if subprocess.run(["which", player], capture_output=True).returncode == 0:
                subprocess.run([player, wav])
                break
    finally:
        os.unlink(wav)


if __name__ == "__main__":
    main()
