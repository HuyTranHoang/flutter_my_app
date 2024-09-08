# Create project
### Access website https://start.spring.io/
- Maven Project, Java, Spring Boot 2.5.5 (avoid snapshot which is alpha, beta version) <br>
- Group: com.ray <br>
- Artifact: spring-boot-ecommerce <br>
- package name: com.ray.ecommerce <br>
- package: jar <br>
- version: 8 <br>
- Dependenies: Spring Data JPA, REST repository, MySQL Driver, Lombok (to reduce boilerplate getter/setter code) <br>
### Intellij community edition
- File -> New Project From existing source-> select "Maven" from "Import project from external model" <br>
- File -> Project structure -> Project SDK -> Select Java 8 <br>
### Eclipse
- Download Lombok JAR file on https://projectlombok.org/downloads/lombok.jar <br>
- Install by double click on the file or run the command <br>
 ```
 java -jar lombok.jar
 ```


# H2 database
- src/main/resources/schema.sql will create tables
- src/main/resources/data.sql will load data.

# RUN
java -jar api-0.0.1-SNAPSHOT.jar
