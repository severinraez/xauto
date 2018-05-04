# xauto

These scripts help with arranging windows. They are intended to be bound to hotkeys.

* **xsplit.rb** Lets you select 3 windows by mouse click and distributes them side-by-side across your whole screen.
* **xsplitwindowh.rb** Lets you select 2 windows. Both windows will be rearranged side-by-side inside the space previously occupied by the first window.
* **xsplitwindowv.rb** Lets you select 2 windows. Both windows will be rearranged on top of each other inside the space previously occupied by the first window.

Click the Desktop instead of a window to abort a script.

## Installation

These tools work on Ubuntu 16.04 / Unity. I'd suspect many distros and window managers work, the "Click the Desktop" feature might need a little tweaking (PR welcome).

You'll need RVM and xdotool installed. After a `bundle install`, these scripts should be usable.
