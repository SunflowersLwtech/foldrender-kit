---
name: foldrender-artifacts
description: Turn an HTML page (a report, diagram, explainer or dashboard) into a link the user can open on any device, using the foldrender command. Use when the user asks to share this page or report, publish this HTML, give me a link, or make it viewable on my phone, and for the Chinese equivalents 发个链接, 分享给别人看 and 手机上看.
---

# FoldRender Artifacts

Publish one self-contained HTML file and get a link. The `foldrender` command does the work.

## 1. Check the setup

```
command -v foldrender || ls ~/.local/bin/foldrender
foldrender whoami
```

- If `foldrender` is missing, install it: `curl -fsSL https://foldrender.dev/install.sh | sh`
  Then use `~/.local/bin/foldrender` if `~/.local/bin` is not on PATH.
- If `whoami` says the user is not signed in, see "Signing in" below.

## 2. Make the page

- One file. Inline the CSS and JavaScript. Use inline SVG or data URIs for images. Do not reference local files.
- Give it a real `<title>`. It becomes the page title.
- Never put secrets in a page: API keys, tokens, passwords, private keys, or personal data the user would not share. The command warns on some key formats, but that check is not a guarantee.
- 5 MB per page at most.

## 3. Publish

```
foldrender publish /path/to/page.html
```

stdout is the URL and nothing else. Capture it and show it to the user.

Pick the visibility:

- Default for a new page: private. Only the owner can see it.
- `--share alice,bob`: only those GitHub logins can see it. Use this when the user names people.
- `--public`: anyone with the link. Use it only when the user asks for public.

Use `-` to publish from stdin: `foldrender publish - < page.html`.

## 4. Iterate on the same link

Publish the same file path again and the command updates the same URL. Keep the file path stable while you work.

To update a specific page instead, pass its slug: `foldrender publish page.html --slug abc123`.

A re-publish with no visibility or share flags keeps what the page already has.

## 5. Change access or manage pages

```
foldrender share <slug-or-url> +alice -bob     add or remove logins
foldrender share <slug-or-url> --public        anyone with the link
foldrender share <slug-or-url> --private       owner only
foldrender list                                all of the user's pages, with expiry dates
foldrender open <slug-or-url>                  open a page in the browser
foldrender rm <slug-or-url>                    delete a page
```

Delete a page only when the user asks.

## 6. Free plan limits

- 10 pages.
- Each page expires 30 days after it was published.
- 5 MB per page.

If a publish fails with "free plan limit reached", tell the user the limit. Run `foldrender list` and offer to delete a page they no longer need. Do not delete anything without asking.

## 7. Export or delete the account

Run these only when the user asks for them in this conversation.

- `foldrender export [file.zip]` saves every page and a `manifest.json` as one zip. The default name is `foldrender-artifacts-<login>-<date>.zip`. It refuses to overwrite a file.
- `foldrender account delete` removes the account, all its pages and all its API tokens. It cannot be undone. Before running it, suggest `foldrender export`.
- Run `foldrender account delete --confirm <login>` only after the user has typed or confirmed their own login in this conversation. Use the login they gave, never one you looked up or guessed. Without a terminal the command refuses unless `--confirm` is given.
- A 403 "cannot be deleted from here" means this account cannot be deleted with this tool. Tell the user and stop.

## Signing in

When a command fails with "not signed in" (exit code 3):

1. Start the sign-in in the background and capture its output:
   `foldrender login > "${TMPDIR:-/tmp}/foldrender-login.txt" 2>&1 &`
2. Wait two seconds, read that file, and show the user the URL and the code exactly as printed.
3. Ask the user to open the URL and enter the code. Wait until the background process exits.
4. Retry the original command.

If the user gives you a token, run `foldrender login --token <token>` and do not repeat it back.

## Exit codes

| Code | Meaning | What to do |
|---|---|---|
| 0 | Done | Use the output |
| 2 | Bad arguments | Fix the command |
| 3 | Not signed in, or the token was rejected | Sign in (above) |
| 4 | Free plan limit reached | Tell the user; offer `foldrender list` |
| 5 | Page larger than 5 MB | Make the page smaller |
| 6 | Cannot reach the server | Retry once, then tell the user |

## Rules

- Publish only what the user asked you to publish.
- Use `--public` only when the user asks for it.
- Do not print, paste or store tokens. Do not write them into the page.
- If a page might contain something sensitive, stop and ask before publishing.
- Never run `foldrender account delete` unless the user explicitly asks to delete the account and types or confirms their login.
