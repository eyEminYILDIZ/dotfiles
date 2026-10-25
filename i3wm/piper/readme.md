# Piper, Text-to-Speech Tool

## What was done

- Handy only converts speech to text (STT, input). A separate TTS tool was needed to read replies aloud, so Piper was installed.
- Piper is a lightweight TTS engine that works offline. It reads one language per voice and cannot switch languages mid-sentence.

## Install locations

| What                | Where                                                          |
|---------------------|----------------------------------------------------------------|
| Piper (Python venv) | ~/.local/share/piper/venv (pip install piper-tts)              |
| Voices              | ~/.local/share/piper/voices/                                   |
| Reader script       | ~/.local/share/piper/speak.py                                  |
| Skill               | ~/.claude/skills/speak/SKILL.md (user level, applies to every project) |

## Voices and speeds

| Language | Voice                                                      | Speed |
|----------|------------------------------------------------------------|-------|
| Turkish  | tr_TR-dfki-medium (the only Turkish voice in Piper)        | 1.3   |
| English  | en_US-lessac-medium                                        | 0.9   |
| Arabic   | ar_JO-kareem-medium (Jordanian dialect)                    | 1.0   |
| Kurdish  | ku_TR-berfin_renas-medium (Kurmanji only, Latin alphabet)  | 1.0   |

Sorani (Kurdish in Arabic script) is not supported.

## How it works

- speak.py strips markdown and code blocks, detects the language automatically, and plays the audio with paplay.
- Language detection: Arabic letters mean Arabic; ğ ş ı İ mean Turkish; ê or î/û mean Kurdish; everything else is English.
- Override detection with `--lang en|tr|ar|ku` and the speed with `--speed N`.
- Default speeds live in the `SPEEDS` dictionary in the script.
- No hook was added. Keeping it simple: speech only happens when asked, via the speak skill.
