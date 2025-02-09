# What?

Mannn, I don't want to maintain my own nvim config... I also don't want all the stuff that comes with a "distro". Keep the changes here pretty simple, avoid changing init.lua as much as possible so it is easy to let upstream do most of the maintenance.

`lua/custom/plugins`

# Stay up to date with upstream

```bash
git remote add upstream https://github.com/nvim-lua/kickstart.nvim.git
git fetch upstream
git merge upstream/master
```
