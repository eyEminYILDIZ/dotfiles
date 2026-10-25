---
name: speak
description: Read a reply aloud using the local Piper text-to-speech (English, Turkish, Arabic, Kurdish). Use only when the user asks you to talk, speak, read aloud, or say something out loud.
---

# Speak

Reads text aloud through Piper via `~/.local/share/piper/speak.py`. The script strips markdown and plays the audio with the voice for the language you pass in `--lang`. Auto-detection exists only as a fallback and is unreliable for short Turkish text, so never rely on it.

## Steps

1. Decide what to say. Unless the user names specific text, speak a short spoken-style version of your reply (a few sentences, no code, no file paths, no tables). Write it in the language the user is using.
2. Run it in the background so the chat isn't blocked while audio plays. Pass the text on stdin via a quoted heredoc to avoid shell-escaping problems:

```bash
~/.local/share/piper/speak.py --lang tr <<'EOF'
Text to say here.
EOF
```

Use `run_in_background: true` on the Bash call.

3. Always pass `--lang` yourself, set to the language you wrote the text in: `en`, `tr`, `ar` or `ku`. Piper uses one voice per call, so for mixed-language text, make one call per language.
4. Still write your normal reply in the chat; the audio is in addition to it.

## Notes

- Voices live in `~/.local/share/piper/voices/` (`en_US-lessac-medium`, `tr_TR-dfki-medium`, `ar_JO-kareem-medium`, `ku_TR-berfin_renas-medium`). Kurdish is Kurmanji (Latin script) only; Sorani (Arabic script) is not supported.
- If it fails silently, test with: `echo "test" | ~/.local/share/piper/venv/bin/piper -m ~/.local/share/piper/voices/en_US-lessac-medium.onnx -f /tmp/t.wav`
