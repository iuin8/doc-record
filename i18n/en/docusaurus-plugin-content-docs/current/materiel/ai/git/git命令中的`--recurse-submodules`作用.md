# `--recurse-submodules` in the git command

On Git, the `--recurse-submodules` flag is used to clone all submodules recursively while clone the main project.Submodules are one of the ways in Git to use one Git repository as a subdirectory for another Git repository, commonly used when the main project needs to rely on others.
When you run the `git clone` command with the `--recurse-submodules` flag, Git will perform the following action：

1. Clone the main project warehouse.
2. Checks the `.gitmodules` file in the main project, which contains configuration information for submodules.
3. For each submodule listed in the `.gitmodules` file, Git clone submodule repository to the path specified in the main project.
4. Sign up submodules to the `.git/config` file of the main project to facilitate subsequent submodule operations such as updating, push and more.
   In short, the `--recurse-submodules` function is to ensure that while the main project is cloned, all the submodules on which it relies are cloned and set up so that developers can start working directly without manually initializing and updating submodules.
   This is an example of the command output：

```sh
Cloning into 'television-local-quickstart'...
...
Submodule 'path/to/submodule' (https://github.com/username/submodule. it) registered for path 'path/to/submodule'
Cloning into 'path/to/submodule'...

Submodule path 'path/to/submodule': checked out 'commit-has'
```

When using submodules, make sure you are familiar with how to update submodules, resolve merge conflicts of submodules, and push changes to remote repositories of submodules.
