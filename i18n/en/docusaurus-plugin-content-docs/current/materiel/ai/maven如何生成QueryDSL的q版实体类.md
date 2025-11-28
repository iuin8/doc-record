# How to create the Entity Class of QueryDSL

To use Maven to generate QueryDSL class you can use the `maven-compiler-plugin` plugin. Here are steps： using this plugin to generate class Q

1. Add the following plugin configuration： in the `pom.xml` file of your Maven project.

    ```xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>com.querydsl</groupId>
                            <artifactId>querydsl-apt</artifactId>
                            <version>5.0.0</version>
                            <classifier>jpa</classifier>
                        </path>
                        <path>
                            <groupId>javax.persistence</groupId>
                            <artifactId>javax.persistence-api</artifactId>
                            <version>2.2</version>
                        </path>
                        <!-- 如果您的项目使用了Lombok，请在此处添加Lombok依赖 -->
                        <!--
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>1.18.30</version>
                        </path>
                        -->
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>
    ```

2. Run the Maven build order, such as `mvn clean install`.

3. Maven will use the `querydsl-apt` and `javax.persistence-api` dependencies to generate the Q.Generated Class Q will be in the `target/generated-sources/java` directory.

Now you can use the generated Qs class in your project to make QueryDSL queries.

---

Learn more:

1. [spring - QueryDsl-How to create Q classes with maven? - Stack Overflow](https://stackoverflow.com/questions/24889990/querydsl-how-to-create-q-classes-with-maven)
2. [3.3 Code generation](http://querydsl.com/static/querydsl/3.2.0/reference/html/ch03s03.html)
3. [How to configure maven to generate QueryDSL classes when using both my own AspectJ ITDs and Roo?](https://groups.google.com/g/querydsl/c/NEiQzP4m1xA)
