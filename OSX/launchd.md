# launchd notes (macOS)

Reference for finding what started a background process and stopping it for good.

## Identify the job behind a PID

```bash
ps -p <PID> -o pid,ppid,user,stat,lstart,command   # PPID 1 means launchd owns it
launchctl list | grep -i <name>                    # column 1 = PID, 2 = last exit status
launchctl print gui/$(id -u)/<label>               # full job state, incl. the plist path
```

`launchctl print` reports `path = ...`, which is the plist that defines the job.

Plists live in:

| Location | Scope |
| --- | --- |
| `~/Library/LaunchAgents` | per-user agents |
| `/Library/LaunchAgents` | all users, one instance per GUI login |
| `/Library/LaunchDaemons` | system-wide, runs as root, no login needed |
| `/System/Library/...` | Apple's, SIP-protected |

Domains: `gui/$(id -u)` for agents, `system` for daemons (`system` needs sudo).

## Stopping one

`kill` is not enough when the plist sets `KeepAlive` — launchd restarts it. Check with
`plutil -p <plist>`. `KeepAlive = true` always restarts; `{SuccessfulExit: false}` restarts
on any nonzero exit, which includes being killed by a signal.

```bash
launchctl bootout  gui/$(id -u)/<label>   # stop now, this boot only
launchctl disable  gui/$(id -u)/<label>   # persists across reboot and login
```

Both are needed. `disable` alone won't stop a running job; `bootout` alone won't survive a
reboot. Order matters only in that `bootout` after `disable` is the safe sequence to verify.

Verify and reverse:

```bash
launchctl print-disabled gui/$(id -u) | grep -i <name>
launchctl enable    gui/$(id -u)/<label>
launchctl bootstrap gui/$(id -u) <plist path>
```

The disable state lives in launchd's own store (`/var/db/com.apple.xpc.launchd/`), not in the
plist, so the plist stays on disk and a reinstall of the app can re-enable the job.

## Disabled on this machine

### Logi Options+ agent — `com.logi.cp-dev-mgr` (2026-09-20)

Hung: up since 2026-08-17, 79 min CPU, 195 MB resident, unresponsive. Plist
`/Library/LaunchAgents/com.logi.optionsplus.plist`, `KeepAlive = {SuccessfulExit: false}`, so
`kill -9` just relaunched it.

```bash
launchctl bootout gui/$(id -u)/com.logi.cp-dev-mgr
launchctl disable gui/$(id -u)/com.logi.cp-dev-mgr
```

Cost: this is the whole Options+ engine, not a helper. Button remaps, gestures, Flow, smooth
scrolling and per-app profiles stop working. Devices still work as plain HID with their
defaults and whatever DPI was last set.

Re-enable:

```bash
launchctl enable gui/$(id -u)/com.logi.cp-dev-mgr
launchctl bootstrap gui/$(id -u) /Library/LaunchAgents/com.logi.optionsplus.plist
```

Other Logitech jobs, left running:

- `com.logi.optionsplus.updater` — `/Library/LaunchDaemons/`, root, `KeepAlive`. The Options+
  auto-updater. Can restore the agent if it ever runs an update.
- `com.logitech.LogiRightSight.Agent` — `/Library/LaunchAgents/`, webcam framing, unrelated.
- `com.logitech.manager.daemon` — `/Library/LaunchAgents/`, old non-Plus Logi Options. Its
  binary (`/Applications/Logi Options.app`) is gone; dead leftover.

Options+ is not in `OSX/Brewfile`, so `OSX/brew.setup` won't reinstall it.
