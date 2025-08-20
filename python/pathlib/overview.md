# Setup
from pathlib import Path

# Methods
1. mkdir
```
Path.mkdir(mode=0o777, parents=False, exist_ok=False)

Create a new directory at this given path. If mode is given, it is combined with the process’s umask value to determine the file mode and access flags. If the path already exists, FileExistsError is raised.

If parents is false (the default), a missing parent raises FileNotFoundError.

If exist_ok is false (the default), FileExistsError is raised if the target directory already exists.
```
2. parents
```
p = PureWindowsPath('c:/foo/bar/setup.py')
p.parents[0]
PureWindowsPath('c:/foo/bar')
p.parents[1]
PureWindowsPath('c:/foo')
p.parents[2]
PureWindowsPath('c:/')
```
3. touch
```
Path.touch(mode=0o666, exist_ok=True)

Create a file at this given path. If mode is given, it is combined with the process’s umask value to determine the file mode and access flags. If the file already exists, the function succeeds when exist_ok is true (and its modification time is updated to the current time), otherwise FileExistsError is raised.
```