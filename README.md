# FoldRender Kit

Tools for [FoldRender Artifacts](https://foldrender.dev/share): publish a
self-contained HTML page and get a link that opens on any device, then manage
who can see it.

This repository holds the released versions of:

| Path | What it is |
|---|---|
| `skills/foldrender-artifacts/SKILL.md` | A skill that teaches AI coding tools which read `SKILL.md` skills how to use the `foldrender` command |
| `cli/foldrender` | The `foldrender` command. It needs only bash and curl, and runs on macOS and Linux |
| `cli/foldrender-bridge.mjs` | What `foldrender bridge` runs: a Node 22+ program the command fetches from the site and checks against the SHA-256 it pins |
| `install.sh` | The installer served at `https://foldrender.dev/install.sh` |

Later additions for FoldRender (plugins, MCP servers, examples) will live here too.

## Install

**Everything: the command and the skill.**

```sh
curl -fsSL https://foldrender.dev/install.sh | sh
```

It puts `foldrender` in `~/.local/bin` and the skill into the skills folder of
each coding tool it finds in your home directory. It does not edit shell profiles.

**Only the skill**, with the [`skills`](https://github.com/vercel-labs/skills) installer:

```sh
npx skills add SunflowersLwtech/foldrender-kit
```

The skill calls the `foldrender` command, so install the command too.

**Only the command.**

```sh
curl -fsSL https://foldrender.dev/install.sh | sh -s -- --no-skill
```

Or copy `cli/foldrender` onto your `PATH` and make it executable.

## Use

```sh
foldrender login                 # sign in with GitHub, once
foldrender publish report.html   # prints the page's link
foldrender help                  # every command
```

The guide is at https://foldrender.dev/share. What the service stores is in
the privacy policy: https://foldrender.dev/privacy.

## How this repository is updated

The files here are copies of what foldrender.dev serves, taken after each
release. They are developed in the FoldRender source repository and copied here,
so a change made directly in this repository would be overwritten by the next
copy. Please report problems and ideas as issues.

## License

Apache License 2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE). The license
does not grant rights to the FoldRender name or logo.

---

## 中文说明

FoldRender Kit 收录 [FoldRender Artifacts](https://foldrender.dev/zh/artifacts)
的工具：把一个自包含的 HTML 页面发布成任何设备都能打开的链接，并管理谁能看到它。

- `skills/foldrender-artifacts/SKILL.md`：给支持 `SKILL.md` 技能的 AI 编程工具使用的技能，教它们如何调用 `foldrender` 命令。
- `cli/foldrender`：`foldrender` 命令，只依赖 bash 和 curl，可在 macOS 和 Linux 上运行。
- `cli/foldrender-bridge.mjs`：`foldrender bridge` 运行的程序（Node 22 以上），命令从网站取下后按它钉住的 SHA-256 校验。
- `install.sh`：`https://foldrender.dev/install.sh` 提供的安装脚本。

三种安装方式：

1. 命令和技能一起装：`curl -fsSL https://foldrender.dev/install.sh | sh`
2. 只装技能：`npx skills add SunflowersLwtech/foldrender-kit`（技能需要调用 `foldrender` 命令，请同时安装命令）
3. 只装命令：`curl -fsSL https://foldrender.dev/install.sh | sh -s -- --no-skill`，或把 `cli/foldrender` 放进 `PATH` 并加上可执行权限。

本仓库里的文件是 foldrender.dev 已发布版本的副本，每次发布后从 FoldRender 源码仓库同步过来；直接改这里的文件会在下次同步时被覆盖，问题和建议请提 issue。

许可证为 Apache License 2.0，见 [LICENSE](LICENSE) 和 [NOTICE](NOTICE)。许可证不授予 FoldRender 名称和标志的使用权。
