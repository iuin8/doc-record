# Jenkins plugin related records

## jenkins create user role project permissions

- [参考文章](https://blog.csdn.net/u013066244/article/details/53407985)
- jenkins create user role project permissions
  - Install Role-Based Strategy Plugin
  - Configure path：
    - System Manager ->
      - Global Security Configuration -> Authorization Strategy - >Role-Based Strategy
      - User -> Create User
      - Manage and Assign Roles->
        - Manage Roles ->
          - Global roles->[All->Read]
          - Item roles->[Pattern->"ma-.\*"]|[Task->(Build|Read)]
        - Assign Roles ->
          - Global roles> Configurated on the ground
          - Item roles->Configurations on the ground
