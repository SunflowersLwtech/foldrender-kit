# FoldRender for Claude Code

Publish a self-contained HTML page (a report, a diagram, an explainer, a dashboard) as a link
that opens on a phone, a tablet or a computer, and choose who can see it. Put several pages on
one canvas with notes and connectors, ask the reader to answer a question with a tap, and read
FoldRender pages, comments and answers back as clean text.

It works wherever your coding tool can run a command, including sessions that use an API key,
a cloud provider or zero data retention.

- Guide: <https://foldrender.dev/share>
- Privacy policy: <https://foldrender.dev/privacy>
- Terms: <https://foldrender.dev/terms>
- Source and issues: <https://github.com/SunflowersLwtech/foldrender-kit>

## What this plugin adds

One skill, `foldrender-artifacts`, which teaches Claude Code how to use the `foldrender` command:
publish and update pages, share them, put them on a canvas, and read pages, comments and answers.

## Install

```
/plugin marketplace add SunflowersLwtech/foldrender-kit
/plugin install foldrender@foldrender
```

## What runs on your computer, and what leaves it

- **What runs.** The skill runs the `foldrender` command, a bash script that uses curl.
  `foldrender bridge` (the page sidebar) runs Node while it is open. Two desk features keep
  working once you set them up, until you remove them: its background helper is a small Node
  program that stays running (a LaunchAgent on a Mac, a systemd user unit or crontab on Linux),
  and its memory adds hooks to your coding tool that run python3 at each session's start, prompt
  and reply. Each is set up only when its install command is run, and its uninstall or
  `--remove` takes it out. When the command is missing, the skill runs the installer from
  <https://foldrender.dev/install.sh>, which downloads `foldrender` into `~/.local/bin` and
  copies the skill into the skills folder of each coding tool it finds. The source of both is in
  the repository above. The plugin itself installs no hooks, starts no server and pre-approves
  no command.
- **What it stores.** Your sign-in token, in your user configuration folder. Pages you publish
  are stored by FoldRender under your account.
- **What it sends.** The pages you publish or edit, and the requests you make (read a page, list
  comments or answers), go to foldrender.dev. Sign-in uses GitHub. When you publish from a
  Claude Code session, the version also records which session made it (its ID and name, its
  folder, the computer and the turn, never what was said); only the page's owner sees it, and
  `--no-session` or `FOLDRENDER_NO_SESSION=1` leaves it out. The command sends no analytics.
  With the desk's memory set up, each prompt and last reply of your coding sessions also goes to
  your desk; with its background helper, the names, states and last lines of your terminal
  sessions and the machine's load, with secrets taken out first. Your desk is private to you.
- Pages are private unless you share them.

## License

Apache License 2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE). The license does not grant
rights to the FoldRender name or logo.
