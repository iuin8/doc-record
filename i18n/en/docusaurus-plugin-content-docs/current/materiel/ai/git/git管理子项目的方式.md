# Git age subprojects

Manual submodules on Git is a way to use one Git repository as a subdirectory for another Git repository. His approach is uselessly used when your main project needs to be re-on another project, which in turn has its own version control needs.
Below is the basic step： on how to add, use, and update children on Git

## Add Subproject

1. Add subproject： in the main project directory using the community below

   ```sh
   git submodule ad <subproject URL> <Subproject path in the main project >
   # This method needs to be executed in the specified directory and will automatically generate <subproject path in the main project>(Generate rules: <Specify path>/<Subproject URL last level path (.git suffix removed)>)
   git submodule add <subproject URL>
   ```

   e.g.：

   ```sh
   git submodule ad https://github.com/username/subject.git path/to/subproject
   ```

2. Commit changes to the main project repository：

   ```sh
   git commit -m "Add Submodule"
   ```

3. Push changes to remote：

   ```sh
   git push origin <branch name>
   ```

## Clone master item with subitems

The subproject directory is empty by default when closing a primary item with a subitem. You need to run the following commitment to initialize and update subproject：

```sh
git submodule init
git submodule update
```

Alternative, you can use a command to initiate and update all subprojects：

```sh
git submodule update --init --recursive
```

## Update Subproject

When a subproject is updated, you can use the community below to update the reference： for a subproject in the main project

```sh
git submodule update --remote <subproject>
```

Alternative, if you want to update all subitems, you can use：

```sh
git submodule forward git null
```

## Delete Subproject

If you want to remove a child from the main project, you can use the following step：

1. Delete the corresponding subproject entry in the `.gitmodules` file.
2. Delete the corresponding subem entry in the `.git/config` file.
3. Delete subproject directory.
4. Submit changes and push them to remote repository.

## Note

- Subprojects can be any Git repository, both public and private.
- Sub items can be nested, i.e. sub-projects can contain other subitems.
- Care needs to be taken when using subjects, as they may increase the complexity of projects.
  Subprojects are a powerful tool, but they also have some learning curve. Make sure you fully understand how they operate, especially when you need to share projects among different developers.
