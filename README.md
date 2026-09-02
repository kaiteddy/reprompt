# Reprompt

One keystroke reads what's on your screen — including the part that's scrolled off it — and writes the right reply into the box you're typing in. A sharper prompt, a drafted reply, a full brief. Nothing is ever sent for you. Nothing is stored. It runs on your own OpenAI or Anthropic key.

Press **Control+R** in any text box. **Control+E** explains what's on screen in plain English.

## Install (Mac) — one line, then two questions

Open Terminal (Cmd+Space, type *Terminal*) and paste:

```
curl -fsSL https://raw.githubusercontent.com/kaiteddy/reprompt/main/install.sh | bash
```

It will:

1. download and set everything up — nothing else to install, no Homebrew, no Xcode;
2. ask you to **paste your API key** (OpenAI is fastest; Anthropic works too) — saved in your Keychain, never a file;
3. open System Settings so you can **switch on Hammerspoon** under Accessibility — the one permission macOS needs to let a hotkey read and write your text boxes. Press Return in Terminal when done.

Then put your cursor in any text box and press Control+R.

## What it does

- **Empty box** → it reads the conversation on screen and drafts your reply.
- **A few words** → it builds your gist into a complete, well-structured prompt.
- **A full draft** → it tightens it and resolves what "this" and "that" refer to.
- **On an engineering conversation** (an incident, a release, a coding agent's report) it judges from the evidence whether the work is actually complete, and writes the reply that says so — what's authorised, what isn't, what needs approval. Control+E gives you the plain-English explanation.

## Updating

From the little **R** in the menu bar: *Check for updates*. Or in Terminal: `reprompt --update`.

## Privacy

Reprompt runs entirely on your Mac. What it reads off your screen goes only to the model you configured, with your own key, and is never written to disk. There is no Reprompt server and no account.

This repository holds the installer and release packages only.
