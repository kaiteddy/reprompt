# Compass distribution

Compass helps you understand your connected AI work and prepare a reviewed next instruction. This repository holds public distribution only; source lives in [full-context-reader](https://github.com/kaiteddy/full-context-reader).

**Public installation is on hold.** The installer refuses before downloading or executing a package until a release owner reviews and pins an immutable version, archive SHA-256 and source commit. The public legacy package does not establish the safety or compatibility of the current source. This repository change does not publish or verify a new release.

The canonical and distribution bootstraps must stay identical. An approved package must contain the complete runtime inside the publisher-signed, notarized Mac app. Installation verifies the publisher and sealed runtime before replacement, stages the app, and retains the previous app for recovery. Configuration and local data stay separate.

Do not install by selecting an arbitrary latest release or bypassing macOS checks. Public downloads and release instructions will be added after the exact artifact passes its Mac release gates.

Compass uses your configured AI provider. Selected context can leave the Mac for that provider, and drafts, project state and recovery information can be retained locally. See the source repository's [privacy document](https://github.com/kaiteddy/full-context-reader/blob/master/PRIVACY.md) for the current candidate's precise behavior.
