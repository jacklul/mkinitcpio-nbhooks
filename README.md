# mkinitcpio-nbhooks

This hook changes execution function (`run_hook()`) of other hooks to run in a non-blocking way.

Define the hooks to modify in `/etc/default/nbhooks.conf`.  
This hook should be placed at the end of `HOOKS` array in `/etc/mkinitcpio.conf`, or at least after the last hook you want to modify.
