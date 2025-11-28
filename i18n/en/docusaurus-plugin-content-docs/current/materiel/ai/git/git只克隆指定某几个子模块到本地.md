# it only clone certain submodules to local

In Git, if you only want to clone the specified submodules to the local level, you can follow the following steps to do：

1. First class project, but not initialize submodule：

   ```bash
   git clone --no-recurse-submodules <Git address of the parent project>
   ```

2. Enter a cloned parent project directory.

3. Edit the `.gitmodules` file to remove or delete some of the comments from the submodules you don't want to clone.

4. Run the following orders to initialize and update the specified submodule：

   ```bash
   git submodule update --init -- <submodules>
   ```

For example, if your project has three submodules of `submodule1`, `submodule2` and `submodule3`, You can simply block `submodule1` and `submodule2`, you can follow the above steps and edit `. When it modules` files, leave the configuration `submodule1` and `submodule2` to annotate or delete the configuration of `submodule3`, then run `git submodule update --init -- submodule1` and `git submodule updates --init -- submodule2` to initialize and block the submodules.
