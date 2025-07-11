---
layout: default
title: git
date: 2023-08-01 00:00:01
nav_order: 5
---

Last update: 20230801

## Forwarding git repos from github and gitlab


An easier way to sync git repos (dcc gitlab and github) to leomed: 
* Using remote port forwarding via your local machine:
* Local .ssh/config

```
Host leomed
  User username
  HostName login-ethsec.leomed.ethz.ch
  ProxyJump username@jump-ethsec.leomed.ethz.ch
  ControlMaster auto
  ControlPath ~/.ssh/%r@%h:%p
  RemoteForward 7239 git.dcc.sib.swiss:22 # 7239 can be any unused port
  RemoteForward 7240 github.com:22
```

* On leomed :
1. create a ssh key and register it with git/gitlab
2. configure the gitlab ssh configuration to re-route to your local machine

* leomed ~/.ssh/config
```
Host git.dcc.sib.swiss
	Hostname localhost
	Port 7239 # the same port as above
	IdentityFile ~/.ssh/id_ed25519 # path to your ssh key

Host github.com
	Hostname localhost
	Port 7240
	IdentityFile ~/.ssh/id_ed25519
```
After this you can clone any repository on github/gitlab directly.
